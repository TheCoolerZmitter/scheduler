# Find end date and time for event
def endOfEvent(date, time, duration)
    range = Struct.new(:date, :time, :numDays)

    # Turn string data into usable values
    startHour = time[0,2].to_i
    startMinutes = time[3,2].to_i
    if time[6,2] == "PM"
        startHour += 12
    end
    durationHours = duration[0,2].to_i
    durationMinutes = duration[3,2].to_i

    lastHour = startHour + durationHours
    lastMinute = startMinutes + durationMinutes
    lastHour += lastMinute / 60
    lastMinute = lastMinute % 60
    numDays = lastHour/24

    # Convert end time back to a string in proper format
    if lastHour % 12 < 10
        leadingZeroHour = "0"
    else
        leadingZeroHour = ""
    end
    if lastMinute < 10
        leadingZeroMinute = "0"
    else
        leadingZeroMinute = ""
    end
    if lastHour % 24 < 12
        timeString = leadingZeroHour + (lastHour % 24).to_s + ":" + leadingZeroMinute + lastMinute.to_s + " AM"
    else
        timeString = leadingZeroHour + (lastHour % 24 - 12).to_s + ":" + leadingZeroMinute + lastMinute.to_s + " AM"
    end

    # Checks if end time is on a different date
    if numDays == 0
        return range.new(date, timeString, 1)
    else
        return findNewDay(date, timeString, numDays)
    end
end

# Calculates new date and time
def findNewDay(date, timeString, numDays)
    range = Struct.new(:date, :time, :numDays)

    year = date[0,4].to_i
    month = date[5,2].to_i
    day = date[8,2].to_i

    # Increases days, months, and years based on number of days in the month and if it is a leap year
    day += numDays
    while true
        if day > 31 && (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month || 12)
            day -= 31
            month += 1
            if month == 13
                month = 1
                year += 1
            end
        elsif day > 30 && (month == 4 || month == 6 || month == 9 || month == 11)
            day -= 30
            month += 1
        elsif day > 29 && month == 2 && year % 4 == 0
            day -= 29
            month += 1
        elsif day > 28 && month == 2
            day -= 28
            month += 1
        else
            if day < 10
                leadingZeroDay = "0"
            else
                leadingZeroDay = ""
            end
            if month < 10
                leadingZeroMonth = "0"
            else
                leadingZeroMonth = ""
            end

            # Returns end date, time, and number of days after date has been correctly calculated
            return range.new(year.to_s + "-" + leadingZeroMonth + month.to_s + "-" + leadingZeroDay + day.to_s, timeString, numDays + 1)
        end
    end
end