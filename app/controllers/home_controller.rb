class HomeController < ApplicationController
  def index
    @buffet = Buffet.find_by(buffet_owner_user: current_buffet_owner_user)
    @buffets = Buffet.all
  end
end
