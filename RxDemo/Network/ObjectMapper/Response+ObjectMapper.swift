//
//  Response+ObjectMapper.swift
//  RxDemo
//
//  Created by bmxd-002 on 17/1/5.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import Moya
import ObjectMapper

public extension Response {
    
    public func mapObject<T: Mappable>() throws -> T {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.jsonMapping(self)
        }
        guard let object = Mapper<T>().map(JSONObject: json["data"]) else {
            throw Error.stringMapping(self)
        }
        return object
    }
    
    /// Maps data received from the signal into an array of objects which implement the Mappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>() throws -> [T] {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.jsonMapping(self)
        }
        guard let object = Mapper<T>().mapArray(JSONArray: json["data"] as! [[String : Any]]) else {
            throw Error.stringMapping(self)
        }
        return object
    }
}
