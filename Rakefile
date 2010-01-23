# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('contextify') do
  self.rubyforge_name = 'contextify'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_options += ['--protected']
  self.remote_yard_dir = ''

  self.extra_dev_deps += [
    ['rspec', '>=1.2.8'],
    ['yard', '>=0.5.3']
  ]
end

# vim: syntax=Ruby
