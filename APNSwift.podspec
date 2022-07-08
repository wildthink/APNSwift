Pod::Spec.new do |spec|
  spec.name = 'APNSwift'
  spec.version = '0.5.0'
  spec.license = 'MIT'
  spec.summary = 'HTTP/2 based APNS provider written in Swift'
  spec.homepage = 'https://github.com/wildthink/APNSwift'
  spec.authors = { 'Kaunteya Suryawanshi' => 'k.suryawanshi@gmail.com' }
  spec.source = { :git => 'https://github.com/wildthink/APNSwift.git', :tag => spec.version }

  spec.ios.deployment_target = '9.0'
  spec.osx.deployment_target = '10.10'

  spec.source_files = 'Sources/*.swift'
end
