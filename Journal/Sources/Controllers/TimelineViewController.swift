//
//  TimelineViewController.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 11..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit
import SnapKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var tableview: UITableView!
    
    var viewModel: TimelineViewViewModel!

    override func viewDidLoad() {
        
        addButton.image = #imageLiteral(resourceName: "baseline_add_white_24pt")
        
        super.viewDidLoad()
        title = viewModel.title
        
        tableview = UITableView()
        
        view.addSubview(tableview)
        
        tableview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tableview.register(EntryTableViewCell.self, forCellReuseIdentifier: "EntryCell")
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 44
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("addEntry"):
            if let vc = segue.destination as? EntryViewController {
                vc.viewModel = viewModel.newEntryViewViewModel()
            }
        case .some("showEntry"):
            if
                let vc = segue.destination as? EntryViewController,
                let selectedIP = tableview.indexPathForSelectedRow {
                vc.viewModel = viewModel.entryViewModel(for: selectedIP)
            }
        case .some("showSetting"):
            if
                let vc = segue.destination as? SettingsTableViewController {
                vc.viewModel = viewModel.settingsViewModel
            }
        default:
            break
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfDates
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle(of: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        cell.viewModel = viewModel.entryTableViewCellModel(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        vc.viewModel = viewModel.entryViewModel(for: indexPath)

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            
            let alertController = UIAlertController.init(title: "일기를 제거하겠습니까?", message: "이 작업은 되돌릴 수 없습니다", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
                let isLastEntryInSection = self.viewModel.numberOfItems(of: indexPath.section) == 1
                self.viewModel.removeEntry(at: indexPath)
                
                UIView.animate(withDuration: 0.3) {
                    tableView.beginUpdates()
                    if isLastEntryInSection {
                        tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    tableView.endUpdates()
                }
                success(true)
            }
            alertController.addAction(deleteAction)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "baseline_delete_white_24pt")
        deleteAction.backgroundColor = UIColor.gradientEnd
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

struct EntryTableViewCellModel {
    let entry: EntryType
    let environment: Environment
    var entryText: String { return entry.text }
    var entryTextFont: UIFont { return UIFont.systemFont(ofSize: environment.settings.fontSize.rawValue) }
    var createdDateText: String { return DateFormatter.timeFormatter.string(from: entry.createdAt) }
    var ampmText: String { return DateFormatter.ampmFormatter.string(from: entry.createdAt) }
}

class EntryTableViewCell: UITableViewCell {
    
    let entryTextLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 20))
    let timeLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 20))
    let ampmLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 20))
    let titleStack = UIStackView(frame: CGRect(x: 0,y: 20,width: 100,height: 40))
    let timeStack = UIStackView(frame: CGRect(x: 0,y: 20,width: 100,height: 40))
    
    var viewModel: EntryTableViewCellModel? {
        didSet {
            entryTextLabel.text = viewModel?.entryText
            timeLabel.text = viewModel?.createdDateText
            ampmLabel.text = viewModel?.ampmText
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleStack.backgroundColor = .red
        
        timeStack.axis = .vertical
        timeStack.alignment = .center
        timeStack.distribution = .fill
        timeStack.spacing = 0
        
        timeStack.addSubview(timeLabel)
        timeStack.addSubview(ampmLabel)
        
        titleStack.addSubview(entryTextLabel)
        
        titleStack.addSubview(timeStack)
        
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.distribution = .fill
        titleStack.spacing = 0
        
        contentView.addSubview(titleStack)
        
        contentView.snp.makeConstraints {
            $0.trailing.equalTo(timeStack).offset(8)
        }
        
//        ampmLabel.backgroundColor = .red
//        entryTextLabel.backgroundColor = .yellow
//        timeLabel.backgroundColor = .blue
        
//        ampmLabel.snp.makeConstraints {
//            $0.height.equalTo(20)
//        }

        entryTextLabel.snp.makeConstraints {
//            $0.height.equalTo(40)
            $0.centerY.equalTo(titleStack)
        }

//        timeLabel.snp.makeConstraints {
//            $0.top.equalTo(ampmLabel.snp.bottom)
//            $0.height.equalTo(40)
//        }
        
        timeStack.snp.makeConstraints {
            $0.top.bottom.equalTo(titleStack)
            $0.width.equalTo(80)
//            $0.leading.equalTo(titleStack.snp.trailing)
//            $0.trailing.equalToSuperview()
        }
        
        titleStack.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.equalTo(contentView).offset(20)
            $0.bottom.equalTo(contentView).offset(-20)
            $0.right.equalTo(contentView).offset(-20)
            
//            $0.edges.equalTo(contentView).inset(UIEdgeInsetsMake(20, 20, 20, 20))
//            $0.top.bottom.equalTo(self.contentView)
//            $0.centerY.equalTo(self.contentView)
//            $0.leading.equalTo(self.contentView).offset(8)
//            $0.height.equalTo(80)
//            $0.width.equalTo(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
