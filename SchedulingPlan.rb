# Creates scheduling plan
def createReservation(date, time, duration, room, purpose)
    reservation = Struct.new(:date, :time, :duration, :room, :purpose)
    return = reservation.new(date, time, duration, room, purpose)
end

def createNewPlan(reservation)
    scheduleNode = Struct.new(:reservation, :next)

    return = scheduleNode.new(reservation, nil)
end

def addReservationToPlan(reservation, plan)
    plan.next = plan
    plan.reservation = reservation
    plan.next.prev = plan
end

def resetPlan(plan)
    currentReservation = plan
    while currentReservation
        nextReservation = currentReservation.next
        currentReservation.delete()
        currentReservation = nextReservation
    end
end