# frozen_string_literal: true

module Administrator
  class BaseController < ::ApplicationController
    before_action :authenticate_admin!

    layout 'administrator'
  end
end
