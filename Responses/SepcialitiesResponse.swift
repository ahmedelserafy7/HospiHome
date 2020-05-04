//
//  SepcialitiesResponse.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

struct SepcialitiesResponse: Codable{
    var specialities: [Speciality]
}

struct Speciality: Codable{
    var name: String
}
