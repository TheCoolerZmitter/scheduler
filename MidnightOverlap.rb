require_relative 'EndOfEvent'

# Check if opening or closing sessions overlap midnight
def midnightOverlap(newEvent, closingSession) 
    
    # Check opening
    openingSessionMidnight = false
    openingDayOne = nil
    openingDayTwo = nil
    openingDate = nil
    if newEvent.time[6,2] == "PM" && newEvent.time[0,2] == "11" && newEvent.time[3,2].to_i > 0
        openingSessionMidnight = true
        openingDayOne = 60 - newEvent.time[3,2].to_i
        openingDayTwo = newEvent.time[3,2].to_i
        if openingDayOne < 10
            openingDayOne = "00:0" + openingDayOne.to_s
        else
            openingDayOne = "00:" + openingDayOne.to_s
        end

        if openingDayTwo < 10
            openingDayTwo = "00:0" + openingDayTwo.to_s
        else
            openingDayTwo = "00:" + openingDayTwo.to_s
        end
        openingDate = endOfEvent(newEvent.date, newEvent.time, "01:00").date
    end

    # Check closing session
    closingSessionMidnight = false
    closingDayOne = nil
    closingDayTwo = nil
    closingDate = nil
    if newEvent.time[6,2] == "PM" && (closingSession.time[0,2].to_i > 9 || (closingSession.time[0,2].to_i == 9 && closingSession.time[3,2].to_i > 0))
        closingSessionMidnight = true
        closingDayOneMinutes = 60 - closingSession.time[3,2].to_i
        closingDayTwoMinutes = closingSession.time[3,2].to_i
        closingDayOneHours = 12 - closingSession.time[0,2].to_i
        if closingDayOneMinutes != 0
            closingDayOneHours -= 1
        end
        closingDayTwoHours = closingSession.time[0,2].to_i - 9

        if closingDayOneHours < 10
            closingDayOneHours = "0" + closingDayOneHours.to_s
        else
            closingDayOneHours = closingDayOneHours.to_s
        end

        if closingDayTwoHours < 10
            closingDayTwoHours = "0" + closingDayTwoHours.to_s
        else
            closingDayTwoHours = closingDayTwoHours.to_s
        end

        if closingDayOneMinutes < 10
            closingDayOneMinutes = "0" + closingDayOneMinutes.to_s
        else
            closingDayOneMinutes = closingDayOneMinutes.to_s
        end

        if closingDayTwoMinutes < 10
            closingDayTwoMinutes = "0" + closingDayTwoMinutes.to_s
        else
            closingDayTwoMinutes = closingDayTwoMinutes.to_s
        end

        closingDayOne = closingDayOneHours + ":" + closingDayOneMinutes
        closingDayTwo = closingDayTwoHours + ":" + closingDayTwoMinutes
        closingDate = endOfEvent(closingSession.date, closingSession.time, "03:00").date
    end

    overlap = Struct.new(:openingSessionMidnight, :closingSessionMidnight, :openingDate, :openingDayOne, :openingDayTwo, :closingDate, :closingDayOne, :closingDayTwo)
    return overlap.new(openingSessionMidnight, closingSessionMidnight, openingDate, openingDayOne, openingDayTwo, closingDate, closingDayOne, closingDayTwo)
end