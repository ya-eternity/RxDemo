//
//  NetworkController.swift
//  RxDemo
//
//  Created by bmxd-002 on 17/1/3.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources
import Alamofire
import RxAlamofire
import ObjectMapper

typealias AlamofireSectionModel = AnimatableSectionModel<String, UserModel>

class NetworkController: UIViewController {

    let host = "http://app3.qdaily.com/app3/homes/index/0.json?"
    
    let disposeBag = DisposeBag()
    
    let sections = Variable([AlamofireSectionModel]())
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil
        tableView.delegate = nil
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<AlamofireSectionModel>()
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCell(withIdentifier: "BasicCell", for: ip) as! BasicCell
            cell.name.text = i.name
            cell.age.text = String(i.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx.items(dataSource: tvDataSource))
            .addDisposableTo(disposeBag)
        
        let manager = SessionManager.default
        manager.rx.responseJSON(.get, host)
            .observeOn(MainScheduler.instance)
            .subscribe { print($0) }
            .addDisposableTo(disposeBag)
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
