note(onmousedown="{dragstart}",ondblclick="{startEdit}")
  div.wrap.pre(if="{!opts.editing}") {opts.text}
    button.btn.editbutton(onclick="{startEdit}") Edit
  div(if="{opts.editing}")
    textarea(name="text",value="{opts.text}")
    button.btn.editbutton(onclick="{endEdit}") Save

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
    
    note .wrap
      padding 10px 10px 40px 10px
    
    note .pre
      white-space pre
    
    .editbutton
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

    @dragstart = (e)=>
      @moved = false
      opts.chosen(opts.idx) if opts.chosen
      @startNote = @root.getBoundingClientRect()
      @startMouse = {x:e.clientX,y:e.clientY}
      @updateOffset(@startMouse)
      return true if opts.editing
      document.addEventListener('mousemove',@dragging)
      document.addEventListener('mouseup',@dragend)
      
    @dragging = (e)=>
      @moved = true
      @pos = {x:e.clientX,y:e.clientY}
      @updateOffset(@pos)
      @root.style.left = @offset.x+"px"
      @root.style.top = @offset.y+"px"

    @updateOffset =(pos)=>
      @offset = 
        x:pos.x - @startMouse.x + @startNote.left
        y:pos.y - @startMouse.y + @startNote.top

    @dragend = (e)=>
      document.removeEventListener('mousemove',@dragging)
      document.removeEventListener('mouseup',@dragend)
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