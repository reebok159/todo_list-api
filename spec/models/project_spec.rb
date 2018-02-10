require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
     is_expected.to validate_uniqueness_of(:name)
   end
  end
end
