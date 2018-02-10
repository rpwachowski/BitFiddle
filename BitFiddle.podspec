Pod::Spec.new do |s|
  s.name          = 'BitFiddle'
  s.version       = '0.1.0'
  s.summary       = 'A tiny library for reading and interpreting raw data.'
  s.description   = <<-DESC
  BitFiddle is a library for reading and interpreting raw data. It makes use of the type system to create safe interfaces for converting to and from various types. The goal of BitFiddle is to ensure that clients can focus on using data instead of asserting preconditions.
  DESC
  s.license       = 'MIT'
  s.author        = 'Ryan Wachowski'
  s.source        = { git: 'https://github.com/rpwachowski/BitFiddle.git', tag: "#{s.version}" }
  s.homepage      = s.source[:git]
  s.source_files  = "BitFiddle/**/*.{h,m,swift}"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true 
  s.swift_version = '4.0'
end
