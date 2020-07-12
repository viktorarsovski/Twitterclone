class CommentsController < ApplicationController
  def new
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build
  end

  def create
    tweet = Tweet.find(params[:tweet_id])

    comment = tweet.comments.build(comment_params)

    comment.save
    redirect_to tweet
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
