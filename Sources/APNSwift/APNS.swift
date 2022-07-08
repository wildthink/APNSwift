//
//  APNS.swift
//  APNSwift
//
//  Created by Alexey Khokhlov on 25.01.16.
//  Copyright © 2016 Alexey Khokhlov. All rights reserved.
//

import Foundation
import Security

open class APNS: NSObject {
    
    var secIdentity: SecIdentity?
    var options: Options
    lazy var session: URLSession =
        .init(configuration: .default, delegate: self, delegateQueue: .main)
    
    public init(identity: SecIdentity, options: Options = Options()) {
        
        self.options = options
        self.secIdentity = identity
        
        super.init()
    }
    
    public init?(certificatePath: String, passphrase: String) {
        guard let identity = APNS.identityFor(certificatePath, passphrase: passphrase)
        else { return nil }
        
        self.secIdentity = identity
        self.options = .init()
        super.init()
    }
    
    open func sendPush(
        dev: Bool? = nil,
        token: String,
        payload: Data
    ) async throws -> APNS.Response {
        let request = request(dev: dev, token: token, payload: payload)
        let (data, response) = try await URLSession.shared
            .upload(for: request, from: payload)
        return .init(deviceToken: token, response: response as! HTTPURLResponse, data: data)
    }
    
    open func sendPush(
        dev: Bool? = nil,
        tokens: [String],
        payload: Data,
        responseBlock: ((_ apnsResponse: APNS.Response) -> Void)?
    ) throws {
        
        for token in tokens {
            let request = request(dev: dev, token: token, payload: payload)
            session.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
                if let httpResponse = response as? HTTPURLResponse,
                   let responseBlock = responseBlock
                {
                    responseBlock(Response(deviceToken: token, response: httpResponse, data: data))
                }
                // error?
                return
            }).resume()
        }
    }
    
    func request(dev: Bool?, token: String, payload: Data) -> URLRequest {
        let pushURL = options.pushURL(dev).appendingPathComponent(token)
        var request = URLRequest(url: pushURL)
        
        request.httpBody = payload
        request.httpMethod = "POST"
        if let topic = options.topic {
            request.addValue(topic, forHTTPHeaderField: "apns-topic")
        }
        if let priority = options.priority {
            request.addValue("\(priority)", forHTTPHeaderField: "apns-priority")
        }
        if let apnsId = options.apnsId {
            request.addValue(apnsId, forHTTPHeaderField: "apns-id")
        }
        if let apnsExpiry = options.expiry {
            request.addValue("\(Int(apnsExpiry.timeIntervalSince1970))",
                             forHTTPHeaderField: "apns-expiration")
        }
        return request
    }
}

//MARK: - NSURLSessionDelegate
extension APNS: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var cert : SecCertificate?
        SecIdentityCopyCertificate(self.secIdentity!, &cert)//FIXME: User identity.certificate instead
        let credentials = URLCredential(identity: self.secIdentity!, certificates: [cert!], persistence: .forSession)
        completionHandler(.useCredential,credentials)
    }
}

//MARK: - Private Helpers
extension APNS.Options {
    func pushURL(_ dev: Bool? = nil) -> URL {
        URL(string: "https://api.\(dev ?? development ? "development." : "")push.apple.com:\(port)/3/device/")!
    }
}

extension APNS {
    
    static func identityFor(_ certificatePath: String, passphrase: String) -> SecIdentity? {
        let PKCS12Data = try? Data(contentsOf: URL(fileURLWithPath: certificatePath))
        let passPhraseKey : String = kSecImportExportPassphrase as String
        let options = [passPhraseKey : passphrase]
        var items : CFArray?
        let ossStatus = SecPKCS12Import(PKCS12Data! as CFData, options as CFDictionary, &items)
        guard ossStatus == errSecSuccess else {
            return nil
        }
        let arr = items!
        if CFArrayGetCount(arr) > 0 {
            let newArray = arr as [AnyObject]
            let secIdentity =  newArray[0][kSecImportItemIdentity as String] as! SecIdentity
            return secIdentity
        }
        return nil
    }
}
