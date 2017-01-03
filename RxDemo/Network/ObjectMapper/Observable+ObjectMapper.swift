//
//  Observable+ObjectMapper.swift
//  RxDemo
//
//  Created by bmxd-002 on 17/1/3.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

public extension ObservableType where E == Response {
    
    
//    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
//        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
//            .flatMap { response -> Observable<T> in
//                return Observable.just(try response.mapObject())
//            }
//            .observeOn(MainScheduler.instance)
//    }
    
}
