require 'spec_helper'
require "byebug"

describe "Platform.sh configuration helper" do

  before(:all) do
    ENV["PLATFORM_APPLICATION"]="eyJyZWxhdGlvbnNoaXBzIjogeyJkYXRhYmFzZSI6ICJkYXRhYmFzZTpteXNxbCJ9LCAid2ViIjogeyJtb3ZlX3RvX3Jvb3QiOiBmYWxzZSwgImNvbW1hbmRzIjogeyJzdGFydCI6ICJ1bnNldCBQT1JUOyB1bmljb3JuIC1sIC9ydW4vYXBwLnNvY2sgLUUgcHJvZHVjdGlvbiBjb25maWcucnUiLCAic3RvcCI6IG51bGx9LCAibG9jYXRpb25zIjogeyIvIjogeyJwYXNzdGhydSI6IHRydWUsICJydWxlcyI6IHt9LCAiZXhwaXJlcyI6ICIxaCIsICJhbGxvdyI6IHRydWUsICJzY3JpcHRzIjogdHJ1ZSwgInJvb3QiOiAicHVibGljIn19fSwgImRpc2siOiAyMDQ4LCAibmFtZSI6ICJteXJ1YnlhcHAiLCAiaG9va3MiOiB7ImJ1aWxkIjogImdlbSBpbnN0YWxsIGJ1bmRsZXJcbmJ1bmRsZSBpbnN0YWxsIC0tam9icyA2IC0td2l0aG91dCBkZXZlbG9wbWVudCB0ZXN0XG4iLCAiZGVwbG95IjogIlJBQ0tfRU5WPXByb2R1Y3Rpb24gYnVuZGxlIGV4ZWMgcmFrZSBkYjptaWdyYXRlIn0sICJjcm9ucyI6IHt9LCAiYWNjZXNzIjogeyJzc2giOiAiY29udHJpYnV0b3IifSwgImRlcGVuZGVuY2llcyI6IHt9LCAicHJlZmxpZ2h0IjogeyJlbmFibGVkIjogdHJ1ZSwgImlnbm9yZWRfcnVsZXMiOiBbXX0sICJidWlsZCI6IHsiZmxhdm9yIjogbnVsbH0sICJtb3VudHMiOiB7Ii90bXAiOiAic2hhcmVkOmZpbGVzL3RtcCIsICIvbG9nIjogInNoYXJlZDpmaWxlcy9sb2cifSwgInRpbWV6b25lIjogbnVsbCwgInJ1bnRpbWUiOiB7fSwgInR5cGUiOiAicnVieS1uaWdodGx5OjIuMyIsICJzaXplIjogIkFVVE8ifQ=="
    ENV["PLATFORM_APPLICATION_NAME"]="myrubyapp"
    ENV["PLATFORM_APP_COMMAND"]="unset PORT; unicorn -l /run/app.sock -E production config.ru"
    ENV["PLATFORM_APP_DIR"]="/app"
    ENV["PLATFORM_DIR"]="/app"
    ENV["PLATFORM_DOCUMENT_ROOT"]="/app/public"
    ENV["PLATFORM_ENVIRONMENT"]="rails"
    ENV["PLATFORM_PROJECT"]="u3cwg2o536mh6"
    ENV["PLATFORM_PROJECT_ENTROPY"]="FUXBXYV6ULYBRJFMNJ5F74FBJUF4ZRJSEFMRY5UPIJLLFUGWXO6Q===="
    ENV["PLATFORM_RELATIONSHIPS"]="eyJwb3N0Z3JlcyI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAicGFzc3dvcmQiOiAibWFpbiIsICJpcCI6ICIyNDYuMC4yNDIuOTkiLCAiaG9zdCI6ICJwb3N0Z3Jlcy5pbnRlcm5hbCIsICJxdWVyeSI6IHsiaXNfbWFzdGVyIjogdHJ1ZX0sICJwYXRoIjogIm1haW4iLCAic2NoZW1lIjogInBnc3FsIiwgInBvcnQiOiA1NDMyfV0sICJtb25nb2RiIjogW3sidXNlcm5hbWUiOiAibWFpbiIsICJwYXNzd29yZCI6ICJtYWluIiwgImlwIjogIjI0Ni4wLjI0Mi44NCIsICJob3N0IjogIm1vbmdvZGIuaW50ZXJuYWwiLCAicXVlcnkiOiB7ImlzX21hc3RlciI6IHRydWV9LCAicGF0aCI6ICJtYWluIiwgInNjaGVtZSI6ICJtb25nb2RiIiwgInBvcnQiOiAyNzAxN31dLCAicmVkaXMiOiBbeyJpcCI6ICIyNDYuMC4yNDIuODUiLCAiaG9zdCI6ICJyZWRpcy5pbnRlcm5hbCIsICJzY2hlbWUiOiAicmVkaXMiLCAicG9ydCI6IDYzNzl9XSwgInJhYmJpdG1xIjogW3sidXNlcm5hbWUiOiAiZ3Vlc3QiLCAic2NoZW1lIjogImFtcXAiLCAiaXAiOiAiMjQ2LjAuMjQyLjk4IiwgImhvc3QiOiAicmFiYml0bXEuaW50ZXJuYWwiLCAicGFzc3dvcmQiOiAiZ3Vlc3QiLCAicG9ydCI6IDU2NzJ9XSwgImVsYXN0aWNzZWFyY2giOiBbeyJpcCI6ICIyNDYuMC4yNDEuMjUzIiwgImhvc3QiOiAiZWxhc3RpY3NlYXJjaC5pbnRlcm5hbCIsICJzY2hlbWUiOiAiaHR0cCIsICJwb3J0IjogIjkyMDAifV0sICJteXNxbCI6IFt7InVzZXJuYW1lIjogInVzZXIiLCAicGFzc3dvcmQiOiAiIiwgImlwIjogIjI0Ni4wLjI0Mi4xMDIiLCAiaG9zdCI6ICJteXNxbC5pbnRlcm5hbCIsICJxdWVyeSI6IHsiaXNfbWFzdGVyIjogdHJ1ZX0sICJwYXRoIjogIm1haW4iLCAic2NoZW1lIjogIm15c3FsIiwgInBvcnQiOiAzMzA2fV0sICJzb2xyIjogW3sicGF0aCI6ICJzb2xyIiwgImhvc3QiOiAic29sci5pbnRlcm5hbCIsICJzY2hlbWUiOiAic29sciIsICJwb3J0IjogODA4MCwgImlwIjogIjI0Ni4wLjI0Mi4xMTkifV19=="
    ENV["PLATFORM_ROUTES"]="eyJodHRwczovL3JhaWxzLXUzY3dnMm81MzZtaDYuZXUucGxhdGZvcm0uc2gvIjogeyJjYWNoZSI6IHsiZGVmYXVsdF90dGwiOiAwLCAiY29va2llcyI6IFsiKiJdLCAiZW5hYmxlZCI6IHRydWUsICJoZWFkZXJzIjogWyJBY2NlcHQiLCAiQWNjZXB0LUxhbmd1YWdlIl19LCAic3NpIjogeyJlbmFibGVkIjogZmFsc2V9LCAib3JpZ2luYWxfdXJsIjogImh0dHBzOi8ve2RlZmF1bHR9LyIsICJ1cHN0cmVhbSI6ICJteXJ1YnlhcHAiLCAidHlwZSI6ICJ1cHN0cmVhbSJ9LCAiaHR0cDovL3JhaWxzLXUzY3dnMm81MzZtaDYuZXUucGxhdGZvcm0uc2gvIjogeyJzc2kiOiB7ImVuYWJsZWQiOiBmYWxzZX0sICJvcmlnaW5hbF91cmwiOiAiaHR0cDovL3tkZWZhdWx0fS8iLCAidXBzdHJlYW0iOiAibXlydWJ5YXBwIiwgImNhY2hlIjogeyJkZWZhdWx0X3R0bCI6IDAsICJjb29raWVzIjogWyIqIl0sICJlbmFibGVkIjogdHJ1ZSwgImhlYWRlcnMiOiBbIkFjY2VwdCIsICJBY2NlcHQtTGFuZ3VhZ2UiXX0sICJ0eXBlIjogInVwc3RyZWFtIn19"
    ENV["PLATFORM_TREE_ID"]="2b2ba012b33a7b6f5b2cef5b42842bb04fa3cb65"
    ENV["PLATFORM_VARIABLES"]="eyJmb28iOiB7ImdydWJiIjogeyJ0d28iOiAyLCAib25lIjogMX0sICJiYXIiOiAiYmF6In19"
    ENV["PORT"]="/run/app.sock"
    @config = PlatformSH::config
  end
  after(:all) do
    ENV.clear["PLATFORM_APPLICATION"]
    ENV.clear["PLATFORM_APPLICATION_NAME"]
    ENV.clear["PLATFORM_APP_COMMAND"]
    ENV.clear["PLATFORM_APP_DIR"]
    ENV.clear["PLATFORM_DIR"]
    ENV.clear["PLATFORM_DOCUMENT_ROOT"]
    ENV.clear["PLATFORM_ENVIRONMENT"]
    ENV.clear["PLATFORM_PROJECT"]
    ENV.clear["PLATFORM_PROJECT_ENTROPY"]
    ENV.clear["PLATFORM_RELATIONSHIPS"]
    ENV.clear["PLATFORM_ROUTES"]
    ENV.clear["PLATFORM_TREE_ID"]
    ENV.clear["PLATFORM_VARIABLES"]
    ENV.clear["PORT"]
    @config = PlatformSH::config
  end
  
  it 'has a version number' do
    expect(PlatformSH::VERSION).not_to be nil
  end

  it 'has a name' do
    expect(@config["application_name"]).to eq("myrubyapp")
  end
  
  it 'has a database' do
    expect(@config["relationships"]["mysql"][0]["host"]).to eq("mysql.internal")
  end

  it 'has a project id' do
    expect(@config["project"]).to eq("u3cwg2o536mh6")
  end

  it 'gets relationships from new method' do
    expect(PlatformSH::relationship('mysql', 'host')).to eq('mysql.internal')
  end

  it 'gets environment variables' do
    expect(@config['variables']['foo']['bar']).to eq("baz")
  end

  it 'fails to guesses database url if there is more than one' do
    expect(PlatformSH::guess_database_url).to be nil
  end
  it 'guesses solr url' do
    expect(PlatformSH::guess_solr_url).to eq('http://solr.internal:8080/solr')
  end
    
  it 'guesses elasticsearch url' do
    expect(PlatformSH::guess_elasticsearch_url).to eq('http://elasticsearch.internal:9200')
  end
  
  it 'guesses mongodb url' do
    expect(PlatformSH::guess_mongodb_url).to eq('mongodb://main:main@mongodb.internal:27017/main')
  end
  
  it 'guesses redis url' do
    expect(PlatformSH::guess_redis_url).to eq('redis://redis.internal:6379')
  end

  it 'guesses rabbitmq url' do
    expect(PlatformSH::guess_rabbitmq_url).to eq('amqp://guest:guest@rabbitmq.internal:5672')
  end
  
  it 'guesses database url' do
    ENV["PLATFORM_RELATIONSHIPS"]="eyJkYXRhYmFzZSI6IFt7InVzZXJuYW1lIjogInVzZXIiLCAicGFzc3dvcmQiOiAiIiwgImlwIjogIjI0Ni4wLjI0MS41MCIsICJob3N0IjogImRhdGFiYXNlLmludGVybmFsIiwgInF1ZXJ5IjogeyJpc19tYXN0ZXIiOiB0cnVlfSwgInBhdGgiOiAibWFpbiIsICJzY2hlbWUiOiAibXlzcWwiLCAicG9ydCI6IDMzMDZ9XX0="
    @config = PlatformSH::config
    expect(PlatformSH::guess_database_url).to eq('mysql2://user:@database.internal:3306/main')
    ENV["PLATFORM_RELATIONSHIPS"]="eyJwb3N0Z3JlcyI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAicGFzc3dvcmQiOiAibWFpbiIsICJpcCI6ICIyNDYuMC4yNDIuOTkiLCAiaG9zdCI6ICJwb3N0Z3Jlcy5pbnRlcm5hbCIsICJxdWVyeSI6IHsiaXNfbWFzdGVyIjogdHJ1ZX0sICJwYXRoIjogIm1haW4iLCAic2NoZW1lIjogInBnc3FsIiwgInBvcnQiOiA1NDMyfV0sICJtb25nb2RiIjogW3sidXNlcm5hbWUiOiAibWFpbiIsICJwYXNzd29yZCI6ICJtYWluIiwgImlwIjogIjI0Ni4wLjI0Mi44NCIsICJob3N0IjogIm1vbmdvZGIuaW50ZXJuYWwiLCAicXVlcnkiOiB7ImlzX21hc3RlciI6IHRydWV9LCAicGF0aCI6ICJtYWluIiwgInNjaGVtZSI6ICJtb25nb2RiIiwgInBvcnQiOiAyNzAxN31dLCAicmVkaXMiOiBbeyJpcCI6ICIyNDYuMC4yNDIuODUiLCAiaG9zdCI6ICJyZWRpcy5pbnRlcm5hbCIsICJzY2hlbWUiOiAicmVkaXMiLCAicG9ydCI6IDYzNzl9XSwgInJhYmJpdG1xIjogW3sidXNlcm5hbWUiOiAiZ3Vlc3QiLCAic2NoZW1lIjogImFtcXAiLCAiaXAiOiAiMjQ2LjAuMjQyLjk4IiwgImhvc3QiOiAicmFiYml0bXEuaW50ZXJuYWwiLCAicGFzc3dvcmQiOiAiZ3Vlc3QiLCAicG9ydCI6IDU2NzJ9XSwgImVsYXN0aWNzZWFyY2giOiBbeyJpcCI6ICIyNDYuMC4yNDEuMjUzIiwgImhvc3QiOiAiZWxhc3RpY3NlYXJjaC5pbnRlcm5hbCIsICJzY2hlbWUiOiAiaHR0cCIsICJwb3J0IjogIjkyMDAifV0sICJteXNxbCI6IFt7InVzZXJuYW1lIjogInVzZXIiLCAicGFzc3dvcmQiOiAiIiwgImlwIjogIjI0Ni4wLjI0Mi4xMDIiLCAiaG9zdCI6ICJteXNxbC5pbnRlcm5hbCIsICJxdWVyeSI6IHsiaXNfbWFzdGVyIjogdHJ1ZX0sICJwYXRoIjogIm1haW4iLCAic2NoZW1lIjogIm15c3FsIiwgInBvcnQiOiAzMzA2fV0sICJzb2xyIjogW3sicGF0aCI6ICJzb2xyIiwgImhvc3QiOiAic29sci5pbnRlcm5hbCIsICJzY2hlbWUiOiAic29sciIsICJwb3J0IjogODA4MCwgImlwIjogIjI0Ni4wLjI0Mi4xMTkifV19=="
    @config = PlatformSH::config
  end
end
