class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :submit]

  # GET /posts
  def index
    @posts = PostPolicy::Scope.new(current_user, Post).published
  end

  # GET /posts/my/
  def my
    @posts = PostPolicy::Scope.new(current_user, Post).by_user
    render :index
  end

  # GET /posts/review/
  def review
    @posts = PostPolicy::Scope.new(current_user, Post).in_review
    render :index
  end

  # GET /posts/1
  def show
    authorize @post
  end

  # GET /posts/new
  def new
    authorize Post
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # GET /posts/1/submit
  def submit
    authorize @post
    @post.submit
    redirect_to posts_path, notice: 'Post was successfully submited.'
  end

  # GET /posts/1/publish
  def publish
    authorize @post
    @post.publish
    redirect_to posts_path, notice: 'Post was successfully published.'
  end

  # GET /posts/1/unpublish
  def unpublish
    authorize @post
    @post.unpublish
    redirect_to posts_path, notice: 'Post was successfully unpublished.'
  end

  # DELETE /admin/posts/1
  def destroy
    authorize @post, :delete?
    @post.delete
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title, :body).merge(user_id: current_user.id)
  end
end
