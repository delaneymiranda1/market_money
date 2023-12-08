require 'rails_helper'

describe "Vendors" do


  it 'gets one vendor' do
    vendor = create(:vendor)

    get "/api/v0/vendors/#{vendor.id}"
    expect(response).to be_successful

    vendor_response = JSON.parse(response.body, symbolize_names: true)


    attributes = vendor_response[:data][:attributes]

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

  it 'gets an error with a wrong vendor id' do
    get "/api/v0/vendors/1"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
  end

  it 'creates a vendor' do
    vendor = ({
      name: 'Johns Juices',
      description: 'Green Juice',
      contact_name: 'John Doe',
      contact_phone: '1-888-777-6666',
      credit_accepted: true
    })
    headers = {"CONTENT_TYPE" => "application/json"}
    
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor)
    expect(response).to be_successful
    new_vendor = Vendor.last 

    expect(new_vendor.name).to eq(vendor[:name])
    expect(new_vendor.description).to eq(vendor[:description])
    expect(new_vendor.contact_name).to eq(vendor[:contact_name])
    expect(new_vendor.contact_phone).to eq(vendor[:contact_phone])
    expect(new_vendor.credit_accepted).to eq(vendor[:credit_accepted])
  end

  it 'gets an error if contact name is not filled in when creating a new vendor' do
    vendor = ({
      name: 'Johns Juices',
      description: 'Green Juice',
      contact_phone: '1-888-777-6666',
      credit_accepted: true
    })

    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor)
    expect(response).to_not be_successful
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank")
  end

  it 'updates a vendor' do
    vendor = create(:vendor, credit_accepted: true)
    vendor_params = ({
      name: 'Joes Crab Shack',
      description: 'Seafood',
      contact_name: 'Joe Crab',
      contact_phone: '1-222-333-4444',
      credit_accepted: false
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    expect(vendor.name).to_not eq(vendor_params[:name])
    expect(vendor.description).to_not eq(vendor_params[:description])
    expect(vendor.contact_name).to_not eq(vendor_params[:contact_name])
    expect(vendor.contact_phone).to_not eq(vendor_params[:contact_phone])
    expect(vendor.credit_accepted).to_not eq(vendor_params[:credit_accepted])

    patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

    expect(response).to be_successful
    expect(response.status).to be(200)

    updated_vendor = Vendor.find(vendor.id)

    expect(updated_vendor.name).to eq(vendor_params[:name])
    expect(updated_vendor.description).to eq(vendor_params[:description])
    expect(updated_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(updated_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(updated_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it 'doesnt update a vendor due to a bad id' do
    vendor = ({
      name: 'Joes Crab Shack',
      description: 'Seafood',
      contact_name: 'Joe Crab',
      contact_phone: '1-222-333-4444',
      credit_accepted: false
    })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v0/vendors/1", headers: headers, params: JSON.generate(vendor: vendor)

    expect(response).to_not be_successful
    expect(response.status).to be(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
  end

  it 'deletes a vendor' do
    vendor = create(:vendor)
    market = create(:market)
    market_vendor = create(:market_vendor, market: market, vendor: vendor)

    expect{ delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)
    expect(response.status).to eq(204)
    expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'given an invalid id deleting a vendor throws an erro' do
    vendor = create(:vendor)
    market = create(:market)
    market_vendor = create(:market_vendor, market: market, vendor: vendor)
  
    expect{ delete "/api/v0/vendors/1" }.to change(Vendor, :count).by(0)
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
  end
end

