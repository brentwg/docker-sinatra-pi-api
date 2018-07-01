=begin
  Extends the base App with PI calculation and display routes
  /pi_job/{num}             <- POST here to create job
  /pi_job/{job_id}          <- GET to see job status
  /download_pi_job/{job_id} <- GET to download results as a zip file
=end
class App < Sinatra::Application

    before do
        content_type 'application/json'
    end

    # --------------------------------------------------------------------
    # SECTION: Helper functions
    # --------------------------------------------------------------------
    helpers do
        def base_url
            @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
        end
    
        def json_params
            begin
                JSON.parse(request.body.read)
            rescue
                halt 400, { message:'Invalid JSON' }.to_json
            end
        end
    
        def piJob
            @piJob ||= PiJob.where(id: params[:id]).first
        end
    
        def halt_if_not_found!
            halt(404, { message:'pi_job Not Found'}.to_json) unless piJob
        end
    
        def serialize(piJob)
          PiJobSerializer.new(piJob).to_json
        end

        def returnDigitsOfPI(num)
            return IO.read("pi1000000.txt", num + 1) 
        end
    end


    # --------------------------------------------------------------------
    # SECTION: See all PI Jobs in the DB
    # --------------------------------------------------------------------
    get '/pi_jobs' do
        piJobs = PiJob.all

        piJobs.map { |piJob| PiJobSerializer.new(piJob) }.to_json
    end


    # --------------------------------------------------------------------
    # SECTION: Create PI Job
    # --------------------------------------------------------------------
    post '/pi_job/:num' do |num|
        num = params[:num]

        myPI = IO.read("pi1000000.txt", num.to_i) 
        
        piJob = PiJob.create(
            num: num,
            pi_value: myPI,
            status: "complete",
            success: "true"
        )

        halt 422, serialize(piJob) unless piJob.save

        response.headers['Location'] = "#{base_url}/pi_job/#{piJob.id}"
        status 201
    end


    # --------------------------------------------------------------------
    # SECTION: See PI Job status
    # --------------------------------------------------------------------
    get '/pi_job/:id' do |id|
        halt_if_not_found!
        serialize(piJob)
    end


    # --------------------------------------------------------------------
    # SECTION: Download Results in a ZIP file
    # --------------------------------------------------------------------
    get '/download_pi_job/:id' do |id|
        folder = "."
        filename = "digits_of_pi_#{id}.txt"
        input_filenames = ["digits_of_pi_#{id}.txt"]
        zipfile_name = "digits_of_pi_#{id}.zip"

        halt_if_not_found!
        piJob = PiJob.where(id: id).first.pi_value
        output = File.open( filename,"w" )
        output << piJob
        output.close

        Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
            input_filenames.each do |filename|
              zipfile.add(filename, File.join(folder, filename))
            end
            zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
        end

        send_file(zipfile_name, :filename => zipfile_name, :type => "application/zip")
    end
end
