//
//  ViewController.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 21..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let yellowSubview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        yellowSubview.backgroundColor = UIColor.yellow
        view.addSubview(yellowSubview)
        yellowSubview.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.leading.equalToSuperview()
        }
        
        let blueSubview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        blueSubview.backgroundColor = .blue
        view.addSubview(blueSubview)
        blueSubview.snp.makeConstraints {
            $0.width.equalTo(yellowSubview).multipliedBy(0.5)
            $0.top.equalTo(yellowSubview.snp.bottom).offset(20)
            $0.centerX.equalTo(yellowSubview)
            $0.bottom.equalToSuperview()
        }
        
        
//        let redSubview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        redSubview.backgroundColor = UIColor.blue
//        view.addSubview(redSubview)
//        redSubview.snp.makeConstraints {
//            $0.width.equalTo(100)
//            $0.bottom.trailing.equalToSuperview()
//        }
//
//        let subview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        subview.backgroundColor = UIColor.blue
//        view.addSubview(subview)
//        subview.snp.makeConstraints {
//            $0.width.equalTo(100)
//            $0.leading.equalTo(yellowSubview.snp.centerX)
//            $0.top.equalTo(yellowSubview.snp.centerY)
//            $0.bottom.equalTo(redSubview.snp.leading)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

