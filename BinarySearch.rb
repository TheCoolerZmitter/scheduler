# Search for smallest room that can hold desired number of attendees 
def binarySearch(rooms, attendees)
    index = rooms.length()/2
    left = 0
    right = rooms.length()-1

    while rooms[index][2] != attendees
        if right - left == 1
            return right
        end
        
        if rooms[index][2] < attendees
            left = index + 1
        else
            right = index - 1
        end
        index = (left + right) / 2
    end

    return index
end