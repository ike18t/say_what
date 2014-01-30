require 'em-websocket'
require 'redis'

EventMachine.run do
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |ws|
    ws.onopen do
      sid = @channel.subscribe { |msg| ws.send msg }
      require_relative 'services/room_service'
      require 'json'
      json_string = { :categories => RoomService.get_room_categories_with_counts('test') }.to_json.to_s
      @channel.push json_string

      ws.onmessage do |msg|
        @channel.push "<#{sid}>: #{msg}"
      end

      ws.onclose do
        @channel.unsubscribe(sid)
      end
    end
  end

  puts "Socket server started"

  Thread.new do
    require_relative 'services/room_service'
    require 'json'
    prev_json_string = ''
    loop do
      json_string = { :categories => RoomService.get_room_categories_with_counts('test') }.to_json.to_s
      if json_string != prev_json_string
        @channel.push json_string
      end
      prev_json_string = json_string
      sleep 1
    end
  end
end
