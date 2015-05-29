class CommentsController < ApplicationController
before_action :require_user
before_action :set_comment, only: [:vote]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user
    
    if @comment.save
      flash[:notice] = "Your comment has been posted"
      redirect_to post_path(@post)
    else 
      render 'posts/show'
    end
  end

  def index
    @comment = Comment.all.sort_by{|x| x.overall_standing}.reverse
  end

  def vote
    @vote = Vote.create(voteable: @comment, creator: current_user, vote_type: params[:vote_type])

    if @vote.valid?
      flash[:notice] = "You successfully voted."
    else
      flash[:error] = "You can only vote on a post once."
    end

    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end