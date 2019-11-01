//
//  Client.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/7/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import Foundation

class Client {
    
    //MARK: Static varibles
    static var objectId: String?
    static var firstName: String?
    static var lastName: String?
    
    //MARK: Properties
    struct Auth{
        static var key = ""
        static var sessionId = ""
    }
    
    //MARK: Request URLs
    enum Endpoints {
        static let udacity = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentInformation
        case postLocation
        case putLocation
        case getUserInfo
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.udacity + "/session"
                
            case .getStudentInformation:
                return Endpoints.udacity + "/StudentLocation" + "?limit=100&order=-updatedAt"
                
            case .postLocation:
                return Endpoints.udacity + "/StudentLocation"
                
            case .putLocation:
                return Endpoints.udacity + "/StudentLocation" + "/\(String(describing: Client.objectId!))"
                
            case .getUserInfo:
                return Endpoints.udacity + "/users" + "/\(Auth.key)"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: Tasks
    class func taskForPostAndPutRequest<ResponseType: Decodable>(body: String, method: String, url: URLRequest, responseType: ResponseType.Type,completion: @escaping (ResponseType?, Error?, Bool) -> Void){
        var request = url
        request.httpMethod = method
        if responseType == LoginResponse.self{
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =  body.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error, true)
                }
                return
            }
            
            let decoder = JSONDecoder()
            var newData = data
            if responseType == LoginResponse.self{
                let range = (5..<data!.count)
                newData = data?.subdata(in: range) /* subset response data! */
            }
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async {
                    completion(responseObject, nil, false)
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error, false)
                }
            }
        }
        task.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URLRequest, responseType: ResponseType.Type,completion: @escaping (ResponseType?, Error?) -> Void){
        let request = url
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
            
            let decoder = JSONDecoder()
            var newData = data
            if responseType == User.self{
                let range = (5..<data!.count)
                newData = data?.subdata(in: range) /* subset response data! */
            }
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    //MARK: Requests
    class func login(username: String, password: String, completion: @escaping(Bool, Error?, Bool)->Void){
        var requestURL = URLRequest(url: Endpoints.login.url)
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPostAndPutRequest(body: body, method: "POST", url: requestURL, responseType: LoginResponse.self) { (response, error, isNetworkError) in
            if let response = response {
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                completion(true,nil, isNetworkError)
            }else{
                completion(false, error, isNetworkError)
            }
        }
        
    }
    
    class func postLocation(firstName: String, lastName: String, long: Double, lat: Double, map: String, url: String, completion: @escaping(Error?)->Void){
        var requestURL = URLRequest(url: Endpoints.postLocation.url)
        let body = "{\"uniqueKey\": \"\(Auth.key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(map)\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        taskForPostAndPutRequest(body: body, method: "POST", url: requestURL, responseType: PostLocationResponse.self) { (response, error, isNetworkError) in
            if error != nil {
                completion(error)
            } else {
                Client.objectId = response?.objectId
                completion(nil)
            }
        }
        
    }
    
    class func putLocation(firstName: String, lastName: String, long: Double, lat: Double, map: String, url: String, completion: @escaping(Error?)->Void){
        var requestURL = URLRequest(url: Endpoints.putLocation.url)
        let body = "{\"uniqueKey\": \"\(Auth.key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(map)\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        taskForPostAndPutRequest(body: body, method: "PUT", url: requestURL, responseType: PutLocationResponse.self) { (response, error, isNetworkError) in
            if error != nil {
                completion(error)
            }else{
                completion(nil)
            }
        }
        
    }
    
    class func getStudentLocation(completion: @escaping([StudentInformation], Error?)->Void ){
        var requestURL = URLRequest(url: Endpoints.getStudentInformation.url)
        taskForGetRequest(url: requestURL, responseType: Result.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([],error)
            }
        }
        
    }
    
    
    class func getUserInfo(completion: @escaping(Error?)->Void){
        let requestURL = URLRequest(url: Endpoints.getUserInfo.url)
        taskForGetRequest(url: requestURL, responseType: User.self) { (response, error) in
            if let response = response {
                completion(nil)
                Client.firstName = response.firstName
                Client.lastName = response.lastName
            }else{
                completion(error)
            }
        }
        
    }
    
    class func logout(completion: @escaping(Error?)->Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(error)
            }else {
                Auth.key = ""
                Auth.sessionId = ""
                Client.objectId = ""
                completion(nil)
            }
            
        }
        task.resume()
    }
}
