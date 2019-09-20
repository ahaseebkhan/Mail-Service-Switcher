module EmailServices
  class SendgridEmail
    def send_email(meta)
      sendgrid_params = { 
                          "personalizations": 
                            [{ "to": [{ "email": meta['to'], "name": meta['to_name'] }] }],
                            "from": {"email": meta['from'], "name": meta['from_name']},
                            "subject": meta['subject'],
                            "content": [{"type": "text/html", "value": meta['body']}]
                        }
      
      sg_headers = { 
                     "Content-Type": "application/json", 
                     "Authorization": "Bearer #{ENV['SG_KEY']}"
                    }

      Net::HTTP.post URI('https://api.sendgrid.com/v3/mail/send'), sendgrid_params.to_json, sg_headers
    end
  end
end
