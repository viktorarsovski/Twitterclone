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
end