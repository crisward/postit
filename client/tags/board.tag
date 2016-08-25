board
  .alert(if="{!connected}")
    p You've been disconnected
  button.btn(onclick="{addnote}") Add Note
  note(each="{note,idx in notes}",no-reorder,style="top:{note.top}px;left:{note.left}px;z-index:{idx==active?5:1}",idx="{idx}",editing="{note.editing}",text="{note.text}",chosen="{parent.noteSelected}",changed="{parent.noteChange}",remove="{parent.noteRemove}")

  style(type="stylus").
    board
      border 1px solid #ccc
      background #ccc 
    .btn
      border 1px solid #ccc
      background rgba(255,255,255,0.8)
      border-radius 4px
      padding 5px 10px
      font-size 14px
      line-height 18px
      margin 0 0 0 5px
      display inline-block
    .btn:active,.btn:focus
      background rgba(255,255,255,1)
      outline 0px
    .alert
      border 1px solid #d00
      background #d88
      color white
      margin 0 0 5px 0
      p 
        margin 10px

  script(type="coffee").
    
    @notes = []

    @on 'mount',->
      @connect()

    @connect = =>
      if !@connected
        @socket = new WebSocket('ws://'+window.location.host)
        @socket.onopen = =>
          @connected = true
          @reconnecting = false
          @getNotes()
        @socket.onmessage = (res)=>
          message = JSON.parse(res.data)
          switch message.type
            when "notes:all" then @updateAll(message.notes)
            else console.log message.type,"unhandled"
        @socket.onclose = =>
          @connected = false
          console.log 'disconnected'
          @update()
          @reconnect() if !@reconnecting

    @reconnect = (timeout=1000)=>
      maxwait = 5000
      @reconnecting = true
      console.log 'reconnect',timeout
      if !@connected
        @connect() 
        setTimeout =>
          timeout *= 1.5
          timeout = maxwait if timeout > maxwait
          @reconnect timeout if !@connected
        ,timeout
     
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

    @noteRemove = (idx)=>
      console.log 'removing',idx,@notes[idx]
      @socket.send(JSON.stringify(type:"notes:remove",note:@notes[idx])) if !@notes[idx].editing
      @update()

    @getNotes = =>
      data = type:"notes:getAll"
      @socket.send(JSON.stringify(data))
      
 
    @updateAll = (@notes)=>
      console.log 'updateAll',@notes
      @update()
      