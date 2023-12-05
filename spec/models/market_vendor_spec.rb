require 'rails_helper'

RSpec.describe MarketVendor, type: :model do

  describe 'Relationships and validations' do
    it { should belong_to(:market) }
    it { should belong_to(:vendor) }

    it { should validate_presence_of(:market)}
    it { should validate_presence_of(:vendor)}
  end
end