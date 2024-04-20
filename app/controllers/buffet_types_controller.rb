class BuffetTypesController < ApplicationController
  before_action :set_buffet_type_and_check_ownership, only: [:show, :edit, :update]

  def new
    @buffet_type = BuffetType.new
  end

  def create
    buffet_type_params = params.require(:buffet_type).permit(:name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, :alcoholic_beverages, :decoration, :parking_valet, :exclusive_address)

    @buffet_type = BuffetType.new(buffet_type_params)
    @buffet_type.buffet = current_buffet_owner_user.buffet

    if @buffet_type.save
      redirect_to @buffet_type, notice: 'Seu tipo de Buffet foi cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Seu Tipo de Buffet não foi cadastrado.'
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    @buffet_type = BuffetType.find(params[:id])

    buffet_type_params = params.require(:buffet_type).permit(:name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, :alcoholic_beverages, :decoration, :parking_valet, :exclusive_address)

    if @buffet_type.update(buffet_type_params)
      redirect_to @buffet_type, notice: 'Seu tipo de Buffet foi editado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o seu tipo de Buffet'
      render 'edit'
    end
  end

  private

  def set_buffet_type_and_check_ownership
    @buffet_type = BuffetType.find(params[:id])
    if @buffet_type.buffet.buffet_owner_user != current_buffet_owner_user
      return redirect_to root_path, alert: 'Você não possui acesso a este tipo de Buffet.'
    end
  end
end
