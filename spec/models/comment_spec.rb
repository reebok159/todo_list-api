require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'ActiveRecord associations' do
    it { should belong_to(:task) }
  end

  describe 'validations' do
    it do
     should validate_length_of(:text).
            is_at_least(10).
            is_at_most(256)
    end
  end
end
