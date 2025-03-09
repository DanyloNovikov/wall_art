# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        if admin&.valid_password?(params[:admin][:password])
          admin.update!(jti: jwt.last['jti'])
          render json: { token: jwt.first }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def admin
        @admin ||= Admin.find_by(email: params[:admin][:email])
      end

      def jwt
        @jwt ||= Warden::JWTAuth::UserEncoder.new.call(admin, :admin, nil)
      end
    end
  end
end
