require 'csv'

# Read from input files
roomList = CSV.parse(File.read("rooms_list.csv"), headers: true)
reservedRooms = CSV.parse(File.read("reserved_rooms.csv"), headers: true)

# Organize reservations in hash table by date
reservationNode = Struct.new(:row, :next)

reservationsByDate = Array.new(12){Array.new(31)}

for i in 0..reservedRooms.length()-1 do

    date = reservedRooms[i][2]
    month = date[5,2].to_i - 1
    day = date[8,2].to_i - 1

    if reservationsByDate[month][day]
        reservationsByDate[month][day] = reservationNode.new(i, reservationsByDate[month][day])
    else
        reservationsByDate[month][day] = reservationNode.new(i, nil)
    end
end