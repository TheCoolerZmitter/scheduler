require 'csv'

# Print output to console
def print(schedule)
    finalSchedule = Array.new(schedule.count + 1){Array.new(13)}
    
    # First row headers
    finalSchedule[0] = [
        "Date", "Time", "Duration", "Building", "Room", "Capacity", "Computer Available",
        "Seating Available", "Seating Type", "Food Allowed", "Room Type", "Priority", "Purpose"
    ]

    # Insert contents of final schedule list to 2D array
    currentReservation = schedule
    i = schedule.count
    while currentReservation
        finalSchedule[i][0] = currentReservation.reservation.date[0,10]
        if currentReservation.reservation.time[0,2] == "00"
            finalSchedule[i][1] = "12" + currentReservation.reservation.time[2,6]
        else
            finalSchedule[i][1] = currentReservation.reservation.time[0,8]
        end
        finalSchedule[i][2] = currentReservation.reservation.duration
        finalSchedule[i][3] = currentReservation.reservation.room[0]
        finalSchedule[i][4] = currentReservation.reservation.room[1]
        finalSchedule[i][5] = currentReservation.reservation.room[2]
        finalSchedule[i][6] = currentReservation.reservation.room[3]
        finalSchedule[i][7] = currentReservation.reservation.room[4]
        finalSchedule[i][8] = currentReservation.reservation.room[5]
        finalSchedule[i][9] = currentReservation.reservation.room[6]
        finalSchedule[i][10] = currentReservation.reservation.room[8]
        finalSchedule[i][11] = currentReservation.reservation.room[7]
        finalSchedule[i][12] = currentReservation.reservation.purpose

        currentReservation = currentReservation.next
        i -= 1
    end

    # Print array to console
    for i in 0..schedule.count do
        puts finalSchedule[i].join(", ")
    end

    # Ask user if they want an output file
    if fileAsk()
        printToFile(finalSchedule)
    end
end

# Ask user if they want to create a file
def fileAsk()
    puts "Print to file? Y/N:"
    print = gets
    if print[0,1] == "Y"
        return true
    end
    return false
end

# Ask user for filename and creates file with scheduling plan
def printToFile(finalSchedule)
    puts "Name of file (\"output.csv\"):"
    name = gets

    CSV.open(name, "w") do |csv|
        finalSchedule.each do |row|
            csv << row
        end
    end

    puts "File created successfully!"
end

# Print message if no schedules are possible given the constraints
def printFail()
    puts "No possible scheduling plan available."
end