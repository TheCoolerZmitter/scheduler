require 'csv'

# prints output to console
def print(schedule)

    p schedule

    finalSchedule = Array.new(schedule.count){Array.new(13)}

    currentReservation = schedule

    for i in 0..schedule.count-1 do
        finalSchedule[i][0] = currentReservation.reservation.date[0,10]
        finalSchedule[i][1] = currentReservation.reservation.time[0,8]
        finalSchedule[i][2] = currentReservation.reservation.duration
        finalSchedule[i][3] = currentReservation.reservation.room[0]
        finalSchedule[i][4] = currentReservation.reservation.room[1]
        finalSchedule[i][5] = currentReservation.reservation.room[2]
        finalSchedule[i][6] = currentReservation.reservation.room[3]
        finalSchedule[i][7] = currentReservation.reservation.room[4]
        finalSchedule[i][8] = currentReservation.reservation.room[5]
        finalSchedule[i][9] = currentReservation.reservation.room[6]
        finalSchedule[i][10] = currentReservation.reservation.room[7]
        finalSchedule[i][11] = currentReservation.reservation.room[8]
        finalSchedule[i][12] = currentReservation.reservation.purpose
        currentReservation = currentReservation.next

        p finalSchedule[i]
    end

    
end