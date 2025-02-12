# Check if the desired room is available during the desired time
def checkDateForConflict(reservations, rooms, date, roomsIndex, time, duration)
    month = date[5,2].to_i - 1
    day = date[8,2].to_i - 1

    startHour = time[0,2].to_i
    if time[6,2] == "PM"
        startHour += 12
    end
    durationHour = duration[0,2].to_i

    dailySchedule = reservations.hash[month][day]
    while dailySchedule
        if rooms[dailySchedule.row][0] == rooms[roomsIndex][0] && rooms[dailySchedule.row][1] == rooms[roomsIndex][1]
            reservationStart = reservations.table[dailySchedule.index][3]
            reservationDuration = reservations.table[dailySchedule.index][4]

            reservationStartHour = reservationStart[0,2].to_i
            if reservationStart[6,2] == "PM"
                reservationStartHour += 12
            end
            reservationEndHour = reservationDuration[0,2].to_i + reservationStartHour

            if !((startHour > reservationEndHour) || (startHour + durationHour < reservationStartHour))
                return false
            end
        end

        if !dailySchedule
            return true
        else
            dailySchedule = dailySchedule.next
        end
    end

    return true
end