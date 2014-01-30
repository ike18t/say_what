require 'sinatra/assetpack'
require_relative 'services/room_service'

class SayWhatServer < Sinatra::Base
  register Sinatra::AssetPack

  set :root, File.join(File.dirname(__FILE__), '..')

  assets do
    js :application, ['/js/*.js']
    css :application, ['/css/*.css']
  end

  get '/' do
    @rooms = RoomService.get_room_list
    haml :index, :layout => :default
  end

  get '/room/:name/view' do
    return 'Room does not exist' unless RoomService.room_exists?(params[:name])
    @room_name = params[:name]
    haml :show, :layout => :default
  end

  get '/room/:name' do
    return 'Room does not exist' unless RoomService.room_exists?(params[:name])
    @room_name = params[:name]
    haml :remote, :layout => :default
  end

  post '/room/add' do
    name = params[:name]
    RoomService.add_room name
    redirect "/room/#{name}/view"
  end

  get '/:room/add_category/:name' do
    room, name = params[:room], params[:name]
    RoomService.add_room_category room, name
  end

  get '/room/:name/get_categories' do
    name = params[:name]
    { :categories => RoomService.get_room_categories(name) }.to_json
  end

  put '/room/:name/incr_category/:category' do
    name, category = params[:name], params[:category]
    RoomService.incr_room_category name, category
  end

  get '/room/:name/get_counts' do
    name = params[:name]
    #so there is no confusion where the data is coming from
    #{ :categories => RoomService.get_room_categories_with_counts(name) }.to_json
  end

end
