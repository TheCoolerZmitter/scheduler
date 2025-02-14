require_relative 'MealCheck'
require_relative 'IndividualRoomsCheck'

# Tests for the HackTCNJ specific constraints
def checkOtherConstraints(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    # Checks individual/group room constraints
    individualPlanBool = individualRoomsCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    if individualPlanBool.pass
        # Checks meal room constraints
        plan = individualPlanBool.newPlan
        mealPlanBool = mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
        if mealPlanBool.pass
            return mealPlanBool
        end
    end

    # Returns if tests were passed and the updated schedule
    planBool = Struct.new(:pass, :newPlan)
    return planBool.new(false, nil)
end
