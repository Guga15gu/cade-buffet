class BuffetTypePricesController < ApplicationController
  before_action :authenticate, only: [:new, :create, :edit, :update]

  def new
    if BuffetTypePrice.exists?(buffet_type: params[:buffet_type_id])
      return redirect_to BuffetTypePrice.find_by(buffet_type: params[:buffet_type_id]), notice: 'Tipo de buffet já tem um preço!'
    end

    @buffet_type_id = params[:buffet_type_id]
    buffet_type = BuffetType.find(@buffet_type_id)
    if buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este tipo de buffet.'
    end
    @buffet_type_price = BuffetTypePrice.new
  end

  def create
    buffet_type_price_params = params.require(:buffet_type_price).permit(:base_price_weekday, :additional_per_person_weekday, :additional_per_hour_weekday, :base_price_weekend, :additional_per_person_weekend, :additional_per_hour_weekend, :buffet_type_id)

    @buffet_type_price = BuffetTypePrice.new(buffet_type_price_params)
    if @buffet_type_price.save
      redirect_to @buffet_type_price, notice: 'Seu preço de Buffet foi cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Seu preço de Buffet não foi cadastrado.'
      @buffet_type_id = buffet_type_price_params[:buffet_type_id]
      render 'new'
    end
  end

  def show
    @buffet_type_price = BuffetTypePrice.find(params[:id])
    buffet_type = @buffet_type_price.buffet_type

    if buffet_owner_user_signed_in?
      if buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
        return redirect_to root_path, alert: 'Você não possui acesso a este preço de tipo de buffet.'
      end
    end
  end

  def edit
    @buffet_type_price = BuffetTypePrice.find(params[:id])
    buffet_type = @buffet_type_price.buffet_type

    if buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este preço de tipo de buffet.'
    end
  end

  def update
    @buffet_type_price = BuffetTypePrice.find(params[:id])

    buffet_type_price_params = params.require(:buffet_type_price).permit(:base_price_weekday, :additional_per_person_weekday, :additional_per_hour_weekday, :base_price_weekend, :additional_per_person_weekend, :additional_per_hour_weekend)

    if @buffet_type_price.update(buffet_type_price_params)
      redirect_to @buffet_type_price, notice: 'Seu preço de tipo de Buffet foi editado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o seu preço de tipo de Buffet'
      render 'edit'
    end
  end

  private

  def authenticate
    if client_signed_in?
      return redirect_to root_path, alert: 'Clientes apenas podem visualizar buffet.'
    elsif not buffet_owner_user_signed_in?
      return redirect_to new_buffet_owner_user_session_path, alert: 'Você precisa ser usuário dono de buffet.'
    end
  end

end
