class BuffetTypesController < ApplicationController
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

  def show
    @buffet_type = BuffetType.find(params[:id])
  end

  def edit
    @buffet_type = BuffetType.find(params[:id])
  end

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
end
