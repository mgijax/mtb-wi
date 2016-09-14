<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>

        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
        
<style type="text/css">
    /* this color is totaly arbitrary -- sota salmony */
.x-grid3-row.false-positive .x-grid3-cell{ 
    background-color:  #ffe2e2 !important; 
    color: #900; 
} 

</style>
        
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="PDX Model Details"/>
    </c:import>

    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>

    <script language="javascript">
        
        google.load("visualization", "1", {packages:["corechart"]});
    
        Ext.ns('org.jax.mgi.mtb');
        
        var expressionData, expressionBarChart, cnvData, cnvBarChart;
        
        var expGeneSortDir = false;
        var expRankSortDir = true;
        
        var cnvGeneSortDir = false;
        var cnvRankSortDir = true;
        
        var cnvLog = true;
        
        
        
        var expressionOptions = {
            fontSize:10,
            title: 'Gene Expression by Percentile Rank Z Score',
            titleTextStyle:{fontSize:14},
            vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
            chartArea:{top:5, height:"95%"}
             
        };
         
        var cnvOptionsLog = {
            fontSize:10,
            legend: {position: 'none'},
            vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
            hAxis: {logScale:true},
            chartArea:{top:5, height:"95%"}
                        
        };
                    
        var cnvOptionsLinear = {
            fontSize:10,
            legend: {position: 'none'},
            vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
            chartArea:{top:5, height:"95%"}
                        
        };
        
        var currentCnvOptions = cnvOptionsLinear;
        
        
        function expSortGene(){
            expGeneSortDir = !expGeneSortDir;
            expressionData.sort({column:0,desc:expGeneSortDir});
            expressionBarChart.draw(expressionData, expressionOptions);
        }
            
        function expSortRank(){
            expRankSortDir = !expRankSortDir;
            expressionData.sort({column:1,desc:expRankSortDir});
            expressionBarChart.draw(expressionData, expressionOptions);
        }
        
        function cnvSortGene(){
            cnvGeneSortDir = !cnvGeneSortDir;
            cnvData.sort({column:0,desc:cnvGeneSortDir});
            cnvBarChart.draw(cnvData, currentCnvOptions);
        }
            
        function cnvSortRank(){
            cnvRankSortDir = !cnvRankSortDir;
            cnvData.sort({column:1,desc:cnvRankSortDir});
            cnvBarChart.draw(cnvData, currentCnvOptions);
        }
        
        function logUnLog(){
            if(cnvLog){
                currentCnvOptions = cnvOptionsLog;
            }else{
                currentCnvOptions = cnvOptionsLinear;
            }
            cnvBarChart.draw(cnvData,currentCnvOptions);
            cnvLog = !cnvLog;
        }
        
         
        function doExpressionBarChart() {
              
            expressionData = google.visualization.arrayToDataTable([${geneExpressionData}]);
                
            if(expressionData.getNumberOfRows() >0 ){
                expressionData.sort(0);
                expressionBarChart = new google.visualization.BarChart(document.getElementById('geneExpressionChart'));
                expressionBarChart.draw(expressionData, expressionOptions);
            }
        }
         
        function doCnvBarChart() {
            cnvData = google.visualization.arrayToDataTable([${geneCNVData}]);
                
            if(cnvData.getNumberOfRows() >0 ){
                cnvData.sort(0);
                cnvBarChart = new google.visualization.BarChart(document.getElementById('geneCNVChart'));
                cnvBarChart.draw(cnvData, cnvOptionsLinear);
            }
        }
        
    
        Ext.onReady(function(){
      
            var dataProxy = new Ext.data.HttpProxy({
                url: '/mtbwi/pdxVariationData.do?modelID=${modelID}'
            })
		
            var fields =     [
                    {name: 'model_id'},
                    {name: 'sample_name'},
                    {name: 'gene_symbol'},
                    {name: 'platform'},
                    {name: 'chromosome'},
                    {name: 'seq_position'},
                    {name: 'ref_allele'},
                    {name: 'alt_allele'},
                    {name: 'consequence'},
                    {name: 'amino_acid_change'},
                    {name: 'rs_variants'},
                    {name: 'read_depth'},
                    {name: 'allele_frequency'},
                    {name: 'transcript_id'},
                    {name: 'filtered_rationale'},
                    {name: 'passage_num'},
                    {name: 'gene_id'},
                    {name: 'ckb_evidence_types'},
                    {name: 'cancer_types_actionable'},
                    {name: 'drug_class'},
                    {name: 'variant_num_trials'},
                    {name: 'variant_nct_ids'}
                    
                ];
                
             
                 
                 
             
	
            // create the Data Store
            var store = new Ext.data.ArrayStore({
                root: 'variation',
                totalProperty: 'total',
                //    idIndex: 0,
                remoteSort: true,
                autoLoad:true,
                // these need to match the webservice field names for sorting to work
                fields: fields,
                proxy: dataProxy
            });
	
            store.setDefaultSort('gene_symbol', 'ASC');
            
            var grid = new Ext.grid.GridPanel({    
                store: store,
                columns: [
                    {
                        header   : 'Sample', 
                        width    : 75, 
                        sortable : true, 
                        dataIndex: 'sample_name'
                    },
                    {
                        header   : 'Gene', 
                        width    : 60, 
                        sortable : true, 
                        dataIndex: 'gene_symbol'
                    },
                    {
                        header   : 'Platform', 
                        width    : 80, 
                        sortable : true, 
                        dataIndex: 'platform'
                    },
                    {
                        header   : 'Chromosome', 
                        width    : 70, 
                        sortable : true, 
                        dataIndex: 'chromosome'
                    },
                    {
                        header   : 'Seq Position', 
                        width    : 80, 
                        sortable : true, 
                        dataIndex: 'seq_position'
                    },
                    {
                        header   : 'Ref Allele', 
                        width    : 65, 
                        sortable : true, 
                        dataIndex: 'ref_allele'
                    
                    },
                    {
                        header   : 'Alt Allele',
                        width    : 65,
                        sortable : true,
                        dataIndex: 'alt_allele'
                    
                    },
                    {
                        header   : 'Consequence',
                        width    : 170,
                        sortable : true,
                        dataIndex: 'consequence'
                    },
                    {
                        header   : 'Amino Acid Change', 
                        width    : 110, 
                        sortable : true,  
                        dataIndex: 'amino_acid_change'
                    },
                    {
                        header   : 'RS Variants', 
                        width    : 80, 
                        sortable : true, 
                        dataIndex: 'rs_variants'
                    },
                    {
                        header   : 'Read Depth', 
                        width    : 70, 
                        sortable : true, 
                        dataIndex: 'read_depth'
                    },
                    {
                        header   : 'Allele Frequency',
                        width    : 100,
                        sortable : true,
                        dataIndex: 'allele_frequency'
                    },
                    {
                        header   : 'Transcript ID', 
                        width    : 100, 
                        sortable : true,  
                        dataIndex: 'transcript_id'
                    },
                    {
                        header   : 'Filtered Rationale', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'filtered_rationale'
                        
                    },
                    {
                        header   : 'Passage Num', 
                        width    : 50, 
                        sortable : true,  
                        dataIndex: 'passage_num'
                    },
                    
                    {
                        header   : 'Gene ID', 
                        width    : 60, 
                        sortable : true, 
                        dataIndex: 'gene_id'
                    },
                     {
                        header   : 'CKB Evidence Type', 
                        width    : 70, 
                        sortable : true,  
                        dataIndex: 'ckb_evidence_types'
                    },
                    {
                        header   : 'Actionable Cancer Types',
                        width    : 120,
                        sortable : true,
                        dataIndex: 'cancer_types_actionable'
                    },
                    {
                        header   : 'Drug Class', 
                        width    : 70, 
                        sortable : true,  
                        dataIndex: 'drug_class'
                    },
                    {
                        header   : 'Variant Num Trials', 
                        width    : 100, 
                        sortable : true,  
                        dataIndex: 'variant_num_trials'
                    },
                    {
                        header   : 'Variant NCT IDs', 
                        width    : 100, 
                        sortable : true,  
                        dataIndex: 'variant_nct_ids'
                    }
        
                ],
                stripeRows: true,
                height:700,
                width: 1000,
                id:'pdxGrid',
				

                // paging bar on the bottom
                bbar: new Ext.PagingToolbar({
                    pageSize:30,
                    store: store,
                    displayInfo: true,
                    displayMsg: 'Displaying results {0} - {1} of {2}'			
                })
                
                
               
            });
            
            Ext.EventManager.onWindowResize(function(w, h){
                    panel.doLayout();
                });
            
            // there must be a better way...
            var colNames = [];
            colNames.push('model_id');
            colNames.push('sample_name');
            colNames.push('gene_symbol');
            colNames.push('platform');
            colNames.push('chromosome');
            colNames.push('seq_position');
            colNames.push('ref_allele');
            colNames.push('alt_allele');
            colNames.push('consequence');
            colNames.push('amino_acid_change');
            colNames.push('rs_variants');
            colNames.push('read_depth');
            colNames.push('allele_frequency');
            colNames.push('transcript_id');
            colNames.push('filtered_rationale');
            colNames.push('passage_num');
            colNames.push('gene_id');
            colNames.push('ckb_evidence_types');
            colNames.push('cancer_types_actionable');
            colNames.push('drug_class');
            colNames.push('variant_nct_ids');
            colNames.push('variant_num_trials')
            
            
            
            // focus on sort column otherwise focus always jumps to first column
            grid.on("sortChange", function(grid, sortInfo){
                if('gene_symbol' != sortInfo.field){
                    (function(){
                       grid.getView().focusCell(1,colNames.indexOf(sortInfo.field));
                    }).defer(75);
                }
            })
            // keep track of the index of columns when they move
            grid.on("columnmove", function(oldInd,newInd){
                col = colNames[oldInd];
                colNames.splice(oldInd,1);
                colNames.splice(newInd,0,col);
                
            })
            
            panel = new Ext.Panel({
                applyTo:'variantSummary',
                collapsible: true,
                collapsed: true,
                collapseFirst: true,
                title:'Click to expand/collapse',

                layout:{
                    type:'fit',
                    align:'stretch',
                    pack:'start'
                },
                titleCollapse:true,
                hideCollapseTool:true,
                items:[grid]
            });

            panel.render();
            
            panel.doLayout();
                    
            checkVariants = function(){
                if(store.getTotalCount()==0){
                    document.getElementById("noVariantSummary").style.display="block";
                    document.getElementById("variantData").style.display="none";
                    document.getElementById("variantSummary").style.display="none";
                }
            }
        
            store.on("load",checkVariants);
            store.load();
            
            if(document.getElementById("geneExpressionDiv")!= null){
            
                panel2 = new Ext.Panel({
                    applyTo:'geneExpressionDiv',
                    collapsible: true,
                    collapsed: true,
                    collapseFirst: false,
                    title:'Click to expand/collapse',
                    forceLayout:true,
                    layout:{
                        type:'fit',
                        align:'stretch',
                        pack:'start'
                    },
                    titleCollapse:true,
                    hideCollapseTool:true,
                    items:[{html:'<b>Sort by:</b><input type="button" value="Gene" onclick="expSortGene()">'+
                                '&nbsp;<input type="button" value="Rank" onclick="expSortRank()">'+
                                '<br><div id="geneExpressionChart" style="height:${expChartSize}px"></div>'}]
                });

                panel2.on('expand',doExpressionBarChart);  
                panel2.render();
                panel2.doLayout();
            }
            
            if(document.getElementById("geneCNV") != null){
           
                panel3 = new Ext.Panel({
                    applyTo:'geneCNV',
                    collapsible: true,
                    collapsed: true,
                    collapseFirst: false,
                    title:'Click to expand/collapse',
                    forceLayout:true,
                    layout:{
                        type:'fit',
                        align:'stretch',
                        pack:'start'
                    },
                    titleCollapse:true,
                    hideCollapseTool:true,
                    items:[{html:'<p style="text-align:center;">Orange bars indicate gene amplification (copy number > 2.5). Blue bars indicate gene deletion (copy number < 1.5). Grey bars indicate no significant copy number change.</p>'+
                                '<br><input type="button" value="Toggle Log Scale" onclick="logUnLog()">'+
                                '&nbsp;<b>Sort by:</b><input type="button" value="Gene" onclick="cnvSortGene()">'+
                                '&nbsp;<input type="button" value="Rank" onclick="cnvSortRank()"<br>'+
                                ' <div id="geneCNVChart" style="height:${cnvChartSize}px" ></div>'}]

                });

                panel3.on('expand',doCnvBarChart);  
                panel3.render();
                panel3.doLayout();
            }
        });
        
    </script>



    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="PDX Model Details"/>
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
            <html:form action="pdxAddContent" method="GET">
                <input type="hidden" name="modelID" value="${mouse.modelID}"/>
                <!--======================= Start Main Section =============================-->
                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border="0" cellpadding="4" cellspacing="4">
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxdetails"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        PDX Model Details
                                    </td>
                                    <td width="20%" valign="middle" align="right">
                                         <c:if test="${empty unavailable}">
                                            <input type="button" value="Request more &#x00A; information on this &#x00A; PDX model." class="pdxRequestButton" onclick="window.location='pdxRequest.do?mice=${mouse.modelID}'">    
                                         </c:if>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr class="stripe1">
                        <td class="cat1">
                            Model Details
                        </td>
                        <td class="data1">
                            <table border=0 cellpadding=5 cellspacing=0 width="100%">

                                <tr>
                                    <td class="normal" style="width:100%; text-align:center" colspan=2>
                                <c:if test="${not empty unavailable}">
                                    <b> This PDX model is no longer available <br>(no inventory remaining).</b>
                                </c:if>
                        </td>
                        <td class="normal" ></td><td class="normal" ></td>
                        <td class="normal" ></td><td class="normal" ></td>
                    <tr>
                        <td class="label" style="width:10%">Model ID:</td><td class="normal" style="width:22%">${mouse.modelID}</td>

                        <td class="label" style="width:10%">Previous ID:</td><td class="normal" style="width:18%">${mouse.previousID}</td>

                        <td class="label" style="width:14%"></td><td class="normal" style="width:26%"></td>
                    </tr>
                    <tr>
                        <td class="label">Primary Site:</td><td class="normal" >${mouse.primarySite}</td>

                        <td class="label">Initial Diagnosis:</td><td class="normal" >${mouse.initialDiagnosis}</td>

                        <td class="label">Final Diagnosis:</td><td class="normal" >${mouse.clinicalDiagnosis}</td>
                        
                        <td></td>

                    </tr>
                    <tr>

                        <td class="label">Tumor Site:</td><td class="normal" >${mouse.tissue}</td>

                        <td class="label">Tumor Type:</td><td class="normal" >${mouse.tumorType}</td>

                        <td class="label">Stage / Grade:</td><td class="normal" >${mouse.stage} / ${mouse.grade}<td></td>

                    </tr>
                    
                    <c:if test="${not empty mouse.fusionGenes}">
                        <tr>
                            <td class="label" style="vertical-align: top">Fusion Genes:</td><td colspan="5">${mouse.fusionGenes}</td>
                        </tr>    
                    </c:if>

                </table>   
                </td>
                </tr>
                <tr class="stripe2">
                    <td class="cat2">
                        Patient
                    </td>
                    <td class="data2">
                        <table border=0 cellpadding=5 cellspacing=0 width="100%">

                            <tr>
                                <td class="label" style="width:10%">Sex:</td><td class="normal" style="width:22%">${mouse.sex}</td>

                                <td class="label" style="width:10%">Age:</td><td class="normal" style="width:18%">${mouse.age}</td>

                                <td class="label" style="width:14%">Race / Ethnicity:</td><td class="normal" style="width:26%">${mouse.race} / ${mouse.ethnicity}</td>

                            </tr>
                        </table>
                    </td>
                </tr>

                <tr class="stripe1">
                    <td class="cat1">
                        Engraftment Host
                    </td>
                    <td class="data1">
                        <table  border=0 cellpadding=5 cellspacing=0 width="100%">

                            <tr>
                                <td class="label" style="width:10%">Strain:</td><td class="normal"  style="width:22%">${mouse.strain}</td>

                                <td class="label" style="width:10%">Implantation Site:</td><td class="normal" style="width:18%">${mouse.location}</td>

                                <td class="label" style="width:14%">Sample Type:</td><td class="normal" style="width:26%">${mouse.sampleType}</td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr class="stripe2">
                    <td class="cat2">
                        Variant Summary
                    </td>
                    <td class="data2">
                        <b>PLEASE NOTE</b> that PDX genomics is changing to reference GRCh38. Genomic coordinates differ depending on platform.<br> CTP, TruSeq JAX and whole exome use GRCh38. CNV and RNA-Seq are in GRCh37 (hg19) coordinates. 
                        <table id="noVariantSummary" style="display: none" border=0 cellpadding=5 cellspacing=0 width="100%">
                            <tr>
                                <td class="normal">
                                    Variant Summary currently not available.
                                </td>
                            </tr>
                        </table>

                        <div id="variantSummary"></div>
                        <br>
                  <!--      <input id="variantData" type="button" value="Download summary data in CSV format" onClick="popSizedPathWin('pdxDetails.do?csvSummary=true&modelID=${modelID}', '',120,120);return false;">   -->
                        <input id="variantData" type="button" value="Download summary data in CSV format" onClick="window.location='pdxDetails.do?csvSummary=true&modelID=${modelID}'">
                    </td>
                </tr>

                <tr class="stripe1">
                    <td class="cat1">
                        Gene Expression
                    </td>
                    <td class="data1">
                <c:choose>
                    <c:when test="${not empty geneExpressionData}">
                        <div id="geneExpressionDiv"></div>
                    </c:when>
                    <c:otherwise>
                        <table  border=0 cellpadding=5 cellspacing=0 width="100%">
                            <tr>
                                <td class="normal">
                                    No gene expression data currently available.
                                </td>
                            </tr>
                        </table>
                    </c:otherwise>
                </c:choose>

                </td>
                </tr>

                <tr class="stripe2">
                    <td class="cat2">
                        Gene CNV
                    </td>
                    <td class="data2">
                <c:choose>
                    <c:when test="${not empty geneCNVData}">
                        <div id="geneCNV"></div>
                    </c:when>
                    <c:otherwise>
                        <table  border=0 cellpadding=5 cellspacing=0 width="100%">
                            <tr>
                                <td class="normal">
                                    No gene CNV data currently available.
                                </td>
                            </tr>
                        </table>
                    </c:otherwise>
                </c:choose>

                </td>
                </tr>
                <tr class="stripe1">
                    <td class="cat1">
                        Model Characterization
                    </td>
                    <td class="data1">
                        <table  border=0 cellpadding=5 cellspacing=0 width="100%">

                            <!--- Histology --->                
                            <c:choose>
                                <c:when test="${not empty histology  ||  not empty sessionScope.pdxEditor || not empty histologySummary}">
                                    <tr>
                                        <td class="label" style="padding:5px; width:12%; vertical-align:top;">
                                            Histology:


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 

                                        <c:if test="${empty histologySummary}">
                                            <input type="submit" name="histologySummary" value="add summary"><br>
                                        </c:if>

                                        <c:if test="${empty pathologist}">
                                            <input type="submit" name="pathologist" value="add pathologist"><br>
                                        </c:if>

                                        <br>
                                        <input type="submit" name="histology" value="add histology">


                                    </c:if>
                                    </td>
                                    <td style="padding:5px; vertical-align:top;">

                                    <c:if test="${not empty histologySummary}">
                                        ${histologySummary.comment}<br>
                                        <c:if test="${not empty sessionScope.pdxEditor}">
                                            <a href="pdxEditContent.do?contentType=comment&contentKey=${histologySummary.contentKey}&modelID=${modelID}" class="linkedButton">  
                                                <input type="button" value="Edit"/>
                                            </a><br>
                                        </c:if>

                                    </c:if>

                                    <c:if test="${not empty pathologist}">
                                        ${pathologist.comment}<br>
                                        <c:if test="${not empty sessionScope.pdxEditor}">
                                            <a href="pdxEditContent.do?contentType=comment&contentKey=${pathologist.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                <input type="button" value="Edit"/>
                                            </a><br>
                                        </c:if>

                                    </c:if>    

                                    <table>

                                        <c:forEach var="graphic" items="${histology}" varStatus="status">

                                            <c:choose>
                                                <c:when test="${status.index%2==0}">
                                                    <tr>
                                                </c:when>
                                            </c:choose>


                                            <td style=" padding:5px; border:none; vertical-align:top; width:250px">
                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;">
                                                    <img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                </a>
                                            <c:if test="${not empty sessionScope.pdxEditor}">
                                                <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                    <input type="button" value="Edit"/></a>
                                            </c:if>
                                            <br>${graphic.description}
                                            </td>
                                            <c:choose>
                                                <c:when test="${status.index%2==1 || status.last}">
                                                    </tr>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </table>
                                    </td>
                                    </tr>                    
                                </c:when>

                            </c:choose>        


                            <!---  Tumor Markers ---->

                            <c:choose>
                                <c:when test="${not empty tumorMarkers  ||  not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style="  padding:5px; width:10%; vertical-align:top;">
                                            Tumor Markers:


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 

                                        <br>
                                        <input type="submit" name="tumorMarkers" value="add">


                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="comment" items="${tumorMarkers}" varStatus="status">
                                                <tr>
                                                    <td style="border:none  padding:5px; ">
                                                        ${comment.comment}
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=comment&contentKey=${comment.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/></a>
                                                </c:if>
                                                </td>
                                                </tr>

                                            </c:forEach>
                                        </table>
                                    </td>
                                    </tr>
                                </c:when>

                            </c:choose>        


                            <!--- Gene Expresssion --->                 

                            <c:choose>
                                <c:when test="${not empty geneExpression  || not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px; width:10%; vertical-align:top;">
                                            Gene Expression:


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 

                                        <br>
                                        <input type="submit" name="geneExpression" value="add">


                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="graphic" items="${geneExpressionImages}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index%2==0}">
                                                        <tr>
                                                    </c:when>
                                                </c:choose>

                                                <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                    <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;">
                                                        <img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                    </a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                <br>${graphic.description}
                                                </td>
                                                <c:choose>
                                                    <c:when test="${status.index%2==1  || status.last}">
                                                        </tr>
                                                    </c:when>
                                                </c:choose>

                                            </c:forEach>

                                            <c:forEach var="link" items="${geneExpressionLinks}" varStatus="status">
                                                <tr>
                                                    <td colspan=2 style=" padding:5px; ">
                                                        ${link.description}&nbsp;<a href="${link.url}">${link.linkText}</a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">  
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                </td>
                                                </tr>

                                            </c:forEach>                
                                        </table>
                                    </td>
                                    </tr>   

                                </c:when>

                            </c:choose>        

                            <!--- Copy Number Variation ---->         

                            <c:choose>
                                <c:when test="${not empty cnv  ||  not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px; width:10%; vertical-align:top;">
                                            Copy Number Variation:
                                    <c:if test="${not empty sessionScope.pdxEditor}" > 
                                        <br>
                                        <input type="submit" name="CNV" value="add">
                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="graphic" items="${cnvImages}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index%2==0}">
                                                        <tr>
                                                    </c:when>
                                                </c:choose>
                                                <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                    <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;">
                                                        <img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                    </a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                <br>${graphic.description}
                                                </td>
                                                <c:choose>
                                                    <c:when test="${status.index%2==1  || status.last}">
                                                        </tr>
                                                    </c:when>
                                                </c:choose>            
                                            </c:forEach>


                                            <c:forEach var="link" items="${cnvLinks}" varStatus="status">
                                                <tr>
                                                    <td colspan=2 style=" padding:5px; "">
                                                        ${link.description}&nbsp;<a href="${link.url}">${link.linkText}</a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                </td>
                                                </tr>
                                            </c:forEach> 
                                        </table>
                                </c:when>
                            </c:choose>        


                            <!-- Mutation -->



                            <c:choose>
                                <c:when test="${not empty mutation  ||  not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px;  width:10%; vertical-align:top;">
                                            Mutation:


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 
                                        <br>
                                        <input type="submit" name="mutation" value="add">
                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="comment" items="${mutationComments}" varStatus="status">
                                                <tr>
                                                    <td style="  padding:5px; border:none">
                                                        ${comment.comment}
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=comment&contentKey=${comment.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                </td>
                                                </tr>
                                            </c:forEach>

                                            <c:forEach var="link" items="${mutationLinks}" varStatus="status">
                                                <tr>
                                                    <td style=" padding:5px; ">
                                                        ${link.description}&nbsp;<a href="${link.url}">${link.linkText}</a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                </td>
                                                </tr>
                                            </c:forEach>
                                        </table>
                                    </td>
                                    </tr>
                                </c:when>
                            </c:choose>        


                            <!-- Drug Sensitivity --->

                            <c:choose>
                                <c:when test="${not empty drugSensitivity  ||  not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px; width:10%; vertical-align:top;">
                                            Drug Response :


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 
                                        <br>
                                        <input type="submit" name="drugSensitivity" value="add">
                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="graphic" items="${drugSensitivityGraphics}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index%2==0}">
                                                        <tr>
                                                    </c:when>
                                                </c:choose>

                                                <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                    <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;"><img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}"></a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                <br>${graphic.description}


                                                </td>
                                                <c:choose>
                                                    <c:when test="${status.index%2==1 || status.last}">
                                                        </tr>
                                                    </c:when>
                                                </c:choose>

                                            </c:forEach>

                                            <c:forEach var="doc" items="${drugSensitivityDocs}" varStatus="status">
                                                <tr>

                                                    <td style=" padding:5px; ">
                                                        ${doc.description}
                                                        <br>
                                                        <a href="${applicationScope.pdxFileURL}${doc.fileName}">${doc.linkText}</a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=document&contentKey=${doc.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                </td>
                                                </tr>
                                            </c:forEach>            


                                        </table>
                                    </td>
                                    </tr>
                                </c:when>
                            </c:choose>       

                            <!-- Circos Plots nee Additional Graphics -->


                            <c:choose>
                                <c:when test="${not empty additionalGraphic  ||  not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px;  width:10%; vertical-align:top;">
                                            <a href ="${applicationScope.pdxFileURL}CircosPlotHelp.pdf">Circos Plots:</a>


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 

                                        <br>
                                        <input type="submit" name="additionalGraphic" value="add">


                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="graphic" items="${additionalGraphic}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index%2==0}">
                                                        <tr>
                                                    </c:when>
                                                </c:choose>
                                                <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                    <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;">
                                                        <img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                    </a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton">
                                                        <input type="button" value="Edit"/>
                                                    </a>
                                                </c:if>
                                                <br>${graphic.description}
                                                </td>
                                                <c:choose>
                                                    <c:when test="${status.index%2==1  || status.last}">
                                                        </tr>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                        </table>
                                    </td>
                                    </tr>   
                                </c:when>
                            </c:choose>        

                            <!----  TUMOR GROWTH RATE ----->

                            <c:choose>
                                <c:when test="${not empty tumorGrowthRate  || not empty sessionScope.pdxEditor}">
                                    <tr>
                                        <td class="label" style=" padding:5px;  width:10%; vertical-align:top;">
                                            Tumor Growth Rate:


                                    <c:if test="${not empty sessionScope.pdxEditor}" > 
                                        <br>
                                        <input type="submit" name="tumorGrowthRate" value="add">
                                    </c:if>
                                    </td>
                                    <td>
                                        <table>
                                            <c:forEach var="graphic" items="${tumorGrowthRate}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index%2==0}">
                                                        <tr>
                                                    </c:when>
                                                </c:choose>
                                                <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                    <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '',1200,1200);return false;"><img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}"></a>
                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                    <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton">  <input type="button" value="Edit"/></a>
                                                </c:if>
                                                <br>${graphic.description}
                                                </td>
                                                <c:choose>
                                                    <c:when test="${status.index%2==1  || status.last}">
                                                        </tr>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                        </table>
                                    </td>
                                    </tr>   
                                </c:when>
                            </c:choose>        
                        </table>
                    </td>
                </tr>
                <!--======================= End Results ====================================-->
        </table>
        </html:form>                 
        <!--======================== End Main Section ==============================-->
    </td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>