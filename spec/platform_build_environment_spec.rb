require 'spec_helper'

describe "Platform.sh helper Build Environment" do

  before(:all) do
    ENV['PLATFORM_APPLICATION']='eyJzaXplIjogIkFVVE8iLCAiZGlzayI6IDIwNDgsICJhY2Nlc3MiOiB7InNzaCI6ICJjb250cmlidXRvciJ9LCAicmVsYXRpb25zaGlwcyI6IHsicG9zdGdyZXMiOiAicG9zdGdyZXNxbDpwb3N0Z3Jlc3FsIiwgIm1vbmdvZGIiOiAibW9uZ29kYjptb25nb2RiIiwgInJlZGlzIjogInJlZGlzOnJlZGlzIiwgInJhYmJpdG1xIjogInJhYmJpdG1xOnJhYmJpdG1xIiwgImVsYXN0aWNzZWFyY2giOiAiZWxhc3RpY3NlYXJjaDplbGFzdGljc2VhcmNoIiwgImluZmx1eGRiIjogImluZmx1eGRiOmluZmx1eGRiIiwgIm15c3FsIjogIm15c3FsOm15c3FsIiwgInNvbHIiOiAic29scjpzb2xyIn0sICJtb3VudHMiOiB7Ii9wdWJsaWMiOiAic2hhcmVkOmZpbGVzL2ZpbGVzIn0sICJ0aW1lem9uZSI6IG51bGwsICJ2YXJpYWJsZXMiOiB7fSwgIm5hbWUiOiAibXlydWJ5YXBwIiwgInR5cGUiOiAicnVieToyLjUiLCAicnVudGltZSI6IHt9LCAicHJlZmxpZ2h0IjogeyJlbmFibGVkIjogdHJ1ZSwgImlnbm9yZWRfcnVsZXMiOiBbXX0sICJ3ZWIiOiB7ImxvY2F0aW9ucyI6IHsiLyI6IHsicm9vdCI6ICJwdWJsaWMiLCAiZXhwaXJlcyI6ICIxaCIsICJwYXNzdGhydSI6IHRydWUsICJzY3JpcHRzIjogdHJ1ZSwgImFsbG93IjogdHJ1ZSwgImhlYWRlcnMiOiB7fSwgInJ1bGVzIjoge319fSwgImNvbW1hbmRzIjogeyJzdGFydCI6ICJ1bmljb3JuIC1sICRTT0NLRVQgLUUgcHJvZHVjdGlvbiBjb25maWcucnUiLCAic3RvcCI6IG51bGx9LCAidXBzdHJlYW0iOiB7InNvY2tldF9mYW1pbHkiOiAidW5peCIsICJwcm90b2NvbCI6IG51bGx9LCAibW92ZV90b19yb290IjogZmFsc2V9LCAiaG9va3MiOiB7ImJ1aWxkIjogInJ1YnkgLWUgJ3B1dHMgUlVCWV9WRVJTSU9OJ1xuYnVuZGxlIGluc3RhbGxcbiIsICJkZXBsb3kiOiBudWxsfX0='
    ENV['PLATFORM_APPLICATION_NAME']='app'
    ENV['PLATFORM_APP_DIR']='/app'
    ENV['PLATFORM_DOCUMENT_ROOT']='/app/public'
    ENV['PLATFORM_PROJECT']='u3cwg2o536mh6'
    ENV['PLATFORM_TREE_ID']=''
        
    @config = PlatformSH::config
  end
  after(:all) do
    ENV.clear['PLATFORM_APPLICATION']
    ENV.clear['PLATFORM_APPLICATION_NAME']
    ENV.clear['PLATFORM_APP_DIR']
    ENV.clear['PLATFORM_DOCUMENT_ROOT']
    ENV.clear['PLATFORM_PROJECT']
    ENV.clear['PLATFORM_TREE_ID']
    @config = PlatformSH::config
  end
  
  it 'is on platform' do
    expect(PlatformSH::on_platform?).to be true 
  end
  
  it 'is a build environment' do
    expect(PlatformSH::is_build_environment?).to be true 
  end
  
  it 'has a name' do
    expect(@config["application_name"]).to eq("app")
  end

  it 'has a project id' do
      expect(@config["project"]).to eq("u3cwg2o536mh6")
  end
  
  it 'does not have an environment' do
    expect(@config["environment"]).to be_nil
  end


end
