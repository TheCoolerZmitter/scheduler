require 'csv'


# Get reservation data from file and store in a hashtable
def createReservedRooms(roomList)
    reservedRooms = CSV.parse(File.read("reserved_rooms.csv"), headers: true)
    reservedRoomsList = organizeReservations(reservedRooms, roomList)
    reservations = Struct.new(:table, :hash)
    return reservations.new(reservedRooms, reservedRoomsList)
end

# Organize reservations in hash table by date
def organizeReservations(reservedRooms, roomList)
    reservationNode = Struct.new(:row, :index, :next)

    reservationsByDate = Array.new(12){Array.new(31)}

    for i in 0..reservedRooms.length()-1 do

        date = reservedRooms[i][2]
        month = date[5,2].to_i - 1
        day = date[8,2].to_i - 1

        building = reservedRooms[i][0]
        roomNum = reservedRooms[i][1]
        index = -1

        currentBuilding = roomList
        while index == -1
            if building == currentBuilding.building
                currentRoom = currentBuilding.contents
                while index == -1
                    if roomNum == currentRoom.roomNum
                        index = currentRoom.index
                    else
                        currentRoom = currentRoom.next
                    end
                end
            else
                currentBuilding = currentBuilding.next
            end
        end

        if reservationsByDate[month][day]
            reservationsByDate[month][day] = reservationNode.new(index, i, reservationsByDate[month][day])
        else
            reservationsByDate[month][day] = reservationNode.new(index, i, nil)
        end
    end

    return reservationsByDate
end