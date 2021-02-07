class TwilioController < ApplicationController
  protect_from_forgery with: :null_session
  def receive_message
    puts "*"*80
    puts params
    body = params["Body"].downcase
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      message.body('Hello World!')
      message.body('test')
      message.body('yes')
    end
    response = FetchDataService.call(params)
    render xml: response.to_xml
  end
end
