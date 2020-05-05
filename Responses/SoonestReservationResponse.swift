//
//  SoonestReservationResponse.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation

struct SoonestReservationResponse: Codable{
    var success: Bool
    var reservation: Reservation?
}

struct Reservation: Codable{
    var time: String
    var id: String
}
