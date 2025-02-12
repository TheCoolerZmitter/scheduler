# Create a nested linked list of buildings and rooms
def organizeByBuilding(rooms)
    buildingNode = Struct.new(:building, :contents, :next)
    roomNode = Struct.new(:index, :roomNum, :next)

    buildings = buildingNode.new(rooms[0][0], roomNode.new(0, rooms[0][1], nil), nil)

    for i in 1..rooms.length()-1 do
        currentBuilding = buildings
        keepSearching = 1
        while keepSearching == 1
            if currentBuilding.building == rooms[i][0]
                currentBuilding.contents = roomNode.new(i, rooms[i][1], currentBuilding.contents)
                keepSearching = 0
            else
                currentBuilding = currentBuilding.next
                if !currentBuilding
                    buildings = buildingNode.new(rooms[i][0], roomNode.new(0, rooms[i][1], nil), buildings)
                    keepSearching = 0
                end
            end
        end
    end

    return buildings
end