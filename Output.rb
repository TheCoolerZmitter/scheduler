# prints output to console
def print(schedule)
    currentReservation = schedule
    while currentReservation
        p currentReservation.reservation.room
        p currentReservation.reservation.date
        p currentReservation.reservation.time
        p currentReservation.reservation.duration
        p currentReservation.reservation.purpose
        currentReservation = currentReservation.next
    end
end