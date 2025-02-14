# Check if the desired room is available during the desired time
def checkDateForConflict(reservations, rooms, date, time, duration, roomsIndex)
    # If data is incorrect, return false imediately so next room search can begin
    if rooms[roomsIndex][1].to_i <= 0 || rooms[roomsIndex][2].to_i < 0 || rooms[roomsIndex][2].to_i > 1000
        return false
    end

    # Turn string data into usable values
    year = date[0,4]
    month = date[5,2].to_i - 1
    day = date[8,2].to_i - 1

    startHour = time[0,2].to_i
    startMinute = time[3,2].to_i
    # Add 12 hours to value if PM
    if (time[5,1].casecmp("P") || time[6,1].casecmp("P"))
        startHour += 12
    end
    durationHour = duration[0,2].to_i
    durationMinute = duration[3,2].to_i

    endHour = startHour + durationHour + (startMinute + durationMinute) / 60
    endMinute = (startMinute + durationMinute) % 60

    # Look at all reservations on specified date
    dailySchedule = reservations[month][day]
    while dailySchedule
        # If desired room is reserved on this date, check hours and minutes for overlap
        if rooms[dailySchedule.index][0] == rooms[roomsIndex][0] && rooms[dailySchedule.index][1] == rooms[roomsIndex][1] && dailySchedule.year == year 
            reservationStart = dailySchedule.reservation[3]
            reservationDuration = dailySchedule.reservation[4]

            reservationStartHour = reservationStart[0,2].to_i
            reservationStartMinute = reservationStart[3,2].to_i
            if reservationStart[6,2] == "PM"
                reservationStartHour += 12
            end
            reservationEndMinute = (reservationStart[3,2].to_i + reservationDuration[3,2].to_i)
            reservationEndHour = reservationDuration[0,2].to_i + reservationStartHour + (reservationEndMinute / 60)
            reservatinoEndMinute = reservationEndMinute % 60

            if !((startHour >= reservationEndHour) || (endHour <= reservationStartHour))
                return false
            elsif startHour == reservationEndHour
                if startMinute <= reservationEndMinute
                    return false
                end
            elsif startHour + durationHour == reservationStartHour
                if endMinute >= reservationStartMinute
                    return false
                end
            end
        end

        if !dailySchedule.next
            return true
        else
            dailySchedule = dailySchedule.next
        end
    end

    return true
end