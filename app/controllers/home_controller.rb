class HomeController < ApplicationController
  # GET /
  def index
    @user = User.new
  end
end
