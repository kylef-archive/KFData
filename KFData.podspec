Pod::Spec.new do |s|
  s.name = 'KFData'
  s.version = '0.1'
  s.license = 'BSD'
  s.summary = 'Lightweight Core Data wrapper.'
  s.homepage = 'https://github.com/kylef/KFData'
  s.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  s.source = { :git => 'https://github.com/kylef/KFData.git', :tag => '0.1' }
  s.source_files = 'Classes'

  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.ios.frameworks = 'CoreData'
end

