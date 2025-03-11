require 'swagger_helper'

RSpec.describe 'API::V1::AuthController', type: :request do
  let!(:admin) { create(:admin, email: 'admin@example.com', password: 'password123') }
  let(:Authorization) { nil }

  path '/api/v1/auth' do
    post 'Authenticate admin user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :auth_params, in: :body, schema: {
        type: :object,
        properties: {
          admin: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: ['email', 'password']
          }
        },
        required: ['admin']
      }

      response(200, 'successful authentication') do
        let(:auth_params) { { admin: { email: admin.email, password: 'password123' } } }

        run_test! do |response|
          expect(json).to have_key('token')
          expect(admin.reload.jti).not_to be_nil
        end
      end

      response(401, 'invalid email') do
        let(:auth_params) { { admin: { email: 'wrong@example.com', password: 'password123' } } }

        run_test! do |response|
          expect(json['error']).to eq('Invalid email or password')
        end
      end

      response(401, 'invalid password') do
        let(:auth_params) { { admin: { email: admin.email, password: 'wrongpassword' } } }

        run_test! do |response|
          expect(json['error']).to eq('Invalid email or password')
        end
      end
    end
  end
end
