module EmailServices
  class PostmarkEmail
    def send_email(meta)      
      postmark_params = { 
                          "From": "#{meta['from_name']} <#{meta['from']}>", 
                          "To": "#{meta['to_name']} <#{meta['to']}>", 
                          "Subject": meta['subject'], 
                          "HtmlBody": meta['body'] 
                        }

      pm_headers = { 
                     "Accept": "application/json",
                     "Content-Type": "application/json",
                     "X-Postmark-Server-Token": ENV['POSTMARK_TOKEN']
                    }
    
      Net::HTTP.post URI('https://api.postmarkapp.com/email'), postmark_params.to_json, pm_headers
    end
  end
end
