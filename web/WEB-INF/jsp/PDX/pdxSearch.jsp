<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft" subtitle="Search Form" help="userHelp.jsp#pdxsearch">
<jsp:attribute name="head">


        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 

	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

 
  
  
	<script type="text/javascript">
	
		function updateVariants(){
			document.getElementById("variantResult").innerHTML="<br>Please wait..."
			document.forms[0].action="pdxSearch.do";
			document.forms[0].submit();
		}
 		
		function resetForm(){
			document.forms[0].reset();
 		
			if(document.getElementById("variantSelect") != null){
				document.getElementById("variantSelect").style.visibility="hidden";
			}
			document.forms[0].modelID.value="";
			document.forms[0].gene.value="";
			document.forms[0].genes2.value="";
			document.forms[0].genesCNV.value="";
 		
			
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
				listEmptyText:'',
				renderTo: 'modelIDCombo'
		//		,pageSize:10
			});
			
  		
			
			var dataProxy = new Ext.data.HttpProxy({
				url: '/mtbwi/pdxHumanGenes.do'
			})
		
			var humanGenestore = new Ext.data.ArrayStore({
				id:'thestore',
 	//   		pageSize: 10, 
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
				listEmptyText:'',
				renderTo: 'geneSelectOMatic'
		//		,pageSize:10
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
				listEmptyText:'',
				renderTo: 'geneSelectOMatic2'
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
				listEmptyText:'',
				renderTo: 'geneSelectOMatic3'
			});
 		
		});
	
	</script>
</jsp:attribute> 
<jsp:body>	


<section id="summary">
	<div class="container">
		<p>Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.  PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.  The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.</p>
		<p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p>
		<p><a href="userHelp.jsp#pdxsearch" target="_blank">Help and Documentation</a></p>
	</div>
</section>


<section id="pdx">
	<div class="container">


<!-- method="GET" -->
<!-- jax:searchform action="pdxSearchResults" -->
<html:form action="pdxSearchResults" method="GET" styleClass="search-form">

<fieldset>
	<legend data-tip="Enter a Model ID (eg TM:00001) as search criteria.">Search by PDX model identifier</legend>
	<div id ="modelIDCombo"></div>&nbsp;eg. TM00001
</fieldset>

<fieldset>
	<legend>Search by primary cancer site</legend>
    <fieldset>
    	<legend data-tip="Select one or more primary sites as search criteria">Primary Site</legend>
    	<html:select property="primarySites" size="8" multiple="true">
    	<html:option value="">ANY</html:option>
    	<html:options collection="primarySitesValues" property="value" labelProperty="label"/>
    	</html:select>
    </fieldset>

    <fieldset>
        <legend data-tip="Only return models with selected additional information.">Limit results to models</legend>	
    	<html:checkbox property="dosingStudy"/> with dosing study data<br>
    	<html:checkbox property="treatmentNaive"/><label data-tip="PDX models are considered treatment naive if the patient did not receive chemotherapy, immunotherapy, hormone therapy or radiation therapy for this primary cancer within 5 years prior to sample collection and/or within 1 year for a different cancer.">from treatment naive patients.</label>
    </fieldset>

	<c:if test="${not empty tagsValues}">    
    <fieldset>
        <legend data-tip="Only return models tagged as.">Limit results to models tagged as</legend>
    	<html:select property="tags" size="4" multiple="true">
    	<html:options collection="tagsValues" property="value" labelProperty="label"/>
    	</html:select>
    </fieldset>
	</c:if>
</fieldset>

<fieldset>
	<legend>Search by diagnosis</legend>
	<fieldset>	
		<legend data-tip="Select a diagnosis or diagnoses as search criteria.">Diagnosis</legend>
		<html:select property="diagnoses" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="diagnosesValues" property="value" labelProperty="label"/>
		</html:select>
	</fieldset>
</fieldset>

<fieldset>
	<legend>Search by dosing study results</legend>   
    <fieldset>
	    <legend data-tip="RECIST drug.">Drug</legend>
    	<html:select property="recistDrugs" size="4" >
    	<html:options collection="recistDrugs" property="value" labelProperty="label"/>
    	</html:select>
    </fieldset> 
      
    <fieldset>
        <legend data-tip="RECIST response.">Response</legend>	
    	<html:select property="recistResponses" size="4" >
    	<html:options collection="recistResponses" property="value" labelProperty="label"/>
    	</html:select>
    </fieldset>
</fieldset>




<fieldset>
	<legend>Search by tumor mutation burden (TMB) score range</legend>
         <table style="width:50%">
             <tr><td align="center"><label for="TMBGT">Minimum:${minTMB}</label></td>
                <td></td>
                <td align="center"><label for="TMBLT">Maximum:${maxTMB}</lable></td>
                <td>&nbsp;&nbsp; ( TMB > 22  is considered high.)</td>
            </tr>
            <tr><td align="center"><html:text size="4" property="TMBGT"/></td>
                <td align="center"> <b>&lt;=</b>&nbsp;&nbsp;<b><a class="help" href="userHelp.jsp#pdxTMB" >TMB</a></b>&nbsp;&nbsp;<b>&lt;=</b></td>
                <td align="center"> <html:text size="4" property="TMBLT"/></td>
                <td></td>
            </tr>
        </table>
	
</fieldset>



<fieldset>
	<legend>Search by fusion gene</legend>
	<fieldset>
		<legend ata-tip="Select a fusion gene as search criteria.">Fusion Gene</legend>
		<html:select property="fusionGenes" size="4" >
			<html:option value="Any">ANY</html:option><!-- this has a value because it is a constraint ie only some models have fusion genes  -->
			<html:options collection="fusionGenes" property="value" labelProperty="label"/>
		</html:select>
	</fieldset>
</fieldset>


<fieldset>
	<legend>Search by gene variants (in engrafted tumors)</legend>
	<fieldset>
		<legend data-tip="Select one or more genes as search criteria">Gene</legend>
		<div id="geneSelectOMatic"></div>
	</fieldset>

	<fieldset>
		<input type="button" value="Show Variants" onclick="updateVariants()">
		<a id="variantsLocation"></a>
	</fieldset>
	
	<fieldset>

		<c:choose>
			<c:when test="${not empty variantsValues}">
			<legend data-tip="Select one or more variants as search criteria">Variants</legend>	

				<html:select property="variants" size="8" multiple="false" styleId="variantSelect">
					<html:option value="">ANY</html:option>
					<html:options collection="variantsValues" property="value" labelProperty="label"/>
				</html:select>
			
				<div id="variantResult"></div>
			</c:when>
			<c:otherwise>
			<legend>Variants</legend>	
				<div id="variantResult">No variants for selected gene.</div>
			</c:otherwise>
		
		</c:choose>
	</fieldset>
</fieldset>   		



<fieldset>
	<legend>Display a chart of gene expression across PDX models for a gene</legend>
	<fieldset>
		<legend data-tip="Select a gene to view expression values">Gene</legend>	
		<div id="geneSelectOMatic2"></div>
	</fieldset>
</fieldset>

<fieldset>
	<legend>Search by gene amplification and deletion</legend>
	<fieldset>
		<legend data-tip="Select a gene">Gene</legend>
		<div id="geneSelectOMatic3"></div>
	</fieldset>
</fieldset>

<input type="submit" VALUE="Search">
<input type="button" VALUE="Reset" onclick="resetForm()">

<!-- /jax:searchform -->


					
</html:form>
	</div>
</section>

<c:if test="${not empty update}">
<script>
	document.location="#variantsLocation"
</script>
</c:if>
</jsp:body>
</jax:mmhcpage>



