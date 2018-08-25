//
//  ViewController.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 21..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit
import SnapKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!

    var viewModel: EntryViewViewModel!
    
    private var textView: UITextView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        removeButton.isEnabled = viewModel.hasEntry
        
        title = DateFormatter.entryDateFormatter.string(from: Date())
        
        self.textView = UITextView()
        
        textView.font = viewModel.textViewFont
        textView.text = viewModel.textViewText

        title = viewModel.title
        
        updateSubviews(viewModel: viewModel)
        
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
        if viewModel.isEditing { textView.becomeFirstResponder() }
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
        guard viewModel.hasEntry else { return }
        let alertController = UIAlertController.init(title: "일기를 제거하겠습니까?", message: "이 작업은 되돌릴 수 없습니다", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "확인", style: .destructive) { (_) in
            guard
                let _ = self.viewModel.removeEntry()
                else { return }
            // pop
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateSubviews(viewModel: EntryViewViewModel) {
        removeButton.isEnabled = viewModel.trashIconEnabled
        button.image = viewModel.buttonImage
        button.target = self
        button.action = viewModel.isEditing ? #selector(saveEntry(_:)) : #selector(editEntry)
        textView.isEditable = viewModel.textViewEditable
    }
    
    @objc func saveEntry(_ sender: Any) {
        viewModel.completeEditing(with: textView.text)
        updateSubviews(viewModel: viewModel)
        textView.resignFirstResponder()
    }
    
    @objc func editEntry(_ sender: Any) {
        viewModel.startEditing()
        updateSubviews(viewModel: viewModel)
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

