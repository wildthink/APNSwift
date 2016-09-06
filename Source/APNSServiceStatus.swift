//
//  APNServiceStatus.swift
//  APNSwift
//
//  Created by Kaunteya Suryawanshi on 16/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    public enum ServiceStatus: Int, CustomStringConvertible {
        case success = 200
        case badRequest = 400
        case badCertitficate = 403
        case badMethod = 405
        case deviceTokenIsNoLongerActive = 410
        case badNotificationPayload = 413
        case serverReceivedTooManyRequests = 429
        case internalServerError = 500
        case serverShutingDownOrUnavailable = 503

        public var description: String {
            switch self {
            case .success: return "Success"
            case .badRequest: return "Bad request"
            case .badCertitficate: return "There was an error with the certificate."
            case .badMethod: return "The request used a bad :method value. Only POST requests are supported."
            case .deviceTokenIsNoLongerActive: return "The device token is no longer active for the topic."
            case .badNotificationPayload: return "The notification payload was too large."
            case .serverReceivedTooManyRequests: return "The server received too many requests for the same device token."
            case .internalServerError: return "Internal server error"
            case .serverShutingDownOrUnavailable: return "The server is shutting down and unavailable."
            }
        }
    }
}
