//
//  Request+ObjectMapper.swift
//  RxDemo
//
//  Created by bmxd-002 on 17/1/5.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import RxSwift
import ObjectMapper
import Alamofire

public enum AlamofireError: Error {
    case ImageMapping(HTTPURLResponse)
    case JSONMapping(HTTPURLResponse)
    case StringMapping(HTTPURLResponse)
    case StatusCode(HTTPURLResponse)
    case Data(HTTPURLResponse)
    case Underlying(Error)
}

public extension ObservableType where E == (HTTPURLResponse, AnyObject) {
    
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T> in
                guard let object = Mapper<T>().map(JSONObject:response.1) else {
                    throw AlamofireError.JSONMapping(response.0)
                }
                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }
    
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]> in
                guard let object = Mapper<T>().mapArray(JSONArray:response.1["data"] as! [[String : Any]]) else {
                    throw AlamofireError.JSONMapping(response.0)
                }
                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }
}
