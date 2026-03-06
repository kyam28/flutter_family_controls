Pod::Spec.new do |s|
  s.name             = 'flutter_family_controls'
  s.version          = '0.0.2'
  s.summary          = 'Flutter plugin for iOS Screen Time API (FamilyControls / ManagedSettings).'
  s.description      = <<-DESC
A Flutter plugin that wraps iOS FamilyControls, ManagedSettings, and FamilyActivityPicker
to allow Flutter apps to request Screen Time authorization, pick apps to restrict,
and enable/disable app restrictions.
                       DESC
  s.homepage         = 'https://github.com/kyam28/flutter_family_controls'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'kyam' => 'kyam28@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
