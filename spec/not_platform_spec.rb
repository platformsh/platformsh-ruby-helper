require 'spec_helper'

describe PlatformSH do
  before(:all) do
      @config = PlatformSH::config
    end

    it 'config is nil when not running on platform' do
      expect(@config).to be_nil
    end

    it 'does not fail when running in envs other than Platform' do
      expect(PlatformSH::get_relationship('database', 'host')).to be_nil
    end
  
end
