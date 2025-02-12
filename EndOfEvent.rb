# Find end date and time for event
def endOfEvent(date, time, duration)
    range = Struct.new(:date, :time, :numDays)

    startHour = time[0,2].to_i
    if time[6,2] == "PM"
        startHour += 12
    end
    durationHours = duration[0,2].to_i

    lastHour = startHour + durationHours
    numDays = lastHour/24
    if lastHour % 12 < 10
        leadingZero = "0"
    else
        leadingZero = ""
    end
    if lastHour % 24 < 12
        timeString = leadingZero + (lastHour % 24).to_s + ":00 AM"
    else
        timeString = leadingZero + (lastHour % 24 - 12).to_s + ":00 PM"
    end

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
            return range.new(year.to_s + "-" + leadingZeroMonth + month.to_s + "-" + leadingZeroDay + day.to_s, timeString, numDays + 1)
        end
    end
end