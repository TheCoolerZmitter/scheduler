require 'csv'

# Get room data from file and store in a table
def createRoomList()
    roomList = CSV.parse(File.read("rooms_list.csv"), headers: true)
    firstPassthrough(roomList)
    quicksort(roomList, 0, roomList.length()-1)
    return roomList
end

# Convert roomList capacity from strings to ints
def firstPassthrough(rooms)
    for i in 0..rooms.length()-1 do
        rooms[i][2] = rooms[i][2].to_i
    end
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