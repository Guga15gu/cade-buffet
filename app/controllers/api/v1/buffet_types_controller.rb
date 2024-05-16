class Api::V1::BuffetTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    buffet_types = buffet.buffet_types.order(:name)

    render status:200, json: buffet_types.as_json(only: [:id, :name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, :alcoholic_beverages, :decoration, :parking_valet, :exclusive_address, :buffet_id])
  end

  def available
    if params[:date].nil? and params[:number_of_guests].nil?
      render status:412, json: {error: 'Data e Número de pessoas não foram informados'}
    elsif params[:date].nil?
      render status:412, json: {error: 'Data não foi informada'}
    elsif params[:number_of_guests].nil?
      render status:412, json: {error: 'Número de pessoas não foi informado'}

    else
      buffet_type = BuffetType.find(params[:id])

      return render status:412, json: {error: 'Tipo de Buffet ainda não tem preço cadastrado'}unless buffet_type.buffet_type_price.present?

      date = params[:date].to_date
      number_of_guests = params[:number_of_guests].to_i

      if number_of_guests < buffet_type.min_capacity_people
        return render status:412, json: {error: "Número de pessoas está abaixo do mínimo de #{buffet_type.min_capacity_people}"}
      elsif date < Date.tomorrow
        return render status:412, json: {error: 'Data precisa ser futura'}
      end

      price = calculate_price(buffet_type, date, number_of_guests)

      render status:200, json: {price: price}
    end
  end

  private

  def return_500
    render status: 500
  end

  def return_404
    render status: 404
  end

  def calculate_price(buffet_type, date, number_of_guests)
    buffet_type_price = buffet_type.buffet_type_price
    extra_people = number_of_guests - buffet_type.min_capacity_people
    if date.on_weekday?
      min_value = buffet_type_price.base_price_weekday
      additional_per_person = buffet_type_price.additional_per_person_weekday
    else
      min_value = buffet_type_price.base_price_weekend
      additional_per_person = buffet_type_price.additional_per_person_weekend
    end

    min_value + extra_people * additional_per_person
  end
end
