//
//  ViewController.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 21..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit
import SnapKit

protocol EntryViewControllerDelegate: class {
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewController: UIViewController {
    
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    var editingEntry: Entry?
    
    weak var delegate: EntryViewControllerDelegate?
    
    private var textView: UITextView!
    
    var environment: Environment!
    
    var hasEntry: Bool { return editingEntry != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeButton.isEnabled = hasEntry
        
        title = DateFormatter.entryDateFormatter.string(from: Date())
        
        self.textView = UITextView()
        
        textView.text = editingEntry?.text
        let date = editingEntry?.createdAt ?? Date()
        title = DateFormatter.entryDateFormatter.string(from: date)
        
        updateSubView(for: editingEntry == nil)
        
        view.addSubview(self.textView)
        
        self.textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func handleKeyboardAppearance(note: Notification) {
        guard
            let userInfo = note.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        let keyboardHeight: CGFloat = note.name == Notification.Name.UIKeyboardWillShow ? keyboardFrameValue.cgRectValue.height
            :0
        let animationOption = UIViewAnimationOptions(rawValue: animationCurve)
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: animationOption,
            animations: {
                
                self.textView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardHeight)
                }
        },
            completion: nil
        )
    }
    
    @IBAction func removeEntry(_ sender: Any) {
        guard let entryToRemove = editingEntry else { return }
        
        let alertController = UIAlertController.init(title: "일기를 제거하겠습니까?", message: "이 작업은 되돌릴 수 없습니다", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
            self.environment.entryRepository.remove(entryToRemove)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    private func updateSubView(for isEditing: Bool) {
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        
        button.target = self
        button.action = isEditing ? #selector(saveEntry(_:)) : #selector(editEntry)
        self.textView.isEditable = isEditing
        _ = isEditing ? self.textView.becomeFirstResponder() : self.textView.resignFirstResponder()
    }
    
    @objc func saveEntry(_ sender: Any) {
        if let oldEntry = self.editingEntry {
            oldEntry.text = self.textView.text
            environment.entryRepository.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: self.textView.text)
            environment.entryRepository.add(newEntry)
            editingEntry = newEntry
            removeButton.isEnabled = true
        }

        updateSubView(for: false)
    }
    
    @objc func editEntry(_ sender: Any) {
        updateSubView(for: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

