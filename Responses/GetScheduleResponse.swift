//
//  GetScheduleResponse.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

struct GetScheduleResponse:Codable{
    var success: Bool
    var schedule: [Day]?
}
