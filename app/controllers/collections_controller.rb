# frozen_string_literal: true

class CollectionsController < ApplicationController
  before_action :set_collection, only: :show

  def index
    @collections = Collection.all
  end

  def show; end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
