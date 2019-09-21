class CommunicationApp < Sinatra::Base
  set :show_exceptions, false
  
  post "/email" do
    format_date
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

  post '/sg_webhook' do
    params = JSON.parse(request.body.read)
    WebhookLog.create(service: :sendgrid, event: params[0]['event'], email: params[0]['email'], response: params)
  end

  post '/pm_webhook' do
    params = JSON.parse(request.body.read)
    WebhookLog.create(service: :postmark, event: params['RecordType'], email: params['Email'], response: params)
  end 

  error do
    { status: 500, message: env['sinatra.error'].message }.to_json 
  end 

  private
  def format_date
    params[:send_at] = DateTime.parse(params[:send_at]) if params[:send_at].present?
  end
end
