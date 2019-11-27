<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>

        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 



    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Search Form"/>
    </c:import>

    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

 
  
  
    <script  language="javascript">
    
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
                listEmptyText:'no matching gene',
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
                listEmptyText:'no matching gene',
                renderTo: 'geneSelectOMatic3'
            });
         
        });
    
    </script>


    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Search Form"/>
    </c:import>

    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="200" valign="top">
        <c:import url="../../../pdxToolBar.jsp" />
    </td>
    <td class="separator">
        &nbsp;
    </td>
    <td valign="top">
        <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
            <tr>
                <td>
                    <!--======================= Start Main Section =============================-->

                    <!--======================= Start Form Header ==============================-->
            <html:form action="pdxSearchResults" method="GET">

                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxsearch"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Patient Derived Xenograft Search Form
                                    </td>
                                    <td width="20%" valign="middle" align="right">
                                        <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location='pdxRequest.do'">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <tr class="pageInfo">
                        <td colspan="2">
                            <table border=0 cellspacing=2 width="100%">
                                <tr>
                                    <td>
                                        &nbsp;Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.  PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.  The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.   
                                        <br>
                                        &nbsp;
                                        <br>
                                       
                                    </td>

                                    <td>
                                        <img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" border=0 alt="NSG Mouse">
                                    <td>
                                </tr>

                            </table>
                        </td>

                    </tr>


                    <tr class="buttons">
                        <td colspan="2">
                            <table border=0 cellspacing=2 width="100%">
                                <tr>
                                    <td>
                                        <input type="submit" VALUE="Search">
                                        <input type="button" VALUE="Reset" onclick="resetForm()">


                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr class="stripe1">
                        <td class="cat1">
                            Search by PDX model identifier
                        </td>
                        <td class="data1" >
                            <table border="0" cellspacing="5">
                                <tr>
                                    <td></td><td></td>
                                </tr>

                                <tr>
                                    <td>
                                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Enter a Model ID (eg TM:00001) as search criteria.', CAPTION, 'Model ID');" onmouseout="return nd();">Model ID</a></b>
                                      
                         
                                <br>
                                <div id ="modelIDCombo"></div>&nbsp;eg. TM00001
                        </td>

                    </tr>

                </table>
                </td>
                </tr>

                <tr class="stripe2">

                    <td class="cat2">
                        Search by primary cancer site
                    </td>

                    <td class="data2">
                        <table>


                            <tr>
                                <td>
                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more primary sites as search criteria', CAPTION, 'Primary Site');" onmouseout="return nd();">Primary Site</a></b>
                                    <br>
                            <html:select property="primarySites" size="8" multiple="true">
                                <html:option value="">ANY</html:option>
                                <html:options collection="primarySitesValues" property="value" labelProperty="label"/>
                            </html:select>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Only return models with selected additional information.', CAPTION, 'Limit results');" onmouseout="return nd();">Limit results to models</a></b>     
                        <br>
                <html:checkbox property="dosingStudy"/> with dosing study data, <html:checkbox property="treatmentNaive"/> 
                <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('PDX models are considered treatment naive if the patient did not receive chemotherapy, immunotherapy, hormone therapy or radiation therapy for this primary cancer within 5 years prior to sample collection and/or within 1 year for a different cancer.', CAPTION, 'Treatment Naive');" onmouseout="return nd();">
                from treatment naive patients.
                <br></a>
                <br>
                <c:choose>
                    <c:when test="${not empty tagsValues}">
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Only return models tagged as.', CAPTION, 'Limit results');" onmouseout="return nd();">Limit results to models tagged as</a></b>     
                        <br>
                        <html:select property="tags" size="4" multiple="true">
                            <html:options collection="tagsValues" property="value" labelProperty="label"/>
                        </html:select>
                    </c:when>
                </c:choose>
                <tr>
                    </td>
                </tr>
        </table>
    </td>
</tr>
<tr class="stripe1">
    <td class="cat1">
        Search by diagnosis
    </td>
    <td class="data1">
        <table>
            <tr>
                <td>
                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a diagnosis or diagnoses as search criteria.', CAPTION, 'Diagnosis');" onmouseout="return nd();">Diagnosis</a></b>
                    <br>
            <html:select property="diagnoses" size="8" multiple="true">
                <html:option value="">ANY</html:option>
                <html:options collection="diagnosesValues" property="value" labelProperty="label"/>
            </html:select>
    </td>
</tr>

</table>
</td>
</tr>


<tr class="stripe2">
    <td class="cat2">
        Search by dosing study results
    </td>
    <td class="data2">
        <table>
            <tr>
                <td>
                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('RECIST drug.', CAPTION, 'RECIST drug');" onmouseout="return nd();">Drug</a></b>
                    <br>
            <html:select property="recistDrugs" size="4" >
                <html:options collection="recistDrugs" property="value" labelProperty="label"/>
            </html:select>
                </td>
                <td>
                     <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('RECIST response.', CAPTION, 'RECIST response');" onmouseout="return nd();">Response</a></b>
                    <br>
                
             <html:select property="recistResponses" size="4" >
                <html:options collection="recistResponses" property="value" labelProperty="label"/>
            </html:select>
    </td>
</tr>

</table>
</td>
</tr>

<tr class="stripe1">
    <td class="cat1">
        Search by tumor mutation burden (TMB) score range
    </td>
    <td class="data1">
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
    </td>
</tr>


<tr class="stripe2">
    <td class="cat2">
        Search by fusion gene
    </td>
    <td class="data2">
        <table>
            <tr>
                <td>
                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a fusion gene as search criteria.', CAPTION, 'Fusion Gene');" onmouseout="return nd();">Fusion Gene</a></b>
                    <br>
            <html:select property="fusionGenes" size="4" >
                <html:option value="Any">ANY</html:option><!-- this has a value because it is a constraint ie only some models have fusion genes  -->
                <html:options collection="fusionGenes" property="value" labelProperty="label"/>
            </html:select>
    </td>
</tr>

</table>
</td>
</tr>
 

<tr class="stripe1">

    <td class="cat1">
        Search by gene variants (in engrafted tumors)
    </td>

    <td class="data1">
        <table>

            <tr>
                <td>
                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more genes as search criteria', CAPTION, 'Genes');" onmouseout="return nd();">Gene</a></b>
                    <br>
                    <div id="geneSelectOMatic"></div>
                </td>


                <td>
                    <br>
                    <input type="button" value="Show Variants" onclick="updateVariants()">
                    <a id="variantsLocation"></a>
                </td>


            <c:choose>
                <c:when test="${not empty variantsValues}">
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select one or more variants as search criteria', CAPTION, 'Variants');" onmouseout="return nd();">Variants</a></b>
                        <br> 
                    <html:select property="variants" size="8" multiple="false" styleId="variantSelect">
                        <html:option value="">ANY</html:option>
                        <html:options collection="variantsValues" property="value" labelProperty="label"/>
                    </html:select>
                    </td>
                    <td id="variantResult"></td>
                </c:when>
                <c:otherwise>
                    <td id="variantResult"><br>No variants for selected gene.</td>
                </c:otherwise>

            </c:choose>
</tr>

</table>
</td>
</tr>


<tr class="stripe2">
    <td class="cat2">
        Display a chart of gene expression across PDX models for a gene
    </td>

    <td class="data2">
        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a gene to view expression values', CAPTION, 'Gene');" onmouseout="return nd();">Gene</a></b>
        <br>

        <div id="geneSelectOMatic2"></div>
    </td>
</tr>

<tr class="stripe1">
    <td class="cat1">
        Search by gene amplification and deletion
    </td>

    <td class="data1">

        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a gene', CAPTION, 'Gene');" onmouseout="return nd();">Gene</a></b>
        <br>

        <div id="geneSelectOMatic3"></div>

    </td>
</tr>


<!--
<tr class="stripe2">
    <td class="cat2">
        Search by chromosome amplification and deletion  <br><b>WORK IN PROGRESS </b>
    </td>

    <td class="data2">

        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Select a chromosome', CAPTION, 'Chromosome');" onmouseout="return nd();">Chromosome</a></b>
        <br>

<html:select property="chrCNV" size="8"  styleId="chrCNV" onclick="clearGenes()">
    <html:options collection="chrValuesCNV" property="value" labelProperty="label"/>
</html:select>
<html:radio property="arm" value="P">P arm</html:radio> &nbsp; 
<html:radio property="arm" value="Q">Q arm</html:radio>

</td>
</tr>

-->


<tr class="buttons">
    <td colspan="2">
        <table border=0 cellspacing=5 width="100%">
            <tr>
                <td>
                    <input type="submit" VALUE="Search">
                    <input type="button" VALUE="Reset" onclick="resetForm()">
                </td>
            </tr>
        </table>
    </td>
</tr>
</html:form>
</table>
<!--======================== End Main Section ==============================-->

</td>
</tr>
</table>
</td>
</tr>
</table>
<!-- If the page reloads to update variants don't go back to the top of the page -->
<c:if test="${not empty update}">
    <script>
        document.location="#variantsLocation"
    </script>
</c:if>
</body>
</html> 
