Pod::Spec.new do |s|
  s.name         = "RSOSData"
  s.version      = "0.8.0-beta1"
  s.summary      = "Get life-saving user data into the hands of first responders in an emergency."
  s.homepage     = "https://rapidsos.com/products/#emergencyapi"
  s.license      = 'APACHE'
  s.authors      = { "Gabe Mahoney" => "gmahoney@rapidsos.com" }
  s.ios.deployment_target  = "8.0"
  s.source       = { :git => "https://github.com/RapidSOS/era-ios.git", :tag => s.version }

  s.requires_arc = true
  
  s.public_header_files = "RSOSData/RSOSData/RSOSData.h"
  s.source_files = "RSOSData/RSOSData/*.{h,m}"

  s.subspec "Util" do |ss|
    ss.source_files = "RSOSData/RSOSData/Utils/*.{h,m}"
    ss.public_header_files = "RSOSData/RSOSData/Utils/*.h"
  end

  s.subspec "Serialization" do |ss|
    ss.dependency "RSOSData/Util"
    ss.source_files = "RSOSData/RSOSData/Serialization/*.{h,m}", "RSOSData/RSOSData/Serialization/**/*.{h,m}"
    ss.public_header_files = "RSOSData/RSOSData/Serialization/*.h", "RSOSData/RSOSData/Serialization/**/*.h"
  end

  s.subspec "Authorization" do |ss|
    ss.dependency "RSOSData/Util"
    ss.dependency "AFNetworking"
    ss.source_files = "RSOSData/RSOSData/Authorization/*.{h,m}", "RSOSData/RSOSData/Authorization/**/*.{h,m}"
    ss.public_header_files = "RSOSData/RSOSData/Authorization/*.h", "RSOSData/RSOSData/Authorization/**/*.h"
    ss.frameworks = "Security"
  end

  s.subspec "DataClient" do |ss|
    ss.dependency "RSOSData/Authorization"
    ss.dependency "RSOSData/Serialization"
    ss.dependency "AFNetworking"
    ss.source_files = "RSOSData/RSOSData/DataClient/*.{h,m}"
    ss.public_header_files = "RSOSData/RSOSData/DataClient/*.h"
  end

end