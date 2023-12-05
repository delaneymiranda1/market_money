require 'rails_helper'

RSpec.describe Market, type: :model do

  describe 'Relationships and validations' do
    it {should have_many(:market_vendors)}
    it {should have_many(:vendors).through(:market_vendors)}

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe "vendor_count" do
    it 'counts the number of vendors' do
      market = create(:market)
      vendor = create_list(:vendor, 3)
      market.vendors << vendor
      expect(market.vendor_count).to eq(3)
    end
  end
end