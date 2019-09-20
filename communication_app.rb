class CommunicationApp < Sinatra::Base
  set :show_exceptions, false
  
  post "/email" do
    email = Email.new(params)

    if email.save
      email = email.reload

      status = email.status
      message = 'Success'
      
    elsif email.errors.any?
      status = 422
      message = email.errors.details

    else
      status = 500
      message = 'Internal server error'

    end

    { status: status, message: message }.to_json
  end

  error do
    { status: 500, message: env['sinatra.error'].message }.to_json 
  end
end
