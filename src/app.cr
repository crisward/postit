require "./app/*"
require "kemal"
require "sqlite3"
require "db"

module App

  db = DB.open "sqlite3://./data.db"
  notes = Notes.new(db)
  noteRoom = Room.new
  
  get "/api" do
    "api here"
  end

  get "/" do
    render "src/views/index.ecr"
  end

  ws "/" do |socket|
    noteRoom.add(socket)
    socket.on_message do |json|
      message = JSON.parse(json)
      notes.handleMessage(message,noteRoom)
    end

    socket.on_close do
      noteRoom.remove socket # remove on leave
    end
  end
  
end

Kemal.run