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
    puts "process  is_valid b ---- #{is_valid}"
    validate_message_received
    puts "process  is_valid a ---- #{is_valid}"
    return invalid_response if !is_valid
    data = fetch_data_from_backend
    generate_response_msg(data)
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
      msg = "#{msg} Active Cases #{data}"
    elsif body.include?("deaths")
      msg = "#{msg} Deaths #{data}"
    end
    response.message do |message|
      message.body(msg)
    end
  end

  def validate_message_received
    puts "*"*80
    puts "body ---- #{body}"
    puts "body body.match(/(cases|deaths)/) ---- #{body.match(/(cases|deaths)/)}"
    if body.match(/(cases|deaths)/)
      puts "validate_message_received  is_valid b ---- #{is_valid}"
      @is_valid = true
      puts "validate_message_received  is_valid a ---- #{is_valid}"
    end
  end

  def backend_payload
    {
      country_code: body.split()[1],
      get_total: body.split()[1] == "total"
    }
  end
  
end