note(onmousedown="{dragstart}",ontouchstart="{dragstart}",ondblclick="{startEdit}")
  div.wrap.pre(if="{!opts.editing}") {opts.text}
    .editbuttons
      a.btn(onclick="{startEdit}",ontouchstart="{startEdit}") Edit
      a.btn(onclick="{remove}",ontouchstart="{remove}") &times;
  div(if="{opts.editing}")
    textarea(name="text",value="{opts.text}")
    .editbuttons
      a.btn(onclick="{endEdit}",ontouchstart="{endEdit}") Save
    

  style(type="stylus").
    note
      display block
      color: #333;
      position: absolute;
      width: 200px;
      min-height 200px
      margin: 0 auto;
      padding: 10px;
      font-size: 21px;
      box-shadow: 0 10px 10px 2px rgba(0,0,0,0.3);
      background: #eae672;
            
    note .pre
      white-space pre
    
    note.animate
      transition all 0.5s ease

    .editbuttons
      position absolute
      bottom 10px
      right 10px

    note textarea
     width 100%
     background transparent
     border 0px
     padding 10px
     outline 1px dotted #444
     resize none
     min-height 140px
     font-size 21px

  script(type="coffee").

    @on 'mount',->
      @root.className += " animate"

    @dragstart = (e)=>
      console.log e
      @moved = false
      @root.className = @root.className.replace(/ ?animate/,'')
      opts.chosen(opts.idx) if opts.chosen
      @startNote = @root.getBoundingClientRect()
      @startMouse = {x:e.pageX,y:e.pageY}
      @updateOffset(@startMouse)
      return true if opts.editing
      document.addEventListener('mousemove',@dragging)
      document.addEventListener('mouseup',@dragend)
      document.addEventListener('touchmove',@dragging)
      document.addEventListener('touchend',@dragend)
      
    @dragging = (e)=>
      console.log 'dragging',e
      @moved = true
      @pos = {x:e.pageX,y:e.pageY}
      @updateOffset(@pos)
      @root.style.left = @offset.x+"px"
      @root.style.top = @offset.y+"px"

    @updateOffset = (pos)=>
      @offset = 
        x:pos.x - @startMouse.x + @startNote.left
        y:pos.y - @startMouse.y + @startNote.top

    @dragend = (e)=>
      @root.className += " animate"
      document.removeEventListener('mousemove',@dragging)
      document.removeEventListener('mouseup',@dragend)
      document.removeEventListener('touchmove',@dragging)
      document.removeEventListener('touchend',@dragend)
      if @moved
        opts.changed opts.idx,
          top:@offset.y
          left:@offset.x
          text:opts.text
          editing:opts.editing
    
    @startEdit = =>
      opts.changed opts.idx,
        top:@offset.y
        left:@offset.x
        text:opts.text
        editing:true
    
    @endEdit = =>
       opts.changed opts.idx,
        top:@offset.y
        left:@offset.x
        text:@text.value
        editing:false   

    @remove = =>
      opts.remove(opts.idx)