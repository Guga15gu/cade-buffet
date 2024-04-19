class BuffetsController < ApplicationController
  before_action :authenticate_buffet_owner_user!

  def new

  end
end
