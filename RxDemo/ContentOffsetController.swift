//
//  ContentOffsetController.swift
//  RxDemo
//
//  Created by bmxd-002 on 16/11/22.
//  Copyright © 2016年 Zoey. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContentOffsetController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { [unowned self] in
                self.title = "contentOffset.y = \($0)"
            }).addDisposableTo(disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
