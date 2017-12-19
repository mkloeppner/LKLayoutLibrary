# Uncomment this line to define a global platform for your project
# platform :ios, "6.0"

target "LKLayoutLibraryStatic" do

end

target "LKLayoutLibraryTests" do
    pod 'Specta'
    pod 'Expecta'
    pod 'OCMockito'
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SDKROOT'] = 'iphoneos7.1'
    end
  end
end
