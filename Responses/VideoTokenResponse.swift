//
//  VideoTokenResponse.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

struct VideoTokenResponse: Codable{
    var success: Bool
    var videotoken: String?
}
