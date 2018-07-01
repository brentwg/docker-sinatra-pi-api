=begin
  Extends the base App with diagnostic routes
  /env  => displays environment info
  /disk => displays disk info
  /memory => displays memory info
  /exit => terminates the application
=end
class App < Sinatra::Application

  # Show environment info
   get '/env' do
     if params[:json] == 'yes'
       content_type :json
       ENV.to_h.to_json
     else
       'Environment (as <a href="/env?json=yes">JSON</a>):<ul>' +
         ENV.each.map { |k, v| "<li><b>#{k}:</b> #{v}</li>" }.join + '</ul>'
     end
   end

   # Show disk info
   get '/disk' do
     "<strong>Disk:</strong><br/><pre>#{`df -h`}</pre>"
   end

   # Show memory info
   get '/memory' do
     "<strong>Memory:</strong><br/><pre>#{`free -m`}</pre>"
   end

   # Exit 'correctly'
   get '/exit' do
     # /exit causes:
     # 15:20:24 web.1  | Damn!
     # 15:20:24 web.1  | exited with code 1
     Process.kill('TERM', Process.pid)
   end

end # class App < Sinatra::Application
