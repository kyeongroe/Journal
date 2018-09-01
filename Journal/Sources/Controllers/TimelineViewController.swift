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
    
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var tableview: UITableView!
    
    var viewModel: TimelineViewViewModel!
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)

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
        
        searchController.searchBar.placeholder = "일기 검색"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingIndicator.startAnimating()
        
        viewModel.refreshEntries { [weak self] in
            self?.tableview.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if searchController.isActive {
            viewModel.endSearching()
            searchController.isActive = false
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.endSearching()
        self.loadingIndicator.startAnimating()
        viewModel.loadEntries { [weak self] in
            self?.tableview.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

extension TimelineViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let searchText = searchController.searchBar.text,
            searchText.isEmpty == false,
            viewModel.isLoading == false
            else { return }
        self.loadingIndicator.startAnimating()
        viewModel.searchText(text: searchText) { [weak self] in
            self?.tableview.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition: CGFloat = scrollView.contentOffset.y
        let cellHeight: CGFloat = 80
        let threshold: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height - cellHeight
        guard scrollPosition > threshold && viewModel.isLoading == false && viewModel.isLastPage == false else { return }
        loadingIndicator.startAnimating()
        viewModel.loadMoreEntries { [weak self] in
            self?.tableview.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard searchController.isActive == false
            else { return UISwipeActionsConfiguration(actions: []) }
        
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
    let titleStack = UIStackView()
    let timeStack = UIStackView()
    
    var viewModel: EntryTableViewCellModel? {
        didSet {
            entryTextLabel.text = viewModel?.entryText
            timeLabel.text = viewModel?.createdDateText
            ampmLabel.text = viewModel?.ampmText
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        titleStack.backgroundColor = .red
//
//        timeStack.backgroundColor = .blue
//
//        timeStack.axis = .vertical
//        timeStack.alignment = .center
//        timeStack.distribution = .fill
//        timeStack.spacing = 0
//
//        timeStack.addSubview(timeLabel)
//        timeStack.addSubview(ampmLabel)
//
//        titleStack.addSubview(entryTextLabel)
//
//        titleStack.addSubview(timeStack)
//
//        titleStack.axis = .horizontal
//        titleStack.alignment = .center
//        titleStack.distribution = .fill
//        titleStack.spacing = 0
        
//        contentView.addSubview(titleStack)
        contentView.addSubview(entryTextLabel)
        contentView.addSubview(timeLabel)

//        contentView.snp.makeConstraints {
//            $0.trailing.equalTo(timeLabel).offset(8)
//        }
        
//        ampmLabel.backgroundColor = .red
//        entryTextLabel.backgroundColor = .yellow
//        timeLabel.backgroundColor = .blue
        
//        ampmLabel.snp.makeConstraints {
//            $0.height.equalTo(20)
//        }

        entryTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
        }

        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(contentView).offset(-8)
            $0.width.equalTo(80)
//            $0.leading.equalTo(entryTextLabel.snp.trailing)
        }
        
//        timeStack.snp.makeConstraints {
//            $0.top.bottom.equalTo(titleStack)
//            $0.width.equalTo(80)
//            $0.leading.equalTo(titleStack.snp.trailing)
//            $0.trailing.equalToSuperview()
//        }
        
//        titleStack.snp.makeConstraints {
//            $0.left.equalTo(contentView).offset(8)
//            $0.right.equalTo(contentView).offset(-8)
        
//            $0.edges.equalTo(contentView).inset(UIEdgeInsetsMake(20, 20, 20, 20))
//            $0.top.bottom.equalTo(self.contentView)
//            $0.centerY.equalTo(self.contentView)
//            $0.leading.equalTo(self.contentView).offset(8)
//            $0.height.equalTo(80)
//            $0.width.equalTo(80)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
