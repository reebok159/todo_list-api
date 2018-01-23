require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'ActiveRecord associations' do
    it { should belong_to(:project) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
