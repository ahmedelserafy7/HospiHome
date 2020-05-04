//
//  LoginResponse.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

struct LoginResponse: Codable{
    var success: Bool
    var access_token: String?
    var msg: String?
    var profile: Profile?
}
