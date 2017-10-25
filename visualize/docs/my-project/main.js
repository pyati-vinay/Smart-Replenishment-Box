//
//  main.js
//
//  A project for visualizing blockchain
//
//
//
//var web3 = require('web3');
var listOfObjects = [];
(function($){

  var Renderer = function(canvas){
    var canvas = $(canvas).get(0)
    var ctx = canvas.getContext("2d");
    //var gfx = arbor.Graphics(canvas)
    var particleSystem

    var that = {
      init:function(system){

        particleSystem = system

        particleSystem.screenSize(canvas.width, canvas.height)
        particleSystem.screenPadding(90) // leave an extra 80px of whitespace per side


        that.initMouseHandling()
      },

      redraw:function(){
        //gfx.clear() // convenience ƒ: clears the whole canvas rect
        ctx.fillStyle = "white"
        ctx.fillRect(0,0, canvas.width, canvas.height)

        particleSystem.eachEdge(function(edge, pt1, pt2){

          // draw a line from pt1 to pt2
          ctx.strokeStyle = "rgba(0,0,0, .333)"
          ctx.lineWidth = 3
          ctx.beginPath()
          ctx.moveTo(pt1.x, pt1.y)
          ctx.lineTo(pt2.x, pt2.y)
          ctx.stroke()
        })

        particleSystem.eachNode(function(node, pt){

          var label = node.data.label||""
          var w = ctx.measureText(""+label).width + 10
          if (!(""+label).match(/^[ \t]*$/)){
            pt.x = Math.floor(pt.x)
            pt.y = Math.floor(pt.y)
          }else{
            label = null
          }


          // draw a rectangle centered at pt
          var w = 30
          ctx.fillStyle = (node.data.alone) ? "green" : "orange"
          ctx.fillRect(pt.x-w/2, pt.y-w/2, w,w)
          // draw the text
          if (label){
            ctx.font = "12px Helvetica"
            ctx.textAlign = "center"
            ctx.fillStyle = "white"
            if (node.data.color=='none') ctx.fillStyle = '#333333'
            ctx.fillText(label||"", pt.x, pt.y+4)
            ctx.fillText(label||"", pt.x, pt.y+4)
          }
        })
      },

      initMouseHandling:function(){

        var dragged = null;

        var handler = {
          clicked:function(e){

            var pos = $(canvas).offset();
            _mouseP = arbor.Point(e.pageX-pos.left, e.pageY-pos.top)
            dragged = particleSystem.nearest(_mouseP);

            if (dragged && dragged.node !== null){
              // while we're dragging, don't let physics move the node
              dragged.node.fixed = true
            }
            var obj = {};
            listOfObjects.forEach( function(s) {
              if(s.blocknum==dragged.node.name)
              {
                obj = s;
              }

            } );
            swal({
              title: 'Block Number :'+obj.blocknum,
              text:     '\n'
              + '\t• Transaction Name : '+obj.find+'\n\n'
              + '\t• Gas Price        : '+obj.gasP+'\n\n'
              + '\t• Gas Used         : '+obj.gasU+'\n\n'
              + '\t• From             : '+obj.from+'\n\n'
              + '\t• To               : '+obj.to+'\n\n',
            })
            $(canvas).bind('mousemove', handler.dragged)
            $(window).bind('mouseup', handler.dropped)

            return false
          },
          dragged:function(e){
            var pos = $(canvas).offset();
            var s = arbor.Point(e.pageX-pos.left, e.pageY-pos.top)

            if (dragged && dragged.node !== null){
              var p = particleSystem.fromScreen(s)
              dragged.node.p = p
            }

            return false
          },

          dropped:function(e){
            if (dragged===null || dragged.node===undefined) return
            if (dragged.node !== null) dragged.node.fixed = false
            dragged.node.tempMass = 1000
            dragged = null
            $(canvas).unbind('mousemove', handler.dragged)
            $(window).unbind('mouseup', handler.dropped)
            _mouseP = null
            return false
          }
        }

        $(canvas).mousedown(handler.clicked);

      },

    }
    return that
  }

  $(window).load(function(){
    var sys = arbor.ParticleSystem(1000, 600, 0.5)
    sys.parameters({gravity:true})
    sys.renderer = Renderer("#viewport")

    App.getTransactionsByAccountVisualize("*",listOfObjects)
    //console.log(listOfObjects)

    listOfObjects.forEach( function(s) {
      if(s.find!="Internal Blockchain Transaction")
      {
        sys.addNode(s.blocknum, {alone:true, mass:.28,label:s.blocknum.toString()})
      }
      else
      {
        sys.addNode(s.blocknum, {alone:false, mass:.28,label:s.blocknum.toString()})
      }
      if(s.blocknum!=listOfObjects.length)
      sys.addEdge(s.blocknum,s.blocknum+1)

    } );


  })

})(this.jQuery)
