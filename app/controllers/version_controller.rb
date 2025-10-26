class VersionController < ApplicationController
  def index
    render json: { version: ENV["GIT_SHA"] || "unknown" }
  end
end
