class TwilioController < ApplicationController
  def receive_message
    puts "*"*80
    puts params
  end
end
