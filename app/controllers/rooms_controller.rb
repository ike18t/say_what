class RoomsController < ApplicationController
  def index
    @rooms = RoomService.get_room_list
  end

  def show
    render :text => 'Room does not exist' unless RoomService.room_exists?(params[:name])
    @room_name = params[:name]
  end

  def remote
    render :text => 'Room does not exist' unless RoomService.room_exists?(params[:name])
    @room_name = params[:name]
  end

  def add
    name = params[:name]
    RoomService.add_room name
    redirect_to :action => :show, :name => name
  end

  def add_category
    room, name = params[:room], params[:name]
    RoomService.add_room_category room, name
  end

  def get_categories
    name = params[:name]
    render :json => { :categories => RoomService.get_room_categories(name) }
  end

  def incr_category
    room, name = params[:room], params[:name]
    RoomService.incr_room_category room, name
    render :nothing => true
  end

  def get_categories_with_counts
    name = params[:name]
    render :json => { :categories => RoomService.get_room_categories_with_counts(name) }
  end
end
