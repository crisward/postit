
class Notes
  
  def initialize(@db : DB::Database)
    begin # migration
      @db.exec "create table notes (id INTEGER PRIMARY KEY ASC,top integer,left integer,text string)"
    rescue
      puts "notes already created"
    end
  end

  def add(note : JSON::Any)
    @db.exec "INSERT into notes (id,top,left,text) values (null, ?, ?, ?)", note["top"].as_i, note["left"].as_i, note["text"].as_s
  end

  def all : Array(Note)
    rs = @db.query("SELECT id,top,left,text FROM notes")
    notes = Note.from_rs(rs)
    rs.close # this is important
    notes
  end

  def update(note : JSON::Any)
    @db.exec "UPDATE notes set top=?,left=?,text=? where id=?", note["top"].as_i, note["left"].as_i, note["text"].as_s,note["id"].as_i
  end

  def handleMessage(message :  JSON::Any, noteRoom : Room)
    case message["type"]
      when "notes:add" then self.add(message["note"])
      when "notes:update" then self.update(message["note"])
    end
    notejson = self.all.to_json
    noteRoom.send_all("{\"type\":\"notes:all\",\"notes\":#{notejson}}")
  end

end