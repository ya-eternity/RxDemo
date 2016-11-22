//
//  ViewController.swift
//  RxDemo
//
//  Created by bmxd-002 on 16/11/21.
//  Copyright © 2016年 Zoey. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastName: UITextField!

    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var tapButton: UIButton!
    
    @IBOutlet weak var tapLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var count = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.combineLatest(firstname.rx.text.orEmpty, lastName.rx.text.orEmpty) { $0 + " " + $1 }
            .map { "Greeting \($0)" }
            .bindTo(greetingLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        tapButton.rx.tap
            .subscribe(onNext: { [unowned self] in 
                print("Tap")
                self.count += 1;
                self.tapLabel.text = "Tap \(self.count)"
            })
            .addDisposableTo(disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

