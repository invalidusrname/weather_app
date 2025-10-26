class VersionController < ApplicationController
  def index
    render json: { version: ENV["KAMAL_VERSION"] || "unknown" }
  end
end
