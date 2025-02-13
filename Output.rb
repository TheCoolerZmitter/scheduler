require 'csv'

# prints output to console
def print(schedule)
    finalSchedule = Array.new(schedule.count + 1){Array.new(13)}
    
    finalSchedule[0] = [
        "Date", "Time", "Duration", "Building", "Room", "Capacity", "Computer Available",
        "Seating Available", "Seating Type", "Food Allowed", "Room Type", "Priority", "Purpose"
    ]

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

    for i in 0..schedule.count do
        puts finalSchedule[i].join(", ")
    end

    if fileAsk()
        printToFile(finalSchedule)
    end
end

def fileAsk()
    puts "Print to file? Y/N:"
    print = gets
    if print[0,1] == "Y"
        return true
    end
    return false
end

def printToFile(finalSchedule)
    puts "Name file:"
    name = gets

    CSV.open(name + ".csv", "w") do |csv|
        finalSchedule.each do |row|
            csv << row
        end
    end

    puts "File created successfully!"
end

def printFail()
    puts "No possible scheduling plan available."
end