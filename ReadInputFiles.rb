require 'csv'

roomList = CSV.parse(File.read("rooms_list.csv"), headers: true)
reservedRooms = CSV.parse(File.read("reserved_rooms.csv"), headers: true)