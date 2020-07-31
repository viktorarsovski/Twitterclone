require 'rails_helper'

RSpec.describe "Tweets" do
  describe 'Creating a tweet' do
    context "when no user is logged in" do
      it 'redirects back to login path' do
        post_params = {
          params: {
            article: {
              title: 'New tweet'
            }
          }
        }

        post '/tweets', post_params

        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please sign in to continue.'
      end
    end
  end

  describe 'Editing a tweet' do
    context "when the tweets's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      it 'can edit the tweet' do
        get '/login'
        expect(response).to have_http_status(:ok)

        log_in(user)

        follow_redirect!
        expect(flash[:success]).to eq "Welcome #{user.name} !"

        get "/tweets/#{tweet.id}"
        expect(response).to have_http_status(:ok)

        get "/tweets/#{tweet.id}/edit"
        expect(response).to have_http_status(:ok)

        patch_params = {
          params: {
            article: {
              title: tweet.title,
              body: "New Body"
            }
          }
        }

        patch "/tweets/#{tweet.id}", patch_params

        expect(response).to have_http_status(:found)

        expect(response).to redirect_to(assigns(:tweet))
        follow_redirect!

        expect(response.body).to include(tweet.title)
      end
    end

    context "when the tweets's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      let(:login_user) { create(:user) }

      before { log_in(login_user) }
      it 'redirect back when GET edit' do

        get "/tweets/#{tweet.id}/edit"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end

      it 'redirect back when PATCH edit' do

        patch_params = {
          params: {
            article: {
              title: tweet.title,
              body: "New Body"
            }
          }
        }

        patch "/tweets/#{tweet.id}", patch_params

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:tweet) { create(:tweet) }

      it 'redirect back to root path' do
        get "/tweets/#{tweet.id}/edit"

        expect(flash[:danger]).to eq 'Please sign in to continue.'
        expect(response).to redirect_to(login_path)
      end

      it 'redirect back to root when updating a tweet' do
        patch_params = {
          params: {
            article: {
              title: tweet.title,
              body: "New Body"
            }
          }
        }

        patch "/tweets/#{tweet.id}", patch_params

        expect(flash[:danger]).to eq 'Please sign in to continue.'
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'Deleting a tweet' do
    context "when the tweet's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      it 'can delete the tweet' do
        log_in(user)

        delete "/tweets/#{tweet.id}"

        expect(response).to redirect_to(tweets_path)
      end
    end

    context "when the tweet's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      let(:login_user) { create(:user) }

      it 'redirect back to root path' do
        log_in(login_user)

        delete "/tweets/#{tweet.id}"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:tweet) { create(:tweet) }

      it 'redirect back to root path' do
        delete "/tweets/#{tweet.id}"

        expect(flash[:danger]).to eq 'Please sign in to continue.'
        expect(response).to redirect_to(login_path)
      end
    end
  end
end