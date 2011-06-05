module Rack

  class Callback

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      callback = request.params['callback']
      status, headers, body = @app.call(env)
      returning_json = headers['Content-Type'] && headers['Content-Type'].match(/application\/json/i)

      if returning_json && callback
        json = ''
        body.each { |s| json << s }
        body = ["#{callback}(#{json});"]
        headers['Content-Length'] = body[0].length.to_s
        headers['Content-Type'] = 'application/javascript'
      end
      [status, headers, body]
    end

  end

end
