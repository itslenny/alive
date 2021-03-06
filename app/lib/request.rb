class Request
  def self.run(test)
    return run_api(test) if test.style == 'api'
    return run_browser(test) if test.style == 'browser'
  end

  def self.run_api(test)
    params_breed = %w(get head delete).include?(test.breed)
    data = JSON.parse(test.body) rescue {  }
    data_key = params_breed ? :params : :body

    headers = JSON.parse(test.headers) rescue { }
    headers['Content-Type'] = test.json ? 'application/json' : 'application/x-www-form-urlencoded' unless params_breed

    request = Typhoeus::Request.new(test.url,
      :method => test.breed.to_sym,
      :headers => headers,
      data_key => data
    )

    Response.from_api(request.run)
  end

  def self.run_browser(test)
    session, start = Poltergeist.new.session, Time.now
    session.visit(test.url)

    Response.from_browser(session, duration: Time.now-start)
  end
end
