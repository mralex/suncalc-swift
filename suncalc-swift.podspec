Pod::Spec.new do |s|
	s.name        = "suncalc-swift"
	s.version     = "0.1.2"
	s.summary     = "This is a swift port for iOS of https://github.com/PierreBartholomae/suncalc"
	s.homepage    = "https://github.com/PierreBartholomae/suncalc-swift"
	s.license     = { :type => "MIT" }
	s.authors     = { "shanus" => "shaun@chimani.com" }

	s.requires_arc = true
	s.platform = :ios
	s.ios.deployment_target = "9.0"
	s.source   = { :git => "https://github.com/PierreBartholomae/suncalc-swift.git"}
	s.source_files = "suncalc/**/*.swift"
end
