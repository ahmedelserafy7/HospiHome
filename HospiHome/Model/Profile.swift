//
//  Profile.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation



public struct Profile: Codable{
    var id: String
    var mobile: String
    var name: String
    var email: String
    var avatar: Data?
    private var type: String
    
    var accountType: AccountType{
        get{
            if type=="Doctor"{
                return AccountType.Doctor
            }
            else{
                return AccountType.Patient
            }
        }
    }
}

enum AccountType{
    case Doctor,Patient
}
