require_relative 'MealCheck'
require_relative 'IndividualRoomsCheck'

# Tests for the HackTCNJ specific constraints
def checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    return true
end
