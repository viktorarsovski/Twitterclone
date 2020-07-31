require 'rails_helper'

RSpec.describe "Comments" do
  let(:tweet) { create(:tweet) }
  let(:comment) { create(:comment, tweet: tweet) }

  describe 'Edit tweet comments' do
    context 'when no user is signed in' do
      it 'redirect back to login path' do
        get edit_tweet_comment_path(tweet, comment)

        expect(response).to redirect_to(login_path)
      end

      it 'redirect back to login path using patch HTTP verb' do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch tweet_comment_path(tweet, comment), patch_params

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is signed in' do
      let(:user) { create(:user) }
      let(:user_comment) { create(:comment, user: user) }

      before { log_in(user) }

      it 'cannot edit different user comments' do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch tweet_comment_path(tweet, comment), patch_params

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'Wrong User'
      end

      it 'is able to edit a comment' do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch tweet_comment_path(user_comment.tweet, user_comment), patch_params

        expect(user_comment.reload.body).to eq 'New Body'
      end
    end
  end

  describe 'Creating a tweet comment' do
    context 'when no user is signed in' do
      it 'redirect back when creating new comment' do
        post_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        post tweet_comments_path(tweet), post_params

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is sign in' do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }

      before { log_in(user) }

      it 'can create a comment' do
        post_comment_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        expect do
          post tweet_comments_path(tweet), post_comment_params
        end.to change { Comment.count }
      end
    end
  end

  describe 'Deleting a tweet comment' do
    context 'when no user is signed in' do
      it 'redirect back when deleting a comment' do
        delete tweet_comment_path(tweet, comment)

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is sign in' do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user: user) }
      let(:comment) { create(:comment, user: user, tweet: tweet) }

      let(:different_user) { create(:user) }
      let(:different_comment) { create(:comment, user: different_user) }

      before { log_in(user) }

      it 'can delete its own tweet comment' do
        delete tweet_comment_path(tweet, comment)

        expect(response).to redirect_to(article_path(tweet))
      end

      it 'cannot delete different user comment on a different user article' do
        delete tweet_comment_path(tweet, different_comment)

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end

      it 'can delete different user comments on its own tweet' do
        tweet.comments << different_comment

        delete tweet_comment_path(tweet, different_comment)

        expect(response).to redirect_to(tweet_path(tweet))
      end
    end
  end
end
