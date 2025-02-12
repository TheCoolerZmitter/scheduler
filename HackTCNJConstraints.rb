require_relative 'MealCheck'
require_relative 'IndividualRoomsCheck'

# Tests for the HackTCNJ specific constraints
def checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings)
    mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings)
    individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings)
    return true
end
