# frozen_string_literal: true

module Administrator
  class CollectionsController < BaseController
    before_action :set_collection, only: %i[show edit update destroy]

    def index
      @collections = Collection.all
    end

    def show; end

    def new
      @collection = Collection.new
    end

    def create
      @collection = Collection.new(collection_params.except(:images))

      if @collection.save
        @collection.images.attach(collection_params[:images]) if plate_params[:images].present?

        redirect_to administrator_collections_path,
                    notice: 'Collection was successfully created'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @collection.update(collection_params)
        if collection_params[:images].present?
          @collection.images.purge if @collection.images.attached?
          @collection.images.attach(collection_params[:images])
        end

        redirect_to administrator_collections_path,
                    notice: 'Collection was successfull updated'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @collection.destroy
      redirect_to administrator_collections_path,
                  notice: 'Collection was deleted'
    end

    private

    def set_collection
      @collection = Collection.find(params[:id])
    end

    def collection_params
      params.require(:collection).permit(:title, :description, :publish, images: [])
    end
  end
end
