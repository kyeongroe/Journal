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
    @IBOutlet weak var entryCountLabel: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    var environment: Environment!
    
    private var dates: [Date] = []
    
    private var entries: [Entry] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }
    
    override func viewDidLoad() {
        
        addButton.image = #imageLiteral(resourceName: "baseline_add_white_24pt")
        
        super.viewDidLoad()
        title = "Journal"
        
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
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
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
}

extension TimelineViewController: EntryViewControllerDelegate {
    func didRemoveEntry(_ entry: Entry) {
        navigationController?.popViewController(animated: true)
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let date = self.dates[indexPath.section]
            let entries = self.entries(for: date)
            self.environment.entryRepository.remove(entries[indexPath.row])
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
        deleteAction.image = #imageLiteral(resourceName: "baseline_delete_white_24pt")
        deleteAction.backgroundColor = UIColor.gradientEnd
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
