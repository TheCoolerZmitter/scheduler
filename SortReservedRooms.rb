require 'csv'


# Get reservation data from file and store in a hashtable
def createReservedRooms(roomList, path)
    reservedRooms = CSV.parse(File.read(path), headers: true)
    return organizeReservations(reservedRooms, roomList)
end

# Organize reservations in hash table by date
def organizeReservations(reservedRooms, roomList)
    reservationNode = Struct.new(:index, :reservation, :year, :next)

    # Create 2D array for months and days
    reservationsByDate = Array.new(12){Array.new(31)}

    # Insert all entries into hash table
    for i in 0..reservedRooms.length()-1 do
        # Convert string data into usable values
        date = reservedRooms[i][2]
        year = date[0,4]
        month = date[5,2].to_i - 1
        day = date[8,2].to_i - 1

        # Store building and room number to look for the index of the room in the sorted room_list
        building = reservedRooms[i][0]
        roomNum = reservedRooms[i][1]
        index = -1

        # Look for index of room in room_list using the building/room nested linked list
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

        # Store room in hash table
        if reservationsByDate[month][day]
            reservationsByDate[month][day] = reservationNode.new(index, reservedRooms[i], year, reservationsByDate[month][day])
        else
            reservationsByDate[month][day] = reservationNode.new(index, reservedRooms[i], year, nil)
        end
    end

    return reservationsByDate
end