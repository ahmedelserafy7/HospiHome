//
//  Doctor.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation
struct Doctor: Codable{
    var info: DoctorInfo
    var workingHours: [WorkingHours]
}

struct DoctorInfo: Codable{
    var id: String
    var name: String
    var speciality: String
    var bio: String
    var fees: String
    var imageBase64: String?
    var image: Data?
}


struct WorkingHours: Codable{
    var day: String
    var starttime: String
    var endtime: String
}


