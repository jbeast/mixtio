class Api::V1::ApiController < ApplicationController

  include ApiPagination

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { :message => e.message }, status: :not_found
  end

end