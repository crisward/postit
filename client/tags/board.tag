board
  button.btn(onclick="{addnote}") Add Note
  note(each="{note,idx in notes}",style="top:{note.top}px;left:{note.left}px;z-index:{idx==active?5:1}",idx="{idx}",editing="{note.editing}",text="{note.text}",chosen="{parent.noteSelected}",changed="{parent.noteChange}")

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
    
    @notes = [{top:100,left:100,text:"New Note",editing:false}]

    @addnote = =>
      @notes.push(top:100,left:100,text:"New Note",editing:false)
      @update()

    @noteSelected = (idx)=>
      console.log 'selected',idx
      @active = idx
      @update()

    @noteChange = (idx,note)=>
      @notes[idx] = note
      console.log note
      @update()