require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'

# Checks for rooms in the same building that can be used for individual/group work
def individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    capacityNeeded = newEvent.attendees.to_i * 2
    computersNeeded = newEvent.attendees.to_i / 10

    startHour = newEvent.time[0,2].to_i + 1
    startMinute = newEvent.time[3,2].to_i
    if newEvent.time[6,2] == "PM"
        startHour += 12
    end
    durationHours = newEvent.duration[0,2].to_i - 4
    durationMinutes = newEvent.duration[3,2].to_i

    lastHour = startHour + durationHours
    lastMinute = startMinute + durationMinutes
    lastHour += lastMinute / 60
    lastMinute = lastMinute % 60
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

    firstDayDurationHours = 24 - startHour
    if startMinute > 0
        firstDayDurationHours -= 1
    end
    lastDayDurationHours = lastHour % 24

    for i in 0..numDays do
        currentTotalCapacity = 0
        totalComputers = 0
        numRooms = 0
        currentRoom = currentBuilding.contents

        if i == 0
            individualTime = endOfEvent(newEvent.date, convertToString(startHour, startMinute, true), "00:00")
            if numDays == 0
                individualDuration = convertToString(durationHours, durationMinutes, false)
            else
                individualDuration = convertToString(firstDayDurationHours, 60 - startMinute, false)
            end
        elsif i == numDays
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, 0, false))
            individualDuration = convertToString(lastDayDurationHours, lastMinute, false)
        else
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, 0, false))
            individualDuration = "24:00"
        end

        while (currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded || numRooms < 2) && currentRoom
            if currentRoom.index != desiredRoomIndex && roomList[currentRoom.index][1].to_i > 0 && roomList[currentRoom.index][2].to_i > 0 && roomList[currentRoom.index][2].to_i <= 1000
                if checkDateForConflict(reservedRooms, roomList, individualTime.date, individualTime.time, individualDuration, currentRoom.index)
                    individualRoom = createReservation(individualTime.date, individualTime.time, individualDuration, roomList[currentRoom.index], "Group work")
                    plan = addReservationToPlan(individualRoom, plan)

                    currentTotalCapacity += individualRoom.room[2]
                    numRooms += 1
                    if individualRoom.room[3] == "Yes"
                        totalComputers += individualRoom.room[2]
                    end
                end
            end
            currentRoom = currentRoom.next
        end

        if currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded || numRooms < 2
            return planBool.new(false, nil);
        end
    end

    return planBool.new(true, plan)
end

def convertToString(hour, minute, time)
    if hour < 10
        leadingZeroHour = "0"
    else
        leadingZeroHour = ""
    end
    if minute < 10
        leadingZeroMinute = "0"
    else
        leadingZeroMinute = ""
    end

    if time
        return leadingZeroHour + hour.to_s + ":" + leadingZeroMinute + minute.to_s + "AM"
    else
        return leadingZeroHour + hour.to_s + ":" + leadingZeroMinute + minute.to_s
    end
end