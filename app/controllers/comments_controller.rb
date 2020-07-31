class CommentsController < ApplicationController
  before_action :find_comment, only: [:edit, :update, :destroy]

  def new
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build
  end

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @tweet
    else
      render :new
    end
  end

  def edit
    @tweet = @comment.tweet

    unless equal_with_current_user?(@tweet.user)
      flash[:danger] = 'Wrong User'
      redirect_to(root_path) and return
    end
  end

  def update
    @tweet = @comment.tweet

    if equal_with_current_user?(@comment.user)
      if @comment.update(comment_params)
        redirect_to @tweet
      else
        render :edit
      end
    else
      flash[:danger] = 'Wrong User'
      redirect_to(root_path) and return
    end
  end

  def destroy
    tweet = @comment.tweet

    if equal_with_current_user?(tweet.user)
      @comment.destroy
      redirect_to tweet
    else
      flash[:danger] = 'Wrong User'
      redirect_to(root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
