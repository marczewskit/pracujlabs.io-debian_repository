require 'spec_helper_system'

describe 'basic tests' do
  it 'class should work without errors and be idempotent' do
    pp = <<-EOS
      class { 'apt': }
      class { 'aptly': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
      r.refresh
      r.exit_code.should be_zero
    end
  end

  it 'should have installed aptly' do
    shell 'aptly version' do |r|
      r.stdout.should =~ /^aptly version:/
      r.stderr.should be_empty
      r.exit_code.should be_zero
    end
  end
end
