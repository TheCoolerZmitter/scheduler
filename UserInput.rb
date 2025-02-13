# Gets event constraints from user
def getUserInput()
    event = Struct.new(:date, :time, :duration, :attendees)
    newEvent = event.new()

    puts "Enter date of event (yyyy-mm-dd): "
    newEvent.date = gets
    puts "Enter start time of event (hh:mm AM/PM): "
    time = gets
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