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
    
    let dataSource = Variable([BasicModel]())
    
    let disposeBag = DisposeBag()
    
    static let initialValue = [
        BasicModel(name: "Nike", age: 34),
        BasicModel(name: "Zoey", age: 21),
        BasicModel(name: "Lion", age: 3),
        BasicModel(name: "Snail", age: 10),
        BasicModel(name: "Dog", age: 9)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = nil
        tableview.delegate = nil
        
        tableview.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { [unowned self] in
                self.title = "contentOffset.y = \($0)"
            }).addDisposableTo(disposeBag)
        
        
        dataSource.asObservable()
            .bindTo(tableview.rx.items(cellIdentifier: "BasicCell", cellType: BasicCell.self)) { (_, element, cell)
                in
                cell.name.text = element.name
                cell.age.text = String(element.age)
        }.addDisposableTo(disposeBag)
        
        dataSource.value.append(contentsOf: ContentOffsetController.initialValue)
        
//        tableview.rx.modelSelected(BasicModel.self)
//            .subscribe(onNext: { model in
//                print(model)
//                Alert.showInfo(title: model.name, message: String(model.age))
//            }).addDisposableTo(disposeBag)
        
        tableview.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableview.deselectRow(at: indexPath, animated: true)
                let model = ContentOffsetController.initialValue[indexPath.row]
                Alert.showInfo(title: model.name, message: String(model.age))
            }).addDisposableTo(disposeBag)
        tableview.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                let model = ContentOffsetController.initialValue[indexPath.row]
                Alert.showInfo(title: model.name, message: String(model.age))
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
