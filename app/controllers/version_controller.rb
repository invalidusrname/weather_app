class VersionController < ApplicationController
  def show
    render json: { version: ENV["GIT_SHA"] || "unknown" }
  end
end
