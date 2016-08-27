//
//  APNS.swift
//  APNS
//
//  Created by Alexey Khokhlov on 25.01.16.
//  Copyright © 2016 Alexey Khokhlov. All rights reserved.
//

import Foundation
import Security

class APNS: NSObject {

    private var secIdentity: SecIdentityRef?
    private var session: NSURLSession!
    var options = Options()

    private func baseURL(development: Bool, port: Options.Port) -> NSURL {
        if development {
            return NSURL(string: "https://api.development.push.apple.com:\(port)/3/device/")!
        } else {
            return NSURL(string: "https://api.push.apple.com:\(port)/3/device/")!
        }
    }

    init(identity: SecIdentityRef) {
        super.init()

        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())

        self.secIdentity = identity
    }

    init?(certificatePath: String, passphrase: String) {
        super.init()
        guard let identity = identityFor(certificatePath, passphrase: passphrase) else {
            return nil
        }

        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())

        self.secIdentity = identity
    }

    func sendPush(
        tokenList tokenList: [String],
        payload: NSData,
        responseBlock: ((apnsResponse: APNS.Response) -> Void)?
        ) throws {

        for token in tokenList {
            let url = self.baseURL(options.development, port: options.port).URLByAppendingPathComponent(token)
            let request = NSMutableURLRequest(URL: url)

            request.HTTPBody = payload
            request.HTTPMethod = "POST"
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
                request.addValue("\(apnsExpiry.timeIntervalSince1970)", forHTTPHeaderField: "apns-expiration")
            }

            self.session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
                guard err == nil else {
                    log?.error(err!.localizedDescription)
                    return
                }
                let httpResponse = response as! NSHTTPURLResponse

                responseBlock?(apnsResponse: Response(deviceToken: token, response: httpResponse, data: data))
            }).resume()
        }
    }
}

extension APNS: NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        var cert : SecCertificate?
        SecIdentityCopyCertificate(self.secIdentity!, &cert)//FIXME: User identity.certificate instead
        let credentials = NSURLCredential(identity: self.secIdentity!, certificates: [cert!], persistence: .ForSession)
        completionHandler(.UseCredential,credentials)
    }
}

extension APNS {
    func identityFor(certificatePath: String, passphrase: String) -> SecIdentityRef? {
        let PKCS12Data = NSData(contentsOfFile: certificatePath)
        let passPhraseKey : String = kSecImportExportPassphrase as String
        let options = [passPhraseKey : passphrase]
        var items : CFArray?
        let ossStatus = SecPKCS12Import(PKCS12Data!, options, &items)
        guard ossStatus == errSecSuccess else {
            return nil
        }
        let arr = items!
        if CFArrayGetCount(arr) > 0 {
            let newArray = arr as [AnyObject]
            let secIdentity =  newArray[0][kSecImportItemIdentity as String] as! SecIdentityRef
            return secIdentity
        }
        return nil
    }
}



