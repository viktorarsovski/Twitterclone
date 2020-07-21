require 'rails_helper'

RSpec.describe User do
  context 'when saving' do
    it 'transform email to lower case' do
      viktor = create(:user, email: 'TESTING@TEST.COM')

      expect(viktor.email).to eq 'testing@test.com'
    end
  end

  describe 'associations' do
    it { should have_many(:tweets) }
    it { should have_many(:comments) }

    describe 'dependency' do
      let(:tweets_count) { 1 }
      let(:comments_count) { 1 }
      let(:user) { create(:user) }

      it 'destroys comments' do
        create_list(:comment, comments_count, user: user)

        expect { user.destroy }.to change { Comment.count }.by(-comments_count)
      end

      it 'destroys tweets' do
        create_list(:tweet, tweets_count, user: user)

        expect { user.destroy }.to change { Tweet.count }.by(-tweets_count)
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should have_secure_password }

    context 'when matching uniqueness of email' do
      subject { create(:user) }

      it { should validate_uniqueness_of(:email) }
    end

    it { should validate_length_of(:password).is_at_least(User::MINIMUM_PASSWORD_LENGTH) }
    it { should validate_length_of(:name).is_at_most(User::MAXIMUM_NAME_LENGTH) }
    it { should validate_length_of(:email).is_at_most(User::MAXIMUM_EMAIL_LENGTH) }

    context 'when using invalid email format' do
      it 'is invalid' do
        viktor = build(:user, email: 'test@invalid')

        expect(viktor.valid?).to be false
      end
    end
  end
end
