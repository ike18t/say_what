class RoomService

  ROOM_KEY = "rooms"

  def self.add_room name
    REDIS.rpush ROOM_KEY, name
  end

  def self.get_room_list
    key_count = REDIS.llen(ROOM_KEY)
    REDIS.lrange ROOM_KEY, 0, key_count
  end

  def self.add_room_category room, category
    REDIS.rpush room, category
  end

  def self.get_room_categories room
    key_count = REDIS.llen(room)
    REDIS.lrange room, 0, key_count
  end

  def self.incr_room_category room, category
    REDIS.setex "#{room}::#{category}::#{rand 1000000000}", 5, 0
  end

  def self.get_room_categories_with_counts room
    categories = get_room_categories room
    return_values = Hash.new
    categories.each do |category|
      return_values[category] = (REDIS.keys("#{room}::#{category}::*")).length
    end
    return_values
  end

end
