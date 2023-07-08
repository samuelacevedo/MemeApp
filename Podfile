platform :ios, '13.0'

target 'MemeApp' do
  use_frameworks!
  
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SkeletonView'
  pod "Kingfisher", '~> 7.0'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
