# frozen_string_literal: true

module Api
  module V1
    class BaseController < ::ApplicationController
      before_action :authenticate_admin!
      protect_from_forgery with: :null_session

      private

      def authenticate_admin!
        if decoded_token.present?
          @current_admin = Admin.find_by(id: decoded_token['sub'], jti: decoded_token['jti'])
          render json: { error: 'Invalid token' }, status: :unauthorized unless @current_admin
        else
          render json: { error: 'Token missing or invalid' }, status: :unauthorized
        end
      end

      def decoded_token
        @decoded_token ||= begin
          JWT.decode(
            jwt_payload,
            Rails.application.credentials.secret_key_base,
            true,
            algorithm: 'HS256'
          )[0]
        rescue StandardError
          nil
        end
      end

      def jwt_payload
        @jwt_payload ||= request.headers['Authorization']&.split(' ')&.last
      end
    end
  end
end
