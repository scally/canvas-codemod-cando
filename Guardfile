# A sample Guardfile
guard :minitest, cli: '--pride' do
  watch(%r{^spec/(.*)_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
end
