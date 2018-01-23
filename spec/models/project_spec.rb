require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'ActiveRecord associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it do
     should validate_uniqueness_of(:name)
   end
  end
end
