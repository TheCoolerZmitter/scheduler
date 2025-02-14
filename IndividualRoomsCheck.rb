require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'

# Checks for rooms in the same building that can be used for individual/group work
def individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    planBool = Struct.new(:pass, :newPlan)

    # Converts string data into usable values
    durationHours = newEvent.duration[0,2].to_i - 4
    durationMinutes = newEvent.duration[3,2].to_i

    # If there is no time for individual/group work, return true with the original schedule
    if durationHours + durationMinutes == 0
        return planBool.new(true, plan)
    end

    # Assumes capacity needed is 2x the number of attendees
    capacityNeeded = newEvent.attendees.to_i * 2
    computersNeeded = newEvent.attendees.to_i / 10

    # Converts string data into usable values
    startHour = newEvent.time[0,2].to_i + 1
    startMinute = newEvent.time[3,2].to_i
    if newEvent.time[6,2] == "PM"
        startHour += 12
    end

    lastHour = startHour + durationHours
    lastMinute = startMinute + durationMinutes
    lastHour += lastMinute / 60
    lastMinute = lastMinute % 60
    numDays = lastHour/24

    # Finds linked list containing all rooms in the correct building
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

    # Calculates how many hours the event lasts on the first and last day; used if event is multiple days
    firstDayDurationHours = 24 - startHour
    if startMinute > 0
        firstDayDurationHours -= 1
    end
    lastDayDurationHours = lastHour % 24

    # Checks availability of rooms in the building for every day of the event
    for i in 0..numDays do
        currentTotalCapacity = 0
        totalComputers = 0
        numRooms = 0
        currentRoom = currentBuilding.contents

        # If day 1 of event
        if i == 0
            individualTime = endOfEvent(newEvent.date, convertToString(startHour, startMinute, true), "00:00")
            # if event is less than one day, use duration entered by user
            if numDays == 0
                individualDuration = convertToString(durationHours, durationMinutes, false)
            # if event is more than one day, use previously calculated first day duration
            else
                individualDuration = convertToString(firstDayDurationHours, 60 - startMinute, false)
            end

        # If final day, start reservation at midnight and use previously calculated final day duration
        elsif i == numDays
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, 0, false))
            individualDuration = convertToString(lastDayDurationHours, lastMinute, false)
        
        # If neither first nor final day, start reservation at midnight and reserve 24 hours
        else
            individualTime = endOfEvent(newEvent.date, "00:00 AM", convertToString(i * 24, 0, false))
            individualDuration = "24:00"
        end

        # Check date and duration of each room and date for conflicts
        while (currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded || numRooms < 2) && currentRoom
            if currentTotalCapacity >= capacityNeeded && totalComputers < computersNeeded
                # If necessary capacity is met but there are not enough computers, keep searching for a room with computers
                if roomList[currentRoom.index][3] == "Yes" && currentRoom.index != desiredRoomIndex
                    if checkDateForConflict(reservedRooms, roomList, individualTime.date, individualTime.time, individualDuration, currentRoom.index)
                        individualRoom = createReservation(individualTime.date, individualTime.time, individualDuration, roomList[currentRoom.index], "Group work")
                        plan = addReservationToPlan(individualRoom, plan)

                        currentTotalCapacity += individualRoom.room[2]
                        numRooms += 1
                        totalComputers += individualRoom.room[2]
                    end
                end
            else
                # If capacity has not been met, add any room even if they don't provide computers
                if currentRoom.index != desiredRoomIndex && roomList[currentRoom.index][1].to_i > 0
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
            end
            currentRoom = currentRoom.next
        end

        if currentTotalCapacity < capacityNeeded || totalComputers < computersNeeded || numRooms < 2
            return planBool.new(false, nil);
        end
    end

    return planBool.new(true, plan)
end

# Converts a time or duration integer into a string in the proper format
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