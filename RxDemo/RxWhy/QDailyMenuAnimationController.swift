//
//  QDailyMenuAnimationController.swift
//  RxDemo
//
//  Created by ZoeyWang on 2017/3/3.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import UIKit

class QDailyMenuAnimationController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var effectBgView: UIVisualEffectView!
    
//    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        self.effectBgView.alpha = 0;
        
        self.view.addSubview(self.tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Mark: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init();
    }

//    Mark: - lazy
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView.init()
        view.showsVerticalScrollIndicator = false;
        view.backgroundColor = UIColor.clear
        view.separatorStyle = UITableViewCellSeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        return view;
    }()
    

}
