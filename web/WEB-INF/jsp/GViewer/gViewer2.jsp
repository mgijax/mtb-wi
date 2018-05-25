<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="QTL Viewer">

	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/GViewer/javascript/fileUpload.css"/>
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
	<style type="text/css">
		.upload-icon {
			background: url('${applicationScope.urlBase}/extjs/resources/images/image_add.png') no-repeat 0 0 !important;
				}
				#fi-button-msg {
					border: 2px solid #ccc;
						padding: 5px 10px;
						background: #eee;
						margin: 5px;
						float: left;
				}

.x-form-check-wrap {overflow: hidden;}

.no-icon {
	display : none;
		background-image:'' !important;
			}
	</style>

	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/PagingStore.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/Karyotype-canvas.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FeatureGrid.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FileUploadField.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/Legend.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/ZoomPanel.js"></script>

	<script type="text/javascript">
	// number of pixels for largest chromosome
		var maxSize = 100;

var bandingURL = 'viewer.do?method=getBands';
	// used to link chromosome bands to ucsc details
		// use empty string for no link
		var UCSCBandLink='http://genome.ucsc.edu/cgi-bin/hgTracks?org=Mouse&position=';

// it appears that this is useless	
	var localURL = '';

var karyoPanel = null;
	var qtlStore = null;

Ext.onReady(function() {

Ext.override(Ext.form.Action.Submit,{
	features:[],
		handleResponse : function(response){
			if(this.form.errorReader){
				var rs = this.form.errorReader.read(response);
					this.features = [];
						var errors = [];
							var start = 0;
								if(qtlStore){
									start = qtlStore.getCount();
										}
										if(rs.records){
											for(var i = 0, len = rs.records.length; i < len; i++) {
												var r = rs.records[i];
													errors[i] = r.data;
														var feature = new FeatureRecord({
															chromosome:r.data.chromosome,
																start:r.data.start,
																end:r.data.end,
																type:r.data.type,
																name:r.data.name,
																link:r.data.link,
																description:r.data.description,
																color:r.data.color,
																mgiid:r.data.mgiid,
																group:r.data.group,
																track:r.data.track,
																source:r.data.source,
																score:r.data.score,
																strand:r.data.strand,
																phase:r.data.phase,
																col9:r.data.col9
														});		 
														feature.id ='feature'+(start+i);
														this.features.push(feature);
												}
										}

if(errors.length < 1){
	errors = null;
		}
			return {
				success : rs.success,
					errors : errors
						};
							}
								return Ext.decode(response.responseText);
						}});

FeatureRecord = Ext.data.Record.create([
	{name:'chromosome'},
		{name:'start'},
			{name:'end'},
				{name:'type'},
					{name:'color'},
						{name:'description'},
						{name:'link'},
						{name:'mgiid'},
						{name:'name'},
						{name:'group'},
						{name:'track'},
						{name:'source'},
						{name:'score'},
						{name:'strand'},
						{name:'phase'},
						{name:'col9'}
				]);

var fp = new Ext.FormPanel({
	id:'fp',
		fileUpload: true,
			width: 500,
				frame: true,
					autoHeight: true,
						bodyStyle: 'padding: 10px 10px 0px 10px;',
						labelWidth: 70,
						defaults: {
							anchor: '95%',
								msgTarget: 'side'
						},
						items: [{
							xtype: 'fileuploadfield',
								id: 'form-file',
									fieldLabel: 'File Path',
										name: 'filePath',
										buttonText: '',
										buttonCfg: {
											iconCls: 'upload-icon'
										}
								},
								{ xtype:'textfield',
									id:'group',
										fieldLabel:'Group',
										name:'group'
								},
								{ xtype:'combo',
									name:'color',
										fieldLabel:'Color',
										store: new Ext.data.ArrayStore({
											id: 0,
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
								},
								{ anchor:'80%',
									 xtype: 'radiogroup',
										fieldLabel: 'Track',
										items: [
											{boxLabel: 'Left of Chromosomes', name: 'track', inputValue: 'L'},
												{boxLabel: 'Right of Chromosomes', name: 'track', inputValue: 'R', checked: true}
										]}
								//,
	//							{ xtype:'numberfield',
	//									anchor:'25%',
	//									emptyText: '1',
	//									id:'trackIndex',
	//									fieldLabel:'Track Index',
	//									name:'trackIndex',
	//									minValue:1

//						 }
						],
						buttons: [{
							text: 'Upload',
								handler: function(){
									if(fp.getForm().isValid()){
										fp.getForm().errorReader 
											= new Ext.data.XmlReader({record : 'feature',
												success: '@success'
													}, FeatureRecord),
														fp.getForm().submit({
															url: 'viewer.do?method=upload',
																waitMsg: 'Uploading data',
																success: function(form, action){
																	loadUploadedFeatures(action.features);
																},
																failure: function(form, action){
																	Ext.Msg.alert('Upload Failded', 'Unable to create features from file');
																}
														});
														fileWin.hide();
												}
										}
								},{
									text: 'Reset',
										handler: function(){
											fp.getForm().reset();
										}
								}]
				});

function loadUploadedFeatures(records){
	qtlStore.suspendEvents();
		var start = 0;
			if(qtlStore){
				start = qtlStore.getCount();
					}

qtlStore.add(records);
	qtlStore.resumeEvents();
		qtlStore.fireEvent('add',qtlStore,records,start);
			featureGrid.addAllFeatures();
				};

function loadFromMGI(){

var ch,start,end;

mgdWin.show();

if(featureGrid.getSelectionModel().hasSelection()){
	ch = featureGrid.getSelectionModel().getSelected().get("chromosome");
		start = featureGrid.getSelectionModel().getSelected().get("start");
			end = featureGrid.getSelectionModel().getSelected().get("end");;
				}
					if(zoomPanel.end > 0){
						ch = zoomPanel.chromosome;
							start = zoomPanel.start;
								end = zoomPanel.end;
						}

if(end > 0){	 
								document.mgiForm.chrom.value = ch;
								document.mgiForm.start.value =	start;
								document.mgiForm.end.value =	end;
						}
				};

function mgdQueryHandler(){

var ch = document.mgiForm.chrom.value;
	var start = document.mgiForm.start.value;
		var end = document.mgiForm.end.value;
			var pheno = document.mgiForm.phenotype.value;

var ontologyKeys="";

if(document.mgiForm.ontology_key1.checked){
	ontologyKeys="&ontology_key="+document.mgiForm.ontology_key1.value;
		}

if(document.mgiForm.ontology_key2.checked){
	ontologyKeys= ontologyKeys+"&ontology_key="+document.mgiForm.ontology_key2.value;
		}

if(document.mgiForm.ontology_key3.checked){
	ontologyKeys= ontologyKeys+"&ontology_key="+document.mgiForm.ontology_key3.value;
		}

var goOp = document.mgiForm.goOp.value;
	var goTerm = document.mgiForm.goTerm.value;

var mcvs = document.mgiForm.featureTypes.value;

qtlStore.proxy.setUrl(localURL+'viewer.do?method=getMGIFeatures&chromosome='+ch+'&start='+start+'&end='+end
	+'&phenotype='+pheno+'&mcv='+mcvs+'&go_op='+goOp+'&go_term='+goTerm+ontologyKeys+'&linkTo=details');

mgdWin.hide();

mask =	new Ext.LoadMask('mainDiv', {msg:"Loading data...", removeMask:true, store:qtlStore});

qtlStore.load({add:true, callback:mgiQueryCallback});

document.mgiForm.reset();
	};

function mgiQueryCallback(r, options, success){

if(r.length == 0){
	Ext.Msg.alert('MGI Query', 'Query returned no results.');
		}

};	

function showRegionWin(){
	regionWin.show();
		}

function createRegion(){

regionWin.hide();

var ch =	createRegionForm.getForm().findField('chromosome').getValue();
						var start = createRegionForm.getForm().findField('start').getValue();
						var end = createRegionForm.getForm().findField('end').getValue();

var name = createRegionForm.getForm().findField('name').getValue();
	var description = createRegionForm.getForm().findField('description').getValue();

var group = createRegionForm.getForm().findField('group').getValue();
	if(group == null || group.length == 0){
		group = 'user created';
			}

if(end > 0){
	var rec = new FeatureRecord({
		chromosome:ch,
			start:start,
				end:end,
					type:'region',
						color:'blue',
							description:description,
								link:'viewer.do?method=details%26location='+ch+':'+start+'..'+end+'%26description='+description+'%26name='+name,
									mgiid:'',
										name:name,
										group:group,
										track:'R1'
								});

qtlStore.add(rec);
	featureGrid.store.add(rec.copy());
		}
			}

var createRegionForm = new Ext.FormPanel({
	frame: true,
		bodyStyle: 'padding: 5px 5px 0px 5px;',
			defaults: {
				anchor: '95%',
					msgTarget: 'side'
						},
						autoHeight: true,
						labelWidth: 60,
						items: [
							{ xtype:'textfield',
								fieldLabel:'Chr',
									name:'chromosome',
										width:165
								},
								{ xtype:'numberfield',
									fieldLabel:'Start',
										name:'start',
										minValue:0,
										width:165
								},
								{ xtype:'numberfield',
									fieldLabel:'End',
										name:'end',
										minValue:0,
										width:165
								},{ 
									xtype:'textfield',
										name:'name',
										fieldLabel:'Name',
										width:165
								},
								{ 
									xtype:'textfield',
										name:'description',
										fieldLabel:'Description',
										width:165
								},
								{ 
									xtype:'textfield',
										name:'group',
										fieldLabel:'Group',
										width:165
								}
						],
						buttonAlign:'center',
						buttons: [{
							text: 'Create region',
								handler:createRegion

}]
	});

var mgdWin =	new Ext.Window({
						layout:'fit',
						target: Ext.getBody(),
						closeAction:'hide', 
						width:680,
						title: 'MGI Query',
						//	items:[mgdForm]
						html: '<form name="mgiForm"><table>'+
							'<tr>'+
								'<td colspan="6">'+
								'<strong>Search for features within the selected coordinates.</strong>'+

'</td>'+
	'</tr>'+
		'<tr>'+
			'<td><h4>Chromosome</h4></td>'+
				'<td><input type="text" name="chrom" value="" size="5"></td>'+
					'<td><h4>Start (bp)</h4></td>'+
						'<td><input type="text" name="start" value=""></td>'+
							'<td><h4>End (bp)</h4></td>'+
								'<td><input type="text" name="end" value=""></td>'+
								'</tr>'+
								'<tr><td><h4>Feature Type</h4></td><td colspan="5" id="feature-type-selection"></td></tr>'+
								'<tr>'+
								'<td class="cat-2">'+
								'Mouse phenotypes & mouse models of human disease'+
								'</td>'+
								'<td colspan="5">'+
								'<em>Enter any combination of phenotype terms, disease terms, or IDs </em>
<!-- \n -->
'+
	'<textarea name="phenotype" rows="2" cols="50"></textarea>'+
		'
<!-- \n -->
'+
	'Browse <a href="nojavascript.jsp" onClick="popPathWin(&quot;http://www.informatics.jax.org/searches/MP_form.shtml&quot;);return false;">Mammalian Phenotype Ontology (MP)</a>'+
		'
<!-- \n -->
'+
	'Browse <a href="nojavascript.jsp" onClick="popPathWin(&quot;http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=omimVocab&subset=A&quot;);return false;">Human Disease Vocabulary (OMIM)</a>'+
		'</td>'+
			'</tr>'+
				'<tr	class="stripe-1">'+
								'<td class="cat-1">'+
								'Gene Ontology(GO) Classification'+
								'</td>'+
								'<td colspan="3">'+
								'<select name="goOp">'+
								'<option value="begins">begins</option>'+
								'<option value="%3D">=</option>'+
								'<option value="ends">ends</option>'+
								'<option value="contains">contains</option>'+
								'<option value="like">like</option>'+
								'</select>'+
								'&nbsp;'+
								'<input type="text" name="goTerm" size="30"/>&nbsp;in
<!-- \n -->
'+
	'Browse <a href="nojavascript.jsp" onClick="popPathWin(&quot;http://www.informatics.jax.org/searches/GO_form.shtml&quot;);return false;">Gene Ontology</a>'+
		'</td><td colspan="2">'+
			'<input type="checkbox" name="ontology_key1" value="Molecular+Function"/>Molecular Function
<!-- \n -->
'+
	'<input type="checkbox" name="ontology_key2" value="Biological+Process"/>Biological Process
<!-- \n -->
'+
	'<input type="checkbox" name="ontology_key3" value="Cellular+Component"/>Cellular Component'+

' </td>'+
	'</tr>'+	

'</table> <input type="hidden" name="featureTypes"/></form>',
	buttons: [
		 {
			text: 'Load from MGI',
				handler:mgdQueryHandler
					},
						{
							text: 'Clear',
								handler:function(){document.mgiForm.reset();}
									}
									 ]

});

treePanel = new Ext.tree.TreePanel({
	height: 100,
		width: 450,
			useArrows:true,
				autoScroll:false,
					autoHeight:true,
						animate:false,
							enableDD:false,
								containerScroll: true,
								rootVisible: false,
								frame: false,
								root: {
									nodeType: 'async',
									text:'root',
									id:'0',
									checked:false,
									iconCls:'no-icon'
								},

// auto create TreeLoader
	dataUrl:'gViewerDetails.do?featureTypes=json',

listeners: {
	'checkchange': function(node, checked){
		function check(cNode){
			cNode.expand();
				cNode.expandChildNodes(true);
					var j=0, gChildren = cNode.childNodes;
						for(j; j < gChildren.length; j++){
							gChildren[j].getUI().toggleCheck(checked);
								check(gChildren[j]);

}
	}
		 check(node);

var mcvs ='',selNodes = treePanel.getChecked();;
	Ext.each(selNodes, function(node){
		if(mcvs.length > 0){
			mcvs += ',';
				}
					mcvs +=node.id;
						});
							document.mgiForm.featureTypes.value = mcvs;
								}
								}
							});

function showTree(){
	treePanel.render(document.getElementById('featureTypeSelection'))
		 }

mgdWin.on('afterrender',showTree);

var regionWin =	new Ext.Window({
						layout:'fit',
						target: Ext.getBody(),
						closeAction:'hide', 
						width:260,
						title: 'Create region',
						items:[createRegionForm]
				});

var fileWin = new Ext.Window({
	title:'Load features from file.',
		layout:'fit',
			width:550,
				height:215,
					closeAction:'hide', 
						items:[fp]
				});

function showFPWindow(){
	fileWin.show();
		fp.getForm().reset();
			};

karyoPanel = new org.jax.mgi.kmap.KaryoPanel({bandingFile:bandingURL,
	title:'<div>MTB QTL Viewer</div>',
		id:'kPanel',
			maxKaryoSize:maxSize,
				bandLink:UCSCBandLink,
					localLink:localURL,
						legend:'legendPanel',
						allowZoom:true,
						chromosomeWidth:11,
						featureGap:2,
						fCanvasHeight:250,
						fCanvasWidth:20,
						bandMaskDiv:'mainDiv',
						width:1000
				});

qtlStore = new Ext.ux.data.PagingXmlStore({
	autoDestroy: true,
		storeId: 'qtlStore',
			url:'toConfigureProxy',
				record: 'feature', 
					autoLoad: false,
						autoSave:false,
						// the writer is needed to export features. maybe rewrite export
						writer: new Ext.data.XmlWriter({writeAllFields:true}),
						fields: [
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
								'phase',
								'col9'

]	
	});	

var oGridHandler = function (b,e){
	var i;
		var link = localURL+'viewer.do?method=getQTLs&';
			var selections = Ext.getCmp('oGrid').getSelectionModel().getSelections();

for(i = 0 ; i < selections.length; i++){
	link = link+'selectedQTLTypes='+ selections[i].get("name").replace(/ /g,'+')+'&';
		}	 
						Ext.getCmp('oGridMenu').hide();
						Ext.getCmp('oGridMenu').findParentByType('menu').hide();
						if(selections.length == 0 ){

Ext.Msg.alert('Display QTL', 'No QTL groups were selected.');
	return;
		}
			if(b.getText() == 'View'){

qtlStore.proxy.setUrl(link);

var mask =	new Ext.LoadMask('mainDiv', {msg:"Loading data...", removeMask:true, store:qtlStore});

qtlStore.load({add:true});

}else{
	if(b.getText() == 'as HTML'){
		link = link + 'qtlList=HTML';

}else if(b.getText() == 'as Text'){
	link = link + 'qtlList=tabbed';
		}
			window.open(link,'qtlList');
				} 
				};

var oStore = new Ext.data.XmlStore({
	autoDestroy: true,
		storeId: 'oStore',
			record: 'organ', 
				autoLoad: true,
					url:localURL+'viewer.do?method=getOrganGroups',
						fields: [
							'name',
								'color'
						]
				});

var oGridCM =	new Ext.grid.ColumnModel({columns:[
								{id:'name', sortable: true, dataIndex: 'name'}
						]});

var oGrid = new Ext.grid.GridPanel({
	id:'oGrid',
		selModel:new Ext.grid.RowSelectionModel(),
			store:oStore,
				cm:oGridCM,
					stripeRows: true,
						height:200,
						width:200,
						viewConfig:{autoFill:true},
						autoExpandColumn:'name',
						bbar: [ {text: 'View',
							handler:oGridHandler,
								scope:this
								},'-',
								{text: 'as HTML',
									handler:oGridHandler,
										scope:this
								},'-',
								{text: 'as Text',
									handler:oGridHandler,
										scope:this
								}
						]
				});

var oGridMenu = new Ext.menu.Menu({
	id: 'oGridMenu',
		style: {
			overflow: 'visible'		 
						},
						items: [oGrid]
				});

karyoPanel.setFeatureStore(qtlStore);

karyoPanel.getTopToolbar().items.items[2].menu.add(
	[{text:'Create Region', handler:showRegionWin},
		{text:'Clear All',handler:karyoPanel.clear, scope:karyoPanel}
			]);

karyoPanel.getTopToolbar().add('-');

karyoPanel.getTopToolbar().add(
	{text:'Help',
		menu:{items:[{text:'Viewer Help', handler:helpHandler},
			{text:'Using GFF files',handler:gffHowToHandler}
				]}});

//			karyoPanel.getTopToolbar().add('-');

//			 karyoPanel.getTopToolbar().addButton({
				//					 text:'Create region',
				//					 handler:showRegionWin
				//			 });

karyoPanel.getTopToolbar().add('-');

karyoPanel.getTopToolbar().items.items[0].menu.add({
	text:'Load QTL',
		menu:oGridMenu
			});

karyoPanel.getTopToolbar().items.items[0].menu.add({
	text:'Load annotations from MGI',
		handler:loadFromMGI
			});

karyoPanel.getTopToolbar().items.items[0].menu.add({
	text:'Upload annotation file (GFF)',
		handler:showFPWindow
			});

karyoPanel.getTopToolbar().items.items[0].menu.add(
	{text:'Export annotation file (GFF)',
		handler:karyoPanel.exportFeatures,
			scope:karyoPanel
				});

var zoomPanel = new org.jax.mgi.kmap.ZoomPanel({
	id:'zoomPanel',
		rowspan:2,
			minWidth:200,
				kPanel:karyoPanel});

var featureGrid = new org.jax.mgi.kmap.FeatureGrid({
	id:'featureGrid',
		rowspan:1,
			colspan:1,
				editable:false,
					hideTopToolbar:true,
						kPanel:karyoPanel,
						localLink:localURL,
						viewConfig:{autoFill:true, markDirty:false},
						tbar: new Ext.Toolbar({}),
						bbar: new Ext.PagingToolbar({			
							displayInfo: true,
								pageSize:5,
								prependButtons: true
						})
				});

// table for the center
	var centerTable = new Ext.Container({
		region: 'center',
			layout:'table',
				layoutConfig:{columns:2},
					items:[karyoPanel,zoomPanel,featureGrid]

});

// Legend Panel to the west

var legendPanel = new org.jax.mgi.kmap.LegendPanel({
	autoScroll:true,
		title:'Legend',
			id:'legendPanel',
				region: 'west',
					split: true,
						width: 350,
						collapsible:true,
						collapsed:true,
						style:{borderstyle:'none'},
						karyoPanel:karyoPanel
				});

var mainContainer = new Ext.Container({
	id:'mainTain',
		height:780,	// the kPanel height is based on the size of the chromosomes so this value is really how the legend panel is sized
						//	width:1200,
						layout: 'border',
						renderTo:'mainDiv',
						items: [legendPanel,centerTable],
						style:{background:'white'}
				});

mainContainer.doLayout();

zoomPanel.doLayout();
	zoomPanel.hide();

karyoPanel.loadBands();

featureGrid.doLayout();

zoomPanel.on('featureClick',featureGrid.selectFeature,featureGrid);
	zoomPanel.on('featureRightClick',karyoPanel.featureRightClick,karyoPanel);
		zoomPanel.on('featureMouseOver',karyoPanel.featureMouseOver,karyoPanel);
			zoomPanel.on('featureMouseOut',karyoPanel.featureMouseOut,karyoPanel);

function setjBrowseURL(e,mbp,feature,kpanel){
	if(feature){
		 start = parseInt(feature.start);
			 end = parseInt(feature.end) ;

// not sure how worth wile this is
	 pad = Math.floor((end - start)/4);
		 start = start - pad;
			 if(start<0) start =0;
				 end = end + pad;

src = "http://jbrowse.informatics.jax.org/?data=data%2Fmouse&loc=chr"+feature.chromosome+"%3A"+start+".."+end+"&tracks=MGI_Genome_Features";
	 document.getElementById('jBrowseFrame').src = src
		 document.getElementById('jBrowseFrame').width = (mainContainer.getWidth())+"px";

qtlStore.proxy.setUrl(localURL+'viewer.do?method=getMGIFeatures&chromosome='+feature.chromosome+'&start='+feature.start+'&end='+feature.end
	+'&phenotype=&mcv=&go_op=&go_term=&linkTo=details');

mask =	new Ext.LoadMask('mainDiv', {msg:"Loading data...", removeMask:true, store:qtlStore});

qtlStore.load({add:true, callback:mgiQueryCallback});

}
	}

// for jill recla
	//karyoPanel.on('featureClick',setjBrowseURL,karyoPanel);

zoomPanel.on('featureClick',setjBrowseURL,featureGrid);

var helpWindow = null;

function helpHandler(){
	if(!helpWindow){
		helpWindow = new Ext.Window({
			title:'MTB QTL Viewer Help',
				layout:'fit',
					width:550,
						height:400,
							closeAction:'hide',
								plain: true,
									html:"<p><strong>Loading QTLs</strong>
<!-- \n -->
"+
	"&nbsp;	'File->Load QTL' will list cancer QTLs by organ/tissue type. Crtl+Click to select multiple organs. 
<!-- \n -->
"+
	"&nbsp;	Click 'View' to display selected QTL types in viewer. 
<!-- \n -->
"+
	"&nbsp;	QTL data can be displayed as html or tab delimited.
<!-- \n -->
"+
	"&nbsp;	A collapsible legend displays the types of loaded QTL. 
<!-- \n -->
"+
	"&nbsp;	In the legend, clicking on a QTL's colored box allows the QTL group's display properties to be configured.
<!-- \n -->
"+
	"</p><p>"+
		"<strong>Zoom in</strong>
<!-- \n -->
"+
	"&nbsp;	Click and drag on a chromosome to select a region to zoom into.
<!-- \n -->
"+
	"&nbsp;	The zoom panel is then displayed on the right. 
<!-- \n -->
"+
	"&nbsp;	The zoomed region corresponds to red highlighted region on the chromosome. 
<!-- \n -->
"+
	"&nbsp;	Zoom can be adjusted by dragging red indicator or by the scroll and zoom buttons on zoom panel.
<!-- \n -->
"+
	"</p><p>	"+
												"<strong>Export/Import</strong>
<!-- \n -->
"+
	"&nbsp;	'File->Load Features' allows features to be loaded from a .gff file.
<!-- \n -->
"+
	"&nbsp;	'File->Export' exports currently displayed features as a .gff file.
<!-- \n -->
"+
	"</p><p>	"+
												"<strong>Capture Image</strong>
<!-- \n -->
"+
	"&nbsp;	'View->Capture Image' converts viewer display into single image which can be saved.
<!-- \n -->
"+
	"</p><p>	"+
												"<strong>Load From MGI</strong>
<!-- \n -->
"+
	"&nbsp;	The viewer can be used to query MGI in two ways. 
<!-- \n -->
"+
	"&nbsp;	'File->Load annotations from MGI' opens a simple query window. 
<!-- \n -->
"+
	"&nbsp;	Results are displayed on the viewer. 
<!-- \n -->
"+
	"&nbsp;	Alternatively, clicking on the symbol of a feature in the feature details table opens a new window with a more advanced query form. 
<!-- \n -->
"+
	"&nbsp;	Results from this query page can be sent back to the viewer.
<!-- \n -->
</p>"
	});
		}
			helpWindow.show(); 
				};

var howToWindow = null;

function gffHowToHandler(){
	if(!howToWindow){
		howToWindow = new Ext.Window({
			title:'Using GFF files with the MTB QTL Viewer',
				layout:'fit',
					width:820,
						height:550,
							closeAction:'hide',
								plain: true,
									html:"<pre>
<!-- \n -->
"+
	 " You can easily upload your own genome features for display in the QTL Viewer using a General Feature Format (GFF) file. 
<!-- \n -->
"+
	 " The GFF format is a simple tab-delimited text file with the following 9 columns:
<!-- \n -->
"+
	 " 
<!-- \n -->
"+
	 " SEQID - <strong>required</strong>; chromosome #
<!-- \n -->
"+
	 " SOURCE - not used by the viewer; use '.' to indicate an empty field
<!-- \n -->
"+
	 " TYPE - not used by the viewer; use '.' to indicate an empty field
<!-- \n -->
"+
	 " START - <strong>required</strong>; start coordinate of the genome feature
<!-- \n -->
"+
	 " END - <strong>required</strong>; end coordinate of the genome feature
<!-- \n -->
"+
	 " SCORE - not used by the viewer; use '.' to indicate an empty field 
<!-- \n -->
"+
	 " STRAND - not used by the viewer; use '.' to indicate an empty field
<!-- \n -->
"+
	 " PHASE - not used by the viewer; use '.' to indicate an empty field
<!-- \n -->
"+
	 " ATTRIBUTES. -	optional; used to label and format data display in the viewer
<!-- \n -->
"+
	 " 
<!-- \n -->
"+
	 " Information in the ATTRIBUTES field modifies how information is displayed in the viewer. 
<!-- \n -->
"+
	 " All of these attributes are optional.	
<!-- \n -->
"+
	 " The different format is attribute=value with each pair separated by semicolons (;). 
<!-- \n -->
"+
	 " 
<!-- \n -->
"+
	 " The accepted attributes are:
<!-- \n -->
"+
	 " mgiID - the accession id for a feature from the Mouse Genome Informatics group. No default value.
<!-- \n -->
"+
	 " color - the color of the feature to be displayed. Can be the <a href='http://www.december.com/html/spec/color.html' target='_blank'>name of the color or the hex code</a>. Green is default.	 
<!-- \n -->
"+
	 " track - determines the side of the chromosome for display (L or R); R is default.
<!-- \n -->
"+
	 " group - a label for a group of features. No default value.
<!-- \n -->
"+
	 " Name - the symbol of the feature. No default value. Attribute name must begin with a capital 'N'.
<!-- \n -->
"+
	 " description - the full name for a feature. No default value.
<!-- \n -->
"+
	 " 
<!-- \n -->
"+
	 " Groups as defined by the group attribute(s) are displayed in the legend to the left of the viewer.
<!-- \n -->
"+
	 " The legend assumes all members of a group have the same color and track atrributes.
<!-- \n -->
"+
	 " If a GFF file has features with the same group but different colors or tracks,
<!-- \n -->
"+
	 " the color and track in the legend will be based on an aribitrary feature from the group.
<!-- \n -->
"+
	 " Changing the color or track via the legend will affect all features in the group.
<!-- \n -->
"+
	 " 
<!-- \n -->
 <a href='http://www.sanger.ac.uk/resources/software/gff/spec.html' target='_blank'>The formal GFF specification can be found here.</a> 
<!-- \n -->
"+
	 " 
<!-- \n -->
"+
	 " Here is a sample text file in GFF format.
<!-- \n -->
"+
	 " <a href='${applicationScope.gViewerPath}/QTL_viewer_example_file.txt' target='_blank'>QTL_viewer_example_file.txt</a>
<!-- \n -->
"+
	 " </pre>"
		});
			}
				howToWindow.show(); 
				};

// allows the form to be run outside of mtbwi app
	document.forms['exportForm'].action = localURL+'viewer.do?method=export';
		});	//end onReady()
	</script>
</jsp:attribute>

<table>
	<tr>
		<td id="main-div" colspan="2" style="width:100%">

<noscript>
<!-- \n -->

<!-- \n -->

<!-- \n -->

<!-- \n -->
<h2>The QTL Viewer requires Javascript which is disabled or unavailable on your browser.</h2></noscript>
	</td>

</tr>
	<tr>
		<td>
			<iframe id="j-browse-frame" height="500px" width="1349px" style="border: 1px solid #dfdfdf; padding: 5px" src=""></iframe>
				</td>
					</tr>

</table>

<form action="" id="export-form" target="_blank" method="post" >
	<input type="hidden" name="export" value="true">
		<input type="hidden" id="export-x-mL" name="exportXML" value="">
</form>
</jax:mmhcpage>

