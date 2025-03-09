require 'swagger_helper'

RSpec.describe 'API::V1::CollectionsController', type: :request do
  let!(:admin) { create(:admin) }
  let(:Authorization) { "Bearer #{jwt_token(admin)}" }
  let!(:collections) { create_list(:collection, 3) }
  let!(:collection) { collections.first }

  path '/api/v1/collections' do
    get 'Retrieve all collections' do
      tags 'Collections'
      produces 'application/json'
      security [bearer_auth: []]

      response(200, 'successful') do
        run_test! do |response|
          expect(json.size).to eq(3)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end

    post 'Create a new collection' do
      tags 'Collections'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :collection_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          publish: { type: :boolean }
        },
        required: ['title']
      }

      response(201, 'collection created') do
        let(:collection_params) { { collection: attributes_for(:collection) } }

        run_test! do |response|
          expect(Collection.count).to eq(4)
          expect(json['title']).to eq(collection_params[:collection][:title])
          expect(json).to have_key('id')
        end
      end

      response(422, 'validation failed') do
        let(:collection_params) { { collection: { title: '' } } }

        run_test! do |response|
          expect(json['errors']).to include("Title can't be blank")
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:collection_params) { { collection: attributes_for(:collection) } }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end
  end

  path '/api/v1/collections/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Collection ID'

    get 'Retrieve a specific collection' do
      tags 'Collections'
      produces 'application/json'
      security [bearer_auth: []]

      response(200, 'successful') do
        let(:id) { collection.id }

        run_test! do |response|
          expect(json['id']).to eq(collection.id)
        end
      end

      response(404, 'collection not found') do
        let(:id) { 'non-existent-id' }

        run_test! do |response|
          expect(json['error']).to eq('Collection not found')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:id) { collection.id }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end

    delete 'Delete a collection' do
      tags 'Collections'
      security [bearer_auth: []]

      response(204, 'collection deleted') do
        let(:id) { collection.id }

        run_test! do
          expect(Collection.exists?(id)).to be_falsey
        end
      end

      response(404, 'collection not found') do
        let(:id) { 'non-existent-id' }

        run_test! do |response|
          expect(json['error']).to eq('Collection not found')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:id) { collection.id }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end
  end
end
