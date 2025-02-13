require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'

# Checks for rooms in the same building that can be used for individual/group work
def individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    capacityNeeded = newEvent.attendees.to_i * 2
    computersNeeded = newEvent.attendees.to_i / 10

    startHour = newEvent.time[0,2].to_i + 1
    if newEvent.time[6,2] == "PM"
        startHour += 12
    end
    durationHours = newEvent.duration[0,2].to_i - 4

    lastHour = startHour + durationHours
    numDays = lastHour/24

    building = roomList[desiredRoomIndex][0]
    keepSearching = true
    currentBuilding = buildings
    while keepSearching
        if building == currentBuilding.building
            keepSearching = false
        else
            currentBuilding = currentBuilding.next
        end
    end

    planBool = Struct.new(:pass, :newPlan)

    firstDayDuration = 24 - startHour
    lastDayDuration = lastHour % 24
    for i in 0..numDays do
        currentTotalCapacity = 0
        totalComputers = 0
        currentRoom = currentBuilding.contents

        if i == 0
            individualTime = endOfEvent(newEvent.date, convertToString(startHour, true), "00:00")
            if numDays == 0
                individualDuration = durationHours
            else
                individualDuration = convertToString(firstDayDuration, false)
            end
        elsif i == numDays
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, false))
            individualDuration = convertToString(lastDayDuration, false)
        else
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, false))
            individualDuration = "24:00"
        end

        while (currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded) && currentRoom
            if currentRoom.index != desiredRoomIndex && roomList[currentRoom.index][1].to_i > 0 && roomList[currentRoom.index][2].to_i > 0 && roomList[currentRoom.index][2].to_i <= 1000
                if checkDateForConflict(reservedRooms, roomList, individualTime.date, individualTime.time, individualDuration, currentRoom.index)
                    individualRoom = createReservation(individualTime.date, individualTime.time, individualDuration, roomList[currentRoom.index], "Group work")
                    plan = addReservationToPlan(individualRoom, plan)

                    currentTotalCapacity += individualRoom.room[2]
                    if individualRoom.room[3] == "Yes"
                        totalComputers += individualRoom.room[2]
                    end
                end
            end
            currentRoom = currentRoom.next
        end

        if currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded
            return planBool.new(false, nil);
        end
    end

    return planBool.new(true, plan)
end

def convertToString(value, time)
    if value < 10
        if time
            return "0" + value.to_s + ":00 AM"
        else
            return "0" + value.to_s + ":00"
        end
    else
        if time
            return value.to_s + ":00 AM"
        else
            return value.to_s + ":00"
        end
    end
end