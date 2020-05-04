//
//  HTTPRequests.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

func httpPOSTRequest(urlString: String, postData: [String: Any], completion: @escaping ( _ responseData: Data?, _ error: Error?) -> Void){
    //let urlStringWithKey = appendKeysToURL(urlString: urlString)
    
    //let url = URL(string: urlStringWithKey)
    let url = URL(string: urlString)
    
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = postData.percentEncoded()
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
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

func httpGETRequest(urlString: String, completion: @escaping ( _ responseData: Data?, _ error: Error?) -> Void){
    //let urlStringWithKey = appendKeysToURL(urlString: urlString)
    
    //let url = URL(string: urlStringWithKey)
    let url = URL(string: urlString)
    
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
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
