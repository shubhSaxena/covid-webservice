class FetchDataService < ApplicationService
  attr_accessor :params, :response, :body, :is_valid
  def initialize(params)
    @params = params
    @response = Twilio::TwiML::MessagingResponse.new
    @body = params["Body"].downcase
    @is_valid = false
  end

  def call
    process
  end

  private

  def process
    validate_message_received
    return invalid_response if !is_valid
    res = fetch_data_from_backend
    if res.code != 200
      error_response
    else
      generate_response_msg(res.parsed_response)
    end
    response
  end

  def fetch_data_from_backend
    if body.include?("cases")
      BackendClient.new.fetch_active_cases_data(backend_payload)
    elsif body.include?("deaths")
      BackendClient.new.fetch_total_death_data(backend_payload)
    end
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

  def generate_response_msg(data)
    msg = body.split()[1]
    if body.include?("cases")
      msg = "#{msg.upcase} Active Cases #{data}"
    elsif body.include?("deaths")
      msg = "#{msg.upcase} Deaths #{data}"
    end
    response.message do |message|
      message.body(msg)
    end
  end

  def validate_message_received
    if body.match(/(cases|deaths)/)
      @is_valid = true
    end
  end

  def backend_payload
    {
      country_stat: {
        country_code: body.split()[1].upcase,
        get_total: body.split()[1] == "total"
      }
    }
  end

  def error_response
    response.message do |message|
      message.body("Error occured.")
      message.body("Please try again later.")
    end
  end
  
end