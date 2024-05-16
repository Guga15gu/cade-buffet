class Api::V1::BuffetTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    buffet_types = buffet.buffet_types.order(:name)

    render status:200, json: buffet_types.as_json(only: [:id, :name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, :alcoholic_beverages, :decoration, :parking_valet, :exclusive_address, :buffet_id])
  end

  private

  def return_500
    render status: 500
  end

  def return_404
    render status: 404
  end
end
