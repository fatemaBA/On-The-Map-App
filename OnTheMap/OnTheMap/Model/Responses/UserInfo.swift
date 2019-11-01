//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/14/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let user: User
}

struct User: Codable{
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
