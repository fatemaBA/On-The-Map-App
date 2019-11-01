//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/9/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation
struct Result: Codable{
    let results: [StudentInformation]
}

struct StudentInformation: Codable{
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL:String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}
