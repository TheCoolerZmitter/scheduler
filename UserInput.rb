# Get event constraints from user
def getUserConstraints()
    event = Struct.new(:date, :time, :duration, :attendees)
    newEvent = event.new()

    # Loops until input is valid
    validInput = false
    while !validInput
        restartLoop = false
        puts "Enter date of event (yyyy-mm-dd): "
        newEvent.date = gets

        # Fixes leading 0 issues
        if newEvent.date[6,1] == "-"
            newEvent.date = newEvent.date[0,5] + "0" + newEvent.date[5,4]
        end
        if newEvent.date[9,1] == "\n"
            newEvent.date = newEvent.date[0,8] + "0" + newEvent.date[8,1]
        end

        if newEvent.date[4,1] != "-" || newEvent.date[7,1] != "-"
            restartLoop = true
        end

        # Checks validity
        if !restartLoop && newEvent.date.to_i > 2020 && newEvent.date.to_i < 2030 && newEvent.date[5,5].to_i > 0 && newEvent.date[5,5].to_i < 13 && newEvent.date[8,2].to_i > 0 && newEvent.date[8,2].to_i < 32
            validInput = true
        else
            puts "Invalid date. Year must be between 2020 and 2030."
        end
    end

    validInput = false
    while !validInput
        puts "Enter start time of event (hh:mm AM/PM): "
        time = gets

        # Fixes leading 0 issues
        if time[1,1] == ":"
            time = "0" + time
        end

        # Checks validity
        if time.to_i > 0 && time.to_i < 13 && time[3,2].to_i >= 0 && time[3,2].to_i < 60 && (time.chomp.length == 8 || time.chomp.length == 7)
            validInput = true
            # Change 12 to 00 for later calculations
            if time[0,2] == "12"
                time = "00" + time[2, 6]
            end
            newEvent.time = time

            if newEvent.time[5,1] != " "
                newEvent.time = newEvent.time[0,5] + " " + newEvent.time[5,2]
            end
            if newEvent.time[6,2] == "am"
                newEvent.time = newEvent.time[0,6] + "AM"
            elsif newEvent.time[6,2] == "pm"
                newEvent.time = newEvent.time[0,6] + "PM"
            end

            if newEvent.time[6,2] != "AM" && newEvent.time[6,2] != "PM"
                validInput = false
                puts "Invalid time. Please enter time in AM/PM format."
            end
        else
            puts "Invalid time. Please enter time in AM/PM format."
        end
    end

    validInput = false
    while !validInput
        restartLoop = false
        puts "Enter duration of event (hh:mm): "
        newEvent.duration = gets

        # Fixes leading 0 issues
        if newEvent.duration[1,1] == ":"
            newEvent.duration = "0" + newEvent.duration
        end

        if newEvent.duration[2,1] != ":"
            restartLoop = true
        end

        # Checks validity
        if !restartLoop && newEvent.duration.to_i >= 4 && newEvent.duration.to_i < 100 && newEvent.duration[3,2].to_i >= 0 && newEvent.duration[3,2].to_i < 60
            validInput = true
        else
            puts "Invalid duration. Must have duration between 04:00 and 99:59."
        end
    end

    validInput = false
    while !validInput
        puts "Enter number of attendees: "
        newEvent.attendees = gets

        # Checks validity
        if newEvent.attendees.to_i > 0 && newEvent.attendees.to_i <= 1000
            validInput = true
        else
            puts "Invalid value. Number of attendees must be between 1 and 1000."
        end
    end

    return newEvent
end

# Get filepath of room_list
def getRoomListFilePath()
    fileExists = false
    while !fileExists
        puts "Enter the name of room list file (ie. \"rooms_list.csv\"):"
        path = gets

        # Error handling
        if File.exists?(path.chomp)
            fileExists = true
        else
            puts "File not found"
        end
    end
    return path.chomp
end

# Get filepath of reserved_rooms
def getReservationListFilePath()
    fileExists = false
    while !fileExists
        puts "Enter the name of reserved rooms file (ie. \"reserved_rooms.csv\"):"
        path = gets
        
        # Error handling
        if File.exists?(path.chomp)
            fileExists = true
        else
            puts "File not found"
        end
    end
    return path.chomp
end