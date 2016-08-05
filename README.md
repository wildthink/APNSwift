# apns-swift

## Usage
### Create APNS connection object
```swift
guard let apnsConnection = APNS(certificatePath: pathOfCertificate, passphrase: "*******") else {
    Swift.print("Connection creation failed")
    return
}
```

### Create options
```swift
var apnsOptions = APNS.Options()
apnsOptions.development = true
apnsOptions.port = APNS.Options.Port.p443
```

### Push
```swift
try! apnsConnection.sendPush(tokenList: tokens, payload: jsonPayLoad, options: apnsOptions) {
    (apnsResponse) in
    Swift.print("Status: \(apnsResponse.serviceStatus)")
    Swift.print("APNS ID: \(apnsResponse.apnsId)")
    if let errorReason = apnsResponse.errorReason {
        Swift.print("ERROR: \(errorReason)")
    }
}
```
