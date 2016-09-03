//
//  APNSOptions.swift
//  Smart APN
//
//  Created by Kaunteya Suryawanshi on 26/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    public struct Options {
        public enum Port: Int {
            case p443 = 443, p2197 = 2197
        }
        public init() {}
        public var port: Port = .p443
        public var development: Bool = true
        public var topic: String?
        public var expiry: NSDate?
        public var priority: Int?
        public var apnsId: String?
    }
}
