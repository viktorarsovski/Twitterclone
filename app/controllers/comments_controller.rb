class CommentsController < ApplicationController
  def new
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build
  end

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)

    if @comment.save
      redirect_to @tweet
    else
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @tweet = @comment.tweet
  end

  def update
    @comment = Comment.find(params[:id])
    @tweet = @comment.tweet

    if @comment.update(comment_params)
      redirect_to @tweet
    else
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy

    redirect_to comment.tweet
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
