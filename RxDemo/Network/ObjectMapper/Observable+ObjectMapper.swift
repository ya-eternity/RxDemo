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
//        return observeOn(MainScheduler.instance)
//            .flatMap { response -> Observable<T> in
//                return Observable.just(try response.mapObject()())
//            }
//            .observeOn(MainScheduler.instance)
//    }
//    
//    
//    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
//        return observeOn(SerialDispatchQueueScheduler(qos: .background))
//            .flatMap { response -> Observable<[T]> in
//                guard let object = Mapper<T>().mapArray(response["data"]) else {
//                    throw AlamofireError.JSONMapping(response)
//                }
//                return Observable.just(object)
//            }
//            .observeOn(MainScheduler.instance)
//    }
}
