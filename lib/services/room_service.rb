class RoomService
  class << self

    ROOM_KEY = "rooms"

    def add_room name
      redis.rpush ROOM_KEY, name
    end

    def room_exists? room_name
      get_room_list.include? room_name
    end

    def get_room_list
      key_count = redis.llen(ROOM_KEY)
      redis.lrange ROOM_KEY, 0, key_count
    end

    def add_room_category room, category
      redis.rpush room, category
    end

    def remove_room_category room, category
      redis.lrem room, 0, category
    end

    def get_room_categories room
      key_count = redis.llen(room)
      redis.lrange room, 0, key_count
    end

    def incr_room_category room, category
      keys = get_keys_for_room_category(room, category) << "#{room}::#{category}::#{rand 1000000000}"
      keys.each { |key| redis.setex key, 5, 0 }
    end

    def get_room_categories_with_counts room
      categories = get_room_categories room
      return_values = Hash.new
      categories.each do |category|
        return_values[category] = get_keys_for_room_category(room, category).length
      end
      return_values
    end

    private

    def get_keys_for_room_category room, category
      redis.keys "#{room}::#{category}::*"
    end

    def redis
      @redis ||= Redis.new
    end

  end
end
