class RoomService
  class << self

    ROOM_KEY = "rooms"

    def add_room name
      REDIS.rpush ROOM_KEY, name
    end

    def room_exists? room_name
      get_room_list.include? room_name
    end

    def get_room_list
      key_count = REDIS.llen(ROOM_KEY)
      REDIS.lrange ROOM_KEY, 0, key_count
    end

    def add_room_category room, category
      REDIS.rpush room, category
    end

    def remove_room_category room, category
      REDIS.lrem room, 0, category
    end

    def get_room_categories room
      key_count = REDIS.llen(room)
      REDIS.lrange room, 0, key_count
    end

    def incr_room_category room, category
      keys = get_keys_for_room_category(room, category) << "#{room}::#{category}::#{rand 1000000000}"
      keys.each { |key| REDIS.setex key, 5, 0 }
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
      REDIS.keys "#{room}::#{category}::*"
    end

  end
end
