project 'RxDemo.xcodeproj'


def net_pods
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

def model_pods
    pod 'ObjectMapper'
end

# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'RxDemo' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxDemo
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    #pod 'Alamofire'
    #pod 'RxAlamofire'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
        
    end
    
  target 'RxDemoTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'RxDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
