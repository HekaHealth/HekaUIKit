Pod::Spec.new do |s|
    s.name             = 'HekaUIKit'
    s.version          = '0.0.1'
    s.summary          = 'Integrate fitness data sources into your app.'
    s.homepage         = 'https://www.hekahealth.co'
    s.license          = { :type => 'GNU AGPL', :file => 'LICENSE' }
    s.author           = { 'Heka' => 'contact@hekahealth.co' }
    s.source           = { :git => 'https://github.com/HekaHealth/HekaUIKit.git', :tag => s.version.to_s }
    s.ios.deployment_target = '11.0'
    s.swift_version = '5.0'
    s.source_files = 'Sources/HekaUIKit/**/*.{swift, plist}'
    s.dependency 'HekaCore', '~> 0.0.8'
    s.resource_bundles = {
        'heka_heka' => [
            'Sources/HekaUIKit/**/*.{ xib,storyboard,xcassets,json,png }'
        ]
    }
  end