class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def new
    session_notice(:danger, 'You must be logged in!') unless logged_in?
    @tweet = Tweet.new
  end

  def create
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user

    if @tweet.save
      redirect_to @tweet
    else
      render :new
    end
  end

  def edit
    session_notice(:danger, 'You must be logged in!') unless logged_in?
    @tweet = Tweet.find(params[:id])

    if logged_in?
      session_notice(:danger, 'Wrong User') unless equal_with_current_user?(@tweet.user)
    end
  end

  def update
    unless logged_in?
    session_notice(:danger, 'You must be logged in!') and return
  end

    @tweet = Tweet.find(params[:id])

    if equal_with_current_user?(@tweet.user)
      if @tweet.update(tweet_params)
        redirect_to @tweet
      else
        render :edit
      end
    else
      session_notice(:danger, 'Wrong User') and return
    end
  end

  def destroy
    unless logged_in?
      session_notice(:danger, 'You must be logged in!') and return
    end

    tweet = Tweet.find(params[:id])

    if equal_with_current_user?(tweet.user)
      tweet.destroy
      redirect_to tweets_path
    else
      session_notice(:danger, 'Wrong User')  and return
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:title, :body)
  end
end
