require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'
require_relative 'SchedulingPlan'

# Checks for rooms in the same building that can be used for meals
def mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings, plan)
    numMeals = newEvent.duration.to_i / 6
    capacityNeeded = newEvent.attendees.to_i * 6 / 10
    
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
    
    planBool = Struct.new(:pass, :newPlan)

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
            if roomList[currentRoom.index][6] == "Yes" && roomList[currentRoom.index][1].to_i > 0 && roomList[currentRoom.index][2].to_i > 0
                if checkDateForConflict(reservedRooms, roomList, mealTime.date, mealTime.time, "01:00", currentRoom.index)
                    mealRoom = createReservation(mealTime.date, mealTime.time, "01:00", roomList[currentRoom.index], "Meal room")
                    plan = addReservationToPlan(mealRoom, plan)

                    currentTotalCapacity += mealRoom.room[2]
                    numMealRooms += 1
                end
            end
            currentRoom = currentRoom.next
        end

        if currentTotalCapacity < capacityNeeded || numMealRooms < 2
            return planBool.new(false, nil);
        end
    end

    return planBool.new(true, plan)
end