require 'spec_helper'

describe "Platform.sh configuration helper" do

  before(:all) do
    ENV['SOCKET']='/run/app.sock'
    ENV['PLATFORM_APPLICATION']='eyJzaXplIjogIkFVVE8iLCAiZGlzayI6IDIwNDgsICJhY2Nlc3MiOiB7InNzaCI6ICJjb250cmlidXRvciJ9LCAicmVsYXRpb25zaGlwcyI6IHsicG9zdGdyZXMiOiAicG9zdGdyZXNxbDpwb3N0Z3Jlc3FsIiwgIm1vbmdvZGIiOiAibW9uZ29kYjptb25nb2RiIiwgInJlZGlzIjogInJlZGlzOnJlZGlzIiwgInJhYmJpdG1xIjogInJhYmJpdG1xOnJhYmJpdG1xIiwgImVsYXN0aWNzZWFyY2giOiAiZWxhc3RpY3NlYXJjaDplbGFzdGljc2VhcmNoIiwgImluZmx1eGRiIjogImluZmx1eGRiOmluZmx1eGRiIiwgIm15c3FsIjogIm15c3FsOm15c3FsIiwgInNvbHIiOiAic29scjpzb2xyIn0sICJtb3VudHMiOiB7Ii9wdWJsaWMiOiAic2hhcmVkOmZpbGVzL2ZpbGVzIn0sICJ0aW1lem9uZSI6IG51bGwsICJ2YXJpYWJsZXMiOiB7fSwgIm5hbWUiOiAibXlydWJ5YXBwIiwgInR5cGUiOiAicnVieToyLjUiLCAicnVudGltZSI6IHt9LCAicHJlZmxpZ2h0IjogeyJlbmFibGVkIjogdHJ1ZSwgImlnbm9yZWRfcnVsZXMiOiBbXX0sICJ3ZWIiOiB7ImxvY2F0aW9ucyI6IHsiLyI6IHsicm9vdCI6ICJwdWJsaWMiLCAiZXhwaXJlcyI6ICIxaCIsICJwYXNzdGhydSI6IHRydWUsICJzY3JpcHRzIjogdHJ1ZSwgImFsbG93IjogdHJ1ZSwgImhlYWRlcnMiOiB7fSwgInJ1bGVzIjoge319fSwgImNvbW1hbmRzIjogeyJzdGFydCI6ICJ1bmljb3JuIC1sICRTT0NLRVQgLUUgcHJvZHVjdGlvbiBjb25maWcucnUiLCAic3RvcCI6IG51bGx9LCAidXBzdHJlYW0iOiB7InNvY2tldF9mYW1pbHkiOiAidW5peCIsICJwcm90b2NvbCI6IG51bGx9LCAibW92ZV90b19yb290IjogZmFsc2V9LCAiaG9va3MiOiB7ImJ1aWxkIjogInJ1YnkgLWUgJ3B1dHMgUlVCWV9WRVJTSU9OJ1xuYnVuZGxlIGluc3RhbGxcbiIsICJkZXBsb3kiOiBudWxsfX0='
    ENV['PLATFORM_APPLICATION_NAME']='myrubyapp'
    ENV['PLATFORM_APP_COMMAND']='unicorn -l /run/app.sock -E production config.ru'
    ENV['PLATFORM_APP_DIR']='/app'
    ENV['PLATFORM_BRANCH']='master'
    ENV['PLATFORM_DIR']='/app'
    ENV['PLATFORM_DOCUMENT_ROOT']='/app/public'
    ENV['PLATFORM_ENVIRONMENT']='master-7rqtwti'
    ENV['PLATFORM_PROJECT']='u3cwg2o536mh6'
    ENV['PLATFORM_PROJECT_ENTROPY']='EOP6EKCM2IY5IJ2H4PBF5OVO4RBJZC7GU72NDLGDJ67PYWNAJYIA===='
    ENV['PLATFORM_RELATIONSHIPS']='eyJwb3N0Z3JlcyI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAic2NoZW1lIjogInBnc3FsIiwgInNlcnZpY2UiOiAicG9zdGdyZXNxbCIsICJpcCI6ICIyNTAuMC42Ni43MiIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJwb3N0Z3Jlcy5pbnRlcm5hbCIsICJyZWwiOiAicG9zdGdyZXNxbCIsICJwYXRoIjogIm1haW4iLCAicXVlcnkiOiB7ImlzX21hc3RlciI6IHRydWV9LCAicGFzc3dvcmQiOiAibWFpbiIsICJwb3J0IjogNTQzMn1dLCAibW9uZ29kYiI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAic2NoZW1lIjogIm1vbmdvZGIiLCAic2VydmljZSI6ICJtb25nb2RiIiwgImlwIjogIjI1MC4wLjY2Ljc0IiwgImNsdXN0ZXIiOiAic3hsbG1uZGgzeHZodS1tYXN0ZXItN3JxdHd0aSIsICJob3N0IjogIm1vbmdvZGIuaW50ZXJuYWwiLCAicmVsIjogIm1vbmdvZGIiLCAicGF0aCI6ICJtYWluIiwgInF1ZXJ5IjogeyJpc19tYXN0ZXIiOiB0cnVlfSwgInBhc3N3b3JkIjogIm1haW4iLCAicG9ydCI6IDI3MDE3fV0sICJyZWRpcyI6IFt7InNlcnZpY2UiOiAicmVkaXMiLCAiaXAiOiAiMjUwLjAuNjYuNzAiLCAiY2x1c3RlciI6ICJzeGxsbW5kaDN4dmh1LW1hc3Rlci03cnF0d3RpIiwgImhvc3QiOiAicmVkaXMuaW50ZXJuYWwiLCAicmVsIjogInJlZGlzIiwgInNjaGVtZSI6ICJyZWRpcyIsICJwb3J0IjogNjM3OX1dLCAicmFiYml0bXEiOiBbeyJ1c2VybmFtZSI6ICJndWVzdCIsICJwYXNzd29yZCI6ICJndWVzdCIsICJzZXJ2aWNlIjogInJhYmJpdG1xIiwgImlwIjogIjI1MC4wLjY2Ljc1IiwgImNsdXN0ZXIiOiAic3hsbG1uZGgzeHZodS1tYXN0ZXItN3JxdHd0aSIsICJob3N0IjogInJhYmJpdG1xLmludGVybmFsIiwgInJlbCI6ICJyYWJiaXRtcSIsICJzY2hlbWUiOiAiYW1xcCIsICJwb3J0IjogNTY3Mn1dLCAiZWxhc3RpY3NlYXJjaCI6IFt7InNlcnZpY2UiOiAiZWxhc3RpY3NlYXJjaCIsICJpcCI6ICIyNTAuMC42Ni44MCIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJlbGFzdGljc2VhcmNoLmludGVybmFsIiwgInJlbCI6ICJlbGFzdGljc2VhcmNoIiwgInNjaGVtZSI6ICJodHRwIiwgInBvcnQiOiAiOTIwMCJ9XSwgImluZmx1eGRiIjogW3sic2VydmljZSI6ICJpbmZsdXhkYiIsICJpcCI6ICIyNTAuMC42Ni44NyIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJpbmZsdXhkYi5pbnRlcm5hbCIsICJyZWwiOiAiaW5mbHV4ZGIiLCAic2NoZW1lIjogImh0dHAiLCAicG9ydCI6IDgwODZ9XSwgIm15c3FsIjogW3sidXNlcm5hbWUiOiAidXNlciIsICJzY2hlbWUiOiAibXlzcWwiLCAic2VydmljZSI6ICJteXNxbCIsICJpcCI6ICIyNTAuMC42Ni44MiIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJteXNxbC5pbnRlcm5hbCIsICJyZWwiOiAibXlzcWwiLCAicGF0aCI6ICJtYWluIiwgInF1ZXJ5IjogeyJpc19tYXN0ZXIiOiB0cnVlfSwgInBhc3N3b3JkIjogIiIsICJwb3J0IjogMzMwNn1dLCAic29sciI6IFt7InNlcnZpY2UiOiAic29sciIsICJpcCI6ICIyNTAuMC42Ni44MyIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJzb2xyLmludGVybmFsIiwgInJlbCI6ICJzb2xyIiwgInBhdGgiOiAic29sciIsICJzY2hlbWUiOiAic29sciIsICJwb3J0IjogODA4MH1dfQ=='
    ENV['PLATFORM_ROUTES']='eyJodHRwczovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIjogeyJ0eXBlIjogInVwc3RyZWFtIiwgImNhY2hlIjogeyJkZWZhdWx0X3R0bCI6IDAsICJjb29raWVzIjogWyIqIl0sICJlbmFibGVkIjogdHJ1ZSwgImhlYWRlcnMiOiBbIkFjY2VwdCIsICJBY2NlcHQtTGFuZ3VhZ2UiXX0sICJzc2kiOiB7ImVuYWJsZWQiOiBmYWxzZX0sICJ1cHN0cmVhbSI6ICJteXJ1YnlhcHAiLCAib3JpZ2luYWxfdXJsIjogImh0dHBzOi8ve2RlZmF1bHR9LyJ9LCAiaHR0cDovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIjogeyJ0byI6ICJodHRwczovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIiwgInR5cGUiOiAicmVkaXJlY3QiLCAib3JpZ2luYWxfdXJsIjogImh0dHA6Ly97ZGVmYXVsdH0vIn19'
    ENV['PLATFORM_SMTP_HOST']='250.0.64.1'
    ENV['PLATFORM_TREE_ID']='61927a879ea2a45c83e62fb8b78c6579aac5d8eb'
    ENV["PLATFORM_VARIABLES"]="eyJmb28iOiB7ImdydWJiIjogeyJ0d28iOiAyLCAib25lIjogMX0sICJiYXIiOiAiYmF6In19"
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
  
  it 'guesses influxdb url' do
    expect(PlatformSH::guess_influxdb_url).to eq('http://influxdb.internal:8086')
  end

  
  it 'guesses database url' do
    ENV["PLATFORM_RELATIONSHIPS"]="eyAgIm15c3FsIjogWw0KICAgIHsNCiAgICAgICJ1c2VybmFtZSI6ICJ1c2VyIiwNCiAgICAgICJzY2hlbWUiOiAibXlzcWwiLA0KICAgICAgInNlcnZpY2UiOiAibXlzcWwiLA0KICAgICAgImlwIjogIjI1MC4wLjY2LjgyIiwNCiAgICAgICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLA0KICAgICAgImhvc3QiOiAibXlzcWwuaW50ZXJuYWwiLA0KICAgICAgInJlbCI6ICJteXNxbCIsDQogICAgICAicGF0aCI6ICJtYWluIiwNCiAgICAgICJxdWVyeSI6IHsNCiAgICAgICAgImlzX21hc3RlciI6IHRydWUNCiAgICAgIH0sDQogICAgICAicGFzc3dvcmQiOiAiIiwNCiAgICAgICJwb3J0IjogMzMwNg0KICAgIH0NCiAgXX0="
    @config = PlatformSH::config
    expect(PlatformSH::guess_database_url).to eq('mysql://user:@mysql.internal:3306/main')
    ENV["PLATFORM_RELATIONSHIPS"]="eyJwb3N0Z3JlcyI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAic2NoZW1lIjogInBnc3FsIiwgInNlcnZpY2UiOiAicG9zdGdyZXNxbCIsICJpcCI6ICIyNTAuMC42Ni43MiIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJwb3N0Z3Jlcy5pbnRlcm5hbCIsICJyZWwiOiAicG9zdGdyZXNxbCIsICJwYXRoIjogIm1haW4iLCAicXVlcnkiOiB7ImlzX21hc3RlciI6IHRydWV9LCAicGFzc3dvcmQiOiAibWFpbiIsICJwb3J0IjogNTQzMn1dLCAibW9uZ29kYiI6IFt7InVzZXJuYW1lIjogIm1haW4iLCAic2NoZW1lIjogIm1vbmdvZGIiLCAic2VydmljZSI6ICJtb25nb2RiIiwgImlwIjogIjI1MC4wLjY2Ljc0IiwgImNsdXN0ZXIiOiAic3hsbG1uZGgzeHZodS1tYXN0ZXItN3JxdHd0aSIsICJob3N0IjogIm1vbmdvZGIuaW50ZXJuYWwiLCAicmVsIjogIm1vbmdvZGIiLCAicGF0aCI6ICJtYWluIiwgInF1ZXJ5IjogeyJpc19tYXN0ZXIiOiB0cnVlfSwgInBhc3N3b3JkIjogIm1haW4iLCAicG9ydCI6IDI3MDE3fV0sICJyZWRpcyI6IFt7InNlcnZpY2UiOiAicmVkaXMiLCAiaXAiOiAiMjUwLjAuNjYuNzAiLCAiY2x1c3RlciI6ICJzeGxsbW5kaDN4dmh1LW1hc3Rlci03cnF0d3RpIiwgImhvc3QiOiAicmVkaXMuaW50ZXJuYWwiLCAicmVsIjogInJlZGlzIiwgInNjaGVtZSI6ICJyZWRpcyIsICJwb3J0IjogNjM3OX1dLCAicmFiYml0bXEiOiBbeyJ1c2VybmFtZSI6ICJndWVzdCIsICJwYXNzd29yZCI6ICJndWVzdCIsICJzZXJ2aWNlIjogInJhYmJpdG1xIiwgImlwIjogIjI1MC4wLjY2Ljc1IiwgImNsdXN0ZXIiOiAic3hsbG1uZGgzeHZodS1tYXN0ZXItN3JxdHd0aSIsICJob3N0IjogInJhYmJpdG1xLmludGVybmFsIiwgInJlbCI6ICJyYWJiaXRtcSIsICJzY2hlbWUiOiAiYW1xcCIsICJwb3J0IjogNTY3Mn1dLCAiZWxhc3RpY3NlYXJjaCI6IFt7InNlcnZpY2UiOiAiZWxhc3RpY3NlYXJjaCIsICJpcCI6ICIyNTAuMC42Ni44MCIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJlbGFzdGljc2VhcmNoLmludGVybmFsIiwgInJlbCI6ICJlbGFzdGljc2VhcmNoIiwgInNjaGVtZSI6ICJodHRwIiwgInBvcnQiOiAiOTIwMCJ9XSwgImluZmx1eGRiIjogW3sic2VydmljZSI6ICJpbmZsdXhkYiIsICJpcCI6ICIyNTAuMC42Ni44NyIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJpbmZsdXhkYi5pbnRlcm5hbCIsICJyZWwiOiAiaW5mbHV4ZGIiLCAic2NoZW1lIjogImh0dHAiLCAicG9ydCI6IDgwODZ9XSwgIm15c3FsIjogW3sidXNlcm5hbWUiOiAidXNlciIsICJzY2hlbWUiOiAibXlzcWwiLCAic2VydmljZSI6ICJteXNxbCIsICJpcCI6ICIyNTAuMC42Ni44MiIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJteXNxbC5pbnRlcm5hbCIsICJyZWwiOiAibXlzcWwiLCAicGF0aCI6ICJtYWluIiwgInF1ZXJ5IjogeyJpc19tYXN0ZXIiOiB0cnVlfSwgInBhc3N3b3JkIjogIiIsICJwb3J0IjogMzMwNn1dLCAic29sciI6IFt7InNlcnZpY2UiOiAic29sciIsICJpcCI6ICIyNTAuMC42Ni44MyIsICJjbHVzdGVyIjogInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCAiaG9zdCI6ICJzb2xyLmludGVybmFsIiwgInJlbCI6ICJzb2xyIiwgInBhdGgiOiAic29sciIsICJzY2hlbWUiOiAic29sciIsICJwb3J0IjogODA4MH1dfQ=="
    @config = PlatformSH::config
  end
  
  it 'guesses hostname' do
    @config = PlatformSH::config
    expect(PlatformSH::guess_hostname).to eq('master-7rqtwti-sxllmndh3xvhu.eu.platform.sh')
  end

  describe '.export_services_urls' do
    let(:export_services_envs) do
      %w[DATABASE_URL MONGODB_URL REDIS_URL ELASTICSEARCH_URL RABBITMQ_URL
         SOLR_URL INFLUXDB_URL KAFKA_URL HOSTNAME].freeze
    end

    context 'when ENV is not already set' do
      it 'try to guess urls' do
        export_services_envs.each do |key|
          ENV.clear[key]
        end
        ENV["PLATFORM_ENVIRONMENT"] = "production"
        ENV['PLATFORM_PROJECT']='u3cwg2o536mh6'
        # blank them to avoid log warning
        ENV['PLATFORM_APPLICATION']= "e30=\n"
        ENV['PLATFORM_VARIABLES'] = "e30=\n"
        # postgres without mysql to have a DATABASE_URL present
        ENV['PLATFORM_RELATIONSHIPS']="eyJwb3N0Z3JlcyI6W3sidXNlcm5hbWUiOiJtYWluIiwic2NoZW1lIjoicGdz\ncWwiLCJzZXJ2aWNlIjoicG9zdGdyZXNxbCIsImlwIjoiMjUwLjAuNjYuNzIi\nLCJjbHVzdGVyIjoic3hsbG1uZGgzeHZodS1tYXN0ZXItN3JxdHd0aSIsImhv\nc3QiOiJwb3N0Z3Jlcy5pbnRlcm5hbCIsInJlbCI6InBvc3RncmVzcWwiLCJw\nYXRoIjoibWFpbiIsInF1ZXJ5Ijp7ImlzX21hc3RlciI6dHJ1ZX0sInBhc3N3\nb3JkIjoibWFpbiIsInBvcnQiOjU0MzJ9XSwibW9uZ29kYiI6W3sidXNlcm5h\nbWUiOiJtYWluIiwic2NoZW1lIjoibW9uZ29kYiIsInNlcnZpY2UiOiJtb25n\nb2RiIiwiaXAiOiIyNTAuMC42Ni43NCIsImNsdXN0ZXIiOiJzeGxsbW5kaDN4\ndmh1LW1hc3Rlci03cnF0d3RpIiwiaG9zdCI6Im1vbmdvZGIuaW50ZXJuYWwi\nLCJyZWwiOiJtb25nb2RiIiwicGF0aCI6Im1haW4iLCJxdWVyeSI6eyJpc19t\nYXN0ZXIiOnRydWV9LCJwYXNzd29yZCI6Im1haW4iLCJwb3J0IjoyNzAxN31d\nLCJyZWRpcyI6W3sic2VydmljZSI6InJlZGlzIiwiaXAiOiIyNTAuMC42Ni43\nMCIsImNsdXN0ZXIiOiJzeGxsbW5kaDN4dmh1LW1hc3Rlci03cnF0d3RpIiwi\naG9zdCI6InJlZGlzLmludGVybmFsIiwicmVsIjoicmVkaXMiLCJzY2hlbWUi\nOiJyZWRpcyIsInBvcnQiOjYzNzl9XSwicmFiYml0bXEiOlt7InVzZXJuYW1l\nIjoiZ3Vlc3QiLCJwYXNzd29yZCI6Imd1ZXN0Iiwic2VydmljZSI6InJhYmJp\ndG1xIiwiaXAiOiIyNTAuMC42Ni43NSIsImNsdXN0ZXIiOiJzeGxsbW5kaDN4\ndmh1LW1hc3Rlci03cnF0d3RpIiwiaG9zdCI6InJhYmJpdG1xLmludGVybmFs\nIiwicmVsIjoicmFiYml0bXEiLCJzY2hlbWUiOiJhbXFwIiwicG9ydCI6NTY3\nMn1dLCJlbGFzdGljc2VhcmNoIjpbeyJzZXJ2aWNlIjoiZWxhc3RpY3NlYXJj\naCIsImlwIjoiMjUwLjAuNjYuODAiLCJjbHVzdGVyIjoic3hsbG1uZGgzeHZo\ndS1tYXN0ZXItN3JxdHd0aSIsImhvc3QiOiJlbGFzdGljc2VhcmNoLmludGVy\nbmFsIiwicmVsIjoiZWxhc3RpY3NlYXJjaCIsInNjaGVtZSI6Imh0dHAiLCJw\nb3J0IjoiOTIwMCJ9XSwiaW5mbHV4ZGIiOlt7InNlcnZpY2UiOiJpbmZsdXhk\nYiIsImlwIjoiMjUwLjAuNjYuODciLCJjbHVzdGVyIjoic3hsbG1uZGgzeHZo\ndS1tYXN0ZXItN3JxdHd0aSIsImhvc3QiOiJpbmZsdXhkYi5pbnRlcm5hbCIs\nInJlbCI6ImluZmx1eGRiIiwic2NoZW1lIjoiaHR0cCIsInBvcnQiOjgwODZ9\nXSwic29sciI6W3sic2VydmljZSI6InNvbHIiLCJpcCI6IjI1MC4wLjY2Ljgz\nIiwiY2x1c3RlciI6InN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCJo\nb3N0Ijoic29sci5pbnRlcm5hbCIsInJlbCI6InNvbHIiLCJwYXRoIjoic29s\nciIsInNjaGVtZSI6InNvbHIiLCJwb3J0Ijo4MDgwfV0sImthZmthIjpbeyJz\nZXJ2aWNlIjoia2Fma2EiLCJpcCI6IjI1MC4wLjY2LjgzIiwiY2x1c3RlciI6\nInN4bGxtbmRoM3h2aHUtbWFzdGVyLTdycXR3dGkiLCJob3N0Ijoia2Fma2Eu\naW50ZXJuYWwiLCJyZWwiOiJrYWZrYSIsInNjaGVtZSI6ImthZmthIiwicG9y\ndCI6OTA5Mn1dfQ==\n"
        ENV['PLATFORM_ROUTES']='eyJodHRwczovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIjogeyJ0eXBlIjogInVwc3RyZWFtIiwgImNhY2hlIjogeyJkZWZhdWx0X3R0bCI6IDAsICJjb29raWVzIjogWyIqIl0sICJlbmFibGVkIjogdHJ1ZSwgImhlYWRlcnMiOiBbIkFjY2VwdCIsICJBY2NlcHQtTGFuZ3VhZ2UiXX0sICJzc2kiOiB7ImVuYWJsZWQiOiBmYWxzZX0sICJ1cHN0cmVhbSI6ICJteXJ1YnlhcHAiLCAib3JpZ2luYWxfdXJsIjogImh0dHBzOi8ve2RlZmF1bHR9LyJ9LCAiaHR0cDovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIjogeyJ0byI6ICJodHRwczovL21hc3Rlci03cnF0d3RpLXN4bGxtbmRoM3h2aHUuZXUucGxhdGZvcm0uc2gvIiwgInR5cGUiOiAicmVkaXJlY3QiLCAib3JpZ2luYWxfdXJsIjogImh0dHA6Ly97ZGVmYXVsdH0vIn19'
        PlatformSH.export_services_urls
        expect(ENV['DATABASE_URL']).to eq("postgresql://main:main@postgres.internal:5432")
        expect(ENV['MONGODB_URL']).to eq("mongodb://main:main@mongodb.internal:27017/main")
        expect(ENV['REDIS_URL']).to eq("redis://redis.internal:6379")
        expect(ENV['ELASTICSEARCH_URL']).to eq("http://elasticsearch.internal:9200")
        expect(ENV['RABBITMQ_URL']).to eq("amqp://guest:guest@rabbitmq.internal:5672")
        expect(ENV['SOLR_URL']).to eq("http://solr.internal:8080/solr")
        expect(ENV['INFLUXDB_URL']).to eq("http://influxdb.internal:8086")
        expect(ENV['KAFKA_URL']).to eq("kafka.internal:9092")
        expect(ENV['HOSTNAME']).to eq("master-7rqtwti-sxllmndh3xvhu.eu.platform.sh")
      end
    end

    context 'when ENV is already set' do
      let(:env_value) { "something" }

      it 'do not override urls' do
        export_services_envs.each do |key|
          ENV[key] = env_value
        end
        PlatformSH.export_services_urls
        export_services_envs.each do |key|
          expect(ENV[key]).to eq(env_value)
        end
      end
    end
  end
end
