use_frameworks!
target “HelloWorld” do
pod 'Crashlytics', '~> 3.6'
pod 'Fabric', '~> 1.6'
pod 'AFNetworking', '~> 3.0'
post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ''
			config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
			config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
		end
	end
end
end

