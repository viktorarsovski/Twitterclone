require 'rails_helper'

RSpec.describe Tweet do
  describe 'associations' do
    it { should have_many(:comments) }
    it { should belong_to(:user) }

    describe 'dependency' do
      let(:comments_count) { 1 }
      let(:tweet) { create(:tweet) }

      it 'destroys comments' do
        create_list(:comment, comments_count, tweet: tweet)

        expect { tweet.destroy }.to change { Comment.count }.by(-comments_count)
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(Tweet::MINIMUM_TITLE_LENGTH) }
  end
end
