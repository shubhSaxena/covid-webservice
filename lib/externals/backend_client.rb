class BackendClient < RootClient
  def base_url
    ENV['BACKEND_API'] || 'https://covid-backend-test.herokuapp.com'
  end

  def fetch_active_cases_data(body)
    self.post('country_stat/active_cases', body)
  end

  def fetch_total_death_data(body)
    self.post('country_stat/total_deaths', body)
  end

end