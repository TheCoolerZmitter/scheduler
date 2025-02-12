require_relative 'UserInput'
require_relative 'SortRoomList'
require_relative 'SortReservedRooms'
require_relative 'BinarySearch'

# Get room and reservation data from files
roomList = createRoomList()
reservedRooms = createReservedRooms()

# Get event constraints from user
newEvent = getUserInput()

# Find desired room
desiredRoomIndex = binarySearch(roomList, newEvent.attendees.to_i)