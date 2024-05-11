class OrdersController < ApplicationController
  before_action :authenticate_buffet_owner_user, only: [:buffet_owner_user_index]
  before_action :authenticate_client, only: [:client_index, :new]
  def new
    @order = Order.new
    @buffet = Buffet.find(params[:buffet_id])
    @buffet_types = @buffet.buffet_types
  end

  def create
    order_params = params.require(:order).permit(:buffet_type_id, :date, :number_of_guests, :event_details, :has_custom_address, :address)

    @order = Order.new(order_params)
    @order.buffet = @order.buffet_type.buffet
    @order.client = current_client

    if @order.save
      redirect_to @order, notice: 'Pedido feito com sucesso, aguardando análise do Buffet.'
    else
      flash.now[:alert] = 'Seu pedido não foi cadastrado.'
      @buffet = @order.buffet_type.buffet
      @buffet_types = @buffet.buffet_types
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
    @buffet = Buffet.find(@order.buffet_id)
    @buffet_type = BuffetType.find(@order.buffet_type_id)
  end

  def client_index
    @orders = current_client.orders
  end

  def buffet_owner_user_index
    buffet = current_buffet_owner_user.buffet

    if buffet.nil?
      @orders = []
    else
      return @orders = [] if buffet.orders.nil?
      @orders = buffet.orders
    end
  end

  private

  def authenticate_buffet_owner_user
    if client_signed_in?
      return redirect_to root_path, alert: 'Você precisa ser um dono de buffet para acessar seus pedidos como dono'
    end
    unless buffet_owner_user_signed_in?
      return redirect_to new_buffet_owner_user_session_path, alert: 'Você precisa ser um dono de buffet para acessar pedidos'
    end
  end

  def authenticate_client
    if buffet_owner_user_signed_in?
      return redirect_to root_path, alert: 'Você precisa ser um cliente para acessar seus pedidos como cliente'
    end

    unless client_signed_in?
      return redirect_to new_client_session_path, alert: 'Você precisa ser um cliente para acessar seus pedidos'
    end
  end
end
