//
//  Article.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import Foundation


struct Article: Codable{
    var title: String
    var body: String
    var poster: String
    var shortDate: String
    var fullDate: String
    var posterImage: Data?
}
