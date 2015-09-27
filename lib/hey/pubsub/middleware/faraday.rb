module Hey::Pubsub::Middleware
  class Faraday < Faraday::Middleware
    def call(env)
      Hey.publish!("request", request: env)

      @app.call(env).on_complete do |env|
        Hey.publish!("response", response: env)
      end
    end
  end
end








