require 'test_helper'

class RoomServiceTest < ActiveSupport::TestCase
  ROOM_KEY = "rooms"

  setup do
    REDIS.flushdb
  end

  test "add_room adds to the redis room list" do
    assert_equal(0, REDIS.llen(ROOM_KEY))
    RoomService.add_room("test")
    assert_equal(1, REDIS.llen(ROOM_KEY))
    assert_equal("test", REDIS.lpop(ROOM_KEY))
  end

  test "get_room_list returns a list of rooms" do
    RoomService.add_room("foo")
    RoomService.add_room("bar")
    room_list = RoomService.get_room_list
    assert_equal(2, room_list.length)
    assert(room_list.index("foo") != nil)
    assert(room_list.index("bar") != nil)
  end

  test "room_exists returns false if no rooms" do
    assert_equal(false, RoomService.room_exists?("bah"))
  end

  test "room_exists returns true if room does exists" do
    RoomService.add_room "bah"
    assert_equal(true, RoomService.room_exists?("bah"))
  end

  test "get_room_list returns empty array if no rooms" do
    assert_equal([], RoomService.get_room_list)
  end

  test "add_room_category adds the category to the rooms list" do
    assert_equal(0, REDIS.llen("foo"))
    RoomService.add_room("foo")
    RoomService.add_room_category("foo", "bar")

    assert_equal(1, REDIS.llen("foo"))
    assert_equal("bar", REDIS.lpop("foo"))
  end

  test "get_room_categories returns all room categories" do
    RoomService.add_room "foo"
    RoomService.add_room_category "foo", "bar"
    RoomService.add_room_category "foo", "bah"
    categories = RoomService.get_room_categories "foo"
    assert_equal 2, categories.length
    assert(categories.index("bar") != nil)
    assert(categories.index("bah") != nil)
  end

  test "get_room_categories returns empty array if no categories" do
    RoomService.add_room "foo"
    assert_equal [], RoomService.get_room_categories("foo")
  end

  test "incr_room_category adds an entry to redis" do
    RoomService.incr_room_category "foo", "bar"
    keys = REDIS.keys "foo::bar::*"
    assert_equal 1, keys.length
  end

  test "incr_room_category adds an entry as well as updates expirations for previous entries which then expire after 5 seconds" do
    RoomService.incr_room_category "foo", "bar"
    keys = REDIS.keys "foo::bar::*"
    assert_equal 1, keys.length
    sleep 4
    RoomService.incr_room_category "foo", "bar"
    sleep 3
    keys = REDIS.keys "foo::bar::*"
    assert_equal 2, keys.length
    sleep 6
    keys = REDIS.keys "foo::bar::*"
    assert_equal 0, keys.length
  end

  test "get_room_categories_with_counts returns a hash of categories for a room and counts" do
    RoomService.add_room "foo"
    RoomService.add_room_category "foo", "bar"
    RoomService.incr_room_category "foo", "bar"
    RoomService.incr_room_category "foo", "bar"
    assert_equal({ "bar" => 2 }, RoomService.get_room_categories_with_counts("foo"))
  end
end
