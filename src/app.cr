require "./app/*"
require "kemal"
require "sqlite3"
require "db"

SOCKETS = [] of HTTP::WebSocket

# migration
db = DB.open "sqlite3://./data.db"

begin
  db.exec "create table notes (id INTEGER PRIMARY KEY ASC,top integer,left integer,text string)"
rescue
  puts "notes already created"
end  

def notesAll(socket,db) 
  db.query("SELECT id,top,left,text FROM notes") do |rs|
    notejson = Note.from_rs(rs).to_json
    p "sending notes to ",SOCKETS.size
    SOCKETS.each do |socket| 
      socket.send "{\"type\":\"notes:all\",\"notes\":#{notejson}}"
    end
  end
end

def noteAdd(socket,db,note)
  p "adding",note["top"],note["left"],note["text"]
  db.exec "INSERT into notes (id,top,left,text) values (null, ?, ?, ?)", note["top"].as_i, note["left"].as_i, note["text"].as_s
  notesAll(socket,db)
end

def noteUpdate(socket,db,note)
  p "updating",note["top"],note["left"],note["text"]
  db.exec "UPDATE notes set top=?,left=?,text=? where id=?", note["top"].as_i, note["left"].as_i, note["text"].as_s,note["id"].as_i
  notesAll(socket,db)
end

module App
  
  get "/api" do
    "api here"
  end

  get "/" do
    render "src/views/index.ecr"
  end

  ws "/" do |socket|
    
    SOCKETS << socket # add on join
    p "connected",SOCKETS.size
    notesAll(socket,db)
    socket.on_message do |json|
      message = JSON.parse(json)
      notesAll(socket,db) if message["type"] == "notes:getAll"
      noteAdd(socket,db,message["note"]) if message["type"] == "notes:add"
      noteUpdate(socket,db,message["note"]) if message["type"] == "notes:update" 
    end

    socket.on_close do
      SOCKETS.delete socket # remove on leave
    end
  end
  
end

Kemal.run