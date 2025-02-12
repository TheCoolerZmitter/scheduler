require_relative 'UserInput'
require_relative 'SortRoomList'
require_relative 'SortReservedRooms'
require_relative 'BinarySearch'
require_relative 'CheckDateForConflict'
require_relative 'OrganizeByBuilding'
require_relative 'HackTCNJConstraints'
require_relative 'Output'
require_relative 'EndOfEvent'

# Get room and reservation data from files
roomList = createRoomList()
buildings = organizeByBuilding(roomList)
reservedRooms = createReservedRooms(buildings)

# Get event constraints from user
newEvent = getUserInput()

# Find desired room
desiredRoomIndex = binarySearch(roomList, newEvent.attendees.to_i)

# Find date and time of closing session
closingSession = endOfEvent(newEvent.date, newEvent.time, newEvent.duration.to_i - 3)

# Check for room's validity
keepSearching = true
#while keepSearching
    # Check opening and closing session
    if checkDateForConflict(reservedRooms, roomList, newEvent.date, newEvent.time, "01:00", desiredRoomIndex) && checkDateForConflict(reservedRooms, roomList, closingSession.date, closingSession.time, "03:00", desiredRoomIndex)
        # Check rest of HackTCNJ constraints
        checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings)

    # If there are scheduling problems, try the next room (in order of capacity)
    else
        desiredRoomIndex += 1
        if desiredRoomIndex >= roomList.length()
            keepSearching = false
        end
    end
#end