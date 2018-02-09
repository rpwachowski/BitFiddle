Pod::Spec.new do |s|
  s.name          = 'BitFiddle'
  s.version       = '0.0.1'
  s.summary       = 'Directly manipulate data with expressive and type-safe interfaces.'
  s.description   = 'TODO'
  s.license       = 'MIT'
  s.author        = 'Ryan Wachowski'
  s.source        = { git: 'http://foo.bar/BitFiddle.git', tag: "#{s.version}" }
  s.homepage      = s.source[:git]
  s.source_files  =  "BitFiddle/**/*.{h,m,swift}"
end
