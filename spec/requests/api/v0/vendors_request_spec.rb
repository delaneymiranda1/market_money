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
    
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
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
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    expect(response).to_not be_successful
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank")
  end
end
