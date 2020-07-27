require 'rails_helper'

RSpec.describe "Users" do
  it "creates a User and redirects to the User's page" do
    get '/users/signup'

    expect(response).to render_template(:new)

    post_params = {
      params: {
        user: {
          name: 'Viktor',
          email: 'macedonian.wow@live.com',
          password: '123456',
          password_confirmation: '123456'
        }
      }
    }

    post '/users', post_params

    expect(session[:user_id]).not_to be_nil
    expect(response).to redirect_to(assigns(:user))

    follow_redirect!
    expect(response).to render_template(:show)

    expect(response.body).to include('Viktor')
    expect(response.body).to include('macedonian.wow@live.com')
  end

  it "renders New when User params are empty" do
    get '/users/signup'

    post_params = {
      params: {
        user: {
          name: '',
          email: '',
          password: '',
          password_confirmation: ''}
      }
    }

    post '/users', post_params

    expect(session[:user_id]).to be_nil
    expect(response).to render_template(:new)
  end

  describe 'Editing a tweet' do
    context "when the tweet's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      it 'can edit the tweet' do
        get '/login'
        expect(response).to have_http_status(:ok)

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

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

    context "when the tweet's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      let(:login_user) { create(:user) }

      it 'redirect back to root path' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params


        get "/tweets/#{tweet.id}/edit"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:tweet) { create(:tweet) }

      it 'redirect back to root path' do
        get "/tweets/#{tweet.id}/edit"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Deleting a tweet' do
    context "when the tweet's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      it 'can delete the tweet' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/tweets/#{tweet.id}"

        expect(response).to redirect_to(tweets_path)
      end
    end

    context "when the tweet's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      let(:login_user) { create(:user) }

      it 'redirect back to root path' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/tweets/#{tweet.id}"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:article) { create(:article) }

      it 'redirect back to root path' do
        delete "/tweets/#{tweet.id}"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end