# apns-swift
HTTP/2 Apple Push Notification Service (APNs) push provider written in Swift

## Features
- Sends notifications using new HTTP/2 protocol
- Send notifications iOS, tvOS and macOS apps

# Installation
##CocoaPods
[CocoaPods](http://cocoapods.org) adds supports for Swift and embedded frameworks.

To integrate APNSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby

pod 'APNSwift'
```

## Usage
### APNS Connection can be created by `SecIdentity` or `Path to PKCS certificate`
```swift
guard let apns = APNS(certificatePath: "/path/to/PKCS/certificate", passphrase: "********") else {
    //Failed to create APNS object
    return nil
}

let apnsConnection = APNS(identity: certificateIdentity)
```

### Push Notification options
```swift
var apnsOptions = APNS.Options()
apnsOptions.development = true
apnsOptions.port = APNS.Options.Port.p443
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
