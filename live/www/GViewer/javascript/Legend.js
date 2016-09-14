Ext.ns('org.jax.mgi.kmap');


/**
 * @class org.jax.mgi.kmap.Legend
 * @extends Ext.Panel
 * Provides a color coded legend for each group displayed in the viewer.
 * Groups can have their color and track changed or can be removed.
 * Configured by passing an instance of the KaryoPanel as a config param
 * @author Steven Neuhauser
 * @version 1.0
 */
org.jax.mgi.kmap.LegendPanel = Ext.extend(Ext.Panel,{
  
 
   /**
   * @cfg {KaryoPanel} kPanel The the backing KayroPanel
   * <br>Required
   */
  karyoPanel:null,
  
  html:'<div id="legendPanelDiv"></div>',
  legendTip:null,
  legendForm:null,
  
   initComponent: function(){                                         
    org.jax.mgi.kmap.MapPanel.superclass.initComponent.apply(this,arguments); 
    
    this.karyoPanel.featureStore.addListener({'clear':this.clearLegend,scope:this});
    this.karyoPanel.featureStore.addListener({'add':this.createLegend,scope:this});
    
    
     this.legendTip =  new Ext.Tip({
      layout:'fit',
      target: this.id,
      anchor: 'right',
      trackMouse: true,
      autoHide: false,
      closable: true,
      draggable:true,
      width:230,
      title: '',
      header:true
    });
     
    this.legendForm = new Ext.FormPanel({
      autoHeight: true,
      labelWidth: 40,
      items: [
        { xtype: 'radiogroup',
          id:'track',
          fieldLabel: 'Track',
          name:'track',
          allowBlank:false,
          items: [
            {id:'leftTrack',boxLabel: 'Left of Chromosome', name: 'track', inputValue: 'L'},
            {id:'rightTrack',boxLabel: 'Right of Chromosome', name: 'track', inputValue: 'R', checked:true}         
          ]},
 //       { xtype:'numberfield',
 //         id:'tIndex',
 //         value: '1',
 //         fieldLabel:'Index',
 //         name:'tIndex',
 //         minValue:1,
 //         width:40
 //       },
        { xtype:'combo',
          id:'color',
          name:'color',
          fieldLabel:'Color',
          store: new Ext.data.ArrayStore({
            fields: ['color'],
            data: [ 
              ['aqua']
              ,['black']
              ,['blue']
              ,['fuchsia']
              ,['grey']
              ,['green']
              ,['lime']
              ,['maroon']
              ,['navy']
              ,['olive']
              ,['purple']
              ,['red']
              ,['silver']
              ,['teal']
              ,['white']
              ,['yellow']
            ]
          }),
          valueField: 'color',
          displayField: 'color',
          mode:'local',
          triggerAction:'all'
        }
      ],
      buttons: [{
          text: 'Change',
          handler:this.changeGroupHandler,
          scope:this
        },{
          text: 'Remove',
          handler:this.removeGroupHandler, 
          scope:this
        }]
    });
    this.legendTip.add(this.legendForm);
    this.legendTip.doLayout();
    this.legendTip.hide(); 
    
    
    
   },
   
   clearLegend:function(){
     Ext.DomHelper.overwrite('legendPanelDiv','');
     this.collapse();
   },
  
   createLegend:function(){
      var i,legendHTML ='<table>';
      var groups = this.karyoPanel.featureStore.collect('group').sort();
      for(i = 0 ; i < groups.length; i++){
        // color is Ox rather than # as in current viewer not sure where it gets changed
        // groups with more than one color will be legended by the first color to be returned
        var color = this.karyoPanel.featureStore.getAt(this.karyoPanel.featureStore.findExact('group',groups[i])).get('color');
        color  = color.replace("0x","#");
        
        legendHTML = legendHTML + "<tr><td><div id ='"+groups[i]+"' style='background-color:"+color
          + ";width:10px; height:15px'></div></td><td nowrap='nowrap'>" +groups[i] + "</td></tr>\n";
      } 
      legendHTML = legendHTML+ '<tr><td>&nbsp;</td></tr><tr><td>&nbsp;&nbsp;</td><td>'+
        'Click on a chromosome to zoom in.<br>Right click on a feature for details.'+
        '<br>Pop-ups should be enabled on your browser.</td></tr>'+
        '<tr><td>&nbsp;</td><td><br>Genome coordinates used for the mouse cancer QTLs are from NCBI Build 37.</td></tr></table>';
      this.expand();
      Ext.DomHelper.overwrite('legendPanelDiv', legendHTML);     
      for(i = 0 ; i < groups.length; i++){
        Ext.get(groups[i]).on('click',this.legendClick,this); 
      }
     
  },
  
   legendClick: function(e,t,o){
    var pos = e.getXY();
    pos[0] = pos[0] + 20;  
    
    // populate the color, track and index values based on the the group
    var color = this.karyoPanel.featureStore.getAt(this.karyoPanel.featureStore.findExact('group',t.id)).get('color');
    var track = this.karyoPanel.featureStore.getAt(this.karyoPanel.featureStore.findExact('group',t.id)).get('track');
    
    if(track == null || track == "null"){
        track = "R1";
    } 
 //   this.legendForm.getForm().items.get('tIndex').setValue(track.substr(1));
    
    if( track.indexOf("R") != -1){
        this.legendForm.getForm().items.get('track').setValue("rightTrack",true);
        
    }else{
        this.legendForm.getForm().items.get('track').setValue("leftTrack",true);
    }
    this.legendForm.getForm().items.get('color').setValue(color);
    this.legendTip.setTitle(t.id);
    this.legendTip.setPosition(pos);
    this.legendTip.show();
  },
  
  
  removeGroupHandler:function(b,e){
    this.karyoPanel.removeGroup(this.legendTip.title),
    this.legendTip.hide();
    this.createLegend();
  },
 
 
  changeGroupHandler:function(b,e){
    var fp =b.findParentByType('form');
    var vals = fp.getForm().getFieldValues()
    var tIndex = 1; // was vals.tIndex
    if(vals.color){
      this.karyoPanel.changeGroupColor(this.legendTip.title,vals.color);
    }
    if(vals.track && tIndex){
      this.karyoPanel.changeGroupTrack(this.legendTip.title,vals.track.inputValue+""+tIndex)
    }
    fp.getForm().reset();
    this.legendTip.hide(); 
    
    this.createLegend();
    
  }
  })
 