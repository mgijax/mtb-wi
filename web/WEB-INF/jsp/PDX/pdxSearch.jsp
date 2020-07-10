<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft" subtitle="Search Form" help="userHelp.jsp#pdxsearch">
<jsp:attribute name="head">


        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 

    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

 
  
  
    <script  language="text/javascript">
    
        function updateVariants(){
            document.getElementById("variantResult").innerHTML="<br>Please wait..."
            document.forms[1].action="pdxSearch.do";
            document.forms[1].submit();
        }
         
        function resetForm(){
            document.forms[1].reset();
         
            if(document.getElementById("variantSelect") != null){
                document.getElementById("variantSelect").style.visibility="hidden";
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
                listEmptyText:'',
                renderTo: 'modelIDCombo'
        //        ,pageSize:10
            });
            
          
            
            var dataProxy = new Ext.data.HttpProxy({
                url: '/mtbwi/pdxHumanGenes.do'
            })
        
            var humanGenestore = new Ext.data.ArrayStore({
                id:'thestore',
     //           pageSize: 10, 
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
        //        ,pageSize:10
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
<jax:searchform action="pdxSearchResults">



<fieldset>
    <legend>Search by PDX model identifier</legend>

    <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Enter a Model ID (eg TM:00001) as search criteria.', CAPTION, 'Model ID');" onmouseout="return nd();">Model ID</a>
    
    <div id ="modelIDCombo"></div>&nbsp;eg. TM00001
</fieldset>





<fieldset>
    <legend>Search by primary cancer site</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more primary sites as search criteria', CAPTION, 'Primary Site');" onmouseout="return nd();">Primary Site</a></b>
    <br>
    <html:select property="primarySites" size="8" multiple="true">
    <html:option value="">ANY</html:option>
    <html:options collection="primarySitesValues" property="value" labelProperty="label"/>
    </html:select>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Only return models with selected additional information.', CAPTION, 'Limit results');" onmouseout="return nd();">Limit results to models</a></b>     
    
    <html:checkbox property="dosingStudy"/> with dosing study data
    <html:checkbox property="treatmentNaive"/> 
    <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('PDX models are considered treatment naive if the patient did not receive chemotherapy, immunotherapy, hormone therapy or radiation therapy for this primary cancer within 5 years prior to sample collection and/or within 1 year for a different cancer.', CAPTION, 'Treatment Naive');" onmouseout="return nd();">
    from treatment naive patients.</a>

    <c:if test="${not empty tagsValues}">
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Only return models tagged as.', CAPTION, 'Limit results');" onmouseout="return nd();">Limit results to models tagged as</a></b>     
    <br>
    <html:select property="tags" size="4" multiple="true">
    <html:options collection="tagsValues" property="value" labelProperty="label"/>
    </html:select>
    </c:if>
</fieldset>





<fieldset>
    <legend>Search by diagnosis</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a diagnosis or diagnoses as search criteria.', CAPTION, 'Diagnosis');" onmouseout="return nd();">Diagnosis</a></b>
    
    <html:select property="diagnoses" size="8" multiple="true">
    <html:option value="">ANY</html:option>
    <html:options collection="diagnosesValues" property="value" labelProperty="label"/>
    </html:select>
</fieldset>



<fieldset>
    <legend>Search by dosing study results</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('RECIST drug.', CAPTION, 'RECIST drug');" onmouseout="return nd();">Drug</a></b>
    
    <html:select property="recistDrugs" size="4" >
    <html:options collection="recistDrugs" property="value" labelProperty="label"/>
    </html:select>
    
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('RECIST response.', CAPTION, 'RECIST response');" onmouseout="return nd();">Response</a></b>
    
    
    <html:select property="recistResponses" size="4" >
    <html:options collection="recistResponses" property="value" labelProperty="label"/>
    </html:select>
</fieldset>




<fieldset>
    <legend>Search by tumor mutation burden (TMB) score range</legend>
    
    <table>
    <tr><td align="center">Minimum:${minTMB}</td>
    <td></td>
    <td align="center">Maximum:${maxTMB}</td>
    <td>&nbsp;&nbsp; ( TMB > 22  is considered high.)</td>
    </tr>
    <tr><td align="center"><html:text size="4" property="TMBGT"/></td>
    <td align="center"> <b>&lt;=</b>&nbsp;&nbsp;<b><a href="userHelp.jsp#pdxTMB" style="text-decoration: none; cursor:help;" onmouseover="return overlib('TMB is calculated for each sample associated with a PDX model.  Models will be returned if any of the samples meet the search criteria. Click for details on how TMB is cacluated.', CAPTION, 'Tumor mutation burden');" onmouseout="return nd();">TMB</a></b>&nbsp;&nbsp;<b>&lt;=</b></td>
    <td align="center"> <html:text size="4" property="TMBLT"/></td>
    <td></td>
    </tr>
    </table>
</fieldset>



<fieldset>
    <legend>Search by fusion gene</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a fusion gene as search criteria.', CAPTION, 'Fusion Gene');" onmouseout="return nd();">Fusion Gene</a></b>
    <br>
    <html:select property="fusionGenes" size="4" >
    <html:option value="Any">ANY</html:option><!-- this has a value because it is a constraint ie only some models have fusion genes  -->
    <html:options collection="fusionGenes" property="value" labelProperty="label"/>
    </html:select>
</fieldset>


<fieldset>
    <legend>Search by gene variants (in engrafted tumors)</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more genes as search criteria', CAPTION, 'Genes');" onmouseout="return nd();">Gene</a></b>
    
    <div id="geneSelectOMatic"></div>
    
    
    <input type="button" value="Show Variants" onclick="updateVariants()">
    <a id="variantsLocation"></a>
    
    
    
    <c:choose>
    <c:when test="${not empty variantsValues}">
    
            <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more variants as search criteria', CAPTION, 'Variants');" onmouseout="return nd();">Variants</a></b>
    
        <html:select property="variants" size="8" multiple="false" styleId="variantSelect">
            <html:option value="">ANY</html:option>
            <html:options collection="variantsValues" property="value" labelProperty="label"/>
        </html:select>
    
        <div id="variantResult"></div>
    </c:when>
    <c:otherwise>
        <div id="variantResult">No variants for selected gene.</div>
    </c:otherwise>
    
    </c:choose>
</fieldset>           



<fieldset>
    <legend>Display a chart of gene expression across PDX models for a gene</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a gene to view expression values', CAPTION, 'Gene');" onmouseout="return nd();">Gene</a></b>
    
    
    <div id="geneSelectOMatic2"></div>
</fieldset>



<fieldset>
    <legend>Search by gene amplification and deletion</legend>
    
    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a gene', CAPTION, 'Gene');" onmouseout="return nd();">Gene</a></b>
    
    <div id="geneSelectOMatic3"></div>
</fieldset>



<!-- <input type="submit" VALUE="Search">
<input type="button" VALUE="Reset" onclick="resetForm()"> -->



</jax:searchform>
    </div>
</section>

<c:if test="${not empty update}">
<script>
    document.location="#variantsLocation"
</script>
</c:if>
</jsp:body>
</jax:mmhcpage>



