# Create a nested linked list of buildings and rooms
def organizeByBuilding(rooms)
    buildingNode = Struct.new(:building, :contents, :next)
    roomNode = Struct.new(:index, :roomNum, :next)

    # Create nested linked of buildingNode * roomNode
    buildings = buildingNode.new(rooms[0][0], roomNode.new(0, rooms[0][1], nil), nil)

    # Add all rooms to nested linked list
    for i in 1..rooms.length()-1 do
        currentBuilding = buildings
        keepSearching = true
        # Find correct linked list for the room
        while keepSearching
            if currentBuilding.building == rooms[i][0]
                currentBuilding.contents = roomNode.new(i, rooms[i][1], currentBuilding.contents)
                keepSearching = false
            # If building is not in the list, add new node to outer linked list
            else
                currentBuilding = currentBuilding.next
                if !currentBuilding
                    buildings = buildingNode.new(rooms[i][0], roomNode.new(0, rooms[i][1], nil), buildings)
                    keepSearching = false
                end
            end
        end
    end

    return buildings
end