//
//  SectionTableViewController.swift
//  RxDemo
//
//  Created by bmxd-002 on 16/11/30.
//  Copyright © 2016年 Zoey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias TableSectionModel = AnimatableSectionModel<String, BasicModel>

class SectionTableViewController: UITableViewController {

    
    let disposeBag = DisposeBag()
    let sections = Variable([TableSectionModel]())
    
    static let initialValue: [BasicModel] = [
        BasicModel(name: "Jack", age: 18),
        BasicModel(name: "Tim", age: 20),
        BasicModel(name: "Andy", age: 24)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        
        let tvDataSource = RxTableViewSectionedAnimatedDataSource<TableSectionModel>()
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicCell
            cell.name.text = i.name
            cell.age.text = String(i.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx.items(dataSource: tvDataSource))
            .addDisposableTo(disposeBag)
        
        sections.value = [TableSectionModel(model: "", items: SectionTableViewController.initialValue)]
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexpath in
                self.tableView.deselectRow(at: indexpath, animated: true)
                let model = SectionTableViewController.initialValue[indexpath.row]
                Alert.showInfo(title: model.name, message: String(model.age)
                
                )
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   

}
