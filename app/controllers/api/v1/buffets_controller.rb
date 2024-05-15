class Api::V1::BuffetsController < Api::V1::ApiController
  def show
    buffet = Buffet.find(params[:id])
    render status: 200, json: buffet.as_json(only: [:id, :business_name, :contact_phone, :address, :district, :state, :city, :postal_code, :description, :payment_methods])
  end

  def index

    if params[:search].present?
      buffets = Buffet.where("business_name LIKE ?", "%#{params[:search]}%").order(:business_name)
    else
      buffets = Buffet.all.order(:business_name)
    end

    render status:200, json: buffets.as_json(only: [:id, :business_name, :contact_phone, :address, :district, :state, :city, :postal_code, :description, :payment_methods])

  end

  private

  def return_500
    render status: 500
  end

  def return_404
    render status: 404
  end
end
