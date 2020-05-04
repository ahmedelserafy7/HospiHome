//
//  HTTPRequests.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

class API{
var baseURL = "http://142.93.138.37/~hospihome/api/"
    
    enum EndPoints: String{
        case login = "login"
        case logout = "logout"
        case otp = "otp"
        case signup = "signup"
        case avatar = "fetchAvatar"
        case fetchDoctors = "fetchDoctors"
        case fetchArticles = "fetchArticles"
        case fetchSpecialaities = "fetchSpecialities"
        case getOwnSchedule = "doctors/getSchedule"
        case updateSchedule = "doctors/updateSchedule"
        case getFreeTimeSlots = "reservations/getAvailableSlots.php"
        
    }
    
    func httpPOSTRequest(endpoint: EndPoints, postData: [String: Any], completion: @escaping ( _ responseData: Data?, _ error: Error?) -> Void){
        let url = URL(string: baseURL+endpoint.rawValue)
    
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = postData.percentEncoded()
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    if let access_token = access_token{
        request.addValue(access_token, forHTTPHeaderField: "Token")
    }
    
    let task = URLSession.shared.dataTask(with: request) {data, httpresponse, error in
        if let error = error{
            print("HTTP Request Error: " + error.localizedDescription)
        }
        
        if let _ = data{
            
            
        } else{
            print("Returned data is nil")
        }
        
        completion(data,error)
        
    }
    
    task.resume()
    
}

func httpGETRequest(endpoint: EndPoints, completion: @escaping ( _ responseData: Data?, _ error: Error?) -> Void){
    let url = URL(string: baseURL+endpoint.rawValue)
    
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
    if let access_token = access_token{
        request.addValue(access_token, forHTTPHeaderField: "Token")
    }
    
    let task = URLSession.shared.dataTask(with: request) {data, httpresponse, error in
        if let error = error{
            print("HTTP Request Error: " + error.localizedDescription)
        }
        
        if let _ = data{
            
            
        } else{
            print("Returned data is nil")
        }
        
        completion(data,error)
        
    }
    
    task.resume()
    
}
}
