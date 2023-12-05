require 'rails_helper'

describe "Market Vendors" do


  it 'gets all vendors for a market' do
    market1 = create(:market, vendors: create_list(:vendor, 2))
    market2 = create(:market, vendors: create_list(:vendor, 3))
    get "/api/v0/markets/#{market.id}/vendors"
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

      data = vendor[:attributes]

      expect(data).to have_key(:name)
      expect(data[:name]).to be_an(String)

      expect(data).to have_key(:description)
      expect(data[:description]).to be_an(String)

      expect(data).to have_key(:contact_name)
      expect(data[:contact_name]).to be_an(String)

      expect(data).to have_key(:contact_phone)
      expect(data[:contact_phone]).to be_an(String)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end

  xit 'gets an error for vendors for a market if a wrong id is passed in' do
    get "/api/v0/markets/123123123123/vendors"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
  end
end