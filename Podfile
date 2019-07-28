platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

target 'CatList' do
    pod 'SDWebImage'
    pod 'Whisper'
end

target 'GiniKit' do
  pod 'Alamofire'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # puts "#{target} #{config} configuration…"
      config.build_settings['ENABLE_BITCODE'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      # puts "ENABLE_BITCODE #{config.build_settings['ENABLE_BITCODE'].inspect}"
    end
  end
end
