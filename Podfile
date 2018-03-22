# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/RapidSOS/beacon-ios-sdk.git'

target 'RSOSData' do
    
    workspace 'EmergencyReferenceApp.xcworkspace'
    project 'RSOSData/RSOSData'
    
    pod 'AFNetworking'
    
end

target 'EmergencyReferenceApp' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
  workspace 'EmergencyReferenceApp.xcworkspace'
  project 'EmergencyReferenceApp'

  pod 'AFNetworking'
  pod 'UIView+Shake'
  pod 'SVProgressHUD'
  pod 'IQKeyboardManager'
  pod 'RSOSData', :path => '.'

  # Pods for Emergency Reference App

end
