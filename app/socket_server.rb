require 'em-websocket'
require 'redis'

EventMachine.run do
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |ws|
    ws.onopen do
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "#{sid} connected!"

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
    loop do
      json_string = { :categories => RoomService.get_room_categories_with_counts('test_room') }.to_json.to_s
      @channel.push json_string
      sleep 1
    end
  end
end
