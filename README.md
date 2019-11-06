# APNSwift
HTTP/2 Apple Push Notification Service (APNs) push provider written in Swift

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/APNSwift.svg)](https://img.shields.io/cocoapods/v/APNSwift.svg)
[![Platform](https://img.shields.io/cocoapods/p/APNSwift.svg?style=flat)](http://cocoadocs.org/docsets/APNSwift)
[![License](https://img.shields.io/cocoapods/l/APNSwift.svg?style=flat)](http://cocoadocs.org/docsets/APNSwift)


## Features
- Sends notification using new HTTP/2 protocol
- Send notifications iOS, tvOS and macOS apps

# Installation
##CocoaPods
[CocoaPods](http://cocoapods.org) adds supports for Swift and embedded frameworks.

To integrate APNSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby

pod 'APNSwift'
```

## Usage

### Initialization
#### SecIdentity
```swift
let apnsConnection = APNS(identity: certificateIdentity, options: apnsOptions)
```
#### PFCS Container (.p12)
```swift
guard let apns = APNS(certificatePath: "/path/to/PKCS/certificate", passphrase: "********") else {
    //Failed to create APNS object
    return nil
}

```

### Push Notification options
```swift
var apnsOptions = APNS.Options()
apnsOptions.topic = "Weekend deal"
apnsOptions.port = .p2197
apnsOptions.expiry = NSDate()
apnsOptions.development = false
```

### Push
```swift
try! apnsConnection.sendPush(tokenList: tokens, payload: jsonPayLoad) {
    (apnsResponse) in
    Swift.print("\n\(apnsResponse.deviceToken)")
    Swift.print("  Status: \(apnsResponse.serviceStatus)")
    Swift.print("  APNS ID: \(apnsResponse.apnsId ?? "")")
    if let errorReason = apnsResponse.errorReason {
        Swift.print("  ERROR: \(errorReason)")
    }
}
```
