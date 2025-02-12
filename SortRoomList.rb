require 'csv'

# Get room data from file and store in a table
def createRoomList()
    roomList = CSV.parse(File.read("rooms_list.csv"), headers: true)
    buildings = firstPassthrough(roomList)
    quicksort(roomList, 0, roomList.length()-1)
    rooms = Struct.new(:byCapacity, :byBuilding)
    organizedRooms = rooms.new(roomList, buildings)
    return organizedRooms
end

# Create a nested linked list of buildings and rooms
# and convert capacity from a string to an int
def firstPassthrough(rooms)
    buildingNode = Struct.new(:building, :contents, :next)
    roomNode = Struct.new(:index, :roomNum, :next)

    buildings = buildingNode.new(rooms[0][0], roomNode.new(0, rooms[0][1], nil), nil)
    rooms[0][2] = rooms[0][2].to_i

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

        rooms[i][2] = rooms[i][2].to_i
    end

    return buildings
end

# Sort roomList by capacity using quicksort
def quicksort(rooms, left, right)
    if(left < right)
        index = partition(rooms, left, right)
        quicksort(rooms, left, index-1)
        quicksort(rooms, index+1, right)
    end

    rooms
end

def partition(rooms, left, right)
    pivotIndex = left
    pivotRow = rooms[right]
    pivotValue = rooms[right][2]
    
    for i in left..right-1 do
        if rooms[i][2] <= pivotValue
            temp = rooms[i]
            rooms[i] = rooms[pivotIndex]
            rooms[pivotIndex] = temp
            pivotIndex += 1
        end
    end

    temp = rooms[pivotIndex]
    rooms[pivotIndex] = pivotRow
    rooms[right] = temp

    return pivotIndex
end