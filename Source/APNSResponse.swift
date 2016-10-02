//
//  APNSResponse.swift
//  APNSwift
//
//  Created by Kaunteya Suryawanshi on 23/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

extension APNS {

    public struct Response {

        public let apnsId: String?
        public let serviceStatus: APNS.ServiceStatus
        public var errorReason: APNS.Error?
        public let deviceToken: String

        init(deviceToken: String, response: HTTPURLResponse, data: Data?) {
            self.deviceToken = deviceToken
            apnsId = response.allHeaderFields["apns-id"] as? String
            serviceStatus = APNS.ServiceStatus(rawValue: response.statusCode)!

            if serviceStatus != .success {
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))  as! [String : Any]
                if let reason = json["reason"] as? String {
                    errorReason = APNS.Error(rawValue: reason)
                }
            }
        }
    }
}
