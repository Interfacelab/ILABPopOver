Pod::Spec.new do |s|
  s.name             = "ILABPopOver"
  s.version          = "0.0.1"
  s.summary          = "A popover library for iOS."
  s.homepage         = "https://github.com/interfacelab/ILABPopOver"
  s.license          = { :type => "BSD", :file => "LICENSE" }
  s.author           = { "Jon Gilkison" => "jon@interfacelab.com" }
  s.source           = { :git => "https://github.com/interfacelab/ILABPopOver.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Source'
end
