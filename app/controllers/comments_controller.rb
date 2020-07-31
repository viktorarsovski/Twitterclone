class CommentsController < ApplicationController
  def new
    session_notice(:danger, 'You must be logged in!') unless logged_in?
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build
  end

  def create
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

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
    session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?
    @comment = Comment.find(params[:id])

    if logged_in?
      session_notice(:danger, 'Wrong User') unless equal_with_current_user?(@comment.user)
    end
    @tweet = @comment.tweet
  end

  def update
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

    @comment = Comment.find(params[:id])
    @tweet = @comment.tweet

    if equal_with_current_user?(@comment.user)
      if @comment.update(comment_params)
        redirect_to @article
      else
        render :edit
      end
    else
      session_notice(:danger, 'Wrong User', login_path)
    end
  end

  def destroy
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

    comment = Comment.find(params[:id])
    tweet = comment.tweet

    if equal_with_current_user?(tweet.user)
      comment.destroy
      redirect_to tweet
    else
      session_notice(:danger, 'Wrong User')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
