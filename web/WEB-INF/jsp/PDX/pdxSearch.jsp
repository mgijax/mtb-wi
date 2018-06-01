<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Search Form" help="pdxsearch">
	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript">
	function updateVariants(){
		document.getElementById("variant-result").innerHTML="Please wait...";
		document.forms[1].action="pdxSearch.do";
		document.forms[1].submit();
	}
	function resetForm(){
		document.forms[1].reset();
		if(document.getElementById("variant-select") != null){
			document.getElementById("variant-select").style.visibility="hidden";
		}
		document.forms[1].modelID.value="";
		document.forms[1].gene.value="";
		document.forms[1].genes2.value="";
		document.forms[1].genesCNV.value="";
	}
	Ext.onReady(function(){
		// to clear value on reset. from sencha forum.
		Ext.form.ComboBox.prototype.initQuery = Ext.form.ComboBox.prototype.initQuery.createInterceptor(function(e)
		{
			var v = this.getRawValue();
			if (typeof v === 'undefined' || v === null || v === '')
			this.clearValue();
		});
		var idStore = new Ext.data.ArrayStore({
			id: 0,
			fields: [
			'id',
			'display'
			],
			data:${modelIDs}
		})
		var modelIDcombo = new Ext.form.ComboBox({
			store: idStore,
			minChars:1,
			valueField:'id',
			displayField:'display',
			typeAhead: true,
			lazyRender:true,
			mode: 'local',
			forceSelection: false,
			triggerAction: 'all',
			selectOnFocus:true,
			hideTrigger:false,
			hiddenName:'modelID',
			width:360,
			listEmptyText:'no matching model',
			renderTo: 'model-id-combo'
			//				,pageSize:10
		});
		var dataProxy = new Ext.data.HttpProxy({
			url: '${pageContext.request.contextPath}/pdxHumanGenes.do'
		})
		var humanGenestore = new Ext.data.ArrayStore({
			id:'thestore',
			//					 pageSize: 10, 
			root:'data',
			totalProperty: 'total',
			fields: [{name:'symbol'}, {name:'display'}],
			proxy: dataProxy,
			autoLoad:false
		});
		var combo = new Ext.form.ComboBox({
			store: humanGenestore,
			minChars:2,
			valueField:'symbol',
			displayField:'display',
			typeAhead: true,
			mode: 'remote',
			forceSelection: false,
			triggerAction: 'all',
			selectOnFocus:true,
			hideTrigger:true,
			hiddenName:'gene',
			width:260,
			listEmptyText:'no matching gene',
			renderTo: 'gene-select-o-matic'
			//				,pageSize:10
		});
		combo.setValue('${gene}');
		var ctpStore = new Ext.data.ArrayStore({
			id: 0,
			fields: [
			'symbol'
			],
			data: ${exomePanelGenes}
		})
		var combo2 = new Ext.form.ComboBox({
			store: ctpStore,
			minChars:1,
			valueField:'symbol',
			displayField:'symbol',
			typeAhead: true,
			lazyRender:true,
			mode: 'local',
			forceSelection: false,
			triggerAction: 'all',
			selectOnFocus:true,
			hideTrigger:true,
			hiddenName:'genes2',
			width:260,
			listEmptyText:'no matching gene',
			renderTo: 'gene-select-o-matic-2'
		});
		var combo3 = new Ext.form.ComboBox({
			store: ctpStore,
			minChars:1,
			valueField:'symbol',
			displayField:'symbol',
			typeAhead: true,
			lazyRender:true,
			mode: 'local',
			forceSelection: false,
			triggerAction: 'all',
			selectOnFocus:true,
			hideTrigger:true,
			hiddenName:'genesCNV',
			width:260,
			listEmptyText:'no matching gene',
			renderTo: 'gene-select-o-matic-3'
		});
	});
</script>
</jsp:attribute>
<jsp:body>
<html:form action="pdxSearchResults" method="GET">
<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">
<table>
	<tr class="page-info">
		<td colspan="2">
			<table>
				<tr>
					<td>
						&nbsp;Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.	PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.	The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.	 
						<!-- \n -->
						<!-- \n -->
						<!-- \n -->
						<!-- \n -->
						<table class="mi-table">
							<tr><td border="5px">
									<p class="mi-title">PDX minimal information data standards are now public. Read about it in Cancer Research, <a href="https://www.ncbi.nlm.nih.gov/pubmed/29092942">Meehan et al., 2017</a></p>
									<ul>
										<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMI_README.docx">PDX Minimal Information Read Me (doc)</a></li>
										<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMIPublication.xlsx">PDX Minimal Information Specification (xls)</a></li>
										<li class="real-list"><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">PDX Minimal Information Feedback (web form)</a></li>
									</ul>
									<!-- \n -->
							</td></tr>
						</table>
					</td>
					<td>
						<img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" alt="NSG Mouse">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="buttons">
		<td colspan="2">
			<table>
				<tr>
					<td>
						<input type="submit" VALUE="Search">
						<input type="button" VALUE="Reset" onclick="resetForm()">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by PDX model identifier
		</td>
		<td class="data-1" >
			<table>
				<tr>
					<td></td><td></td>
				</tr>
				<tr>
					<td>
						<dl class="tip"><dt>Model ID</dt><dd>Enter a Model ID (eg TM:00001) as search criteria.</dd></dl>
						<!-- \n -->
						<div id ="model-i-dCombo"></div>&nbsp;eg. TM00001
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by primary cancer site
		</td>
		<td>
			<table>
				<tr>
					<td>
						<dl class="tip"><dt>Primary Site</dt><dd>Select one or more primary sites as search criteria</dd></dl>
						<!-- \n -->
						<html:select property="primarySites" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="primarySitesValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
					<td></td>
					<td>
						<dl class="tip"><dt>Limit results to models</dt><dd>Only return models with selected additional information.</dd></dl>		 
						<!-- \n -->
						<html:checkbox property="dosingStudy"/> with dosing study data, <html:checkbox property="tumorGrowth"/> with tumor growth graphs, <html:checkbox property="treatmentNaive"/> 
						<dl class="tip"><dt>
							from treatment naive patients.
							<!-- \n -->
						</dt><dd>PDX models are considered treatment naive if the patient did not receive chemotherapy, immunotherapy, hormone therapy or radiation therapy for this primary cancer within 5 years prior to sample collection and/or within 1 year for a different cancer.</dd></dl>
						<!-- \n -->
						<c:choose>
						<c:when test="${not empty tagsValues}">
						<dl class="tip"><dt>Limit results to models tagged as</dt><dd>Only return models tagged as.</dd></dl>		 
						<!-- \n -->
						<html:select property="tags" size="4" multiple="true">
						<html:options collection="tagsValues" property="value" labelProperty="label"/>
						</html:select>
						</c:when>
						</c:choose>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by diagnosis
		</td>
		<td>
			<table>
				<tr>
					<td>
						<dl class="tip"><dt>Diagnosis</dt><dd>Select a diagnosis or diagnoses as search criteria.</dd></dl>
						<!-- \n -->
						<html:select property="diagnoses" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="diagnosesValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by dosing study results
		</td>
		<td>
			<table>
				<tr>
					<td>
						<dl class="tip"><dt>Drug</dt><dd>RECIST drug.</dd></dl>
						<!-- \n -->
						<html:select property="recistDrugs" size="4" >
						<html:options collection="recistDrugs" property="value" labelProperty="label"/>
						</html:select>
					</td>
					<td>
						<dl class="tip"><dt>Response</dt><dd>RECIST response.</dd></dl>
						<!-- \n -->
						<html:select property="recistResponses" size="4" >
						<html:options collection="recistResponses" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by fusion gene
		</td>
		<td>
			<table>
				<tr>
					<td>
						<dl class="tip"><dt>Fusion Gene</dt><dd>Select a fusion gene as search criteria.</dd></dl>
						<!-- \n -->
						<html:select property="fusionGenes" size="4" >
						<html:option value="Any">ANY</html:option><!-- this has a value because it is a constraint ie only some models have fusion genes	-->
						<html:options collection="fusionGenes" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Search by gene variants (in engrafted tumors)
		</td>
		<td>
			<table>
				<tr>
					<td>
						<dl class="tip"><dt>Gene</dt><dd>Select one or more genes as search criteria</dd></dl>
						<!-- \n -->
						<div id="gene-select-oMatic"></div>
					</td>
					<td>
						<!-- \n -->
						<input type="button" value="Show Variants" onclick="updateVariants()">
						<a id="variants-location"></a>
					</td>
					<c:choose>
					<c:when test="${not empty variantsValues}">
					<td>
						<dl class="tip"><dt>Variants</dt><dd>Select one or more variants as search criteria</dd></dl>
						<!-- \n -->
						<html:select property="variants" size="8" multiple="false" styleId="variantSelect">
						<html:option value="">ANY</html:option>
						<html:options collection="variantsValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
					<td id="variant-result"></td>
					</c:when>
					<c:otherwise>
					<td id="variant-result">
						<!-- \n -->
					No variants for selected gene.</td>
					</c:otherwise>
					</c:choose>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Display a chart of gene expression across PDX models for a gene
		</td>
		<td>
			<dl class="tip"><dt>Gene</dt><dd>Select a gene to view expression values</dd></dl>
			<!-- \n -->
			<div id="gene-select-oMatic2"></div>
		</td>
	</tr>
	<tr>
		<td>
			Search by gene amplification and deletion
		</td>
		<td>
			<dl class="tip"><dt>Gene</dt><dd>Select a gene</dd></dl>
			<!-- \n -->
			<div id="gene-select-oMatic3"></div>
		</td>
	</tr>
	<!--
	<tr>
		<td>
			Search by chromosome amplification and deletion	
			<!-- \n -->
			<strong>WORK IN PROGRESS </strong>
		</td>
		<td>
			<dl class="tip"><dt>Chromosome</dt><dd>Select a chromosome</dd></dl>
			<!-- \n -->
			<html:select property="chrCNV" size="8"	styleId="chrCNV" onclick="clearGenes()">
			<html:options collection="chrValuesCNV" property="value" labelProperty="label"/>
			</html:select>
			<html:radio property="arm" value="P">P arm</html:radio>  
			<html:radio property="arm" value="Q">Q arm</html:radio>
		</td>
	</tr>
	-->
	<tr class="buttons">
		<td colspan="2">
			<table>
				<tr>
					<td>
						<input type="submit" VALUE="Search">
						<input type="button" VALUE="Reset" onclick="resetForm()">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</html:form>
<!-- If the page reloads to update variants don't go back to the top of the page -->
<c:if test="${not empty update}">
<script>
	document.location="#variantsLocation"
</script>
</c:if>
</jsp:body>
</jax:mmhcpage>

