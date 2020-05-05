//
//  VideoChatUtils.swift
//  SlotsUI
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Seif Elmenabawy. All rights reserved.
//

import Foundation
// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
