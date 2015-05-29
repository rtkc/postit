class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort_by{|x| x.overall_standing}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)

    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @post.creator = User.first

    if @post.update(post_params)
      flash[:notice] = "Your post was updated."
      redirect_to posts_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote_type: params[:vote_type])

    if @vote.valid? && !voted_user
      flash[:notice] = "You successfully voted."
      current_user = voted_user
    else
      flash[:error] = "You vote was unsuccessful."
    end

    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
