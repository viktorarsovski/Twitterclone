require 'rails_helper'

RSpec.describe Comment do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end
end
