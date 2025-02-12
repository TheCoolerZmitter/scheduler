require_relative 'UserInput'
require_relative 'SortRoomList'
require_relative 'SortReservedRooms'
require_relative 'BinarySearch'
require_relative 'CheckDateForConflict'
require_relative 'OrganizeByBuilding'

# Get room and reservation data from files
roomList = createRoomList()
buildings = organizeByBuilding(roomList)
reservedRooms = createReservedRooms(buildings)

# Get event constraints from user
newEvent = getUserInput()

# Find desired room
desiredRoomIndex = binarySearch(roomList, newEvent.attendees.to_i)

# Check for conflict
checkDateForConflict(reservedRooms, roomList, newEvent.date, desiredRoomIndex)