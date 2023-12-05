require 'rails_helper'

describe "Markets" do
  it "sends a list of all markets" do
    market1 = create(:market)
    market2 = create(:market)
    market3 = create(:market, vendors: [create(:vendor)])
    market4 = create(:market, vendors: create_list(:vendor, 2))
    get '/api/v0/markets'
    expect(response).to be_successful
    markets = JSON.parse(response.body, symbolize_names: true)
    expect(markets[:data].count).to eq(4)
  

    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      details = market[:attributes]

      expect(details).to have_key(:name)
      expect(details[:name]).to be_an(String)

      expect(details).to have_key(:street)
      expect(details[:street]).to be_an(String)

      expect(details).to have_key(:city)
      expect(details[:city]).to be_an(String)

      expect(details).to have_key(:county)
      expect(details[:county]).to be_an(String)

      expect(details).to have_key(:state)
      expect(details[:state]).to be_an(String)

      expect(details).to have_key(:zip)
      expect(details[:zip]).to be_an(String)

      expect(details).to have_key(:lat)
      expect(details[:lat]).to be_an(String)

      expect(details).to have_key(:lon)
      expect(details[:lon]).to be_an(String)
    end
  end


end