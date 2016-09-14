Ext.ns('org.jax.  mgi.kmap');


/**
 * @class org.jax.mgi.kmap.FeatureGrid
 * @extends Ext.grid.EditorGridPanel
 * A grid to display Features from a KaryoPanel
 * Features in grid are pulled from the KaryoPanel provided as a config parameter
 * @author Steven Neuhauser
 * @version 1.0
 */
org.jax.mgi.kmap.FeatureGrid =  Ext.extend(Ext.grid.EditorGridPanel,{
  /**
   * @cfg {KaryoPanel} kPanel The the backing KayroPanel
   * <br>Required
   */
  kPanel:null,
  hideTopToolbar:false,
  stripeRows: true,
  clicksToEdit: 1,
  editable:false,
  height:180,
  store:null,
  fixedWidth:false,
  cm:null,
      
  initComponent: function(){
    
    this.selModel = new Ext.grid.RowSelectionModel(),
    
    org.jax.mgi.kmap.FeatureGrid.superclass.initComponent.apply(this,arguments);
    
    this.kPanel.on('afterBuild',this.configureChromosomes,this);
    this.kPanel.on('load',this.addAllFeatures,this); 
    this.kPanel.on('clear',this.clearFeatures,this);
    
    this.kPanel.on('featuresRemoved',this.removeFeatures,this);
    
    this.on('rowdblclick',this.rowDblClick,this);
   
    var tb = this.getTopToolbar();

    if(this.hideTopToolbar){
      tb.hide();
    }else{
      tb.add({
        text: 'Create New',
        handler : this.createNewFeature,
        scope:this
      });
      tb.add(new Ext.Toolbar.Separator());
      tb.add(
      {text: 'Add / Remove',
        menu:{      
          id:this.id+':add/remove',          
          items:[]
        }
      });

      tb.add(new Ext.Toolbar.Separator());

      tb.add({text:'Add from Zoom',
        handler:this.addZoomedFeatures,
        scope:this});

      tb.add(new Ext.Toolbar.Separator());

      tb.add({text:'Remove Selected',
        handler:this.removeSelectedFeatures,
        scope:this});

      tb.add(new Ext.Toolbar.Separator());

      tb.add({text:'Delete Selected',
        handler:this.deleteSelectedFeatures,
        scope:this});

      tb.add(new Ext.Toolbar.Separator());

      tb.add({text:'Export Features',
        handler:this.exportFeatures,
        scope:this});
      
      tb.add(new Ext.Toolbar.Separator());
      
      tb.add({text:'Downloadable Image',
        handler:this.exportImage,
        scope:this});
    }
     
    this.store = new ChromosomeStore({
      autoDestroy: true,
      record: 'feature', 
      autoLoad: false,
      writer: new Ext.data.XmlWriter({writeAllFields:true}),
      proxy: new Ext.data.HttpProxy({url:''}),
      fields: [
        'id',
        'chromosome',
        'start',
        'end',
        'type',
        'color',
        'description',
        'link',
        'mgiid',
        'name',
        'group',
        'track',
        'source',
        'score',
        'strand',
        'phase'
      ],
      data:[],
      idIndex:0,
      autoSave:false
    });
    
    this.view = new Ext.grid.GridView({forceFit:true});
    
    this.cModel = new Ext.grid.ColumnModel({columns:[
        {id:'Chr',header: 'Chr', width:30, sortable: true, dataIndex: 'chromosome', editor: new Ext.form.TextField()},
        {header: 'Start', width:85, sortable: true, dataIndex: 'start', editor: new Ext.form.TextField()},
        {header: 'End', width:85, sortable: true, dataIndex: 'end', editor: new Ext.form.TextField()},
        {header: 'Type', width:60, sortable: true, dataIndex: 'type', editor: new Ext.form.TextField()},
        /*      {header: 'Color', width: 80, sortable: true, dataIndex: 'color',
          editor: new Ext.form.ComboBox({
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            listClass: 'x-combo-list-small',
            mode:'local',
            store: new Ext.data.ArrayStore({
              id: 0,
              fields: [
                'color'
              ],
              data: [['Blue'], ['Green'],
                ['Orange'], ['Pink'],
                ['Red'], ['Yellow'],['White']
              ]
            }),
            valueField: 'color',
            displayField: 'color'})
        }, */
        {header: 'Name', width:80, sortable: true,  dataIndex: 'name', editor: new Ext.form.TextField(),
          renderer:function(value, metaData, record, rowIndex, colIndex, store) {
            var newLink = record.get('link').replace(/%26/g,"&");
            if(newLink.indexOf('http')== -1){
              newLink = this.kPanel.localLink+newLink;
            }
            return "<a href='"+newLink+"' target='_blank'>"+value+"</a>";
          },
          scope:this
        },
        {id:'description',header: 'Description',width:100, sortable:true, dataIndex:'description', editor: new Ext.form.TextField()},
        {id:'group',header: 'Group',width:60,  sortable:true, dataIndex:'group', editor: new Ext.form.TextField()},
        {id:'mgiid',header: 'MGI ID',width:70, sortable:true, dataIndex:'mgiid'} //,
        //     {header: 'Link', width: 100, sortable: true, dataIndex: 'link', editor: new Ext.form.TextField()}
      ]});
    
    if(!this.editable){
      var i,cols = this.cModel.getColumnCount();
      for(i = 0; i < cols; i++){
        this.cModel.setEditable(i,false);
      }
    }
       
    this.reconfigure(this.store,this.cModel);
    this.getBottomToolbar().bind(this.store);  
          
    this.addListener("afterRender", function(p){
      this.updateWidth();
      this.doLayout();
      this.store.on('update',this.featureUpdate, this);
      this.kPanel.on('resize',this.updateWidth,this);
      this.kPanel.on('featureClick',this.selectFeature,this);
      
      this.getBottomToolbar().doLayout();
      this.getBottomToolbar().doRefresh();
    });
  },
  
  updateWidth:function(){
    if(!this.fixedWidth){
      this.setWidth(this.kPanel.getWidth());
    }
  },
  
  configureChromosomes:function(){
    var i,gridMenu = Ext.getCmp(this.id+":add/remove");
    if(gridMenu){
      gridMenu.add(
      new Ext.menu.CheckItem({
        text:'All', 
        checked:false, 
        handler:this.addRemoveGridFeatureHandler, 
        scope:this}));

      for(i = 1; i < this.kPanel.mPanels.length; i++){

        gridMenu.add(
        new Ext.menu.CheckItem({id:this.id+':addRemove'+this.kPanel.mPanels[i].id.substring(6),
          text:this.kPanel.mPanels[i].title, 
          checked:false, 
          handler:this.addRemoveGridFeatureHandler, 
          scope:this}));
      }
    }
  },
  
  featureUpdate: function(store, record, type){
    if(!this.kPanel.featureStore.getById(record.id)){
      if( (record.get('chromosome') != "0" ) && (record.get('end') != "0") &&
        (record.get('color') != null) && (record.get('start') != "0")){
        // if the chromosome exists
        if(this.getMPanelByName(record.get('chromosome'))){
          this.getMPanelByName(record.get('chromosome'))
          .getRightTrack(0).addFeature(this.recordToFeature(record));
          this.getMPanelByName(record.get('chromosome'))
          .getRightTrack(0).drawFeatures();
          this.kPanel.featureStore.add(record.copy());
        }
      }
    }else{
      this.kPanel.featureStore.removeAt(this.kPanel.featureStore.indexOfId(record.id));
      this.kPanel.featureStore.add(record.copy());
      var feature = this.recordToFeature(record);
    }
  },
  
  createNewFeature: function(){
    // access the Record constructor through the grid's store
    var Feature = this.store.recordType;
    var f = new Feature({
      id:'feature'+this.store.getTotalCount(),
      chromosome:0,
      start: 0,
      end:0,
      type:'user defined'
    });
    f.id = f.get('id');
    this.stopEditing();
    this.store.insert(0, f);
    this.startEditing(0, 0);
  },
  
  addRemoveGridFeatureHandler:function(item,event){
    var chromosome = item.id.substring(9);
    var add = !item.checked;
    this.addRemoveGridFeatures(chromosome,add);
  },
  
  addAllFeatures:function(){
    this.store.removeAll(true);
    this.addRemoveGridFeatures('All',true);
  },
  
  removeFeatures:function(recs){
    for(var i = 0; i < recs.getCount(); i++){
     
      this.store.remove(this.store.getById(recs.get(i).id));
    
    }
      
    this.getBottomToolbar().doRefresh();
    this.getBottomToolbar().moveFirst();
    
  },
  
  addRemoveGridFeatures:function(chromosome, add){
    var features = [];
    var feature = null;
    var all = false;
    var i;
    if(chromosome == 'All'){
      all = true;
    }
    if(add){ 
      for(i = 0; i < this.kPanel.featureStore.getCount(); i++){
        feature = this.kPanel.featureStore.getAt(i);
        if((feature.get('chromosome') == chromosome) || all){
          features.push(feature.copy());
        }
      }
      this.store.suspendEvents();
      this.store.add(features);
      this.store.resumeEvents();
    }else{
      // can't remove while iterating though the list 
      // get all features to remove then remove 
      for(i = 0; i < this.store.getTotalCount(); i++){
        feature = this.store.allData.get(i);
        if((feature.get('chromosome') == chromosome) || all){
          features.push(feature);
        }
      }
      for(i = 0; i < features.length; i++){
        this.store.allData.remove(features[i]);
      }
    }
    if(all){
      var menu = Ext.getCmp(this.id+":add/remove");
      // index 0 is the All button so skip it
      if(menu){
        for(i = 1; i < menu.items.getCount(); i++){
          menu.items.itemAt(i).setChecked(add,true);
        }
      }
    }
    this.getBottomToolbar().doRefresh();
    this.getBottomToolbar().moveFirst();
  },
  
  selectFeature:function(event,mbp,feature,canvas){
    var id = feature.id;
    if(id.indexOf('zoom') != -1){
      id = id.substring(5);
    }
    if(this.store.getById(id)){
      var index = this.store.allData.indexOfKey(id);
      var page = Math.floor(index /this.getBottomToolbar().pageSize) + 1;
      this.getBottomToolbar().changePage(page);
      var records = [];
      var record = this.store.getById(id);
      records.push(record);
      // changePage is asynchronous and clears selected rows
      // give it 50ms and then select the row
      this.selectRow.defer(50,this,[records]);
    }
  },
       
  selectRow:function(records){
    this.getSelectionModel().selectRecords(records);
  },
  
  rowDblClick:function(grid, index, event){
    var record = grid.getStore().getAt(index);
    this.kPanel.highlightFeature(record.id);
    var zoomPanel  = Ext.getCmp('zoomPanel');
    if(zoomPanel){
      zoomPanel.highlightFeature(record); 
    }
  },
  
  removeSelectedFeatures:function(){ 
    this.store.remove(this.getSelectionModel().getSelections());
    this.getBottomToolbar().doRefresh();
  },
  
  deleteSelectedFeatures:function(){ 
    var i,selections = this.getSelectionModel().getSelections();
    this.store.remove(selections);
    var recs = [];  
    for(i = 0; i < selections.length; i++){
      recs.push(this.kPanel.featureStore.getById(selections[i].id));
    }
    this.kPanel.featureStore.remove(recs);
    this.getBottomToolbar().doRefresh();
  },
  
  clearFeatures:function(){
    this.store.removeAll();
    this.getBottomToolbar().doRefresh();
    
  },
  
  addZoomedFeatures:function(){
    var i,zFeatures =[];
    var fRecords = [];
    var FeatureType = this.store.recordType;
    var zoomPanel  = Ext.getCmp('zoomPanel');
    if(zoomPanel.zoomMapPanel){
      zFeatures = zoomPanel.zoomMapPanel.getAllTrackFeatures();
      for(i = 0 ; i < zFeatures.length; i++){
        var record = new FeatureType({
          id:zFeatures[i].id,  // zoom features once had id 'zoom:'+id?
          chromosome:zFeatures[i].chromosome,
          start:zFeatures[i].start,
          end:zFeatures[i].end,
          type:zFeatures[i].type,
          name:zFeatures[i].name,
          link:zFeatures[i].link,
          label:zFeatures[i].label,
          color:zFeatures[i].color,
          mgiId:zFeatures[i].mgiId
        });
        record.id = record.get('id');
        fRecords.push(record);
      }
      this.store.add(fRecords);
    }
    this.getBottomToolbar().doRefresh();  
  }
  
  
});

// class extends sortData method so chromosomes are
// sorted correctly
ChromosomeStore = Ext.extend( Ext.ux.data.PagingArrayStore,{
  
  sortData: function () {
    var sortInfo = this.hasMultiSort ? this.multiSortInfo : this.sortInfo,
    direction = sortInfo.direction || "ASC",
    sorters = sortInfo.sorters,
    sortFns = [];
    if (!this.hasMultiSort) {
      sorters = [{
          direction: direction,
          field: sortInfo.field
        }];
    }
    var i,j;
    for (i = 0, j = sorters.length; i < j; i++) {
      sortFns.push(this.createSortFunction(sorters[i].field, sorters[i].direction));
    }
    if (!sortFns.length) {
      return;
    }
    var directionModifier = direction.toUpperCase() == "DESC" ? -1 : 1;
    var fn = function (r1, r2) {
      var result = sortFns[0].call(this, r1, r2);
      if (sortFns.length > 1) {
        for (i = 1, j = sortFns.length; i < j; i++) {
          result = result || sortFns[i].call(this, r1, r2);
        }
      }
      return (directionModifier * result);
    };
    // added for chromosome sorting
    if(sortInfo.field == 'chromosome'){
      var fn = function(a,b){
        a = a.get('chromosome');
        b = b.get('chromosome');
        var aVal,bVal;
        if(isNaN(a)){
          if(String(a).toUpperCase() == 'X'){
            aVal = 100;
          }
          if(String(a).toUpperCase() == 'Y'){
            aVal = 200;
          }
        }else{
          aVal = parseInt(a,10); 
        }
        if(isNaN(b)){
          if(String(b).toUpperCase() == 'X'){
            bVal = 100;
          }
          if(String(b).toUpperCase() == 'Y'){
            bVal = 200;
          }
        }else{
          bVal = parseInt(b,10);
        }
        return aVal > bVal ? 1 : (aVal < bVal ? -1 : 0);
      };
    }
    if (this.allData) {
      this.data = this.allData;
      delete this.allData;
    }
    this.data.sort(direction, fn);
    if (this.snapshot && this.snapshot != this.data) {
      this.snapshot.sort(direction, fn);
    }
    this.applyPaging();
  }
});
      