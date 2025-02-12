# Check if the desired room is available during the desired time
def checkDateForConflict(reservations, rooms, date, roomsIndex)
    month = date[5,2].to_i - 1
    day = date[8,2].to_i - 1

    p reservations[4][4]

    dailySchedule = reservations[month][day]
    
    while dailySchedule
        p rooms[dailySchedule.row]
        if rooms[dailySchedule.row][0] == rooms[roomsIndex][0] && rooms[dailySchedule.row][1] == rooms[roomsIndex][1]
            return false
        end

        if !dailySchedule
            return true
        else
            dailySchedule = dailySchedule.next
        end
    end

    return true
end