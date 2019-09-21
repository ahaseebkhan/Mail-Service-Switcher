module EmailServices
  class PostmarkEmail
    def send_email(meta)
      # Don't run postmark if email is scheduled. Postmark API doesn't support scheduling by default
      return nil if meta['send_at'].present?
      
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
