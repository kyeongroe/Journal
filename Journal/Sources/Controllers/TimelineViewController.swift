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
    
    var environment: Environment!
    
    private var dates: [Date] = []
    
    private var entries: [Entry] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }
    
    override func viewDidLoad() {
        
        addButton.image = #imageLiteral(resourceName: "baseline_add_white_24pt")
        
        super.viewDidLoad()
        title = "Journal"
        
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
        
        dates = entries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
        
        tableview.reloadData()
    }
    
    private func entries(for day: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> Entry {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("addEntry"):
            if let vc = segue.destination as? EntryViewController {
                vc.environment = environment
                vc.delegate = self
            }
        case .some("showEntry"):
            if
                let vc = segue.destination as? EntryViewController,
                let selectedIP = tableview.indexPathForSelectedRow {
                vc.environment = environment
                vc.editingEntry = entries[selectedIP.row]
                vc.delegate = self
            }
        default:
            break
        }
    }
}

class EntryTableViewCell: UITableViewCell {
    let entryTextLabel = UILabel()
    let timeLabel = UILabel()
    let ampmLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        entryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        ampmLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(entryTextLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(ampmLabel)
        
        self.entryTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        self.timeLabel.snp.makeConstraints {
            $0.leading.equalTo(entryTextLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DateFormatter.entryDateFormatter.string(from: dates[section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries(for: dates[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        let entry = self.entry(for: indexPath)
        
        cell.entryTextLabel.text = "\(entry.text)"
        cell.ampmLabel.text = DateFormatter.ampmFormatter.string(from: entry.createdAt)
        cell.timeLabel.text = DateFormatter.timeFormatter.string(from: entry.createdAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        
        vc.environment = environment
        vc.editingEntry = self.entry(for: indexPath)
        vc.delegate = self

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TimelineViewController: EntryViewControllerDelegate {
    func didRemoveEntry(_ entry: Entry) {
        navigationController?.popViewController(animated: true)
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let date = self.dates[indexPath.section]
            let entries = self.entries(for: date)
            let entryToRemove = entries[indexPath.row]
            
            let alertController = UIAlertController.init(title: "일기를 제거하겠습니까?", message: "이 작업은 되돌릴 수 없습니다", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
                self.environment.entryRepository.remove(entryToRemove)
                if entries.count == 1 { self.dates = self.dates.filter { $0 != date } }
                UIView.animate(withDuration: 0.3) {
                    tableView.beginUpdates()
                    if entries.count == 1 {
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
