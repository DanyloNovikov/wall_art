# frozen_string_literal: true

module Api
  module V1
    class CollectionsController < BaseController
      before_action :set_collection, only: %i[show update destroy]

      def index
        collections = Collection.all
        render json: collections,
               each_serializer: CollectionSerializer,
               status: :ok
      end

      def show
        render json: @collection,
               serializer: CollectionSerializer,
               status: :ok
      end

      def create
        collection = Collection.new(collection_params)

        if collection.save
          render json: collection,
                 serializer: CollectionSerializer,
                 status: :created
        else
          render json: {
            errors: collection.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @collection.update(collection_params)
          render json: @collection,
                 serializer: CollectionSerializer,
                 status: :ok
        else
          render json: {
            errors: @collection.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @collection.destroy

        head :no_content
      end

      private

      def set_collection
        @collection = Collection.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Collection not found' }, status: :not_found
      end

      def collection_params
        params.require(:collection).permit(:title, :description, :publish, images: [])
      end
    end
  end
end