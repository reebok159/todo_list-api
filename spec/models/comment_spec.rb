require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:task) }
  end

  describe 'validations' do
    it do
     is_expected.to validate_length_of(:text).
            is_at_least(10).
            is_at_most(256)
    end
  end
end
