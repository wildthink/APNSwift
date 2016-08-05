Pod::Spec.new do |spec|
  spec.name = 'apns-swift'
  spec.version = '0.1.0'
  spec.license = 'MIT'
  spec.summary = 'APNS provider written in Swift'
  spec.homepage = 'https://github.com/kaunteya/apns-swift'
  spec.authors = { 'Kaunteya Suryawanshi' => 'k.suryawanshi@gmail.com' }
  spec.source = { :git => 'https://github.com/kaunteya/apns-swift.git', :tag => spec.version }

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.tvos.deployment_target = '9.0'

  spec.requires_arc = true

  spec.source_files = 'Source/*.swift'
end
