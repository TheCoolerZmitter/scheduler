require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'

# Checks for rooms in the same building that can be used for meals
def mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    # Stores if tests were passed and the updated schedule
    planBool = Struct.new(:pass, :newPlan)

    # Number of meals is duration hours divided by 6
    numMeals = newEvent.duration.to_i / 6

    # If there are no meals required, return test passes and the original scheduling plan
    if numMeals == 0 
        return planBool.new(true, plan)
    end

    # Meal rooms need to hold 60% of attendees
    capacityNeeded = newEvent.attendees.to_i * 6 / 10
    
    # Find linked list of rooms in the desired building
    building = roomList[desiredRoomIndex][0]
    keepSearching = true
    currentBuilding = buildings
    while keepSearching
        if building == currentBuilding.building
            keepSearching = false
        else
            currentBuilding = currentBuilding.next
        end
    end

    # Check availability of rooms in the buildings during all meal times
    for i in 1..numMeals do
        currentTotalCapacity = 0
        numMealRooms = 0
        currentRoom = currentBuilding.contents
        if i == 1
            mealTime = endOfEvent(newEvent.date, newEvent.time, "0" + (6 * i - 1).to_s + ":00")
        else
            mealTime = endOfEvent(newEvent.date, newEvent.time, (6 * i - 1).to_s + ":00")
        end
        while (currentTotalCapacity < capacityNeeded || numMealRooms < 2) && currentRoom
            if roomList[currentRoom.index][6] == "Yes"
                if checkDateForConflict(reservedRooms, roomList, mealTime.date, mealTime.time, "01:00", currentRoom.index)
                    mealRoom = createReservation(mealTime.date, mealTime.time, "01:00", roomList[currentRoom.index], "Meal room")
                    plan = addReservationToPlan(mealRoom, plan)

                    currentTotalCapacity += mealRoom.room[2]
                    numMealRooms += 1
                end
            end
            currentRoom = currentRoom.next
        end

        # If requirements were not met, return false
        if currentTotalCapacity < capacityNeeded || numMealRooms < 2
            return planBool.new(false, nil);
        end
    end

    return planBool.new(true, plan)
end