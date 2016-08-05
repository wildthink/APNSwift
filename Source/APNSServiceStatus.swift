//
//  APNServiceStatus.swift
//  Smart APN
//
//  Created by Kaunteya Suryawanshi on 16/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    enum ServiceStatus: Int, CustomStringConvertible {
        case Success = 200
        case BadRequest = 400
        case BadCertitficate = 403
        case BadMethod = 405
        case DeviceTokenIsNoLongerActive = 410
        case BadNotificationPayload = 413
        case ServerReceivedTooManyRequests = 429
        case InternalServerError = 500
        case ServerShutingDownOrUnavailable = 503

        var description: String {
            switch self {
            case .Success: return "Success"
            case .BadRequest: return "Bad request"
            case .BadCertitficate: return "There was an error with the certificate."
            case .BadMethod: return "The request used a bad :method value. Only POST requests are supported."
            case .DeviceTokenIsNoLongerActive: return "The device token is no longer active for the topic."
            case .BadNotificationPayload: return "The notification payload was too large."
            case .ServerReceivedTooManyRequests: return "The server received too many requests for the same device token."
            case .InternalServerError: return "Internal server error"
            case .ServerShutingDownOrUnavailable: return "The server is shutting down and unavailable."
            }
        }
    }
}