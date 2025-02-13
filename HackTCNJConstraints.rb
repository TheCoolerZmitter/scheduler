require_relative 'MealCheck'
require_relative 'IndividualRoomsCheck'

# Tests for the HackTCNJ specific constraints
def checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    if individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
        if mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
            return true
        end
    end
    return false
end
