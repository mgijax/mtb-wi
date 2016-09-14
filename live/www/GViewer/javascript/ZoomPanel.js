Ext.ns('org.jax.mgi.kmap');

/**
 * @class org.jax.mgi.kmap.ZoomPanel
 * @extends Ext.Container
 * Displayed a 'zoomed in' section of a MapPanel.
 * Allows for scrolling along a MapPanel at differnt levels of magnification.
 * Displays a zoom tool tip based on click events from FeatureCanvases where showZoomTip is true <br/>
 * @author Steven Neuhauser
 * @version 1.0
 */

org.jax.mgi.kmap.ZoomPanel = Ext.extend(Ext.Container,{
  
  /**
   * @cfg {Number} minWidth The minimum size the panel will be when displayed.
   * <br>Default 110
   */ 
  minWidth:110,
  
  /**
   * @cfg {KaryoPanel} kPanel The the KaryoPanel this is assoicated with.
   * <br> Listens to events from this panel
   * <br>Default Null : Required
   */ 
  kPanel:null,
  
  /**
   * @cfg {Number} scrollInterval The fraction of the length displayed to move with each scroll.
   * <br>Default 80
   */ 
  scrollInterval:80, 
  
  /**
   * @cfg {Number} scrollSpeed The time in ms to defer calls to scroll when in a scroll loop.
   * <br>Default 50
   */ 
  scrollSpeed:50,  
  
  // folowing should be considered private
  
  maxSize:0, // size (height) of the zoomMapPanel
  length:0,  // size (height) of the KaryoPanel
  scale:0,
  start:0,
  end:0,
  mapPanel:null, // the map panel to be zoomed in on
  layout:'auto',  // don't change this
  zoomMapPanel:null, // the mapPanel to display the zoom
  graduation:0,
  scrolling:false,
  scrollingDown:true,
  chromosome:'',
  cLength:0,
  
  initComponent: function(){
    org.jax.mgi.kmap.ZoomPanel.superclass.initComponent.apply(this,arguments);  
    
    //   this.kPanel.addListener({'featureClick':this.showZoomTip,scope:this});
    this.kPanel.addListener({'featuresRemoved':this.removeFeatures,scope:this});
    this.kPanel.addListener({'removedAllFeatures':this.clear,scope:this});
    this.kPanel.addListener({'load':this.redraw,scope:this});
    this.kPanel.addListener({'update':this.updateFeature,scope:this});
    
   
  },
  
  zoom: function(start, basePairs){
    this.mapPanel = this.kPanel.getMPanelByName(this.chromosome);
    
    this.start = start;
    this.maxSize = this.length -25; // about the size of the header and vgap
    var scale = this.maxSize / basePairs;
 
    this.end = start + basePairs;
    
    this.scale = scale;
    this.reset();
    this.updateTitle();
  
    this.zoomMapPanel.doLayout(); 
    this.zoomMapPanel.drawAllFeatures();
    
    this.doLayout();
   
    if(this.mapPanel.getCenter()){
      this.mapPanel.getCenter().showZoomIndicator(this.start,this.end);
    } 
  },
  
  // called when all features are removed from the kPanel
  // hides zoom panel and removes indicator
  clear:function(){
    this.hide();
    this.end = 0;
    if(this.mapPanel){
      this.mapPanel.getCenter().removeZoomIndicator();
      this.mapPanel.removeAllFeatureZoomX();
    }
    this.mapPanel = null; 
  },
  
  redraw:function(){
    if(this.mapPanel){
      this.scrollCanvas(this.start,this.end);
    }
  },
  
  highlightFeature:function(record){
    var zRecord = record.copy();
    zRecord.id = 'zoom:'+zRecord.id;
    if(this.zoomMapPanel){
      this.zoomMapPanel.highlightFeature(zRecord);
    }
  },
  
 
  
  // allows the zoom panel to be configure by dragging the zoom region
  configure: function(start, zoom, chromosome){
    
    this.length = this.kPanel.getHeight();
    var grid = Ext.getCmp('featureGrid');
    if(grid){
      this.length = this.length + grid.getHeight();
    }
    
   
    this.chromosome = chromosome;

    if(this.mapPanel){
      this.mapPanel.removeAllFeatureZoomX();
      this.mapPanel.getCenter().removeZoomIndicator();
    }
 
    this.show();
    this.setHeight(this.length);
    this.zoom(start, zoom); 
    //new
    this.scrollCanvas(this.start,this.end);
    
  },
    
  updateTitle: function(){
    // don't want the title rounded up
    // but want 2 decimal precision
    var title = Math.floor( this.start / 10000);
    title = title / 100;
    title = title.toFixed(2);
    title = title +"Mbp";
    this.zoomMapPanel.setTitle('Ch:'+this.chromosome+'@'+title);
    this.zoomMapPanel.doLayout();
  },
  
  incrementScroll: function(){
    if(this.scrolling){
      this.scrolling = false;
      this.scrollSpeed = this.scrollSpeed - 30;
      if(this.scrollSpeed < 5){
        this.scrollSpeed = 5;
      }
      this.scrolling = true;
    }else{
      this.scrollInterval = this.scrollInterval / 2;
      if(this.scrollInterval < 2){
        this.scrollInterval = 2;
      }
    }
  },
  
  decrementScroll:function(){
    if(this.scrolling){
      this.scrollSpeed = this.scrollSpeed + 30;
      if(this.scrollSpeed > 320){
        this.scrollSpeed = 320;
      }
    }else{
      this.scrollInterval = this.scrollInterval * 2;
      if(this.scrollInterval > 80){
        this.scrollInterval = 80;
      }
    }
  },
  
  resetScroll:function(){
    this.scrollInterval = 80;
    this.scrollSpeed = 50;
  },
  
  up:function(b,e){
    this.scrollingDown = false;
    var length = this.end - this.start;
    var start = Math.floor( this.start - (length/this.scrollInterval));
    if(start < 0){
      start = 0;
      this.scrolling = false;
    }
    var end = start + length;
    this.scrollCanvas(start,end);
  },
  
  down:function(b,e){
    this.scrollingDown = true;
    var length = this.end - this.start;
    var start = Math.floor( this.start + (length/this.scrollInterval));
    var end = start + length;
    if((this.cLength > 0) && ((end - (length/4)) > this.cLength )){
      this.scrolling = false;
    }else{
      this.scrollCanvas(start,end);
    }
  },
  
  gear:function(b,e){
    this.scrollInterval = 80;
    this.scrolling = ! this.scrolling;
    if(this.scrolling){
      this.scrollLoop(b,e);
    }
  },
  
  scrollLoop:function(b,e){
    if(this.scrolling){
      if(this.scrollingDown){
        this.down(b,e);
      }else{
        this.up(b,e);
      }
      this.scrollLoop.defer(this.scrollSpeed,this,[b,e]);
    }
  },
  
  /**
   * @event featureMouseOver
   * Relayed from each zoomed FeatureCavas
   */
  /**
   * @event featureMouseOut
   * Relayed from each zoomed FeatureCavas
   */
  /**
   * @event featureClick
   * Relayed from each zoomed FeatureCavas
   */
  /**
   * @event featureRightClick
   * Relayed from each zoomed FeatureCavas
   */
  reset: function(){
    if(this.zoomMapPanel){ 
      this.zoomMapPanel.removeAllTracks();
      
    }
    this.removeAll(true);
    this.mapPanel.removeAllFeatureZoomX();
    var i,items = [];
    for(i = 0 ; i <  this.mapPanel.items.getCount() ; i++){
      items.push(this.copyTrack(this.mapPanel.get(i)));
    }
    this.zoomMapPanel = new org.jax.mgi.kmap.MapPanel({x:0,y:0, 
      tools:[{ 
          id:'up',
          handler:this.up,
          scope:this
        },
        { 
          id:'down',
          handler:this.down,
          scope:this
        },
        {
          id:'gear',
          handler:this.gear,
          scope:this,
          qtip:'scroll'
        },
        {
          id:'plus',
          handler:this.zoomIn,
          scope:this
        
        },
        {
          id:'minus',
          handler:this.zoomOut,
          scope:this
        },
        {
          id:'close',
          handler:this.close,
          scope:this
        }          
      ],
      
      headerStyle:'align:left',
      minWidth:this.minWidth,
      items:items,
      centerId:'zoom:'+this.mapPanel.centerId
    });
    this.add(this.zoomMapPanel);
    this.doLayout();
    this.zoomMapPanel.doLayout();
    this.relayEvents(this.zoomMapPanel,['featureMouseOver','featureMouseOut','featureClick','featureRightClick']);
  },
  
  
  // can't we just call clear?
  close:function(){
    this.hide();
    this.end = 0;
    if(this.mapPanel.getCenter()){
        this.mapPanel.getCenter().removeZoomIndicator();
        this.mapPanel.removeAllFeatureZoomX();
    }
    this.mapPanel = null;
    
  },
  
  // these two functions need some sanity checking if they are going to be used
  // this.cLength is the total length of the chromosome 
  
  zoomIn:function(){
  
    var bp =Math.floor((this.end - this.start) / 2);
    // zoom more than this things get ugly
    if(bp >= 500){
      var middle = this.start + bp/2;
      if(middle > this.cLength){
        middle = this.start;
      }
      this.zoom(middle,bp);
      //new
      this.scrollCanvas(this.start,this.end);
    }
    
   
  },
  
  zoomOut:function(){
   
    var bp =Math.floor(this.end - this.start);
    var newStart = this.start - bp/2;
    if(newStart < 0){
      newStart = 0;
    }
    this.zoom(newStart, bp*2);
    //new
    this.scrollCanvas(this.start,this.end);
  },
  
  scrollCanvas: function(start,end){
    
    this.start = start;
    this.end = end;
    var i;
    for(i = 0 ; i <  this.zoomMapPanel.items.getCount() ; i++){
      this.updateTrack(this.zoomMapPanel.items.get(i));  
    }
    this.doLayout();
    this.zoomMapPanel.doLayout(); 
    this.zoomMapPanel.drawAllFeatures();
    this.updateTitle();
    if(this.mapPanel.getCenter()){
      this.mapPanel.getCenter().showZoomIndicator(this.start,end);
    }
    
  },
  
  updateTrack:function(canvas){
    canvas.clear(true,true);
    if(canvas.isAxis){
      canvas.start = this.start;
      canvas.configure();  
    }else{
      canvas.start = this.start;
      var dataCanvasId = canvas.id.substring(5); // id follows 'zoom:' prefix
      canvas.features = this.zoomFeatures(Ext.getCmp(dataCanvasId).features);
    }
  },
  
  copyTrack: function(canvas){
    var newCanvas;
    if(canvas.isAxis){
      this.cLength = canvas.length;
      newCanvas = this.copyAxis(canvas);
    }else{
      newCanvas = this.copyCanvas(canvas);
      newCanvas.features = this.zoomFeatures(canvas.features);
    }    
    return newCanvas;    
  },
  
  copyAxis: function(canvas){
    
    var newAxis = new org.jax.mgi.kmap.Axis({
      id:'zoom:'+canvas.id,
      graduation:canvas.graduation,
      start:this.start,
      scale:this.scale,
      length:this.end - this.start,
      chromosomeEnd:canvas.chromosomeEnd,
      height:this.maxSize,
      // width of the ext component
      width:canvas.width, 
      // with of underlying html canvas element
      // may need to display long labels for bp ie '175.25'
      canvasWidth:canvas.canvasWidth+15,
      features:[],
      featureMap:[],
      initialWidth:canvas.initialWidth,        
      color:canvas.color,
      chromosome:canvas.chromosome,
      calcGraduation:true,
      karyoPanelId:canvas.karyoPanelId,
      zoomTip:false,
      labelPrecision:2
    });
    return newAxis;
  },
  
  copyCanvas: function(canvas){
    var expand = true;
    if(canvas.isBanding){
        expand = false;
    }
    var newCanvas = new org.jax.mgi.kmap.FeatureCanvas({
      id:'zoom:'+canvas.id,
      height:this.maxSize,
      width:canvas.width, 
      featureHGap:canvas.featureHGap,
      featureVGap:canvas.featureVGap,
      scale:this.scale,
      features:[],
      featureMap:[],
      topMargin:canvas.topMargin,
      featureWidth:canvas.featureWidth,
      initialWidth:canvas.initialWidth,
      expand:expand,
      curvePx:canvas.curvePx,
      justify:canvas.justify,
      chromosome:canvas.chromosome,
      start:this.start
    });
    return newCanvas;
  },
  
  zoomFeatures: function(features){
    var i,newFeature,newFeatures= [];
    for(i = 0; i < features.length; i++){
      
      // don't show the zoom indicator
      if(!features[i].isZoomRegion){
      
        // features that start within the zoom region
        if((features[i].start >= this.start)
          && features[i].start < this.end){
          newFeature = this.copyFeature(features[i]);
          if(features[i].end > this.end){
            //truncate the end
            newFeature.curvedBottom = false;
            newFeature.end = this.end;
          }
          newFeatures.push(newFeature);
        }
        // features that start before the zoom region
        if((features[i].start < this.start) &&
          features[i].end > this.start){
          newFeature = this.copyFeature(features[i]);
          newFeature.start = this.start;
          newFeature.curvedTop = false;
          if(newFeature.end > this.end){
            newFeature.end = this.end;
          }
          newFeatures.push(newFeature);
        }
      }
    }
    return newFeatures;
  },
  
  copyFeature: function(theFeature){
    var newFeature = new org.jax.mgi.kmap.Feature({
      id:'zoom:'+theFeature.id,
      label:theFeature.label,
      link:theFeature.link,
      chromosome:theFeature.chromosome,
      start:theFeature.start,
      end:theFeature.end,
      name:theFeature.name,
      mgiId:theFeature.mgiId,
      color:theFeature.color,
      width:theFeature.width,
      minSize:theFeature.minSize,
      curvedTop:theFeature.curvedTop,
      curvedBottom:theFeature.curvedBottom,
      parent:theFeature
    });
    
    return newFeature;
  },
  
  // recs is a mixed collection
  removeFeatures: function(recs){
    if(this.zoomMapPanel){
      recs.each(function(obj,index,length){
        if(this.chromosome == obj.get('chromosome')){
          var zRecord = obj.copy();
          zRecord.id = 'zoom:'+zRecord.id;
          if(this.zoomMapPanel){
            this.zoomMapPanel.removeTrackFeaturesById(zRecord.id);
          }
        }
      },this);
    
      this.zoomMapPanel.drawAllFeatures();
    }
  },
  
  updateFeature: function(store,record,operation){
    if(this.chromosome == record.get('chromosome')){
      var zRecord = record.copy();
      zRecord.id = 'zoom:'+zRecord.id;
      if(this.zoomMapPanel){
        this.zoomMapPanel.paintFeature(zRecord);
      }
    }
  }
});