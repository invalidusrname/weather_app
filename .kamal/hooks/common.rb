require "bundler/inline"

gemfile(true) { gem "octokit" }

GH_REPO = "invalidusrname/weather_app"

def exit_with_error(message)
  $stderr.puts message
  exit 0
end

def github_client
  Octokit::Client.new(access_token: ENV["DEPLOYMENTS_GITHUB_TOKEN"])
rescue Octokit::ClientError => error
  exit_with_error "GitHub client error: #{error.message}"
end
