<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Search Results">
	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
	<script type="text/javascript" src="/_res/js/datatables.min.js"></script>	
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
	<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript">
		Ext.ns('org.jax.mgi.mtb');
		Ext.onReady(function(){
			Ext.ux.GridRowChecker = Ext.extend(Object, {
				header: "",
				width: 30,
				sortable: true,
				fixed: false,
				menuDisabled: true,
				dataIndex: '',
				id: 'selection-checkbox',
				rowspan: undefined,
				init: function(grid) {
					this.grid = grid;
					this.gridSelModel = this.grid.getSelectionModel();
					this.gridSelModel.originalMouseDown = this.gridSelModel.handleMouseDown;
					this.gridSelModel.handleMouseDown = this.onGridMouseDown;
					grid.getColumnModel().config.unshift(this);
					grid.getChecked = this.getChecked.createDelegate(this);
				},
				renderer: function(value, cell, record) {
					if((record.get("modelID").trim().length>0)&&("${unavailableModels}".indexOf(record.get("modelID"))!= -1)){
						return '<strong>NA</strong>';
					}
					return '<input class="x-row-checkbox" type="checkbox">';
				},
				getChecked: function() {
					var result = [];
					var cb = this.grid.getEl().query("div.x-grid3-col-selection-checkbox > *");
					var idx = 0;
					this.grid.store.each(function(rec) {
						if ((typeof( cb[idx]) != 'undefined') && cb[idx].checked) {
							result.push(rec);
						}
						idx++;
					});
					delete cb;
					return result;
				},
				onGridMouseDown: function(g, rowIndex,	columnIndex, e) {
					if (e.getTarget('div.x-grid3-col-selection-checkbox')) {
						e.stopEvent();
						updateBucket.defer(200);
						return false;
					}
					this.originalMouseDown.apply(this, arguments);
				}
			});
			function updateBucket(){
				var checked = grid.getChecked();
				var bucket = document.getElementById("bucket");
				var bucketDiv = document.getElementById("bucket-div");
				if(checked.length ==0){
					bucketDiv.style.display='none';
				}else{
					bucketDiv.style.display='inline';
				}
				var mice ="";
				var sep ="";
				for(i=0; i < checked.length; i++){
					if(i>0){
						sep=", ";
					}
					mice = mice+sep+checked[i].get("modelID");
				}
				bucket.size=mice.length+10;
				bucket.value=mice;
			}
			var store = new Ext.data.ArrayStore({
				fields: [
				{name: 'modelID'},
				{name: 'status'},
				{name: 'previousID'},
				{name: 'tissue'},
				{name: 'diagnosis'},
				{name: 'location'},
				{name: 'sampleType'},
				{name: 'tumorType'},
				{name: 'primarySite'},
				{name: 'tumorMarkers'},
				{name: 'sex'},
				{name: 'age'},
				{name: 'strain'},
				{name: 'assocData'},
				{name: 'tag'},
				{name: 'gene'},
				{name: 'variant'},
				{name: 'consequence'},
				{name: 'fusionGenes'},
                                {name: 'tmb'}
				],
				data: ${mice},
				sortInfo: {
					field: 'modelID',
					direction: 'ASC'
				}
			});
			org.jax.mgi.mtb.PDXGrid =	Ext.extend(Ext.grid.EditorGridPanel,({
				initComponent: function(){
					org.jax.mgi.mtb.PDXGrid.superclass.initComponent.apply(this,arguments);
					this.setTitle(this.getStore().getTotalCount()+" matching PDX Model(s)");
				}
			}));
			function idRenderer(value, p, record){
				return String.format('<a href="pdxDetails.do?modelID={0}" target="_blank">{0}</a>',record.get("modelID"));
			}
			var grid = new org.jax.mgi.mtb.PDXGrid({		
				store: store,
				columns: [
				{
					id			 :'modelID',
					header	 : 'Model ID', 
					width		: 70, 
					sortable : true, 
					dataIndex: 'modelID',
					renderer: idRenderer
				},
				//						 {
					//								 header	 : 'Status', 
					//								 width		: 110, 
					//								 sortable : true, 
					//								 dataIndex: 'status'
					//						 },
				{
					header	 : 'Previous ID', 
					width		: 75, 
					sortable : true, 
					dataIndex: 'previousID'
				},
				{
					header	 : 'Primary Site', 
					width		: 100, 
					sortable : true, 
					dataIndex: 'primarySite'
				},
				{
					header	 : 'Diagnosis (Initial : Final)', 
					width		: 110, 
					sortable : true, 
					dataIndex: 'diagnosis'
				},
				{
					header	 : 'Tumor Site', 
					width		: 120, 
					sortable : true, 
					dataIndex: 'tissue'
				},
				{
					header	 : 'Tumor Type',	
					width		: 120, 
					sortable : true, 
					dataIndex: 'tumorType'
				},
                                {
                                        header   : 'TMB',  
                                        width    : 120, 
                                        sortable : true, 
                                        dataIndex: 'tmb',
                                        hidden   : ${hideTMB}

                                },
				{
					header	 : 'Fusion genes',
					width		: 330,
					sortable : false,
					dataIndex: 'fusionGenes',
					hidden	 : ${hideFusionGenes}
				},
				{
					header	 : 'Gene',
					width		: 70,
					sortable : true,
					dataIndex: 'gene',
					hidden	 : ${hideGene}
				},
				{
					header	 : 'Variant(s)',
					width		: 90,
					sortable : true,
					dataIndex: 'variant',
					hidden	 : ${hideGene}
				},
				{
					header	 : 'Consequence(s)',
					width		: 100,
					sortable : true,
					dataIndex: 'consequence',
					hidden	 : true //${hideGene}
				},
				{
					header	 : 'Sex', 
					width		: 70, 
					sortable : true,	
					dataIndex: 'sex'
				},
				{
					header	 : 'Age', 
					width		: 60, 
					sortable : true, 
					dataIndex: 'age'
				},
				{
					header	 : 'Tag', 
					width		: 100, 
					sortable : true, 
					dataIndex: 'tag',
					hidden	 : true
				},
				{
					header	 : 'Additional data', 
					width		: 170, 
					sortable : true, 
					dataIndex: 'assocData'
				}
				],
				stripeRows: true,
				height:350,
				autoExpandColumn:3,
				title: 'PDX Mice',
				plugins: [new Ext.ux.GridRowChecker()],
				id:'pdxGrid'
			});
			panel = new Ext.Panel({
				applyTo:'data-div',
				items:[grid],
				layout:{type:'fit'}
			});
			Ext.EventManager.onWindowResize(function(w, h){
				panel.doLayout();
			});
			panel.render();
			panel.doLayout();
		});
	</script>
	</jsp:attribute>
	<jsp:body>
	
	<section id="summary">
		<div class="container">
			
			<table>
				<tbody>		
					<tr>
						<td><h4>Details</h4></td>
						<td>	
					<jax:dl dt="Model ID" dd="${modelID}"/>
					<jax:dl dt="Primary Site" dts="Primary Sites" dds="${primarySites}" dd="Any"/>
					<jax:dl dt="Diagnosis" dts="Diagnoses" dds="${diagnoses}" dd="Any"/>
					<jax:dl dt="Tag" dts="Tags" dds="${tags}" dd="Any"/>
					<jax:dl dt="Gene" dd="${gene}"/>
					<jax:dl dt="Variant" dts="Variants" dds="${variants}" dd="Any"/>
					<jax:dl dt="Fusion Gene" dts="Fusion Genes" dd="${fusionGenes}"/>
					<jax:dl dt="Tumor Growth Data" test="${not empty tumorGrowth}" dd="Required"/>
					<jax:dl dt="Dosing Studies" test="${not empty dosingStudy}" dd="Required"/>
					<jax:dl dt="Treatment Naive Patient" test="${not empty treatmentNaive}" dd="Required"/>
					<jax:dl dt="RECIST Drug" dd="${recistDrug}"/>
					<jax:dl dt="RECIST Response" dd="${recistResponse}"/>
					<jax:dl dt="TMB" dd="${tmb}"/>
						</td>
					</tr>
				</tbody>
			</table>

			<!-- <p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p> -->
		</div>
    </section>
	
	<section id="detail">
		

		<table class="detail-table">
			
			<tr class="buttons">
				<td>
					<table>
						<c:choose>
						<c:when test="${not empty mice}">
						<tr>
							<td>
								<div id="data-div"></div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="bucket-div" style="display:none">
									<form method="get" action="pdxRequest.do">
										<label>Selected Models: </label>
										<input type="text" id="bucket"	name="mice">
										<input type="submit" value="Request Details" >
									</form>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								Check boxes can be used to select models to request details on availability.
								<!-- \n -->
								Models without check boxes (<strong>NA</strong>) are no longer available (no inventory remaining).
							</td>
						</tr>
						</c:when>
						<c:otherwise>
						<!-- No results found. //-->
						</c:otherwise>
						</c:choose>
						<tr>
							<td>
								<form method="GET" action ="pdxSearch.do"><input type="submit" value="Search Again"></form>
							</td>
						</tr>
						<tr>
							<td>
								<c:if test="${applicationScope.publicDeployment == false}">
								<!-- This should not be available on public until there is a go-ahead from Ed L. -->
								<input type="button" value="Download results as spreadsheet" onclick="window.location=document.URL+'&asCSV=true'" />
								</c:if>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</table>

		
		
	</jsp:body>
</jax:mmhcpage>
