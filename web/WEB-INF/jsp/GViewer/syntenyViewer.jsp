<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<html>

		<head>
		<c:set var="pageTitle" scope="request" value="Synteny Viewer"/>
		<c:import url="../../../meta.jsp"/>

		<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/PagingStore.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/Karyotype-canvas.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FeatureGrid.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FeatureGrid.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/Legend.js"></script>
	

		<script type="text/javascript">
				// number of pixels for largest chromosome
				var maxSize = 100;

				var humanBandingURL = 'viewer.do?method=getHumanBands';
		
				var mouseBandingURL = 'viewer.do?method=getBands';
		
				// used to link chromosome bands to ucsc details
				// use empty string for no link
			
				var localURL = 'http://narsil:8080/mtbwi/';
			
				var karyoPanel = null;
				var qtlStore = null;
		
				Ext.onReady(function() {
		 
						FeatureRecord = Ext.data.Record.create([
								{name:'chromosome'},
								{name:'start'},
								{name:'end'},
								{name:'type'},
								{name:'color'},
								{name:'label'},
								{name:'link'},
								{name:'mgiid'},
								{name:'name'},
								{name:'group'},
								{name:'track'}
						]);

						var syntenyForm = new Ext.FormPanel({
								id:'syntenyForm',
								frame: true,
								bodyStyle: 'padding: 5px 5px 0px 5px;',
								defaults: {
										anchor: '95%',
										msgTarget: 'side'
								},
								autoHeight: true,
								labelWidth: 60,
								items: [
										{
												xtype: 'radiogroup',
												fieldLabel: 'Source Organism',
												columns: 1,
												items: [
														{boxLabel: 'Mouse', name: 'organism', inputValue: 'mouse', checked: true},
														{boxLabel: 'Human', name: 'organism', inputValue: 'human'}
												]
										}, 
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
										}
								],
								buttonAlign:'center',
								buttons: [{
												text: 'Get Syntenic Regions',
												handler:syntenyHandler
										}]
						});
				
						function syntenyHandler(){
								syntenyWin.hide();
								var ch = syntenyForm.getForm().findField('chromosome').getValue();
								var start = syntenyForm.getForm().findField('start').getValue();
								var end = syntenyForm.getForm().findField('end').getValue();
								var source = syntenyForm.getForm().items.items[0].getValue().inputValue
			 
								syntenyStore.proxy.setUrl(localURL+'viewer.do?method=getSyntenicFeatures&source='+source+'&chromosome='+ch+'&start='+start+'&end='+end, true);
				
								if (source != loadedBands)
								{
										// need to reload bands then load syntenic regions
										karyoPanel.on('afterBuild', afterKaryoBuild);
						
										// remove all features
										syntenyStore.removeAll(true);
						
										if(source == 'human'){
												karyoPanel.reloadBands(mouseBandingURL);
												loadedBands = 'human';
										}else{
												karyoPanel.reloadBands(humanBandingURL);
												loadedBands = 'mouse';
										}
								}else{
										syntenyStore.load({add:true});
								}
								syntenyForm.getForm().reset();
						};
				
						function afterKaryoBuild(){
								syntenyStore.load({add:true});	
								karyoPanel.removeListener('afterBuild', afterKaryoBuild);
						};
				
						var syntenyWin =	new Ext.Window({
								layout:'fit',
								target: Ext.getBody(),
								closeAction:'hide', 
								width:260,
								title: 'Synteny Query',
								items:[syntenyForm]
						});
			 
						function syntenyWinHandler(){
								syntenyWin.show();		
								window.getAttention();
						};
						
						
		 
						var loadedBands = "human";
		 
						var karyoPanel = new org.jax.mgi.kmap.KaryoPanel({
								bandingFile:humanBandingURL,
								title:'<div>MTB Synteny Viewer</div>',
								id:'kPanel',
								maxKaryoSize:maxSize,
								bandLink:"",
								localLink:localURL,
								columns:12,
								allowZoom:false,
								chromosomeWidth:11,
								featureGap:2,
								fCanvasHeight:310,
								fCanvasWidth:20,
								//bandMaskDiv:'mainDiv',
								width:1000,
								renderTo:'mainDiv',
								deDupOnMgiId:false,
								hideEmptyChr: true,
								expandFeatures: false	
						});
				
						karyoPanel.getTopToolbar().get(0).hide();
			
						var	syntenyStore = new Ext.data.XmlStore({
								autoDestroy: true,
								storeId: 'syntenyStore',
								url:'toConfigureProxy',
								record: 'feature', 
								autoLoad:false,
								autoSave:false,
								fields: [			
										'chromosome',	
										'start',			 
										'end',				 
										'type',
										'color',
										'label',
										'link',
										'mgiid',
										'name',
										'group',
										'track'
								]	
						});	
				
						karyoPanel.setFeatureStore(syntenyStore);
			
						karyoPanel.getTopToolbar().addButton({
								text:'Load Syntenic Regions',
								handler:syntenyWinHandler
						});
			
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
						var centerTable = new Ext.Panel({
								region: 'center',
								layout:'table',
								layoutConfig:{columns:1},
								items:[karyoPanel,featureGrid]
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
								height:780,	
								layout: 'border',
								renderTo:'mainDiv',
								items: [centerTable,legendPanel],
								style:{background:'white'}
						});

						mainContainer.doLayout();
			
						karyoPanel.loadBands();
																												
						featureGrid.doLayout();
			
				});	//end onReady()
		</script>

</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">
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
										<tr>
								</table>

</section>
</div>
<form action="" id="export-form" target="_blank" method="post" >
		<input type="hidden" name="export" value="true">
		<input type="hidden" id="export-x-mL" name="exportXML" value="">
</form>
</body>
</html>

