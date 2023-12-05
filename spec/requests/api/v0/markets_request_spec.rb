require 'rails_helper'

describe "Markets" do
  before(:each) do
    market1 = create(:market)
    market2 = create(:market)
    market3 = create(:market, vendors: [create(:vendor)])
    market4 = create(:market, vendors: create_list(:vendor, 2))
    @markets = [market1, market2, market3, market4]
  end

  it "sends a list of markets" do
    get '/api/v0/markets'
    expect(response).to be_successful
    @markets = JSON.parse(response.body, symbolize_names: true)

    expect(@markets[:details].count).to eq(3)

    @markets[:details].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      data = market[:data]

      expect(data).to have_key(:name)
      expect(data[:name]).to be_an(String)

      expect(data).to have_key(:street)
      expect(data[:street]).to be_an(String)

      expect(data).to have_key(:city)
      expect(data[:city]).to be_an(String)

      expect(data).to have_key(:county)
      expect(data[:county]).to be_an(String)

      expect(data).to have_key(:state)
      expect(data[:state]).to be_an(String)

      expect(data).to have_key(:zip)
      expect(data[:zip]).to be_an(String)

      expect(data).to have_key(:lat)
      expect(data[:lat]).to be_an(String)

      expect(data).to have_key(:lon)
      expect(data[:lon]).to be_an(String)
    end
  end


end