//
//  APNSOptions.swift
//  APNSwift
//
//  Created by Kaunteya Suryawanshi on 26/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    public struct Options: CustomStringConvertible {
        public enum Port: Int {
            case p443 = 443, p2197 = 2197
        }

        public var topic: String?
        public var port: Port = .p443
        public var expiry: Date?
        public var priority: Int?
        public var apnsId: String?
        public var development: Bool = true

        public init() {}

        public var description: String {
            var exp: String = "nil"
            if let date = expiry {
                exp = "\(date) \(date.timeIntervalSince1970.rounded())"
            }
            return "Topic \(self.topic ?? "nil")" +
            "\nPort \(port.rawValue)" +
            "\nExpiry \(exp)" +
            "\nPriority \(priority ?? 0)" +
            "\nAPNSID \(apnsId ?? "nil")" +
            "\nDevelopment \(development)"
        }
    }
}
