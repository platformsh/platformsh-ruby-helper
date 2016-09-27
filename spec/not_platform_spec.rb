require 'spec_helper'

describe PlatformSH do
  before(:all) do
      @config = PlatformSH::config
    end

    it 'config is nil when not running on platform' do
      expect(@config).to be_nil
    end
  
end
