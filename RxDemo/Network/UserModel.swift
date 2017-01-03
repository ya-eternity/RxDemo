//
//  UserModer.swift
//  RxDemo
//
//  Created by bmxd-002 on 17/1/3.
//  Copyright © 2017年 Zoey. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct UserListModel {
    var users: [UserModel]!
}

struct UserModel {
    var name: String!
    var age: String!
}

extension UserListModel: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        users <- map["users"]
    }
}

func ==(lhs: UserListModel, rhs: UserListModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension UserListModel: Hashable {
    var hashValue: Int {
        return users.description.hashValue
    }
}

extension UserListModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

extension UserModel: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
    }
}


extension UserModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension UserModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

func ==(lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.name == rhs.name
}
