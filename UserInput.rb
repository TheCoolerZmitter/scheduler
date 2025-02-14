# Get event constraints from user
def getUserConstraints()
    event = Struct.new(:date, :time, :duration, :attendees)
    newEvent = event.new()

    puts "Enter date of event (yyyy-mm-dd): "
    newEvent.date = gets
    puts "Enter start time of event (hh:mm AM/PM): "
    time = gets
    # Change 12 to 00 for math purposes later down the line
    if time[0,2] == "12"
        time = "00" + time[2, 6]
    end
    newEvent.time = time
    puts "Enter duration of event (hh:mm): "
    newEvent.duration = gets
    puts "Enter number of attendees: "
    newEvent.attendees = gets

    return newEvent
end

# Get filepath of room_list
def getRoomListFilePath()
    puts "Enter the name of room list file (ie. \"rooms_list.csv\"):"
    path = gets
    return path.chomp
end

# Get filepath of reserved_rooms
def getReservationListFilePath()
    puts "Enter the name of reserved rooms file (ie. \"reserved_rooms.csv\"):"
    path = gets
    return path.chomp
end