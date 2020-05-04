//
//  AvailableTimeSlotsResponse.swift
//  SlotsUI
//
//  Created by Seif Elmenabawy on 5/1/20.
//  Copyright © 2020 Seif Elmenabawy. All rights reserved.
//

import Foundation

struct AvailableTimeSlotsResponse: Codable{
    var success: Bool
    var slots: [Int]
}
