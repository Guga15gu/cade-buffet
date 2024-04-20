class BuffetTypePricesController < ApplicationController
  def new
    @buffet_type_price = BuffetTypePrice.new
  end

  def create
    buffet_type_price_params = params.require(:buffet_type).permit(:base_price_weekday, :additional_per_person_weekday, :additional_per_hour_weekday, :base_price_weekend, :additional_per_person_weekend, :additional_per_hour_weekend)

    @buffet_type_price = BuffetTypePrice.new(buffet_type_price_params)
    @buffet_type_price.buffet_type = current_buffet_owner_user.buffet

    if @buffet_type_price.save
      redirect_to @buffet_type_price, notice: 'Seu preço de Buffet foi cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Seu preço de Buffet não foi cadastrado.'
      render 'new'
    end
  end
end
