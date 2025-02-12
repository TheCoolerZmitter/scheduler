require_relative 'CheckDateForConflict'
require_relative 'EndOfEvent'

# Checks for rooms in the same building that can be used for meals
def mealCheck(reservedRooms, roomList, newEvent, desiredRoomIndex, buildings)
    schedulingPlanNode = Struct.new(:date, :time, :room, :purpose)

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

    for i in 1..numMeals do
        currentTotalCapacity = 0
        numRooms = 0
        currentRoom = currentBuilding.contents
        if i == 1
            mealTime = endOfEvent(newEvent.date, newEvent.time, "0" + (6 * i - 1).to_s + ":00")
        else
            mealTime = endOfEvent(newEvent.date, newEvent.time, (6 * i - 1).to_s + ":00")
        end
        while (currentTotalCapacity < capacityNeeded || numRooms < 2) && currentRoom
            if roomList[currentRoom.index][6] == "Yes"
                if checkDateForConflict(reservedRooms, roomList, mealTime.date, mealTime.time, "01:00", currentRoom.index)
                    mealRoom = schedulingPlanNode.new(mealTime.date, mealTime.time, roomList[currentRoom.index], "Meal")
                    currentTotalCapacity += mealRoom.room[2]
                    numRooms += 1
                end
            end
            currentRoom = currentRoom.next
        end

        if currentTotalCapacity < capacityNeeded || numRooms < 2
            return false;
        end
    end

    return true;
end