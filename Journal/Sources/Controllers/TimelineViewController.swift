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
    
    @IBOutlet weak var entryCountLabel: UILabel!
    
    var environment: Environment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Journal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryCountLabel.text = environment.entryRepository.numberOfEntries > 0
            ? "엔트리 수: \(environment.entryRepository.numberOfEntries)" : "엔트리 없음"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("addEntry"):
            if let vc = segue.destination as? EntryViewController {
                vc.environment = environment
            } default:
            break
        } }
}
