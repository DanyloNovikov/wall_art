# frozen_string_literal: true

module Administrator
  class PlatesController < BaseController
    before_action :set_plate, only: %i[show edit update destroy]

    def index
      @plates = Plate.all
    end

    def show; end

    def new
      @plate = Plate.new
    end

    def create
      @plate = Plate.new(plate_params.except(:image))

      if @plate.save
        @plate.image.attach(plate_params[:image]) if plate_params[:image].present?
        redirect_to administrator_plates_path,
                    notice: 'Plate was successfully created'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @plate.update(plate_params.except(:image))
        if plate_params[:image].present?
          @plate.image.purge if @plate.image.attached?
          @plate.image.attach(plate_params[:image])
        end

        redirect_to administrator_plates_path,
                    notice: 'Plate was successfully updated'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @plate.destroy
      redirect_to administrator_plates_path, notice: 'Plate was deleted'
    end

    private

    def set_plate
      @plate = Plate.find(params[:id])
    end

    def plate_params
      params.require(:plate).permit(:title, :order, :image, :collection_id)
    end
  end
end
