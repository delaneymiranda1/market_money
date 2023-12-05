require 'rails_helper'

describe "Markets" do

  it "sends a list of all markets" do
    market1 = create(:market, vendors: [create(:vendor)])
    market2 = create(:market, vendors: [create(:vendor)])
    market3 = create(:market, vendors: create_list(:vendor, 2))
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

      expect(details).to have_key(:vendor_count)
      expect(details[:vendor_count]).to be_an(Integer)
    end
  end

  it 'gets one market with given id' do
    market = create(:market)
    get "/api/v0/markets/#{market.id}"
    expect(response).to be_successful
    market = JSON.parse(response.body, symbolize_names: true)
    expect(market[:data].count).to eq(1)
    
    data = market[:data][:attributes]

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

      expect(data).to have_key(:vendor_count)
      expect(data[:vendor_count]).to be_an(Integer)
    end
  end
end