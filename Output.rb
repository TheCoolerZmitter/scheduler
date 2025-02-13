require 'csv'

# prints output to console
def print(schedule)

    finalSchedule = Array.new(schedule.count + 1){Array.new(13)}

    currentReservation = schedule
    
    finalSchedule[0][0] = "Date"
    finalSchedule[0][1] = "Time"
    finalSchedule[0][2] = "Duration"
    finalSchedule[0][3] = "Building"
    finalSchedule[0][4] = "Room"
    finalSchedule[0][5] = "Capacity"
    finalSchedule[0][6] = "Computer Available"
    finalSchedule[0][7] = "Seating Available"
    finalSchedule[0][8] = "Seating Type"
    finalSchedule[0][9] = "Food Allowed"
    finalSchedule[0][10] = "Priority"
    finalSchedule[0][11] = "Room Type"
    finalSchedule[0][12] = "Purpose"

    for i in 1..schedule.count do
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
        finalSchedule[i][10] = currentReservation.reservation.room[7]
        finalSchedule[i][11] = currentReservation.reservation.room[8]
        finalSchedule[i][12] = currentReservation.reservation.purpose
        currentReservation = currentReservation.next

        puts finalSchedule[i]
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