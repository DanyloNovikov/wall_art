# frozen_string_literal: true

module Api
  module V1
    class PlatesController < BaseController
      before_action :set_plate, only: %i[show update destroy]

      def index
        plates = Plate.includes(:collection).all
        render json: plates,
               each_serializer: PlateSerializer,
               status: :ok
      end

      def show
        render json: @plate,
               serializer: PlateSerializer,
               status: :ok
      end

      def create
        @plate = Plate.new(plate_params.except(:image))

        if @plate.save
          @plate.image.attach(plate_params[:image]) if plate_params[:image].present?

          render json: @plate,
                 serializer: PlateSerializer,
                 status: :created
        else
          render json: {
            errors: @plate.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @plate.update(plate_params.except(:image))
          @plate.image.attach(plate_params[:image]) if plate_params[:image].present?

          render json: @plate,
                 serializer: PlateSerializer,
                 status: :ok
        else
          render json: {
            errors: @plate.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @plate.destroy

        head :no_content
      end

      private

      def set_plate
        @plate = Plate.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Plate not found' }, status: :not_found
      end

      def plate_params
        params.require(:plate).permit(:title, :order, :collection_id, :image)
      end
    end
  end
end
