class TwilioController < ApplicationController
  protect_from_forgery with: :null_session
  def receive_message
    puts "*"*80
    puts params
    body = params["Body"].downcase
    
    response = FetchDataService.call(params)
    render xml: response.to_xml
  end
end
