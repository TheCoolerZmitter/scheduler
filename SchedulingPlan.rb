# Creates scheduling plan
def createReservation(date, time, duration, room, purpose)
    reservation = Struct.new(:date, :time, :duration, :room, :purpose)
    return reservation.new(date, time, duration, room, purpose)
end

def createNewPlan(reservation)
    scheduleNode = Struct.new(:reservation, :next)

    return scheduleNode.new(reservation, nil)
end

def addReservationToPlan(reservation, plan)
    scheduleNode = Struct.new(:reservation, :next)
    current = plan
    while current.next
        current = current.next
    end
    current.next = scheduleNode.new(reservation, nil)
end

def resetPlan(plan)
    currentReservation = plan
    while currentReservation
        nextReservation = currentReservation.next
        currentReservation.reservation = nil
        currentReservation.next = nil
        currentReservation = nextReservation
    end
    plan = nil
end