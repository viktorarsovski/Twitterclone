require 'rails_helper'

RSpec.describe 'Tweets Comments' do
  describe 'GET tweets comments' do
    let(:expected_comment_body) { 'Comment Body' }
    let(:comment) { create(:comment, body: expected_comment_body) }

    it 'shows the tweet comments' do
      get tweet_path(comment.tweet)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include expected_comment_body
    end
  end
end
