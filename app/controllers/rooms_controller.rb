class RoomsController < ApplicationController
  def index
    @rooms = RoomService.get_room_list
  end

  def show
    name = params[:name]
  end

  def add
    name = params[:name]
    RoomService.add_room name
  end

  def add_category
    name = params[:name]
    RoomService.add_room_category name
  end

  def get_categories
    name = params[:name]
    render :json => RoomService.get_room_categories(name)
  end
end
