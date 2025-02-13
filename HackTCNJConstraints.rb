require_relative 'MealCheck'
require_relative 'IndividualRoomsCheck'

# Tests for the HackTCNJ specific constraints
def checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    individualPlanBool = individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    if individualPlanBool.pass
        plan = individualPlanBool.newPlan
        mealPlanBool = mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
        if mealPlanBool.pass
            return mealPlanBool
        end
    end
    planBool = Struct.new(:pass, :newPlan)
    return planBool.new(false, nil)
end
