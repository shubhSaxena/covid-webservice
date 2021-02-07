class FetchDataService < ApplicationService
  attr_accessor :params, :response, :body
  def initialize(params)
    @params = params
    @response = Twilio::TwiML::MessagingResponse.new
    @body = params["Body"]
  end

  def call
    respond_with_message
  end

  private

  def respond_with_message
    invalid_response
  end

  def fetch_data_from_backend
  end

  def invalid_response
    response.message do |message|
      message.body('This is an invalid input.')
      message.body('Please input in following way.')
      message.body('CASES <country-code> - active cases in a country. eg. "CASES IN"')
      message.body('DEATHS <country-code> - total deaths in a country. eg. "DEATHS IN"')
      message.body('CASES TOTAL - total number of active cases of world combined')
      message.body('DEATHS TOTAL - total number of deaths of world combined')
    end
  end

  def valid_response
  end

  def check_message_received
    
  end
  
end