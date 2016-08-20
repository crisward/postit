board
  button.btn(onclick="{addnote}") Add Note
  note(each="{note,idx in notes}",no-reorder,style="top:{note.top}px;left:{note.left}px;z-index:{idx==active?5:1}",idx="{idx}",editing="{note.editing}",text="{note.text}",chosen="{parent.noteSelected}",changed="{parent.noteChange}")

  style(type="stylus").
    board
      border 1px solid #ccc
      background #ccc 
    .btn
      border 1px solid #ccc
      background rgba(255,255,255,0.8)
      border-radius 4px
      padding 5px 8px
      font-size 14px
    .btn:active,.btn:focus
      background rgba(255,255,255,1)
      outline 0px

  script(type="coffee").
    
    @notes = []

    @on 'mount',->
      @socket = new WebSocket('ws://127.0.0.1:3000')
      @socket.onopen = =>
        @getNotes()
      @socket.onmessage = (res)=>
        message = JSON.parse(res.data)
        switch message.type
          when "notes:all" then @updateAll(message.notes)
          else console.log message.type,"unhandled"
     
    @addnote = =>
      @notes.push(top:100,left:100,text:"New Note",editing:false)
      data = type:"notes:add",note:{top:100,left:100,text:"New Note"}
      @socket.send(JSON.stringify(data))
      @update()

    @noteSelected = (idx)=>
      console.log 'selected',idx
      @active = idx
      @update()

    @noteChange = (idx,note)=>
      note.id = @notes[idx].id
      @notes[idx] = note
      @socket.send(JSON.stringify(type:"notes:update",note:note)) if !note.editing
      @update()

    @getNotes = =>
      data = type:"notes:getAll"
      @socket.send(JSON.stringify(data))
 
    @updateAll = (@notes)=>
      console.log 'updateAll',@notes
      @update()
      