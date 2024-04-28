class BuffetsController < ApplicationController
  before_action :authenticate_buffet_owner_user!, only: [:new, :create, :edit, :update]
  before_action :require_and_set_buffet, only: [:edit, :update]
  before_action :check_if_already_has_buffet, only: [:new, :create]
  before_action :check_buffet_owner_user, only: [:edit, :update]

  def new
    @buffet = Buffet.new
  end

  def create
    buffet_params = params.require(:buffet).permit(:business_name, :corporate_name, :registration_number, :contact_phone, :address, :district, :state, :city, :postal_code, :description, :payment_methods)

    @buffet = Buffet.new(buffet_params)
    @buffet.buffet_owner_user = current_buffet_owner_user

    if @buffet.save
      redirect_to @buffet, notice: 'Seu Buffet foi cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Seu Buffet não foi cadastrado.'
      render 'new'
    end
  end

  def show
    @buffet = Buffet.find(params[:id])
  end

  def edit
  end

  def update
    buffet_params = params.require(:buffet).permit(:business_name, :corporate_name, :registration_number, :contact_phone, :address, :district, :state, :city, :postal_code, :description, :payment_methods)

    if @buffet.update(buffet_params)
      redirect_to @buffet, notice: 'Seu Buffet foi editado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o Buffet'
      render 'edit'
    end

  end

  def search
    @query = params[:query]

    buffets_by_city_or_state = Buffet.where("business_name LIKE ? OR city LIKE ?", "%#{@query}%", "%#{@query}%")
    buffets_by_type = Buffet.joins(:buffet_types).where("buffet_types.name LIKE ?", "%#{@query}%")

    @buffets = (buffets_by_city_or_state + buffets_by_type).sort_by { |buffet| buffet.business_name }
  end

  private

  def require_and_set_buffet
    if Buffet.exists?(buffet_owner_user: current_buffet_owner_user)
      @buffet = Buffet.find_by(buffet_owner_user: current_buffet_owner_user)
    else
      return redirect_to new_buffet_path, alert: 'Como Dono de Buffet, precisas cadastrar seu buffet!'
    end
  end

  def check_if_already_has_buffet
    if Buffet.exists?(buffet_owner_user: current_buffet_owner_user)
      buffet = Buffet.find_by(buffet_owner_user: current_buffet_owner_user)

      return redirect_to buffet, alert: 'Você já é dono de um Buffet, e apenas podes ser Dono de um Buffet!'
    end
  end

  def check_buffet_owner_user
    @buffet = Buffet.find(params[:id])
    if @buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este buffet.'
    end
  end
end
