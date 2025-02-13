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

# Get room and reservation data from files
roomList = createRoomList()
buildings = organizeByBuilding(roomList)
reservedRooms = createReservedRooms(buildings)

# Get event constraints from user
newEvent = getUserInput()

# Find desired room
desiredRoomIndex = binarySearch(roomList, newEvent.attendees.to_i)

# Find date and time of closing session
if newEvent.duration[0,2].to_i - 3 < 10
    closingSession = endOfEvent(newEvent.date, newEvent.time, "0" + (newEvent.duration[0,2].to_i - 3).to_s + ":00")
else
    closingSession = endOfEvent(newEvent.date, newEvent.time, (newEvent.duration[0,2].to_i - 3).to_s + ":00")
end

# Check for room's validity
keepSearching = true
while keepSearching
    # Check availability for opening and closing session
    if checkDateForConflict(reservedRooms, roomList, newEvent.date, newEvent.time, "01:00", desiredRoomIndex) && checkDateForConflict(reservedRooms, roomList, closingSession.date, closingSession.time, "03:00", desiredRoomIndex)
        # Create scheduling plan and add reservations for opening and closing sessions
        openingReservation = createReservation(newEvent.date, newEvent.time, "01:00", roomList[desiredRoomIndex], "Opening session")
        closingReservation = createReservation(closingSession.date, closingSession.time, "03:00", roomList[desiredRoomIndex], "Closing session")
        finalPlan = createNewPlan(openingReservation)
        addReservationToPlan(closingReservation, finalPlan)
        
        # Check the rest of HackTCNJ constraints
        keepSearching = !checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, finalPlan)
        if keepSearching
            #resetPlan(finalPlan)
            desiredRoomIndex += 1
            if desiredRoomIndex >= roomList.length()
                keepSearching = false
            end
        end

    # If there are scheduling problems, try the next room in roomList (in order of capacity)  
    else
        desiredRoomIndex += 1
        if desiredRoomIndex >= roomList.length()
            keepSearching = false
        end
    end
end

print(finalPlan)