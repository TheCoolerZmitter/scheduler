require_relative 'UserInput'
require_relative 'SortRoomList'
require_relative 'SortReservedRooms'
require_relative 'BinarySearch'
require_relative 'CheckDateForConflict'
require_relative 'OrganizeByBuilding'
require_relative 'HackTCNJConstraints'
require_relative 'Output'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'
require_relative 'MidnightOverlap'

# Get first file path from user
roomListPath = getRoomListFilePath()

# Get room data from file
roomList = createRoomList(roomListPath)
buildings = organizeByBuilding(roomList)

# Get second file path from user
roomReservationPath = getReservationListFilePath()

# Get reservation data from file
reservedRooms = createReservedRooms(buildings, roomReservationPath)

# Get event constraints from user
newEvent = getUserConstraints()

# Find desired room
desiredRoomIndex = binarySearch(roomList, newEvent.attendees.to_i)

# Find date and time of closing session
durationHours = newEvent.duration[0,2].to_i - 3
if durationHours < 10
    closingSession = endOfEvent(newEvent.date, newEvent.time, "0" + durationHours.to_s + newEvent.duration[2,3])
else
    closingSession = endOfEvent(newEvent.date, newEvent.time, durationHours.to_s + newEvent.duration[2,3])
end

# Check for room's validity
keepSearching = true
success = true
while keepSearching
    # Checks if opening or closing session overlaps midnight (occuring on two dates)
    overlap = midnightOverlap(newEvent, closingSession)

    # Check availability of desired room during opening and closing session
    if ((!overlap.openingSessionMidnight && checkDateForConflict(reservedRooms, roomList, newEvent.date, newEvent.time, "01:00", desiredRoomIndex)) || (overlap.openingSessionMidnight && checkDateForConflict(reservedRooms, roomList, newEvent.date, newEvent.time, overlap.openingDayOne, desiredRoomIndex))) && ((!overlap.closingSessionMidnight && checkDateForConflict(reservedRooms, roomList, overlap.openingDate, "00:00 AM", overlap.openingDayTwp, desiredRoomIndex)) || (overlap.closingSessionMidnight && checkDateForConflict(reservedRooms, roomList, closingSession.date, closingSession.time, overlap.closingDayOne, desiredRoomIndex) && checkDateForConflict(reservedRooms, roomList, overlap.closingDate, "00:00 AM", overlap.closingDayTwo, desiredRoomIndex)))
        # Create scheduling plan and add reservations for opening and closing sessions
        if overlap.openingSessionMidnight
            openingReservation = createReservation(newEvent.date, newEvent.time, overlap.openingDayOne, roomList[desiredRoomIndex], "Opening session")
            openingReservationTwo = createReservation(overlap.openingDate, "12:00 AM", overlap.openingDayTwo, roomList[desiredRoomIndex], "Opening session")
            finalPlan = createNewPlan(openingReservation)
            finalPlan = addReservationToPlan(openingReservationTwo, finalPlan)
        else
            openingReservation = createReservation(newEvent.date, newEvent.time, "01:00", roomList[desiredRoomIndex], "Opening session")
            finalPlan = createNewPlan(openingReservation)
        end

        if overlap.closingSessionMidnight
            closingReservation = createReservation(closingSession.date, closingSession.time, overlap.closingDayOne, roomList[desiredRoomIndex], "Closing session")
            closingReservationTwo = createReservation(overlap.closingDate, "12:00 AM", overlap.closingDayTwo, roomList[desiredRoomIndex], "Closing session")
            finalPlan = addReservationToPlan(closingReservation, finalPlan)
            finalPlan = addReservationToPlan(closingReservationTwo, finalPlan)
        else
            closingReservation = createReservation(closingSession.date, closingSession.time, "03:00", roomList[desiredRoomIndex], "Closing session")
            finalPlan = addReservationToPlan(closingReservation, finalPlan)
        end
        
        # Check the rest of HackTCNJ constraints
        finalPlanBool = checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, finalPlan)
        keepSearching = !finalPlanBool.pass
        if keepSearching
            #resetPlan(finalPlan)
            desiredRoomIndex += 1
            if desiredRoomIndex >= roomList.length()
                keepSearching = false
            end
        else
            finalPlan = finalPlanBool.newPlan
        end

    # If there are scheduling problems, try the next room in roomList (in order of capacity)  
    else
        desiredRoomIndex += 1
        if desiredRoomIndex >= roomList.length()
            keepSearching = false
            success = false
        end
    end
end

# Print success or fail message
if success
    print(finalPlan)
else
    printFail()
end