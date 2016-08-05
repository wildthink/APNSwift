//
//  APNSOptions.swift
//  Smart APN
//
//  Created by Kaunteya Suryawanshi on 26/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    struct Options {
        enum Port: Int {
            case p443 = 443, p2197 = 2197
        }
        var port: Port = .p443
        var development: Bool = true
        var topic: String?
        var expiry: NSDate?
        var priority: Int?
        var apnsId: String?
    }
}
