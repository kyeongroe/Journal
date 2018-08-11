//
//  ViewController.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 21..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit
import SnapKit

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy. M. dd. EEE"
        return df
    }()
}

class EntryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    private var editingEntry: Entry?
    
    
    private let journal: Journal = InMemoryJournal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "첫 번째 일기"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubView(for: true)
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
                self.textViewBottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    private func updateSubView(for isEditing: Bool) {
        if isEditing {
            textView.isEditable = true
            textView.becomeFirstResponder()
            
            button.setTitle("save", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(saveEntry(_:)), for: .touchUpInside)
        } else {
            textView.resignFirstResponder()
            textView.isEditable = false
            
            button.setTitle("edit", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(editEntry(_:)), for: .touchUpInside)
        }
    }
    
    @objc func saveEntry(_ sender: Any) {
        if let oldEntry = self.editingEntry {
            oldEntry.text = textView.text
            journal.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: textView.text)
            journal.add(newEntry)
            editingEntry = newEntry
        }
        
        updateSubView(for: false)
    }
    
    @objc func editEntry(_ sender: Any) {
        updateSubView(for: true)
    }
    
    func deprecatedviewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let titleConfigSubview = UIView()
        
        titleConfigSubview.backgroundColor = .yellow
        
        view.addSubview(titleConfigSubview)

        titleConfigSubview.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        let labelOfCreateAt = UILabel()
        
        labelOfCreateAt.text = "2018.08.04"
        labelOfCreateAt.font  = labelOfCreateAt.font.withSize(15)
        
        titleConfigSubview.addSubview(labelOfCreateAt)
        
        labelOfCreateAt.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        let btnForSaving = UIButton()
        
        btnForSaving.setTitle("저장", for: .normal)
        btnForSaving.setTitleColor(.black, for: .normal)
        
//        btnForSaving.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
        
        titleConfigSubview.addSubview(btnForSaving)
        
        btnForSaving.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        let contentSubview = UIView()
        
        contentSubview.backgroundColor = .blue
        
        view.addSubview(contentSubview)
        
        contentSubview.snp.makeConstraints {
            $0.top.equalTo(titleConfigSubview.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        let contentTextSubview = UITextView()
        
        contentTextSubview.backgroundColor = .gray

        contentSubview.addSubview(contentTextSubview)

        contentTextSubview.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func pressed(sender: UIButton!) {
        print("Button Clicked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

