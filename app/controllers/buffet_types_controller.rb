class BuffetTypesController < ApplicationController
  before_action :authenticate, only: [:new, :create, :edit, :update]
  before_action :set_buffet_type_and_check_ownership, only: [:edit, :update]
  before_action :require_and_set_own_buffet, only: [:new, :create, :edit, :update]

  def new
    @buffet_type = BuffetType.new
  end

  def create
    @buffet_type = BuffetType.new(buffet_type_params)
    @buffet_type.buffet = current_buffet_owner_user.buffet

    if @buffet_type.save
      redirect_to @buffet_type, notice: 'Seu tipo de Buffet foi cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Seu Tipo de Buffet não foi cadastrado.'
      render 'new'
    end
  end

  def show
    unless buffet_owner_user_signed_in?
      return @buffet_type = BuffetType.find(params[:id])
    end

    if Buffet.exists?(buffet_owner_user: current_buffet_owner_user)
      @buffet = Buffet.find_by(buffet_owner_user: current_buffet_owner_user)
    else
      return redirect_to new_buffet_path, alert: 'Como Dono de Buffet, precisas cadastrar seu buffet!'
    end

    @buffet_type = BuffetType.find(params[:id])
    if @buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este tipo de Buffet.'
    end
  end

  def edit; end

  def update
    if @buffet_type.update(buffet_type_params)
      redirect_to @buffet_type, notice: 'Seu tipo de Buffet foi editado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o seu tipo de Buffet'
      render 'edit'
    end
  end

  private

  def buffet_type_params
    params.require(:buffet_type).permit(:name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, :alcoholic_beverages, :decoration, :parking_valet, :exclusive_address)
  end

  def authenticate
    if client_signed_in?
      return redirect_to root_path, alert: 'Clientes apenas podem visualizar buffet.'
    elsif not buffet_owner_user_signed_in?
      return redirect_to new_buffet_owner_user_session_path, alert: 'Você precisa ser usuário dono de buffet.'
    end
  end

  def set_buffet_type_and_check_ownership
    @buffet_type = BuffetType.find(params[:id])
    if @buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este tipo de Buffet.'
    end
  end

  def require_and_set_own_buffet
    if Buffet.exists?(buffet_owner_user: current_buffet_owner_user)
      @buffet = Buffet.find_by(buffet_owner_user: current_buffet_owner_user)
    else
      return redirect_to new_buffet_path, alert: 'Como Dono de Buffet, precisas cadastrar seu buffet!'
    end
  end
end
