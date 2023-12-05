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
      expect(market[:id]).to be_an(String)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_an(String)
      expect(market[:type]).to eq('market')

      data = market[:attributes]

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

  it 'gets one market with given id' do
    market = create(:market)
    get "/api/v0/markets/#{market.id}"
    expect(response).to be_successful
    market = JSON.parse(response.body, symbolize_names: true)

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

  it 'gets an error if invalid market id is given' do 
    get "/api/v0/markets/123123123123"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
  end
end