class HomeController < ApplicationController
  # GET /
  def index
    @posts = PostPolicy::Scope.new(current_user, Post).published
    render "posts/index"
  end
end
