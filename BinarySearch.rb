# Search for smallest room that can hold desired number of attendees 
def binarySearch(rooms, attendees)
    index = rooms.length()/2
    left = 0
    right = rooms.length()-1

    # Binary searches sorted table for room with desired capacity
    while rooms[index][2] != attendees
        if left == right
            return right
        end
        
        if rooms[index][2] < attendees
            left = index + 1
        else
            right = index
        end
        index = (left + right) / 2
    end

    # Picks room with lowest index if multiple rooms have the same capacity
    while rooms[index][2] == rooms[index - 1][2]
        index -= 1
    end

    # Returns index of room
    return index
end