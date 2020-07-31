require 'rails_helper'
RSpec.describe "TweetsInteraction" do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }
  before do
    driven_by :selenium, using: :chrome
    # driven_by :rack_test

    log_in(user)
    system_log_in(user)
    # visit tweet_path(tweet)
  end

  describe 'Creating a tweet' do
    it 'creates and shows the newly created tweet' do
      title = 'Create new system spec'
      body = 'This is the body'
      click_on('New Tweet')
      within('form') do
        fill_in "Title", with: title
        fill_in "Body", with: body
        click_on 'Save Tweet'
      end
      expect(page).to have_content(title)
      expect(page).to have_content(body)
    end
  end
  describe 'Editing a tweet' do
    it 'edits and shows the tweet' do
      title = 'New Title'
      body = 'New Body'
      visit tweet_path(tweet)
      click_on 'Edit'
      within('form') do
        fill_in "Title", with: title
        fill_in "Body", with: body
        click_on 'Update Tweet'
      end
      expect(page).to have_content(title)
      expect(page).to have_content(body)
    end
  end
  describe 'Deleting a tweet' do
    it 'deletes the tweet and redirect to index view' do
      visit tweet_path(tweet)
      # Only if using selenium driver.
      # If not, comment this block
      accept_alert do
        click_on 'Delete'
      end
      # If using rack_test driver, uncomment this block
      # click_on 'Delete'
      expect(page).to have_content('Tweets')
    end
  end
  describe 'Creating new tweet comments' do
    it 'creates a tweet comment' do
      new_comment = 'New comment'
      visit tweet_path(tweet)
      click_on 'New Comment'
      within('form') do
        fill_in 'comment_body', with: new_comment
        click_on 'Save'
      end
      expect(page).to have_content(new_comment)
    end
  end
  describe 'Going back to tweet index page' do
    it 'goes back to tweet index page' do
      visit tweet_path(tweet)
      click_on 'Back'
      expect(page).to have_content('Tweets')
    end
  end
end