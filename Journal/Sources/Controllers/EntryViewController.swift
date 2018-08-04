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

    override func viewDidLoad() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

