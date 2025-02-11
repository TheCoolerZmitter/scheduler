require 'csv'

# Read from input file
roomList = CSV.parse(File.read("rooms_list.csv"), headers: true)

# Convert roomList capacity from strings to ints
def FirstPassthrough(rooms)
    for i in 0..rooms.length()-1 do
        rooms[i][2] = rooms[i][2].to_i
    end
end

FirstPassthrough(roomList)

# Sort roomList by capacity using quicksort
def Quicksort(rooms, first, last)
    if(first < last)
        index = Partition(rooms, first, last)
        Quicksort(rooms, first, index-1)
        Quicksort(rooms, index+1, last)
    end

    rooms
end

def Partition(rooms, first, last)
    pivotIndex = first
    pivotRow = rooms[last]
    pivotValue = rooms[last][2]
    
    for i in first..last-1 do
        if rooms[i][2] <= pivotValue
            temp = rooms[i]
            rooms[i] = rooms[pivotIndex]
            rooms[pivotIndex] = temp
            pivotIndex += 1
        end
    end

    temp = rooms[pivotIndex]
    rooms[pivotIndex] = pivotRow
    rooms[last] = temp

    return pivotIndex
end

Quicksort(roomList, 0, roomList.length()-1)