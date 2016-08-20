require "json"
require "db"

class Note

  DB.mapping({
    id: Int64,
    text:  {type: String, default: ""},
    top:  {type: Int64},
    left: {type: Int64},
  })
  JSON.mapping({
    id: Int64,
    text:  {type: String, default: ""},
    top:  {type: Int64},
    left: {type: Int64},
  })
end