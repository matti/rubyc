require 'sinatra/base'
$stdout.sync = true
$stderr.sync = true

require 'open3'

s = Sinatra.new
s.set :port, (
  if ENV['RUBYC_PORT']
    begin
      (Integer ENV['RUBYC_PORT']).to_s
    rescue
      (Integer ENV[ENV['RUBYC_PORT']]).to_s
    end
  else
    "8080"
  end
)
s.set :bind, '0.0.0.0'

s.get "/gem" do
  ENV.delete "RUBYC_SERVER"
  p params

  if Dir.exist? "/gem"
    FileUtils.rm_rf "/gem"
    FileUtils.mkdir "/gem"
  end

  if params["RUBYC_CLEAN"] && Dir.exist?("/cache")
    FileUtils.rm_rf "/cache"
  end

  env = {
    "RUBYC_GEM" => params["RUBYC_GEM"],
    "RUBYC_ENTRYPOINT" => params["RUBYC_ENTRYPOINT"],
    "RUBYC_OUTPUT" => params["RUBYC_GEM"]
  }
  stdin, stdout, stderr, wait_thr = Open3.popen3 env, "/rubyc/entrypoint.sh", chdir: "/rubyc"

  stderr_reader_thr = Thread.new do
    while c = stderr.read(1) do
      $stderr.print c
    end
  end
  stdout_reader_thr = Thread.new do
    puts "started"
    while c = stdout.read(1) do
      $stdout.print c
    end
  end

  puts "waiting for stdout to join"
  stdout_reader_thr.join
  puts "stdout joined"
  stderr_reader_thr.kill

  send_file File.join("/build/", params["RUBYC_GEM"])
end

s.run!
