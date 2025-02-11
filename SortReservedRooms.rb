require 'csv'


# Get reservation data from file and store in a hashtable
def createReservedRooms()
    reservedRooms = CSV.parse(File.read("reserved_rooms.csv"), headers: true)
    return organizeReservations(reservedRooms)
end

# Organize reservations in hash table by date
def organizeReservations(reservedRooms)
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

    return reservationsByDate
end