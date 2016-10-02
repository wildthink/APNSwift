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

    fileprivate var secIdentity: SecIdentity?
    fileprivate var session: URLSession!
    fileprivate var options: Options!

    public init(identity: SecIdentity, options: Options? = Options()) {
        super.init()

        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        self.options = options
        self.secIdentity = identity
    }

    public init?(certificatePath: String, passphrase: String) {
        super.init()
        guard let identity = identityFor(certificatePath, passphrase: passphrase) else {
            return nil
        }

        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        self.secIdentity = identity
    }

    open func sendPush(
        tokenList: [String],
        payload: Data,
        responseBlock: ((_ apnsResponse: APNS.Response) -> Void)?
        ) throws {

        for token in tokenList {
            let pushURL = self.baseURL(options.development, port: options.port).appendingPathComponent(token)

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
                request.addValue("\(apnsExpiry.timeIntervalSince1970.rounded())", forHTTPHeaderField: "apns-expiration")
            }

            session.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
                guard err == nil else {
//                    log?.error(err!.localizedDescription)
                    return
                }
                let httpResponse = response as! HTTPURLResponse

                responseBlock?(Response(deviceToken: token, response: httpResponse, data: data))
            }).resume()
        }
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
extension APNS {

    fileprivate func baseURL(_ development: Bool, port: Options.Port) -> URL {
        if development {
            return URL(string: "https://api.development.push.apple.com:\(port)/3/device/")!
        } else {
            return URL(string: "https://api.push.apple.com:\(port)/3/device/")!
        }
    }

    fileprivate func identityFor(_ certificatePath: String, passphrase: String) -> SecIdentity? {
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

//FIXME: Temporary hack until Swift 3.0
public extension TimeInterval {
    func rounded() -> Int {
        return Int(self)
    }
}

