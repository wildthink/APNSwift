//
//  APNError.swift
//  Smart APN
//
//  Created by Kaunteya Suryawanshi on 16/07/16.
//  Copyright © 2016 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
extension APNS {
    enum Error: String, CustomStringConvertible {
        case PayloadEmpty
        case PayloadTooLarge
        case BadTopic
        case TopicDisallowed
        case BadMessageId
        case BadExpirationDate
        case BadPriority
        case MissingDeviceToken
        case BadDeviceToken
        case DeviceTokenNotForTopic
        case Unregistered
        case DuplicateHeaders
        case BadCertificateEnvironment
        case BadCertificate
        case Forbidden
        case BadPath
        case MethodNotAllowed
        case TooManyRequests
        case IdleTimeout
        case Shutdown
        case InternalServerError
        case ServiceUnavailable
        case MissingTopic


        var description: String {
            switch self {
            case .PayloadEmpty: return "The message payload was empty."
            case .PayloadTooLarge: return "The message payload was too large. The maximum payload size is 4096 bytes."
            case .BadTopic: return "The apns-topic was invalid."
            case .TopicDisallowed: return "Pushing to this topic is not allowed."
            case .BadMessageId: return "The apns-id value is bad."
            case .BadExpirationDate: return "The apns-expiration value is bad."
            case .BadPriority: return "The apns-priority value is bad."
            case .MissingDeviceToken: return "The device token is not specified in the request :path. Verify that the :path header contains the device token."
            case .BadDeviceToken: return "The specified device token was bad. Verify that the request contains a valid token and that the token matches the environment."
            case .DeviceTokenNotForTopic: return "The device token does not match the specified topic."
            case .Unregistered: return "The device token is inactive for the specified topic."
            case .DuplicateHeaders: return "One or more headers were repeated."
            case .BadCertificateEnvironment: return "The client certificate was for the wrong environment."
            case .BadCertificate: return "The certificate was bad."
            case .Forbidden: return "The specified action is not allowed."
            case .BadPath: return "The request contained a bad :path value."
            case .MethodNotAllowed: return "The specified :method was not POST."
            case .TooManyRequests: return "Too many requests were made consecutively to the same device token."
            case .IdleTimeout: return "Idle time out."
            case .Shutdown: return "The server is shutting down."
            case .InternalServerError: return "An internal server error occurred."
            case .ServiceUnavailable: return "The service is unavailable."
            case .MissingTopic: return "The apns-topic header of the request was not specified and was required. The apns-topic header is mandatory when the client is connected using a certificate that supports multiple topics."
            }
            
        }
    }
}