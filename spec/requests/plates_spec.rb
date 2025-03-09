require 'swagger_helper'

RSpec.describe 'API::V1::PlatesController', type: :request do
  let!(:admin) { create(:admin) }
  let(:Authorization) { "Bearer #{jwt_token(admin)}" }
  let(:collection) { create(:collection) }
  let!(:plates) { create_list(:plate, 3, collection: collection) }
  let!(:plate) { plates.first }

  path '/api/v1/plates' do
    get 'Retrieve all plates' do
      tags 'Plates'
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

    post 'Create a new plate' do
      tags 'Plates'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      let(:plate_params) { { plate: attributes_for(:plate, collection_id: collection.id) } }

      parameter name: :plate_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          order: { type: :integer },
          collection_id: { type: :string }
        },
        required: ['title', 'collection_id']
      }

      response(201, 'plate created') do
        run_test! do |response|
          expect(Plate.count).to eq(4)
          expect(json['title']).to eq(plate_params[:plate][:title])
          expect(json).to have_key('id')
        end
      end

      response(422, 'validation failed') do
        let(:plate_params) { { plate: { title: '', collection_id: nil } } }

        run_test! do |response|
          expect(json['errors']).to include("Title can't be blank", "Collection must exist")
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end
  end

  path '/api/v1/plates/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Plate ID'

    get 'Retrieve a specific plate' do
      tags 'Plates'
      produces 'application/json'
      security [bearer_auth: []]

      response(200, 'successful') do
        let(:id) { plate.id }

        run_test! do |response|
          expect(json['id']).to eq(plate.id)
        end
      end

      response(404, 'plate not found') do
        let(:id) { 'non-existent-id' }

        run_test! do |response|
          expect(json['error']).to eq('Plate not found')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:id) { plate.id }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end

    put 'Update a plate' do
      tags 'Plates'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      let(:plate_params) { { plate: { title: 'Updated Title' } } }

      parameter name: :plate_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          order: { type: :integer }
        }
      }

      response(200, 'plate updated') do
        let(:id) { plate.id }

        run_test! do |response|
          expect(plate.reload.title).to eq('Updated Title')
        end
      end

      response(422, 'validation failed') do
        let(:id) { plate.id }
        let(:plate_params) { { plate: { title: '' } } }

        run_test! do |response|
          expect(json['errors']).to include("Title can't be blank")
        end
      end

      response(404, 'plate not found') do
        let(:id) { 'non-existent-id' }

        run_test! do |response|
          expect(json['error']).to eq('Plate not found')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:id) { plate.id }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end

    delete 'Delete a plate' do
      tags 'Plates'
      security [bearer_auth: []]

      response(204, 'plate deleted') do
        let(:id) { plate.id }

        run_test! do
          expect(Plate.exists?(id)).to be_falsey
        end
      end

      response(404, 'plate not found') do
        let(:id) { 'non-existent-id' }

        run_test! do |response|
          expect(json['error']).to eq('Plate not found')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }
        let(:id) { plate.id }

        run_test! do |response|
          expect(json['error']).to eq('Token missing or invalid')
        end
      end
    end
  end
end
