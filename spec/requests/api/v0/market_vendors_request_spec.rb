require 'rails_helper'

describe "Market Vendors" do


  it 'gets all vendors for a market' do
    vendors = create_list(:vendor, 2)
    market = create(:market, vendors: vendors)
    vendors2 = create_list(:vendor, 3)
    market2 = create(:market, vendors: vendors2)

    get "/api/v0/markets/#{market.id}/vendors"
    # require 'pry'; binding.pry
    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)
    vendor_data = vendors[:data]
    expect(vendor_data.count).to eq(2)

    vendor_data.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_an(String)
      expect(vendor[:type]).to eq('vendor')

      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_an(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_an(String)

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_an(String)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_an(String)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end

  it 'gets an error for vendors for a market if a wrong id is passed in' do
    get "/api/v0/markets/123123123123/vendors"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
  end

  it 'creates a market vendor' do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor_params = ({
      market_id: market.id,
      vendor_id: vendor.id
    })
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
    market_vendor = MarketVendor.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(market_vendor.market_id).to eq(market_vendor_params[:market_id])
    expect(market_vendor.vendor_id).to eq(market_vendor_params[:vendor_id])

    get "/api/v0/markets/#{market.id}/vendors"
    vendors_parsed = JSON.parse(response.body, symbolize_names: true)
    new_vendor_data = vendors_parsed[:data].last

    expect(new_vendor_data[:relationships][:markets][:data].last[:id].to_i).to eq(market.id)
  end
end