<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft" subtitle="Search Form" help="userHelp.jsp#pdxsearch">
<jsp:attribute name="head">


        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 

	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

        <style>
            .trigger {
                display:initial;
                max-width: none;
                height:18px !important;
            }
        </style>
 
  
  
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
                        document.forms[0].fusionGenes.value="";
 		
			
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
                                triggerClass: "trigger",
				hiddenName:'modelID',
				width:560,
				listEmptyText:'',
				renderTo: 'modelIDCombo'
		//		,pageSize:10
			});
			
  		
			
			var humanGeneProxy = new Ext.data.HttpProxy({
				url: '/mtbwi/pdxHumanGenes.do'
			})
                        
		
			var humanGeneStore = new Ext.data.ArrayStore({
				id:'thestore',
 	//   		pageSize: 10, 
				root:'data',
				totalProperty: 'total',
				fields: [{name:'symbol'}, {name:'display'}],
				proxy: humanGeneProxy,
				autoLoad:false
			});
			
			var combo = new Ext.form.ComboBox({
				store: humanGeneStore,
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
				width:300,
				listEmptyText:'',
				renderTo: 'geneSelectOMatic'
		//		,pageSize:10
			});
	
			combo.setValue('${gene}');
			
			var ctpGeneProxy = new Ext.data.HttpProxy({
                                url: '/mtbwi/pdxHumanGenes.do?ctpOnly=ctpOnly'
			})
                        
                        
			var ctpStore = new Ext.data.ArrayStore({
                                                id: ctpStore,
                                                root:'data',
                                                totalProperty:'total',
                                                fields: [{name:'symbol'},{name:'display'}],
                                                proxy:ctpGeneProxy,
                                                autoLoad:false
						})
			
			var combo2 = new Ext.form.ComboBox({
				store: humanGeneStore,
				minChars:2,
				valueField:'symbol',
				displayField:'display',
				typeAhead: true,
			//	lazyRender:true,
				mode: 'remote',
				forceSelection: false,
				triggerAction: 'all',
				selectOnFocus:true,
				hideTrigger:true,
				hiddenName:'genes2',
				width:300,
				listEmptyText:'',
				renderTo: 'geneSelectOMatic2'
			});
			
			var combo3 = new Ext.form.ComboBox({
				store: humanGeneStore,
				minChars:2,
				valueField:'symbol',
				displayField:'display',
				typeAhead: true,
			//	lazyRender:true,
				mode: 'remote',
				forceSelection: false,
				triggerAction: 'all',
				selectOnFocus:true,
				hideTrigger:true,
				hiddenName:'genesCNV',
				width:300,
				listEmptyText:'',
				renderTo: 'geneSelectOMatic3'
			});
 		
		});
	
	</script>
</jsp:attribute> 
<jsp:body>	


<section id="summary">
	<div class="container">
            <p>
		Patient-Derived Xenografts (PDX) are generated through the engraftment and passaging of tissue or cells from a patient's tumor into an immunodeficient or humanized mouse host. 
                PDX models are an in vivo platform for cancer biology research and for pre-clinical testing of cancer drug efficacy.
            </p>
            <p>
                The Mouse Models of Human Cancer Database provides access to information on hundreds of PDX models distributed by The Jackson Laboratory (JAX). 
                Researchers can search for JAX PDXs by such criteria as primary cancer site, diagnosis, genomic characteristics of engrafted tumors, and PDX dosing study results.
            </p>
            <p >Related Resources:
            <ul style="font-size:14px">
                <li>Try MMHCdb's <a href="${pageContext.request.contextPath}/pdxLikeMe.do">PDX Like Me </a> search tool to find models in the JAX repository that match multiple genomic criteria.</li>
                <li>MMHCdb has partnered with the European Bioinformatics Institute to develop <a href="https://www.pdxfinder.org" target="_blank">PDX Finder</a>, a global catalog of over 4,000 PDX models.</li>
                <li><a href="pdxRequest.do" target="_blank">Contact</a> The Jackson Laboratory Mice, Research and Clinical Services group to request information on the JAX PDX program's capabilities and services.</li>
                <li>Learn <a href="${applicationScope.urlBase}/html/SOCHelp.html" target="_blank" >more</a> about how PDX models are generated at The Jackson Laboratory.</li>
                <li>See MMHCdb's <a href="userHelp.jsp#pdxsearch" target="_blank"> Help Documentation </a> for details on PDX search options and results.</li>
            </ul></p>
		
	</div>
</section>


<section id="pdx">
	<div class="container">


<!-- method="GET" -->
<!-- jax:searchform action="pdxSearchResults" -->
<html:form action="pdxSearchResults" method="GET" styleClass="search-form" styleId="pdx-form">
    
    
    
<fieldset class="form-buttons">
	<input type="submit" VALUE="Search">
	<input type="button" VALUE="Reset" onclick="resetForm()">
</fieldset>

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

    <fieldset style="max-width:50%;">
        <legend data-tip="Only return models with selected additional information.">Limit results to models</legend>	
    	<html:checkbox property="dosingStudy"/> with dosing study data<br>
    	<html:checkbox property="treatmentNaive"/><label data-tip="PDX models are considered treatment naive if the patient did not receive chemotherapy, immunotherapy, hormone therapy or radiation therapy for this primary cancer within 5 years prior to sample collection and/or within 1 year for a different cancer.">from treatment naive patients</label>
     <!--   <html:checkbox property="currentlyAvailable"/><label data-tip="Some models only have data. This will return models available for order form JAX.">currently available</label>  -->
    </fieldset>

</fieldset>
    
	<c:if test="${not empty tagsValues}">    
    <fieldset >
        <legend data-tip="Return models tagged with clinical cancer characteristics. More than one tag can be selected.">Search for models tagged as:</legend>
    	<html:select property="tags" size="4" multiple="true" style="width:70%;">
    	<html:options collection="tagsValues" property="value" labelProperty="label"/>
    	</html:select>
    </fieldset>
	</c:if>

<fieldset>
	<legend data-tip="Return models that match the diagnostic term(s). More than one diagnosis can be selected">Search by diagnosis</legend>
	
		<html:select property="diagnoses" size="8" style="width:70%" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="diagnosesValues" property="value" labelProperty="label"/>
		</html:select>
	
</fieldset>

<fieldset>
	<legend>Search by PDX dosing study results</legend>   
    <fieldset>
	    <legend>Treatment</legend>
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
                <td align="center"><label for="TMBLT">Maximum:${maxTMB}</label></td>
                <td nowrap>&nbsp;&nbsp; ( TMB > 22  is considered high.)</td>
            </tr>
            <tr><td align="center"><html:text size="4" property="TMBGT"/></td>
                <td align="center"> <b>&lt;=</b>&nbsp;&nbsp;<b><a class="help" href="userHelp.jsp#pdxTMB" >TMB</a></b>&nbsp;&nbsp;<b>&lt;=</b></td>
                <td align="center"> <html:text size="4" property="TMBLT"/></td>
                <td></td>
            </tr>
        <!--    <tr>
                <td colspan="2" align="right"><html:checkbox property="pediatric"/><b><a class="help" href="userHelp.jsp#pdxPediatricTMB" >Use pediatric TMB</a></b></td>
                <td align="center">Maximum:38.3</td>
                <td nowrap>&nbsp; &nbsp; ( TMB > 3.0 is considered high.)</td></tr>
           -->
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


<fieldset >
	<legend>Search by gene variants (in engrafted tumors)</legend>
        <fieldset style="display:inline-block;">
	<fieldset>
		<legend data-tip="Select one or more genes as search criteria">Gene</legend>
		<div id="geneSelectOMatic"></div>
	</fieldset>

	<fieldset>
		<input type="button" value="Show Variants" onclick="updateVariants()">
		<a id="variantsLocation"></a>
	</fieldset>
	
	<fieldset>

		
			<c:if test="${not empty variantsValues}">
			<legend data-tip="Select one or more variants as search criteria">Variants</legend>	

				<html:select property="variants" size="8" multiple="false" styleId="variantSelect">
					<html:option value="">ANY</html:option>
					<html:options collection="variantsValues" property="value" labelProperty="label"/>
				</html:select>
			
				<div id="variantResult"></div>
			</c:if>
                        <c:if test="${not empty gene && empty variantsValues}">
			<legend>Variants</legend>	
				<div id="variantResult">No variants for ${gene}.</div>
			</c:if>
                                
                        <c:if test="${empty gene}">	
				<div id="variantResult"></div>
			</c:if>
		
	</fieldset>
        </fieldset>
</fieldset>   		



<fieldset>
	<legend>Display gene expression across PDX models</legend>
	<fieldset>
		<legend data-tip="Start typing to select a gene to view expression values">Gene</legend>	
		<div id="geneSelectOMatic2"></div>
	</fieldset>
</fieldset>

<fieldset>
	<legend>Display amplification and deletion data across PDX models</legend>
	<fieldset>
		<legend data-tip="Start typing to select a gene to view amplifications and deletions">Gene</legend>
		<div id="geneSelectOMatic3"></div>
	</fieldset>
</fieldset>

<fieldset class="form-buttons">
	<input type="submit" VALUE="Search">
	<input type="button" VALUE="Reset" onclick="resetForm()">
</fieldset>

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



