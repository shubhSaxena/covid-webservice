class TwilioController < ApplicationController
  protect_from_forgery with: :null_session
  def receive_message
    puts "*"*80
    puts params
    body = params["Body"].downcase
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      if body.include?("dog")
        # add dog fact and picture to the message
      end
      if body.include?("cat")
        # add cat fact and picture to the message
      end
      if !(body.include?("dog") || body.include?("cat"))
        message.body("I only know about dogs or cats, sorry!")
      end
    end
    content_type "text/xml"
    response.to_xml
  end
end
