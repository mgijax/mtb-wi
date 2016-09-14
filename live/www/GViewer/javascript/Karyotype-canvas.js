Ext.ns('org.jax.mgi.kmap');


/**
 * @class org.jax.mgi.kmap.Feature
 * @extends Ext.BoxComponent
 * Base class for a Feature <br/>
 * 
 * @author Steven Neuhauser
 * @version 1.0
 */


org.jax.mgi.kmap.Feature = Ext.extend(Ext.BoxComponent, {
  /**
   * @cfg {String} label The label for the feature.
   */
  label:'',
  /**
   * @cfg {String} link  The url associated with the feature.
   */
  link:'',
  /**
   * @cfg {String} chromosome The chromosome this feature is on
   * <br>Required
   */
  chromosome:'',
  /**
   * @cfg {Number} start The start position in base pairs.
   * <br>Required
   */
  start:'',
  /**
   * @cfg {Number} end The end position in base pairs.
   * <br>Required
   */
  end:'',
  /**
   * @cfg {String} color The feature's color.
   */
  color:'',
  /**
   * @cfg {String} name The feature's name
   */
  name:'',
  /**
   * @cfg {String} mgiId The MGI ID for the feature
   */
  mgiId:'',
  /**
   * @cfg {Number} width The horizontal width in px for the feature
   * <br>Default is 5 px
   */
  width:5,   
  /**
   * @cfg {Number} minSize The minimum size (height) in px for the feature\
   * <br>Default is 1 px
   */ 
  minSize:1, 
  /**
   * @cfg {Boolean} curvedTop True to draw a curved top on the feature
   * Default false. Used to make rounded ends on chromosomes
   */
  curvedTop:false, 
  /**
   * @cfg {Boolean} curvedBottom True to draw a curved bottom on the feature
   * Default false. Used to make rounded ends on the chromosomes
   */
  curvedBottom:false, 
  
  parent:null,
  zoomX:-1,
  canvasX:'',  // caclulated when drawn, x pos on canvas
  canvasY:'',  // cacluated when drawn, y pos on cavnas
  canvasWidth:'', // calculated when drawn, width in px on cavnas 
  canvasHeight:'', // calculated when drawn, height in px on canvas
  track:'R1', // left or right (L,R) and index > 0 ie 'R1'
  isZoomRegion:false, // special feature to show region being zoomed
  
  initComponent: function(){
    org.jax.mgi.kmap.Feature.superclass.initComponent.apply(this,arguments);
  }                      
});

/**
 * @class org.jax.mgi.kmap.FeatureCanvas
 * @extends Ext.BoxComponent
 *  Displays features. If no HTML5 canvas is available draws features using divs. <br/>
 *  Maps mouse X and Y coordinates to the underlying features.
 * @author Steven Neuhauser
 * @version 1.0
 */
org.jax.mgi.kmap.FeatureCanvas =  Ext.extend(Ext.BoxComponent,{
 
  /**
   * @cfg {Number} featureHGap The horizontal gap in px between overlapping features if expand is true
   * <br>Default 2 px
   */
  featureHGap:2,

  /**
   * @cfg {Number} featureVGap The minimum vertical gap in px between adjacent features
   * <br>Default 0 px
   */
  featureVGap:0,
  
  /**
   * @cfg {Number} scale The ratio of px to base pairs for drawing features
   */
  scale:1,
  
  /**
   * @cfg {Number} topMargin The number of pixels to to leave at the top of the canvas before drawing features
   * <br>Default 15 px
   */
  topMargin:15,
 
  /**
   * @cfg {Number} featureWidth 
   * When > 0 all features will be drawn this width irrespective of the underlying feature's width.
   * This allows for memory savings when mapping X,Y mouse positions to canvas features.
   * Set to 0 to display variable width features.
   * <br>Default 10 px
   */
  featureWidth:10,
 
  /**
   * @cfg {Number} initialWidth the initial and default width for this component
   * <br>Default 10
   */
  initialWidth:10,
 
  /** 
   * @cfg {Boolean} expand 
   * If expand is true overlapping features will be moved tangentially to
   * the chromosome so they can be displayed w/o overalp. Otherwise
   * they will be stacked on top of each other in the order they are drawn.
   * <br>Default true
   */
  expand:false,
  
  /**
   * @cfg {Number} curvePx The number of extra pixels to add for curved tops or bottoms
   * <br>Default 5 px
   */
  curvePx:5,
  
  /**
   * @cfg {Boolean} isBanding True to indicate the cavas displays cytobands.
   *  Allows for chromsome specific mouseover text formatting
   * <br>Default false
   */
  isBanding:false, // true if canvas contains banding features (used to format mouseover text and handle click events)
  
  /**
   * @cfg {String} justify By default features are right justified.
   * Use 'LEFT' to left justify features ie on tracks to the left of a chromosome 
   * <br>Default ''
   */
  justify:'',
   
  /**
   * @cfg {String} chromosome The name of the chromosome ie '1' or 'X'
   */
  chromosome:'', 
 
  /**
   * @cfg {Number} length The length of the chromosome in basepairs
   */
  length:0,
  
  /**
   * @cfg {Number} chromosomeEnd The end in basepairs if showing a sub section of the chromosome
   * end of chromosome, will be less than length if zoomed
   * <br>Default 0
   */   
  chromosomeEnd:0,
  
  /**
   * @cfg {Number} start The start position in base paris if showing a subsection of the chromosome
   * <br>Default 0
   */
  start:0,
  
  /**
   * @cfg {Boolean} allowZoom true to create zoom region 
   * <br>Default false
   */
  allowZoom:false, // zoomPanel will show tip on feature click 
   
  // following are private
   
  zoomFeature:null, // if displaying a zoom feature, the feature
  zoomDrag:false, // if the zoom indicator is being dragged
  createZoomDrag:false, // if the zoom indicator is being resized
  zoomMouseDownBP:0, // where the mouse down event happened
  zoomOffset:0, // how far from the start of the zoom indicator was the mousedown
  canvas:'',        // reference to the canvas div, set internally
  features:[],    // an array of features populated by addFeatures
  featureMap:[],  //maps mouse x,y to underlying feature 2D array
  highlight:true,  // if false highlighting of features will stop
  
                   
  initComponent: function(){
    org.jax.mgi.kmap.FeatureCanvas.superclass.initComponent.apply(this,arguments);                 
    this.addListener("afterRender", function(p){
      Ext.DomHelper.append(this.el,
      {tag:'canvas',
        html:'<div id ="'+this.id+':canvas" style="position:relative"></div>',
        id:this.id+':canvas',
        width:4000,
        height:this.getHeight()});
      Ext.get(this.id).on({'click':this.onClick,scope:this});
      Ext.get(this.id).on({'mousemove':this.onMM,scope:this});
      Ext.get(this.id).on({'contextmenu':this.onCM,scope:this});
      Ext.get(this.id).on({'mousedown':this.onMD,scope:this});
      Ext.get(this.id).on({'mouseup':this.onMU,scope:this});
      
      this.addEvents('featureClick','featureMouseOver', 'featureMouseOut', 'featureRightClick');    
      this.canvas =  document.getElementById(this.id+":canvas");
    }
  );
  },
  
 
  
  /**
   * Clears all the features displayed on the canvas
   * @method 
   * @param {Boolean} removeFeatures True to remove underlying feature objects
   * <br>Rather than calling clear(true) use removeFeatures()
   * @return void
   */
  clear: function(removeFeatures){
    var canvas = this.canvas; 
    if(canvas && canvas.getContext ){
      var ctx = canvas.getContext("2d");
      ctx.clearRect(0,0,canvas.width, canvas.height);
      
    }else{
      var i;
      for(i = 0; i < this.features.length; i++){
        var div = Ext.get(this.id+':'+this.features[i].id);
        if(div){
          div.remove(true);
          
        }
      }  
    }
    if(removeFeatures){
      this.features = [];
    }
    this.featureMap = [];
    this.setWidth(this.initialWidth);
  },
  
  /**
   * Clears and removes all features then resizes the canvas to its initial width
   * @method 
   * @return void
   */
  removeFeatures: function(){
    this.highlight = false;
    if(this.features != null){
      this.clear(true);
      this.setWidth(this.initialWidth);
    }
    this.highlightOn.defer(2300,this);
  },
  
  /**
   * Removes one or more features by id
   * @method 
   * @param {String/Array} id A single ID or an array of feature IDs to remove
   * @return void
   */
  removeFeaturesById:function(id){
    var i;
    this.highlight = false;
    this.clear(false);
    if(Ext.isArray(id)){
      for(i = 0; i < id.length; i++){
        var f = this.getFeatureById(id[i]);
        if(f){
          this.features.remove(f);
        }
      } 
    }else{
      f = this.getFeatureById(id);
      if(f){
        this.features.remove(f);
      }
    }
    this.highlightOn.defer(2300,this);
  },
  
  /**
   * Returns a feature with the given id 
   * @method 
   * @param {String} oid A feature ID 
   * @return Feature null if there is no matching feature in the canvas
   */
  getFeatureById:function(oid){
    var i;
    for(i = 0; i < this.features.length; i++){
      var fid = this.features[i].id;
      if(fid == oid){
        return this.features[i];
      }
    }
    return null;
  },
  
  // highlighting is turned off when removing features
  // so they don't get redrawn by a defered call
  // this is called to restore highlighting
  
  highlightOn:function(){
    this.highlight = true;
  },
  
  
  /**
   * Highlights a feature: feature flashes black, white, original color 5 times 
   * @method 
   * @param {String} id The ID of the feature to highlight
   * @return void
   */
  highlightFeature:function(id){
    var i, f = this.getFeatureById(id);
    if(f){
      var colors = ['black','white',f.color];
      for(i = 1; i < 15; i++){
        this.checkHighlight.defer(150*i,this,[f,colors[i%3]]);  
      }
    }  
  },
  
  // allows defered highlight calls to be stopped if a feature
  // is being removed
  checkHighlight:function(feature, color){
    if(this.highlight){
      this.paintFeature(feature,color);
    }
  },
 
  
  /**
   * @event featureMouseOut
   * Fires when the mouse moves out of a feature.
   * @param {EventObject} e The mouseover event.
   * @param {FeatureCanvas} this The canvas.
   * @event featureMouseOver
   * Fires when the mouse moves over a feature.
   * @param {EventObject} e The mouseout event.
   * @param {FeatureCanvas} this The cavnvas.
   */
  onMM: function(e,t){
   
    var feature = this.getEventFeature(e);
    if(this.zoomDrag && this.allowZoom){
      var start = (this.getEventMBP(e,t) * 1000000) - this.zoomOffset;
         
      // end is the start position plus existing lenght off zoom indicator
      var end = start + this.zoomFeature.end - this.zoomFeature.start;
      this.showZoomIndicator(start,end);
  
    }else if(this.createZoomDrag && this.allowZoom){
   
      start = this.zoomMouseDownBP;
      end = this.getEventMBP(e,t) * 1000000;
      if(end < start){
        this.showZoomIndicator(end,start);
      }else{
        this.showZoomIndicator(start,end);
      }
  
    }else{
      if(feature != null){
        this.fireEvent('featureMouseOver',e,feature,this);
      }else{
        this.fireEvent('featureMouseOut',e,this);
      }
    }
    
  },
  
  /**
   * @event featureClick
   * Fires when a feature is clicked.
   * @param {EventObject} e The click event.
   * @param {Number} mbp The position of the click in Mbp
   * @param {Feature} feature The feature clicked.
   * @param {FeatureCanvas} this The canvas.
   */
  onClick: function(e,t){
    if(!this.isBanding){
      var feature = this.getEventFeature(e);
      var mbp = this.getClickMBP(e,t);

      if((feature != null)&&(feature != this.zoomFeature)){
        this.fireEvent('featureClick',e,mbp,feature,this);

      }
    }
  },
  
 
  /**
   * @event featureRightClick
   * Fires when a feature is right clicked, aka context menu.
   * @param {EventObject} e The click event.
   * @param {Number} mbp The position of the click in Mbp
   * @param {Feature} feature The feature clicked.
   * @param {FeatureCanvas} this The canvas.
   */
  onCM: function(e,t){
    var feature = this.getEventFeature(e);
    var mbp = this.getClickMBP(e,t);  
    if(feature != null){
      this.fireEvent('featureRightClick',e,mbp,feature,this);
    }
    e.stopEvent();
  },
  
  onMD: function(e,t){
    if(this.allowZoom){
      
      var feature = this.getEventFeature(e);
      if(feature != null){
        
        this.zoomMouseDownBP = this.getClickMBP(e)* 1000000;
        
        if(feature.id.indexOf("zFeature") != -1){
          this.zoomDrag = true;
        
          this.zoomOffset = this.zoomMouseDownBP - this.zoomFeature.start;
        
        }else {
          this.createZoomDrag = true;
        
        }
     
        this.findParentByType('karyopanel').el.addListener({"mouseup":this.onMU, scope:this,options:{single:true}});
        this.findParentByType('karyopanel').el.addListener("mousemove",this.onMM,this);
      }
    }
  },
  
  onMU:function(e,t){
    if(this.allowZoom){
      if(this.zoomDrag || this.createZoomDrag){
        if(this.zoomFeature){
          var start = this.zoomFeature.start;
          var length =  this.zoomFeature.end - this.zoomFeature.start;

          //need better way to reference zoom panel 
          Ext.getCmp('zoomPanel').configure(start,length,this.chromosome);

        }
      }
      this.zoomDrag = false;
      this.createZoomDrag = false;
      this.findParentByType('karyopanel').removeListener("mousemove",this.onMM,this);
    }
  },
  
  // convert an event into a megabase pair value
  // for events within the canvas
  // returns -1 if event is outside the chromosome
  getClickMBP: function(e,t){
    var megaBP = 1000000;
    var mbp = -1;
    var elPos = this.getPosition();
    var clickPos = e.getXY();   
    if((clickPos[0] - elPos[0]) < this.topMargin){
      var y = clickPos[1] - (elPos[1] + this.topMargin);
      mbp =Math.floor((y /(megaBP * this.scale) ) + this.start/megaBP);
      if (mbp < 0){
        mbp = 0;
      }
      if(mbp > Math.floor(this.chromosomeEnd / megaBP)){
        mbp = Math.floor(this.chromosomeEnd / megaBP);
      }
    }
    return mbp;
  },
  
  // convert an event into a megabase pair value
  // works for events anywhere
  // returns between 0 and the maximum for the canvas/chromosome
  getEventMBP:function(e,t){
    var megaBP = 1000000;
    var mbp = 0;
    var elPos = this.getPosition();
    var clickPos = e.getXY();   
    
    var y = clickPos[1] - (elPos[1] + this.topMargin);
    mbp =Math.floor((y /(megaBP * this.scale) ) + this.start/megaBP);
    if (mbp < 0){
      mbp = 0;
    }
    if(mbp > Math.floor(this.chromosomeEnd / megaBP)){
      mbp = Math.floor(this.chromosomeEnd / megaBP);
    }
  
    return mbp;
  },
  
  // uses event coordinates to determine which if any feature the event 
  // occured on
  getEventFeature: function(e){
    var feature = null;
    var elPos = this.getPosition();
    var mousePos = e.getXY();           
    var x = mousePos[0] - elPos[0];
    var y = mousePos[1] - elPos[1];
    if(this.featureWidth > 0){
      x = Math.floor(x / (this.featureWidth+this.featureHGap));
    }
    var yMap = this.featureMap[x];             
    if(yMap != null){
      feature = this.features[yMap[y]];
    } 
    return feature; 
  },
  
  /**
   * Paints a feature the specified color 
   * @method 
   * @param {Feature} feature A feature that has been drawn on this canvas.
   * <br> use getFeature(id) to make sure the feature has been layed out.
   * @param {String} color An HTML color.
   * @return void
   */
  paintFeature: function(feature, color){
    var canvas = this.canvas; 
    if(canvas.getContext ){
      var ctx = canvas.getContext("2d");
      ctx.beginPath();
      ctx.fillStyle = color;
      ctx.fillRect(feature.canvasX, 
      feature.canvasY, 
      feature.width, 
      feature.height);
    }else{
      var div = Ext.get(this.id+':'+feature.id);
      div.applyStyles("background-color:"+color);
    }
  },
  
  
  /**
   * Lays out, maps coordinates, and draws features 
   * @method 
   * @param {Array} features An array of features to display on the canvas
   * @return void
   */
  addFeatures:function(featuresIn){
    var i;
    if(this.features == null){
      this.features = [];
    }
    for(i = 0; i < featuresIn.length; i++){
      this.features.push(featuresIn[i]);
    }
    this.drawFeatures();
  },
  
  /**
   * Adds one feature to the canvas but does not draw it.
   * <br>Call drawFeatures to redraw all features including newly added ones.
   * @method 
   * @param {Feature} feature A feature to add to this canvas.
   * @return void
   */
  addFeature:function(feature){
    if(this.features == null){
      this.features = [];
    }
    this.features.push(feature);                                            
  },
  
  /**
   * Lays out, maps coordinates, and draws all features that have been added.
   * @method 
   * @return void
   */
  drawFeatures:function(){
    var i, startX = 0,startY = 0,endY = 0;
    // calculate the position of the features on the screen
    if(this.features == null || this.features.length == 0) return;
    this.layoutFeatures();
    // layout features adjusts the panel's width
    // final width is used to left justify
    for(i = 0 ; i < this.features.length; i++){    
      var theFeature = this.features[i]; 
      if(this.justify == 'LEFT'){
        theFeature.canvasX = this.getWidth()
          - ( theFeature.canvasX + theFeature.width ) ;   
      }     
      var xPos = theFeature.canvasX;
      var yPos = theFeature.canvasY;
      var height = theFeature.height;
      var width = theFeature.width;  
      if(i == 0){
        startX = xPos+width;
        startY = yPos + this.curvePx;
      }
      // puts the features coordinates in an array of arrays
      // x,y events can be translated into features
      this.mapFeature(xPos,yPos,width,height,i);
      var newY;
      var canvas = this.canvas;
      if(canvas){  
        if(canvas.getContext ){
          var ctx = canvas.getContext("2d");
          ctx.fillStyle = theFeature.color;
          if(theFeature.curvedTop){
            newY = yPos + this.curvePx;
            ctx.moveTo(xPos,newY);
            ctx.quadraticCurveTo(xPos+Math.floor(width/2),
            yPos, (xPos+width), newY);
            ctx.fill();     
            yPos = newY;
            height = height - this.curvePx;
          }
          if(theFeature.curvedBottom){
            // without beginPath curved top gets the same color as the bottom
            ctx.beginPath(); 
            newY = yPos + height;
            ctx.moveTo(xPos,newY);
            ctx.quadraticCurveTo(xPos+Math.floor(width/2),
            (newY + this.curvePx), (xPos+width), newY);
            ctx.fill();
            
            //outline the end of the chromosome
            if(this.isBanding){
              ctx.lineWidth = 1;
              ctx.strokeStyle = '#CCC';
              ctx.stroke();  
            }
          }
          if(theFeature.isZoomRegion){
            ctx.globalAlpha=0.4;
            ctx.fillRect(xPos-2, yPos, width+4, height); 
            ctx.globalAlpha=1.0;

          }else{
            ctx.fillRect(xPos, yPos, width, height); 
            if((yPos + height) > endY){
              endY = yPos+height;
            }
          }
          
          // right side 'shadow' on chromosome
          if(this.isBanding && (i+1 == this.features.length)){
            ctx.lineWidth = 1;
            ctx.strokeStyle = '#BBB';
            ctx.moveTo(startX,startY);
            ctx.lineTo(startX,endY);
            ctx.stroke();
          }
        }else{
          var opacity = '';
          // canvas is not available
          // insert features as divs in the DOM
          if(theFeature.isZoomRegion){
            width = width + 5;
            xPos = xPos - 2;
            opacity = ' filter:alpha(opacity=50);'
          }
          
          Ext.DomHelper.append(this.canvas, 
          { 
            id:this.id+':'+theFeature.id,
            tag:'div',
            html:'&nbsp;',
            style:"height:"+height+"; width:"+width+";background-color:"+
              theFeature.color+";position:absolute; top:"+
              yPos+"px;left:"+xPos+"px;font-size:1%;" + opacity
          });
        }
      }
    }     
  },
  
  // deterimine the x and y position each feature
  // adjust the component's width if necessary
  layoutFeatures:function(){            
    var height = this.getHeight();
    var avail = [];
    var maxWidth = 0;
    var i, j;
    // fill avail with zeros: the initial x pos offset for new features
    for(i = 0;  i < height; i ++){
      avail[i] = 0;
    }
    // for each feature added calculate its position and add it
    if(this.features != null){
    for(i = 0 ; i < this.features.length; i++){
      var theFeature = this.features[i];
      var featureSize = 
        Math.abs(Math.round((theFeature.end - theFeature.start) * this.scale )); 
      var featureTop = 
        Math.round((theFeature.start - this.start) * this.scale );
      var xPos =  this.featureHGap;         
      var yPos = featureTop + this.topMargin; 
      if(yPos < this.topMargin){
        yPos = this.topMargin;
      }
      
      if(featureSize < theFeature.minSize){
        featureSize = theFeature.minSize;
      }
        
      var featureBottom = featureTop+featureSize+this.featureVGap;
      var max = 0;
      // zoomed features have a parent
      // the parent when the zoomed x position of the feature is
      // calculated has a value zoomX, once calculated for a specific zoom
      // this doesn't need to change unless the parent's canvasX changes
      
      var zoomX = -1;
      if(theFeature.parent != null){
        zoomX = theFeature.parent.zoomX;
      }
      
      if(this.expand && (zoomX == -1)){
      
        // use the avail array to keep track of feature positions
        // and move any overlaps further out
     
        for(j = featureTop; j < featureBottom; j++){
          if(avail[j] > max){
            max = avail[j];  
          }
        }
        for(j = featureTop; j <  featureBottom; j++){
          avail[j] = max + theFeature.width + this.featureHGap;
        }     
        xPos = xPos  + max;
        this.features[i].zoomX = -1;
        this.features[i].canvasX = xPos;
        if(theFeature.parent){
          theFeature.parent.zoomX = xPos;
        }
      }
        
      if(zoomX != -1){  
        theFeature.canvasX = zoomX;
    
      }
      
      if(!this.expand){
        theFeature.canvasX = xPos;
      }
        
      xPos = theFeature.canvasX;
      
      theFeature.canvasY = yPos;
      
      theFeature.height = featureSize;
      if(this.justify == "LEFT"){
        if((xPos + theFeature.width) > maxWidth){
          maxWidth = xPos + 10;
        }
      }else{
        if(xPos > maxWidth){
         
          maxWidth = xPos + 10;                
        }
      }
    }
    }
    //adjust the panel's width to accomodate the widest feature  
    if(this.getWidth() < maxWidth){
      this.setWidth(maxWidth); 
    }
  }, // end function layoutFeatures
  
  
  // populates this.featureMap 
  // allows translation of mouse coordinates to features        
  mapFeature:function(xPos,yPos,width,height,fIndex){
    var x, y, yMap;
    if(this.featureMap == null){
      this.featureMap = [];
    }
    if(this.featureWidth > 0){
      // use a single x value for the feature to save memory
      x = Math.floor(xPos / (this.featureWidth+this.featureHGap));
      if(this.justify == 'LEFT'){
        x = Math.ceil(xPos / (this.featureWidth+this.featureHGap));
      }
      if(this.featureMap[x] == null){
        this.featureMap[x] = [];
      }
      yMap = this.featureMap[x];
      
      for( y = yPos; y <= yPos + height; y++){
        yMap[y] = fIndex;
      }
    }else{
      
      // features may be variable width so map each pixel
      for(x = xPos; x <= xPos+width; x++){
        if(this.featureMap[x] == null){
          this.featureMap[x] = [];
        }
        yMap = this.featureMap[x];
        for(y = yPos; y <= yPos + height; y++){
          yMap[y] = fIndex;
        }
      }
    }                                
  },
  
  /**
   * Creates a semi transparent red feature to indicate the zoomed region.
   * @method 
   * @param {Number} start The start position of the indicator in base pairs.
   * @param {Number} end The end position of the indicator in base pairs.
   * @return void
   */
  showZoomIndicator:function(start, end){
    if(this.isBanding){
       
      this.features.remove(this.zoomFeature);

      //allows the indicator to extend past the end of the ch
      var len = parseInt(this.length,10) +  8000000;
      if(end > len){
        end = len;
      }
      this.zoomFeature = new org.jax.mgi.kmap.Feature({id:this.id+':zFeature:',
        label:"zoom between "+Math.floor(start)+":"+Math.floor(end),
        start:start,
        end:end,
        color:"red",
        width:this.featureWidth,
        minSize:1,
        isZoomRegion:true}); 

      this.features.push(this.zoomFeature);

      this.clear(false);
      this.drawFeatures();


      // this is a bad way to get a reference to the karyoPanel
      Ext.getCmp('kPanel').updateZoom(this.zoomFeature);
    }
  },
  
  /**
   *Removes the zoom indication feature
   *@method
   *@return void
   */
  removeZoomIndicator:function(){  
    this.clear(false);
    this.features.remove(this.zoomFeature);
    this.zoomDrag = false;
    this.createZoomDrag = false;
    this.zoomFeature = null;
    this.drawFeatures();
  }
});

/**
 * @class org.jax.mgi.kmap.Axis
 * @extends org.jax.mgi.kmap.FeatureCanvas
 *  Specilaized FeatureCanvas for drawing a gruaduated Axis. <br>
 *  Configured to have either a fixed number of graduations or a fixed distance between grauduations.
 *  <br>Only set configuration parameters. Generally, inhereted methods should not be called.
 *  <br>
 * @author Steven Neuhauser
 * @version 1.0
 */
org.jax.mgi.kmap.Axis = Ext.extend(org.jax.mgi.kmap.FeatureCanvas,{
  
  /**
   * @cfg {Number} graduation The number of base pairs between graduation marks
   * <br>Default 1000000
   */   
  graduation:10000000,   
  /**
   * @cfg {Number} featureWidth Width of major graduation marks. Minor marks are 1/2 this width
   * <br>Default 10
   */
  featureWidth:10,     
  /**
   * @cfg {Boolean} calcGraduation True to ignore the graduation param 
   * <br>and calculate the distance between graduation marks based on the value provided for graduations.
   * <br>Default false
   */
  calcGraduation:false, 
  /**
   * @cfg {Number} graduations When calcGraduations is true this is the total number of graduations to display.
   *<br> The distance between graduations will be the length of the axis divided by this number.
   *<br>Default 25
   */
  graduations:25,
  /**
   * @cfg {Number} canvasWidth Width of canvas element can be much smaller than initalilly configured.
   * <br>Default value is appropriate for default value for featureWidth.
   * <br>Default 30
   */  
  canvasWidth:30,
  /**
   * @cfg {Boolean} showBPLabels True to display numeric labels on major graduations.
   * <br>Default True
   */
  showBPLabels:true, 
  /**
   * @cfg {Number} labelPrecision Number of decimal places for numeric lables.
   * <br>Default 0
   */
  labelPrecision:0,     
  
  isAxis:true,          // should always be true
  
  initComponent: function(){       
    org.jax.mgi.kmap.Axis.superclass.initComponent.apply(this,arguments);
    this.addListener("afterRender", function(p){
      var canvas = document.getElementById(this.id+":canvas");
      canvas.width = this.canvasWidth;
    });
    this.configure();
  },  
  
  configure : function(){
    var graduationOffset = ( this.start % this.graduation);
    var graduationCount = 0;
    if(this.calcGraduation){
      var x = Math.floor(this.length/this.graduations);
      var y = x + "";
      y = y.length -1;
      var pow =  Math.pow(10,y);
      y = x / pow;
      x = 1;
      if (y > 3.3){
        x = 5;
      }
      if (y > 6.6){
        x = 10;
        
      }
      x = x * pow;
      this.graduation = x;
      graduationOffset = ( this.start % this.graduation);
    }  
    
    var axisLength = this.length;
    if ((this.start + this.length) > this.chromosomeEnd){
      axisLength = this.chromosomeEnd - this.start;
    }
    
    var lengthF = new org.jax.mgi.kmap.Feature({
      start:0,
      end:axisLength,
      color:this.color,
      width:1,
      minSize:1}); 

    this.features.push(lengthF);
    
    if(graduationOffset == 0){    
      var top = new org.jax.mgi.kmap.Feature({
        label:this.start + "bp",
        start:0,
        end: 2,
        color:this.color,
        width:this.featureWidth,
        minSize:1}); 
      
      this.features.push(top);
      graduationCount = 1;
    }
   
    if(((this.start*1) + (this.length*1)) >= this.chromosomeEnd){
      var bottom = new org.jax.mgi.kmap.Feature({
        label:this.chromosomeEnd+"bp",
        start:this.chromosomeEnd-2 - this.start,
        end:this.chromosomeEnd - this.start,
        color:this.color,
        width:this.featureWidth,
        minSize:1}); 
      this.features.push(bottom);
    }
    var i;
    for(i = this.graduation - graduationOffset; i < this.length-(this.graduation/4); i = i + this.graduation){
      var width = this.featureWidth / 2;
      if((this.start + i)  % (this.graduation * 5) == 0){
        width = width * 2;
        graduationCount++;
      }
      var mark = new org.jax.mgi.kmap.Feature({
        label:this.start+i+"bp",
        start:i,
        end:i + 1,
        color:this.color,
        width:width,
        minSize:1}); 
      if((this.start+i) <= (this.chromosomeEnd)){
        this.features.push(mark);
      }
    }
  }, 
  
  // overides FeatureCanvas' layoutFeatures
  layoutFeatures:function(){
    var i,maxWidth = 0;
    // for each feature added calculate its position and add it
    for(i = 0 ; i < this.features.length; i++){
      var theFeature = this.features[i];
      var featureSize = 
        Math.abs(Math.round(
      (theFeature.end - theFeature.start) * this.scale ));
      if(featureSize < theFeature.minSize){
        featureSize = theFeature.minSize;
      }                                
      var featureTop = Math.round(theFeature.start * this.scale );
      var xPos =  this.featureHGap;      
      var yPos = featureTop + this.topMargin;      
      this.features[i].canvasX = xPos;
      this.features[i].canvasY = yPos;
      this.features[i].height = featureSize;
      if(xPos > maxWidth){
        maxWidth = xPos + 25;                                          
      }
    }
    if(this.getWidth() < maxWidth){
      this.setWidth(maxWidth);    
    }
    if(this.showBPLabels){
      this.drawLabels();    
    }
  }, // end function layoutfeatures
  
  drawLabels:function(){
    var canvas = document.getElementById(this.id+":canvas");
    if(canvas){
      if(canvas.getContext ){
        var i;
        var ctx = canvas.getContext("2d");
        ctx.fillStyle= 'black';
        ctx.textBaseline = 'middle';
        for(i = 0 ; i < this.features.length; i++){
          var theFeature = this.features[i];
          var mbp = Math.floor((theFeature.start + this.start) / 10000);
          if(!theFeature.isZoomRegion){
            // put numeric lables on long graduations that are multiples of 10kbp
            if( mbp == ((theFeature.start + this.start) / 10000)
              && theFeature.width > (this.featureWidth / 2)){
              mbp = mbp / 100;
              mbp = mbp.toFixed(this.labelPrecision);
              var x = theFeature.canvasX + theFeature.width + 1;
              ctx.fillText(mbp,x,theFeature.canvasY);
              x = x+ ctx.measureText(mbp).width;
              if(x > this.getWidth()){
                this.setWidth(x+10);
              }
            }
          }
        } 
      }
    }
  }
});

/**
 * @class org.jax.mgi.kmap.MapPanel
 * @extends Ext.Panel
 * Contains multiple tracks, each a FeatureCanvas
 * Tracks can be added and removed. Standard config would be
 * Axis, LeftFeatures, Chromosomes, RightFeatures. <br>
 * Tracks are identified as L or R then a number ie R1<br>
 * Numbers increase left to right  L0 is assumed to be an axis
 * 
 * @author Steven Neuhauser
 * @version 1.0
 */

org.jax.mgi.kmap.MapPanel = Ext.extend(Ext.Panel,{
  /**
   * @cfg {Number} minWidth The minimum size the panel will be when displayed.
   * <br>Default 0
   */ 
  minWidth:0,
  /**
   * @cfg {Boolean} displayAxis True to initally display the Axis (assumes axis is L0).
   * <br>Default True
   */ 
  displayAxis:true,
  /**
   * @cfg {String} centerId The id of the FeatureCanvas considered to be the center panel.
   * <br>Default null  Required
   */ 
  centerId:null, 
  
  centerIndex:0, //the index of this.items that contains the center FeatureCanvas
  layout:'hbox',// don't change this
  anchor:'0%',  //don't channge this used by KaryoPanel layout
 
 
  /**
   * @event featureMouseOver
   * Relayed from each FeatureCavas
   */
  /**
   * @event featureMouseOut
   * Relayed from each FeatureCavas
   */
  /**
   * @event featureClick
   * Relayed from each FeatureCavas
   */
  /**
   * @event featureRightClick
   * Relayed from each FeatureCavas
   */
   
  initComponent: function(){                                         
    org.jax.mgi.kmap.MapPanel.superclass.initComponent.apply(this,arguments); 
    var i;
    for(i =0; i < this.items.getCount(); i ++){
      if(this.items.get(i).id == this.centerId){
        this.centerIndex = i;
      }
      this.relayEvents(this.items.get(i),['featureMouseOver','featureMouseOut','featureClick', 'featureRightClick']);
    }
    this.addListener("afterrender",function(p){  
      this.header.applyStyles("border-style:none");
    });  
  },
  
  /**
   * Hides the leftmost panel   
   * @method 
   * @return void
   */
  hideAxis: function(){
    this.displayAxis = false;
    this.getLeftTrack(0).hide();
    this.updateWidth();
  },
  
  /**
   * Shows the leftmost panel 
   * @method 
   * @return void
   */
  showAxis: function(){
    this.displayAxis = true;
    if(!this.hidden){
      this.getLeftTrack(0).show();
      this.getLeftTrack(0).layoutFeatures();
      this.updateWidth();
    }
  },
  
  /** 
   * Updates is panels width based on the total widths of visible child panels 
   * Attempts to smooth width adjustment which happens frquently when scolling in zoom panel
   * 
   * @method 
   * @return void
   */
  updateWidth:function(){
  
    var width = 0, newWidth = 0;
    var i,item;
   
    for(i =0; i < this.items.getCount(); i++){
      item = this.items.get(i);
      if(item.rendered){
        
     //   item.width = item.getWidth();
        
        width = width + item.getWidth();
      }
    }
    if(width < this.minWidth){
      width = this.minWidth;
    }
    if(width > this.getWidth()){
      newWidth = width * 1.1;
    }
    if(width < this.getWidth() *.8){
      newWidth = width;
    }
    if(newWidth > 0){
      newWidth = Math.floor(newWidth);
       
      this.setWidth(newWidth);
      this.getResizeEl().setWidth(newWidth);
      this.doLayout();
      
      
    }
  },
  
  /**
   * Adds a left track. It will be the left most track 
   * @method 
   * @param {FeatureCanvas} item the FeatureCanvas to add as a left track.
   * @return void
   */
  addLeftTrack:function(item){
    this.items.insert(this.centerIndex,item);
    this.centerIndex++;
    this.doLayout();
    this.updateWidth();
  },
  
  /**
   * Adds a right track. It will be the right most track 
   * @method 
   * @param {FeatureCanvas} item the FeatureCanvas to add as a right track.
   * @return void
   */
  addRightTrack:function(item){
    this.add(item);
    this.doLayout();
    this.updateWidth();
  },
  
  /**
   * Returns the FeatureCanvas identified by centerId 
   * @method 
   * @return {FeatureCanvas} The center FeatureCanvas
   */
  getCenter:function(){  
    return this.get(this.centerId);
  },
  
  /**
   * Gets the left track at the given index.
   * @method 
   * @param {Number} index The index of the track to return.
   * @return {FeatureCanvas}
   */
  getLeftTrack:function(index){      
    return this.items.get(index);
  },
  /**
   * Gets the right track at the given index.
   * @method 
   * @param {Number} index The index of the track to return.
   * <br> Index zero is the same as the center.
   * <br> 1 is the right track adjacent to the center.
   * @return {FeatureCanvas}
   */
  getRightTrack:function(index){
    index = index + this.centerIndex;
    return this.items.get(index);
  },
  
  // skip axis and chromsome 
  drawAllTrackFeatures:function(){
    var i;
    for(i = 1; i < this.items.getCount(); i++){
      if(i != this.centerIndex){
        this.items.get(i).drawFeatures();
      }
    }
    this.updateWidth();
  },
  
  getAllTrackFeatures:function(){
    var i,allFeatures = [];
    for(i = 1; i < this.items.getCount(); i++){
      if(i != this.centerIndex){
        allFeatures = allFeatures.concat(this.items.get(i).features);
      }
    }
    return allFeatures;
  },
  
  highlightFeature:function(record){
    var canvas = this.getTrack(record.get('track'));
    canvas.highlightFeature(record.id);
  },
  
  paintFeature:function(record,color){
    if(color == null){
      color = record.get('color');
    }
    var canvas = this.getTrack(record.get('track'));
    var feature = canvas.getFeatureById(record.id);
    if(feature){
      feature.color = color;
      canvas.paintFeature(feature,color);
    }
  },
  
  drawAllFeatures:function(){
    var i;
    for(i = 0; i < this.items.getCount(); i++){
      this.items.get(i).drawFeatures();
    }  
    this.updateWidth();
  },
  
  removeFeaturesById:function(id){
    var i;
    for(i = 0; i < this.items.getCount(); i++){
      this.get(i).removeFeaturesById(id);
    }
    this.updateWidth();
  },
  
  removeTrackFeaturesById:function(id){
    var i;
    for(i = 1; i < this.items.getCount(); i++){
      if(i != this.centerIndex){
        this.get(i).removeFeaturesById(id);
      }
    }
    this.updateWidth();
  },
  
  removeAllTrackFeatures:function(){
    this.removeLeftTrackFeatures();
    this.removeRightTrackFeatures();
    this.updateWidth();
  },
  // don't remove axis at 0
  removeLeftTrackFeatures:function(){
    var i;
    for(i = 1; i < this.centerIndex; i++){
      this.get(i).removeFeatures();
    }
    this.updateWidth();
  },
  // don't remove chromosome at centerIndex
  removeRightTrackFeatures:function(){
    var i;
    for(i = this.centerIndex+1; i < this.items.getCount(); i++){
      this.get(i).removeFeatures();
    }
    this.updateWidth();
  },
 
  removeAllTracks:function(){
    this.removeAll(); 
    this.updateWidth();
  },
  
  getTrack:function(track){
    var canvas;
    if((track == 'null') ||(track.length < 2)){
      track = 'R1';
    }
    var lr = track.charAt(0).toUpperCase();
    var index = parseInt(track.substring(1),10);
    if(index <= 0){
      index  = 1;
    }
    if(lr == 'L'){
      canvas = this.getLeftTrack(index);      
    }else if (lr == 'R'){
      canvas = this.getRightTrack(index);
    }
    return canvas;
  },
  
  addFeature:function(feature){
    var track = feature.track;
    if((!track) ||(track == 'null') ||(track.length < 2)){
      track = 'R1';
    }
    var lr = track.charAt(0).toUpperCase();
    var index = parseInt(track.substring(1),10);
    if(index <= 0){
      index  = 1;
    }
    if(lr == 'L'){
      if(index >= this.centerIndex){
        this.createLeftTracks(index); 
      }
      this.getLeftTrack(index).addFeature(feature); 
    }else if (lr == 'R'){
      if(index >= (this.items.getCount() - this.centerIndex)){
        this.createRightTracks(index);
      }
      this.getRightTrack(index).addFeature(feature);
    }
  },
  
  createLeftTracks:function(index){
    var i =  this.centerIndex;
    for(i; i <= index; i++){
      var track = this.createTrack(true);
      this.insert(i,track);
    }
    this.centerIndex = i;
    this.doLayout();
    this.updateWidth();
  },
  
  createRightTracks:function(index){
    var i = (this.items.getCount() - this.centerIndex) ;
    for(i; i <=index; i++){
      var track = this.createTrack(false);     
      this.add(track);
    }
    this.doLayout();
    this.updateWidth();
  },
  
  createTrack:function(left){
    var track;
    if(left){
      track = this.getLeftTrack(1);
    }else{
      track = this.getRightTrack(1);
    }
    var newTrack = new org.jax.mgi.kmap.FeatureCanvas({
      scale:track.scale,
      height:track.height,
      width:track.width, 
      features:[],
      featureMap:[],
      featureHGap:track.featureHGap,
      featureVGap:track.featureVGap,
      initialWidth:track.initialWidth,
      featureWidth:track.featureWidth,
      justify:track.justify,
      expand:track.expand,
      chromosome:track.chromosome,
      canvasMediator:track.canvasMediator
    });
    this.relayEvents(newTrack,['featureMouseOver','featureMouseOut','featureClick']);
    newTrack.addListener("resize",function(cmp){this.updateWidth();},this);
    return newTrack;
  },
  
  overlapFeatures:function(overlap){
    var i;
    for(i = 0; i < this.items.getCount(); i++){
      if(i != this.centerIndex){
        this.items.get(i).expand = overlap;
        this.items.get(i).clear(false);
        this.items.get(i).drawFeatures(); 
      }
    }
    this.updateWidth();
  },
  
  // when a feature is zoomed the zoomX parameter of the original feature is used to save
  // the x position of the zoomed features so they are not recalculated.
  // to save overhead and prevent features from jumping around when scrolled
  removeAllFeatureZoomX:function(){
   
    var i,j,features;
    for(i = 1; i < this.items.getCount(); i++){
      if(i != this.centerIndex){
        features =  this.items.get(i).features
        if(features != null ){
            for(j=0; j < features.length; j++){
              features[j].zoomX = -1;
            }
        }
      }
    }  
  }
});

/**
 * @class org.jax.mgi.kmap.KaryoPanel
 * @extends Ext.Panel
 * Top Level component to display and manipulate features on chromosomes<br/>
 * Contains one MapPanel per chromosome
 * Chromosomes defined in the xml file 'bandingFile'
 * Configured with a store of feature records and responds to store events
 * {@link org.jax.mgi.kmap.KaryoPanel#methodOne this is method one} <br/>
 * {@link org.jax.mgi.kmap.KaryoPanel#methodOne} <br/>
 
 * {@link org.jax.mgi.kmap.KaryoPanel} <br/>
 * {@link org.jax.mgi.kmap.KaryoPanel KaryoPanel class} <br/>
 * @author Steven Neuhauser
 * @version 1.0
 */

org.jax.mgi.kmap.KaryoPanel = Ext.extend(Ext.Panel,{
  /**
   * @cfg {String} bandingFile Location of a file with cytoband information.
   * <br>Requried
   */ 
  bandingFile:'',   
  /**
   * @cfg {Number} width Width of panel.
   * <br>Default 800
   */ 
  width:800,
  /**
   * @cfg {Number} minWidth Minimum width of the panel.
   * <br>Default 800
   */ 
  minWidth:800,
  /**
   * @cfg {Number} minHeight Minimum height of the panel
   * <br>Default 580
   */ 
  minHeight:600,
  /**
   * @cfg {Number} maxKaryoSize Length of longest chromosome in px
   * <br>Default 100
   */ 
  maxKaryoSize:100,   
  /**
   * @cfg {Number} fCanvsHeight Height of each FeatureCanvas  
   * <br>Default 220
   */ 
  fCanvasHeight:220,
  /**
   * @cfg {Number} fCanvasWidth Initial width of each FeatureCanvas
   * <br>Default 20
   */ 
  fCanvasWidth:20,   
  /**
   * @cfg {Number} columns The maximum number of chromosomes to display per column
   * <br>Default 11
   */ 
  columns:11,      
  /**
   * @cfg {String} bandLink A prefix added to each cytobands link value.
   * <br>Default empty. 
   */ 
  bandLink:'', 
  /**
   * @cfg {String} localLink A prefix added to the link of each feature.
   * <br>Default empty
   */ 
  localLink:'',
  /**
   * @cfg {Number} chromosomeWidth Width of cytoband features for the chromosomes.
   * <br>Default 15
   */ 
  chromosomeWidth:15, 
  /**
   * @cfg {Number} featureHGap Minimum horizontal space between overlaping features if features are expanded.
   * <br>Default 2
   */ 
  featureHGap:2,      
  /**
   * @cfg {Number} featureVGap Minimum vertical space between adjancent features
   * <br>Default 0
   */ 
  featureVGap:0,     
   
  /**
   * @cfg {Boolean} hideEmptyChr If true only chromosomes with features will be displayed othewise all chromosomes are displayed
   * <br>Default true.
   */ 
  hideEmptyChr:true,
  /**
   * @cfg {String} bandMaskDiv The id of the div used to display a loading mask when loading the cytobands.
   * <br>Default null. No mask is displayed
   */ 
  bandMaskDiv:null,  
  
  allowZoom:false,
  
  expandFeatures:true,
  
  /**
   * @cfg {boolean} deDupOnMgiId When addiding features exclude those that have the same MGI ID as existing features
   * <br>Default false
   */
  deDupOnMgiId:false,
  
  highlightActionFocusIn:0,
  highlightActionFlash:1,
  highlightAction:0,
  
  // the following should be considered private
  
  featureStore: null, // set by setFeatureStore events on this store are monitored
  layout:'absolute', // don't change this 
  scale:0,
  mPanels: null,  // array of mPanels, one per chromosome, starting at 1 (panels[0] is null)
  nameIndex:null,
  bandStore:null,             // contains chromosome cytoband data populated from bandingFile
  stainColors:null,           // maps cytoband stain names to colors
  featureStoreSortState:null,  //to avoid redrawing features when store is sorted
  suppressStoreChange:false,  // set on before load so features are not drawn twice
  tbar:null,
  bbar:null,
  hideShowStore:null,  // populates the chromosome view grid
  chromGrid:null,  // grid panel to select chromosomes to hide/show
  
  initComponent: function(){  
    this.hideShowStore = new Ext.data.ArrayStore({fields:['chromosome']});
    var chromGridSM = new Ext.grid.CheckboxSelectionModel({dataIndex:'chromosome'});
    chromGridSM.suspendEvents();
    var chromGridCM =  new Ext.grid.ColumnModel({columns:[
        chromGridSM,
        {id:'chromosome',header:'Select all', dataIndex: 'chromosome'}
      ]});
        
    this.chromGrid = new Ext.grid.GridPanel({
      selModel:chromGridSM,
      store:this.hideShowStore,
      cm:chromGridCM,
      stripeRows: true,
      height:300,
      width:200,
      deferRowRender:false,
      forceLayout:true,
      viewConfig:{autoFill:true},
      autoExpandColumn:'chromosome',
      bbar: [ {text: 'Hide',
          handler:this.hideShowHandler,
          scope:this
        }
      ]
    });
    this.chromGrid.on({'afterrender':this.setupChromGrid,scope:this});
      
    var chromGridMenu = new Ext.menu.Menu({
      id:this.id+':hide/show',
      style: {
        overflow: 'visible'     
      },
      items: [this.chromGrid]
    });
    
    this.tbar = {
      items: [
        {text:'File',
          menu:{
            items:[]
          }
        },
        '-',
        {text:'Edit',
          menu:{
           items:[]
            }
        },
        '-',
        {text: 'View',
          menu: {        
            items: [{
                text: 'Chromosomes',
                menu:chromGridMenu
              } ,'-', new Ext.menu.CheckItem({
                id:this.id+':onlyChrCheck',
                text: 'Hide chromosomes w/o features',
                checked:this.hideEmptyChr,
                checkHandler:this.hideEmptyChrHandler,
                scope:this 
              }), new Ext.menu.CheckItem({
                id:this.id+':allChrCheck',
                text: 'Show all chromosomes',
                checked:!this.hideEmptyChr,
                checkHandler:this.showAllChrHandler,
                scope:this 
              }),'-',  new Ext.menu.CheckItem({
                text: 'Axes (length marked in Mbp)',
                checked:false,
                checkHandler:this.axisCheckHandler,
                scope:this 
              }),'-', new Ext.menu.CheckItem({
                text:'Stack features',
                checked:false,
                scope:this,
                checkHandler:this.overlapFeaturesHandler,
                scope:this 
              }),'-', {
                text: 'Restore',
                handler:this.restore,
                scope:this              
              },'-', {
                text: 'Capture image',
                handler:this.exportImage,
                scope:this              
              }  
            ]
          }
        }      
      ]
    };
    this.bbar =  {
      items:[{xtype: 'tbtext', text: '&nbsp;'}]
    };
    org.jax.mgi.kmap.KaryoPanel.superclass.initComponent.apply(this,arguments);
    this.mPanels = [];
    this.nameIndex = [];
    this.stainColors = [];
 
    this.bandStore = new Ext.data.XmlStore({
      autoDestroy: true,
      url: this.bandingFile,
      record: 'chromosome', 
      idPath: 'index',
      fields: [
        {name:'index', mapping:'@index'},
        {name:'number', mapping:'@number'},
        {name:'length', mapping:'@length'},
        {name: 'band', convert: (function(){
            var childReader = new Ext.data.XmlReader({
              record: 'band',
              fields: [
                {name:'index', mapping:'@index'},
                {name:'name', mapping:'@name'},
                'start',
                'end',
                'stain',
                'link'
              ]
            });
            return function(v, n){
              var i, len;
              var records = childReader.readRecords(n).records, data = [];
              for(i = 0, len = records.length; i < len; i++){
                data.push(records[i]);
              }                                      
              return data;
            };
          })()}
      ]
    });
    
    this.stainColors["gneg"]="#eee";
    this.stainColors["gpos100"]="#222";
    this.stainColors["gpos75"]="#444";
    this.stainColors["gpos66"]="#666";
    this.stainColors["gpos50"]="#888";
    this.stainColors["gpos33"]="#aaa";
    this.stainColors["gpos25"]="#ccc";
    this.stainColors["gvar"]="#ccc";
    this.stainColors["gpos"]="#cca";    
  
    this.addListener('featureClick',this.featureClick,this);
    this.addListener('featureRightClick',this.featureRightClick,this);
    this.addListener('featureMouseOver',this.featureMouseOver,this);
    this.addListener('featureMouseOut',this.featureMouseOut,this);
  
    this.addEvents('afterBuild','featuresRemoved','removedAllFeatures');
  },
  
  
  
  featureClick:function(event,mbp,feature,canvas){

  },
  
  featureRightClick:function(event,mbp,feature,canvas){
    if(feature.link && feature.link.length > 0){
      var newLink = feature.link.replace(/%26/g,"&");
      if(newLink.indexOf('http')!= -1){
        window.open(newLink);
      }else{
        window.open(this.localLink+newLink);
      }
    }
  },
  
  featureMouseOver:function(event,feature,canvas){
    if(!canvas.isAxis){
      if(canvas.isBanding){
        if(feature.isZoomRegion){
          this.getBottomToolbar().get(0).setText(feature.label);
        }else{
          this.getBottomToolbar().get(0).setText("Chr "+feature.chromosome+
            " "+feature.start+"-"+feature.end+" Cytoband "+ feature.label);         
        }      
      }else{
          label = "";
        if(feature.label){
            label = feature.label;
        }
        this.getBottomToolbar().get(0).setText(label+" "+feature.name+" "+
          feature.chromosome+":"+feature.start+"-"+feature.end);
      }
    }
  },
  
  
  updateZoom:function(zoom){
    this.getBottomToolbar().get(0).setText(zoom.label);
  },
  
  
  featureMouseOut:function(event,canvas){
  //  this.getBottomToolbar().get(0).setText("&nbsp;");
  },
  
  findFeature : function(id){
    var record, mPanel, canvas, feature, chrom;
    record = this.featureStore.getById(id);
    if(!record) return;
    chrom = this.getMPanelByName(record.get('chromosome'));
    if(!chrom) return;
    var track = chrom.getTrack(record.get('track'));
    if(!track) return;
    feature = track.getFeatureById(id);
    if(!feature) return;
    return { feature:feature, track:track, chrom:chrom };
  },

    
  highlightByFocusIn : function(id){
    var elt, f;
    var dh = Ext.DomHelper;
    f = this.findFeature(id);
    if(!f) return;
    var fadein =  { 
      opacity : {to:0.8, from:0.5}
      ,top :    {to:f.feature.canvasY-2, from: 0}
      ,left:    {to:f.feature.canvasX-2, from: 0}
      ,height : {to:f.feature.height+3, from:f.track.getHeight()}
      ,width  : {to:f.feature.width+3, from:f.track.getWidth()}
    };
    elt = dh.append( f.track.el, {
      tag : 'div',
      style : {
        'background-color' : 'yellow',
        'border' : 'thin solid black',
        'width' : f.feature.width,
        'height' : f.feature.height,
        'position' : 'absolute',
        'top' : f.feature.canvasY, 
        'left' : f.feature.canvasX
      }
    }, true);
    elt.scrollIntoView(this.body);
    elt.animate( fadein, 0.35, function(xx){xx.remove(); }, 'easeOutStrong' );
  },
  
  
  
  // determine which highlighting method to use
  highlightFeature:function(id){
    switch(this.highlightAction){
      case this.highlightActionFlash:
        this.highlightByFlash(id);
        break;
      case this.highlightActionFocusIn:
        this.highlightByFocusIn(id);
        break;
      default: 
        this.highlightByFocusIn(id);
    }
  },
  
  // 
  highlightByFlash:function(id){
    var record = this.featureStore.getById(id);
    var mPanel = this.getMPanelByName(record.get('chromosome'));
    mPanel.highlightFeature(record);
    
  },
  
  
  setupChromGrid:function(grid){
    var sm = this.chromGrid.getSelectionModel();
    for(var i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        if(this.mPanels[i].hidden){
          sm.selectRow(i-1,true);
        }
      }
    }  
  },
  
  /**
   * @event afterBuild
   * Fires after the KayroPanel has been configured from the cytobanding file.
   * <br>Confusingly fires after loadBands() is called.
   * @param {KaryoPanel} this The KaryoPanel.
   */
  /**
   * @event featureMouseOver
   * Relayed from each FeatureCanvas
   */
  /**
   * @event featureMouseOut
   * Relayed from each FeatureCanvas
   */
  /**
   * @event featureClick
   * Relayed from each FeatureCanvas
   */
  /**
   * @event featureRightClick
   * Relayed from each FeatureCanvas
   */
  build: function(){
    //find the longest chromosome and use it to get a scaling value
    var i,b, maxLen = 0;
    for(i = 0; i < this.bandStore.getTotalCount(); i++){
      if(maxLen < this.bandStore.getAt(i).get("length")){
        maxLen = this.bandStore.getAt(i).get("length");
      }
    }
    var theScale = this.maxKaryoSize/maxLen;
 
    this.scale = theScale;
 
    var chromosome;  

    for(i = 0; i < this.bandStore.getTotalCount(); i++){
      chromosome = this.bandStore.getAt(i);
      var cName = chromosome.get("number");
      var cIndex = chromosome.get("index");
      var theId = 'chromosome:'+cName;
      var theBands = chromosome.get("band");  
      var bandFeatures = [];
      var chromosomeLength = 0;
      var color = '';
      
      for(b = 0; b < theBands.length; b++){
        var thisBand = theBands[b];
        color = this.getColorForStain(thisBand.get('stain'));
        var link ='';
        if(this.bandLink.length > 0){
          link = this.bandLink+thisBand.get('link');
        }
        
        var bandFeature = new org.jax.mgi.kmap.Feature({
          label:thisBand.get('name'),
          chromosome:cName,
          start:thisBand.get('start'),
          end:thisBand.get('end'),
          color:color,
          curvedTop:b==0,
          curvedBottom: b == (theBands.length -1),
          width:this.chromosomeWidth,
          link:link,
          minSize:1}); 
        
        bandFeatures.push(bandFeature);    
        chromosomeLength = thisBand.get('end');                  
      }              
      var chromeCanvas = new org.jax.mgi.kmap.FeatureCanvas({
        isBanding:true,
        scale:theScale,
        height:this.fCanvasHeight,
        width:this.chromosomeWidth+6, 
        features:bandFeatures,
        featureMap:[],
        featureHGap:3,  //space for the zoom indicator
        featureVGap:0,
        initialWidth:this.chromosomeWidth+6,
        featureWidth:this.chromosomeWidth,
        expand:false,
        length:chromosomeLength,
        chromosomeEnd:chromosomeLength,
        chromosome:cName,
        allowZoom:this.allowZoom
      });                                        
    
      var featureCanvasR = new org.jax.mgi.kmap.FeatureCanvas({
        scale:theScale,
        height:this.fCanvasHeight,
        width:this.fCanvasWidth, 
        features:[],
        featureMap:[],
        featureHGap:this.featureHGap,
        featureVGap:this.featureVGap,
        initialWidth:this.fCanvasWidth,
        featureWidth:5,
        expand:this.expandFeatures,
        length:chromosomeLength,
        chromosomeEnd:chromosomeLength,
        chromosome:cName
        
      });
      
      var featureCanvasL = new org.jax.mgi.kmap.FeatureCanvas({
        scale:theScale,
        height:this.fCanvasHeight,
        width:this.fCanvasWidth, 
        features:[],
        featureMap:[],
        featureHGap:this.featureHGap,
        featureVGap:this.featureVGap,
        initialWidth:this.fCanvasWidth,
        featureWidth:5,
        justify:'LEFT',
        expand:this.expandFeatures,
        length:chromosomeLength,
        chromosomeEnd:chromosomeLength,
        chromosome:cName
       
      });
    
      var axis = new org.jax.mgi.kmap.Axis({
        graduation:5000000,
        scale:theScale,
        length:chromosomeLength,
        height:this.fCanvasHeight,
        chromosomeEnd:chromosomeLength,
        width:40, 
        features:[],
        featureMap:[],
        initialWidth:35,        
        color:'black',
        chromosome:cName
      });  
      // map the chromosome name to its index
      this.nameIndex[cName] = cIndex;
      
      var mapPanel = new org.jax.mgi.kmap.MapPanel({
        //   id:'panel:'+cName,
        title:'<center>Chr'+cName+'</center>',
        border:false,
        items:[axis,featureCanvasL,chromeCanvas,featureCanvasR],
        centerId:chromeCanvas.id,
        bodyStyle:this.bodyStyle,
        // no background for header
        headerCfg:{cls:""}
      });
      mapPanel.doLayout();
      this.mPanels[cIndex] = mapPanel;
      this.relayEvents(mapPanel,['featureMouseOver','featureMouseOut','featureClick','featureRightClick']);
    }  
   
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        this.add(this.mPanels[i]);
      }
    }
    this.doLayout();
    var hideShowData = [];
  
    // get a list of chromosomes to populate the grid
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        hideShowData.push([this.mPanels[i].getLeftTrack(0).chromosome]);
      }
    }  
    this.hideShowStore.loadData(hideShowData);
    for(i = 1; i < this.mPanels.length; i++){	
      if(this.mPanels[i]){
        this.mPanels[i].drawAllFeatures();  
        this.mPanels[i].updateWidth();
      }
    }
    this.layoutChildItems();
    this.showAxis(false);
    
    this.fireEvent('afterBuild', this);
  },
  
  axisCheckHandler:function(item,event){
    this.showAxis(item.checked)
  },
  
  showAxis:function(show){
    for(var i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        if(!show){
          this.mPanels[i].getLeftTrack(0).hide();
          this.mPanels[i].getLeftTrack(0).setWidth(0);
        }else{
          this.mPanels[i].getLeftTrack(0).show();
          this.mPanels[i].getLeftTrack(0).layoutFeatures();
        }
        this.mPanels[i].updateWidth();
      }
    }
    this.layoutChildItems();
  },
  
  overlapFeaturesHandler:function(item,event){
    this.overlapFeatures(!item.checked);
  },
  
  overlapFeatures:function(overlap){
    var i;
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        this.mPanels[i].overlapFeatures(overlap); 
      }        
    }
    this.layoutChildItems();
  },
  
  
  showAllChrHandler:function(item,event){
    if(this.hideEmptyChr == item.checked){
      this.hideEmptyChr = !item.checked;
      Ext.getCmp(this.id+':onlyChrCheck').setChecked(!item.checked,true);
      this.hideEmptyChromosomes();
    }
  },
  
  hideEmptyChrHandler:function(item,event){
    if(this.hideEmptyChr != item.checked){
      this.hideEmptyChr = item.checked;
      Ext.getCmp(this.id+':allChrCheck').setChecked(!item.checked,true);
      this.hideEmptyChromosomes();
    }
  },
  
  hideEmptyChromosomes:function(){
    if(this.featureStore){
      if(this.hideEmptyChr){
        var chromosomes = this.featureStore.collect('chromosome');

        //hide all
        for(var i =1; i < this.mPanels.length; i++){
          if(this.mPanels[i]){
            this.hideChromosome(i,true);
          }
        }
        // show those with data
        for(i = 0; i < chromosomes.length; i++){
          this.hideChromosome(this.nameIndex[chromosomes[i]],false);
        }
      }else{
        //show all
        for(i =1; i < this.mPanels.length; i++){
          if(this.mPanels[i]){
            this.hideChromosome(i,false);
          }
        }
      }
      this.layoutChildItems();
    }
  },
  
  hideShowHandler:function(item,event){
    Ext.getCmp(this.id+':hide/show').hide();
    Ext.getCmp(this.id+':hide/show').findParentByType('menu').hide();
    var sm = this.chromGrid.getSelectionModel();
    var len = this.chromGrid.store.getTotalCount();
    
    for(var i = 0; i < len; i++){
      this.hideChromosome(i+1,sm.isSelected(i));
    }
    this.layoutChildItems();
  },
  
  hideChromosome:function(ch,hide){
    if(!ch){
      return;
    }
    var sm = this.chromGrid.getSelectionModel();
    var index = ch;
    var panel = this.getMPanelByIndex(ch.toString(10));
    if(panel){
      if(!hide){
        if(panel.hidden){
          panel.show();
          panel.updateWidth();
          if(this.chromGrid.rendered){
            sm.deselectRow((index -1));
          }
        }
      }else{
        if(!panel.hidden){
          panel.hide();
          if(this.chromGrid.rendered){
            sm.selectRow((index -1),true);
          }
        }
      }
    }
  },
  
  getColorForStain: function(stain){
    var color = this.stainColors[stain];
    if(color == undefined){
      color = "#FFF";
    }
    return color;
  },
  
  getMPanelByName: function(name){
    return this.mPanels[this.nameIndex[name]];
  },
  
  getMPanelByIndex: function(index){
    return this.mPanels[index];
  },
  
  /**
   * Provide the KaryoPanel with a baking store of feature records
   * <br>Events on this store will be monitored
   * <br>Relays store events add, remove, update, datachanged, load, clear 
   * @method
   * @param {Store} storeIn A store with feature records to display.
   * <br> Requried Fields: chromosome, start, end.<br>
   *  Optional Fields: name, label, link, color, mgiId, track.
   * @return void
   */
  
  setFeatureStore: function(storeIn){
    if(this.featureStore != storeIn){
      this.featureStore = storeIn;
      this.featureStore.addListener({'add':this.storeAdd,scope:this});
      this.featureStore.addListener({'remove':this.storeRemove,scope:this});
      this.featureStore.addListener({'update':this.storeUpdate,scope:this});
      this.featureStore.addListener({'datachanged':this.storeChange,scope:this});
      this.featureStore.addListener({'beforeload':this.beforeStoreLoad,scope:this});
      this.featureStore.addListener({'load':this.storeLoad,scope:this});
      this.featureStore.addListener({'clear':this.storeClear,scope:this});
      this.featureStore.addListener({'exception':this.storeException,scope:this});
      this.featureStoreSortState = this.featureStore.getSortState();  
      this.relayEvents(this.featureStore,['add','remove','update','datachanged','load','clear']);
    }
  },
  
  addFeatures: function(storeIn, clear){
    if(clear){
      this.removeAllFeatures();
    }
    var i;
    for(i = 0; i < storeIn.getCount(); i++){
      var record = storeIn.getAt(i);
      var aFeature = this.recordToFeature(record);
      var p = this.getMPanelByName(aFeature.chromosome);
      if(p){
        p.addFeature(aFeature);
      }
    }      
    this.drawAllFeatures();
  },
  
  // records is a subset of store
  // any duplicates in records need to be removed from both based on mgiId
  // don't remove a feature with null or empty mgiid
  // 
  deduplicateFeatures: function(store,records){
    if(this.deDupOnMgiId){
      store.suspendEvents();
      var i=0, rec=0, record, dedup = [], dupFound=false;
      for(i; i < records.length; i++){
        var recId = records[i].get('mgiid');
        if(recId && recId.length >0){

          while(rec != -1){
            rec = store.findExact("mgiid",records[i].get("mgiid"),rec)
            record = store.getAt(rec);
            if(record != null){
              rec++;
              if(record.id != records[i].id){
                store.remove(records[i]);

                dupFound=true;

              }
            }
          }
        }
        if(!dupFound){
          dedup.push(records[i]);
        }
        dupFound = false;
        rec =0;
        recId ="";
      }
      store.resumeEvents();
      return dedup;
    
    }else{
      // don't deduplicate
      return records;
    }
  },
  
  storeAdd: function(store, records, index){
    //   console.log("store add");
    records = this.deduplicateFeatures(store,records);
    var i;
    for(i =0; i < records.length; i++){
      var aFeature = this.recordToFeature(records[i]);
      var p = this.getMPanelByName(aFeature.chromosome);
      if(p){
        p.addFeature(aFeature);
      }
    }
    this.drawAllFeatures();
  },
  
  storeRemove: function(store, record, index){
    
    var p = this.getMPanelByName(record.get('chromosome'));
    if(p){
      p.removeTrackFeaturesById(record.id);
    }  
    this.drawAllFeatures();
  },
  
  // this should only be for color change via legend?
  storeUpdate: function(store, record, operation){
    //   console.log('store update');
    var aFeature = this.recordToFeature(record);
    var p = this.getMPanelByName(aFeature.chromosome);
    if(p){
      p.paintFeature(record);
    }
  },
  
  beforeStoreLoad:function(store){
    //     console.log('before load');
    this.suppressStoreChange = true; 
  },
  
  storeChange: function(store){ 
    //  console.log("store change");
    //could be sort or filter
    if((this.featureStoreSortState == store.getSortState()) && !this.suppressStoreChange){
      //sort hasn't changed so it is not filter
      this.addFeatures(store,true);
    }
  },
  
  storeException:function(proxy,type,action,options,response,args){
    //   console.log("exception "+type);
  },
  
  storeLoad: function(store, records, options){
    // console.log('store load');
    // store add fires before store load so we don't need this?
    // this.addFeatures(store,false);
    this.suppressStoreChange = false;
    //    console.log(records.length);
  },
  
  storeClear: function(store, records){
    this.removeAllFeatures();
  },
  
  recordToFeature: function(record){
    var color  = record.get("color")
    if(color){
      color = color.replace("0x","#");
    }else{
      color ='green';
    }
     var tr = record.get('track');
      if(tr == null || tr == "null"){
          tr = "R1";
      }
     
    var aFeature = new org.jax.mgi.kmap.Feature({
      id:record.id,
      label:record.get('label'),
      link:record.get('link'),
      chromosome:record.get('chromosome'),
      start:record.get('start'),
      end:record.get('end'),
      width:5,
      minSize:2,
      color:color, 
      name:record.get('name'),
      mgiId:record.get('mgiid'),
      track:tr,
      html:'&nbsp;'});		
    return aFeature;
  },
  
  /**
   * @event removedAllFeatures
   * Fires when all features have been removed from all the chromosomes
   * Does not include cytoband features
   * @param {KaryoPanel} this The KaroPanel.
   */
  removeAllFeatures: function(){
    var i;
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        this.mPanels[i].removeAllTrackFeatures();
      }
    }
    this.fireEvent('removedAllFeatures',this)
  },
  
  drawAllFeatures: function(){
    var i;
    var chromosomes = this.featureStore.collect('chromosome');
    if(this.hideEmptyChr){
      //hide all
      for(i =1; i < this.mPanels.length; i++){
        if(this.mPanels[i]){
          this.hideChromosome(i,true);
        }
      }
      // show those with data
      for(i = 0; i < chromosomes.length; i++){
        this.hideChromosome(this.nameIndex[chromosomes[i]],false);
      }
    }else{ 
      for(i =1; i < this.mPanels.length; i++){
        if(this.mPanels[i]){
          this.hideChromosome(i,false);
        }
      }
    }
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        this.mPanels[i].removeAllFeatureZoomX();
        this.mPanels[i].drawAllTrackFeatures();
      }
    }
    this.layoutChildItems();
    
  },
  
  clear:function(){
    this.featureStore.removeAll();
    this.restore();
  
  },
  
  restore: function(b,e){
    var i;
    for(i =1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        this.hideChromosome(i,false);
      }
    }
    this.layoutChildItems();
    var menu = Ext.getCmp(this.id+":hide/show");
    if(menu){
      for(i = 1; i < menu.items.getCount(); i++){
        menu.items.itemAt(i).setChecked(false,true);
      }
    }
  },
 
  /**
   * Loads banding info from the 'bandFile' config param and displays the chromosomes
   * @method 
   * @return void
   */
  loadBands: function(){
    if(this.bandMaskDiv){
      var bandmask =  new Ext.LoadMask(this.bandMaskDiv, {msg:"Initializing Viewer", removeMask:true, store:this.bandStore});
    }
    this.bandStore.load({callback:this.build, scope:this});
  }, 
  
  
  reloadBands: function(url){
      this.bandStore.removeAll(true);
   
      this.removeAll(true);
      this.mPanels = [];
      this.nameIndex = []; 
      this.bandStore.proxy.setUrl(url,true);
      this.loadBands();
      
  },
  
  // items are layed out in n (default is 2) rows each this.columns long.
  // when an item is hidden the following items
  // fill in its place wrapping across rows
  // child items need to have a param 'anchor:"0%"' to be layed out correctly
  layoutChildItems: function(){
    var layoutX = 0,
    layoutY = 0,
    maxY = 0,
    totalX = 0,
    columnCount = 0;
    for (var i=0; i < this.items.getCount(); i++){
      var c = this.items.itemAt(i);
      if(c.isVisible()){
        c.setPosition(layoutX,layoutY);
        columnCount++;
        layoutX = layoutX + c.getWidth();
        if(c.getHeight() > maxY){
          maxY = c.getHeight();
        }
        if(columnCount == this.columns){
          layoutY = layoutY +  this.fCanvasHeight;
          maxY = 0;
          columnCount = 0;
                        
          //the widest row
          if(totalX < layoutX){
            totalX = layoutX;
          }   
          layoutX = 0;
        }
      }  
    }
    if(totalX < layoutX){
      totalX = layoutX;
    }
    if(columnCount != 0){
      layoutY = layoutY + maxY;
    }
    totalX = totalX * 1.1;
    layoutY = layoutY * 1.15;
                
    if(this.minWidth > totalX){
      totalX = this.minWidth;
    }           
    if(this.minHeight > layoutY){
      layoutY = this.minHeight;
    }    
    
    this.setWidth(totalX);        
    this.setHeight(layoutY);  
  },
  
  exportFeatures: function(){
    var tpl = new Ext.XTemplate('<tpl for="."><{name}>{value}</{name}></tpl>');
    var rec = null;
    var xml ="<features>";
    for(var i =0; i < this.featureStore.getCount(); i++){
      rec = this.featureStore.getAt(i);
      xml = xml + "<feature>"+tpl.apply(this.featureStore.writer.toArray(rec.data))+"</feature>";
    }
    xml = xml +"</features>";    
    document.getElementById("exportXML").value=xml;
    document.getElementById("exportForm").submit();
  },
  
  /**
   * Opens a new window with the chromosomes and features rendered into a single jpg
   * @method 
   * @return void
   */
  exportImage: function(){
    if(Ext.isIE ){
      Ext.Msg.alert('This feature is not suppored Internet Explorer','Export as an image is not available for Internet Explorer');
      return;
    }
    var eIWindow = new Ext.Window({
      closeable:true,
      resizeable:true,
      headerAsText:true,
      title:'Right click on image to save',
      html:'<div id="elDiv" ><canvas id ="elCanvas" width='+this.getWidth()+', height = '+this.getHeight()+'></canvas></div>',    
      bodyStyle:'background-color:white'
    });
    eIWindow.show();
   
    var i, j, panel, ctx, iData, totalWidth=0, width =0, height=10, count=0;
    var myCtx = document.getElementById("elCanvas").getContext("2d");
    for(i = 1; i < this.mPanels.length; i++){
      if(this.mPanels[i]){
        if(count == this.columns){
          height = this.fCanvasHeight;
          totalWidth = 0;
        }
        if(!this.mPanels[i].hidden){
          count++;
          for(j = 0; j < this.mPanels[i].items.getCount(); j++){
            panel = this.mPanels[i].items.get(j);
            if(!panel.hidden){
              ctx = panel.canvas.getContext('2d');
              width = panel.canvas.width;
              if(width > panel.getWidth()){
                width = panel.getWidth();
              }
              iData = ctx.getImageData(0,0,width,panel.canvas.height);
              myCtx.putImageData(iData,totalWidth,height);
              if(j == this.mPanels[i].centerIndex){
                myCtx.fillStyle= "black";
                myCtx.textBaseline = 'middle';
                myCtx.fillText(panel.chromosome,totalWidth,height);
              }
              totalWidth = totalWidth + width ;
            }   
          }
        }
      }
    }
    myCtx.fillStyle= "black";
    height = this.getHeight() - 30;
    myCtx.fillText('Image produced by MTB Viewer',10,height);
    var img  = document.getElementById("elCanvas").toDataURL("image/png");
     eIWindow.setPosition(50,50);
     document.getElementById("elDiv").innerHTML ='<img src="'+img+'"/>';
   
  },       
  
  /**
   * Removes all features in a group
   * @method 
   * @param {String} group The name of the group to remove.
   * @return void
   * Updates the view and fires a featuresRemoved event.
   */
  removeGroup:function(group){
    // use a regexp for exact match    
    var recs = this.featureStore.query('group',new RegExp('^' + group + '$'),false);
    this.featureStore.suspendEvents();
   
    recs.each(function(item,index,length){
      var p = this.getMPanelByName(item.get('chromosome'));
      p.removeTrackFeaturesById(item.id);
      // not really sure why this needs to happen
      // but this.featureStore.remove(recs) doesn't remove the records
      this.featureStore.data.remove(item);
    },this);
    this.featureStore.resumeEvents();
    this.fireEvent('featuresRemoved',recs);
    this.drawAllFeatures();
  },
  
  /**
   * Changes the track of a group
   * @method 
   * @param {String} group The name of the group to change.
   * @param {String} track The track <L|R># for the group.
   * @return void
   * Updates the displayed features.
   */
  
  changeGroupTrack:function(group,track){
    this.featureStore.suspendEvents();
    var recs = this.featureStore.query('group',new RegExp('^' + group + '$'),false);
    recs.each(function(item,index,length){
      item.set('track',track);
    },this);
    this.featureStore.resumeEvents();
    this.addFeatures(this.featureStore,true);
  },
  
  /**
   * Changes the color of a group
   * @method 
   * @param {String} group The name of the group to change.
   * @param {String} color The new color for the group.
   * @return void
   * Updates the displayed features.
   */
  changeGroupColor:function(group,color){
    var recs = this.featureStore.query('group',new RegExp('^' + group + '$'),false);
    recs.each(function(item,index,length){
      item.set('color',color);
    },this); 
  }
});

Ext.reg('karyopanel',org.jax.mgi.kmap.KaryoPanel);
Ext.reg('feature',org.jax.mgi.kmap.Feature);
Ext.reg('featurecanvas',org.jax.mgi.kmap.FeatureCanvas);
Ext.reg('mappanel',org.jax.mgi.kmap.MapPanel);    
Ext.reg('axis',org.jax.mgi.kmap.Axis);

