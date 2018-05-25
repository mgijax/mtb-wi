<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Patient Derived Xenograft Search Results" help="pdxresults">

	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />

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
								{name: 'fusionGenes'}

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
	applyTo:'dataDiv',
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


	<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">

<table class="results" >

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
	<td >
		<span class="label">Search Summary</span>
<!-- \n -->

<c:choose>
	<c:when test="${not empty modelID}">
		<span class="label">Model ID:</span>${modelID}
<!-- \n -->

</c:when>
	</c:choose>
		<c:choose>
			<c:when test="${not empty primarySites}">
				<c:choose>
					<c:when test="${fn:length(primarySites)>1}">
						<span class="label">Primary Sites:</span>
							</c:when>
								<c:otherwise>
									<span class="label">Primary Site:</span>
										</c:otherwise>
											</c:choose>

<c:forEach var="site" items="${primarySites}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${site},
				</c:when>
					<c:otherwise>
						${site}
							</c:otherwise>
								</c:choose>
									</c:forEach>

<!-- \n -->

</c:when>
	<c:otherwise>
		<span class="label">Primary Sites:</span> Any
<!-- \n -->

</c:otherwise>
	</c:choose>

<c:choose>
	<c:when test="${not empty diagnoses}">
		<c:choose>
			<c:when test="${fn:length(diagnoses)>1}">
				<span class="label">Diagnoses:</span>
					</c:when>
						<c:otherwise>
							<span class="label">Diagnosis:</span>
								</c:otherwise>
									</c:choose>

<c:forEach var="diagnosis" items="${diagnoses}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${diagnosis},
				</c:when>
					<c:otherwise>
						${diagnosis}
							</c:otherwise>
								</c:choose>
									</c:forEach>

<!-- \n -->

</c:when>
	<c:otherwise>
		<span class="label">Diagnosis:</span> Any
<!-- \n -->

</c:otherwise>
	</c:choose>

<c:choose>
	<c:when test="${not empty tags}">
		<c:choose>
			<c:when test="${fn:length(tags)>1}">
				<span class="label">Tags:</span>
					</c:when>
						<c:otherwise>
							<span class="label">Tag:</span>
								</c:otherwise>
									</c:choose>

<c:forEach var="tag" items="${tags}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${tag},
				</c:when>
					<c:otherwise>
						${tag}
							</c:otherwise>
								</c:choose>
									</c:forEach>

<!-- \n -->

</c:when>
	<c:otherwise>
		<span class="label">Tags:</span> Any
<!-- \n -->

</c:otherwise>
	</c:choose>

<c:choose>
	<c:when test="${not empty genes}">
		<c:choose>
			<c:when test="${fn:length(genes)>1}">
				<span class="label">Genes:</span>
					</c:when>
						<c:otherwise>
							<span class="label">Gene:</span>
								</c:otherwise>
									</c:choose>

<c:forEach var="gene" items="${genes}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${gene},
				</c:when>
					<c:otherwise>
						${gene}
							</c:otherwise>
								</c:choose>
									</c:forEach>

<!-- \n -->

</c:when>
	<c:otherwise>
		<span class="label">Genes:</span> Any
<!-- \n -->

</c:otherwise>
	</c:choose>

<c:choose>
	<c:when test="${not empty variants}">
		<c:choose>
			<c:when test="${fn:length(variants)>1}">
				<span class="label">Variants:</span>
					</c:when>
						<c:otherwise>
							<span class="label">Variant:</span>
								</c:otherwise>
									</c:choose>

<c:forEach var="variant" items="${variants}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${variant},
				</c:when>
					<c:otherwise>
						${variant}
							</c:otherwise>
								</c:choose>
									</c:forEach>

<!-- \n -->

</c:when>
	<c:otherwise>
		<span class="label">Variants:</span> Any
<!-- \n -->

</c:otherwise>
	</c:choose>

<c:if test="${not empty fusionGenes}">
	<span class="label">Fusion Gene:</span> ${fusionGenes}
<!-- \n -->

</c:if>	

<c:if test="${not empty tumorGrowth}">
	<span class="label">Tumor Growth Data:</span> Required
<!-- \n -->

</c:if>		

<c:if test="${not empty dosingStudy}">
	<span class="label">Dosing Studies:</span> Required
<!-- \n -->

</c:if>	

<c:if test="${not empty treatmentNaive}">
	<span class="label">Treatment Naive Patient:</span> Required
<!-- \n -->

</c:if> 

<c:if test="${not empty recistDrug}">
	<span class="label">RECIST Drug:</span> ${recistDrug}
<!-- \n -->

</c:if>	

<c:if test="${not empty recistResponse}">
	<span class="label">RECIST Response:</span> ${recistResponse}
<!-- \n -->

</c:if> 

</td>
	</tr>
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

<!-- ////  End Results  //// -->

</table>

</jax:mmhcpage>

