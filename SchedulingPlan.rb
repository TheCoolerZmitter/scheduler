# Creates scheduling plan
def createReservation(date, time, duration, room, purpose)
    reservation = Struct.new(:date, :time, :duration, :room, :purpose)
    return reservation.new(date, time, duration, room, purpose)
end

def createNewPlan(reservation)
    scheduleNode = Struct.new(:reservation, :next, :count)
    return scheduleNode.new(reservation, nil, 1)
end

def addReservationToPlan(reservation, plan)
    scheduleNode = Struct.new(:reservation, :next, :count)
    count = plan.count + 1

    return scheduleNode.new(reservation, plan, count)
end

def resetPlan(plan)
    currentReservation = plan
    while currentReservation
        nextReservation = currentReservation.next
        currentReservation.reservation = nil
        currentReservation.next = nil
        currentReservation.count = nil
        currentReservation = nextReservation
    end
    plan = nil
end