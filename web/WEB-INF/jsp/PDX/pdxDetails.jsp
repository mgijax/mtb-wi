<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
            .x-panel-body{
                border:0 none;
                background-color: #F0F0F0;
            }
            
            .x-panel-body-noheader{
                border:0 none;
            }
            
            p{
                margin-bottom: 2px;
            }
            

        </style>

        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="PDX Model Details"/>
        </c:import>

        <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
        <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
        <script type="text/javascript" src="${applicationScope.urlBase}/extjs/columnHeader.js"></script>

        <script type="text/javascript" src="https://www.google.com/jsapi"></script>

        <script language="javascript">

            google.load("visualization", "1", {packages: ["corechart"]});

            Ext.ns('org.jax.mgi.mtb');

            var expressionData, expressionBarChart, cnvData, cnvBarChart;

            var expGeneSortDir = false;
            var expRankSortDir = true;

            var cnvGeneSortDir = false;
            var cnvRankSortDir = true;

            var cnvLog = true;



            var expressionOptions = {
                fontSize: 10,
                title: 'Gene Expression by Percentile Rank Z Score',
                titleTextStyle: {fontSize: 14},
                vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
                hAxis: {format: '##.##'},
                chartArea: {top: 5, height: "95%"}

            };

            var cnvOptionsLog = {
                fontSize: 10,
                //     legend: {position: 'none'},
                vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
                hAxis: {logScale: true, baseline: 0},
                chartArea: {top: 5, height: "95%"}

            };

            var cnvOptionsLinear = {
                fontSize: 10,
                //         legend: {position: 'none'},
                vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
                hAxis: {logScale: false, baseline: 0},
                chartArea: {top: 5, height: "95%"}

            };

            var currentCnvOptions = cnvOptionsLinear;


            function expSortGene() {
                expGeneSortDir = !expGeneSortDir;
                expressionData.sort({column: 0, desc: expGeneSortDir});
                expressionBarChart.draw(expressionData, expressionOptions);
            }

            function expSortRank() {
                expRankSortDir = !expRankSortDir;
                expressionData.sort({column: 1, desc: expRankSortDir});
                expressionBarChart.draw(expressionData, expressionOptions);
            }

            function cnvSortGene() {
                cnvGeneSortDir = !cnvGeneSortDir;
                cnvData.sort({column: 0, desc: cnvGeneSortDir});
                cnvBarChart.draw(cnvData, currentCnvOptions);
            }

            function cnvSortRank() {
                cnvRankSortDir = !cnvRankSortDir;
                cnvData.sort({column: 1, desc: cnvRankSortDir});
                cnvBarChart.draw(cnvData, currentCnvOptions);
            }



            function logUnLog() {
                if (cnvLog) {
                    currentCnvOptions = cnvOptionsLog;
                } else {
                    currentCnvOptions = cnvOptionsLinear;
                }
                cnvBarChart.draw(cnvData, currentCnvOptions);
                cnvLog = !cnvLog;
            }


            function doExpressionBarChart() {

                expressionData = google.visualization.arrayToDataTable([${geneExpressionData}]);

                if (expressionData.getNumberOfRows() > 0) {
                    expressionData.sort(0);
                    expressionBarChart = new google.visualization.BarChart(document.getElementById('geneExpressionChart'));
                    expressionBarChart.draw(expressionData, expressionOptions);
                }
            }

            function doCnvBarChart() {
                cnvData = google.visualization.arrayToDataTable([${geneCNVData}]);

                if (cnvData.getNumberOfRows() > 0) {
                    cnvData.sort(0);
                    cnvBarChart = new google.visualization.BarChart(document.getElementById('geneCNVChart'));
                    cnvBarChart.draw(cnvData, cnvOptionsLinear);
                }
            }


            Ext.onReady(function () {

                var dataProxy = new Ext.data.HttpProxy({
                    url: '/mtbwi/pdxVariationData.do?modelID=${modelID}',
                    timeout: 7000000
                })

                var fields = [
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
                    {name: 'filter'},
                    {name: 'passage_num'},
                    {name: 'ckb_molpro_link'},
                    {name: 'ckb_molpro_name'},
                    {name: 'ckb_gene_id'},
                    {name: 'ckb_potential_treat_approach'},
                    {name: 'ckb_protein_effect'},
                    {name: 'ckb_nclinical_resist'},
                    {name: 'ckb_nclinical_sens'},
                    {name: 'ckb_npreclinical_resist'},	
                    {name: 'ckb_npreclinical_sens'},
                    {name: 'count_human_reads'},
                    {name: 'pct_human_reads'}
                    

                ];






                // create the Data Store
                var store = new Ext.data.ArrayStore({
                    root: 'variation',
                    totalProperty: 'total',
                    //    idIndex: 0,
                    remoteSort: true,
                    autoLoad: false,
                    // these need to match the webservice field names for sorting to work
                    fields: fields,
                    proxy: dataProxy
                });
                
                var ckb = [{header: '', colspan: 2, align: 'center'},
                        {header: 'JAX Clinical Knowledgebase (CKB) annotations', colspan: 6, align: 'center'},
                        {header: '', colspan: 16, align: 'center'}]
                
                 var group = new Ext.ux.grid.ColumnHeaderGroup({
                    rows: [ckb]
                });

                store.setDefaultSort('gene_symbol', 'ASC');

                var grid = new Ext.grid.GridPanel({
                    store: store,
                    columns: [
                        {
                            header: 'Sample',
                            width: 85,
                            sortable: true,
                            dataIndex: 'sample_name'
                        },
                        {
                            header: 'Gene',
                            width: 60,
                            sortable: true,
                            dataIndex: 'gene_symbol',
                           
                        },
                        
                        {
                            header: 'Variant',
                            width: 100,
                            sortable: true,
                            dataIndex: 'ckb_molpro_name',
                            renderer: ckbMolProRenderer
                        },
                        {
                            header: 'Variant effect',
                            width: 90,
                            sortable: true,
                            dataIndex: 'consequence'
                        },
                                      
                        {
                            header: 'CKB<br>protein<br>effect',
                            width: 70,
                            sortable: true,
                            dataIndex: 'ckb_protein_effect'
                        },
                                    
                        {
                            header: '# <b>Clinical/Preclinical</b><br>annotations<br>predicting<br>sensitivity',
                            width: 130,
                            sortable: true,
                            dataIndex: 'ckb_nclinical_sens',
                            renderer: ckbSensitivityRenderer
                        },
               //         {
               //             header: '# <b>Preclinical</b><br>annotations<br>predicting<br>sensitivity',
               //             width: 70,
               //             sortable: true,
               //             dataIndex: 'ckb_npreclinical_sens'
               //         },
                        {
                            header: '# <b>Clinical/Preclinical</b><br>annotations<br>predicting<br>resistance',
                            width: 130,
                            sortable: true,
                            dataIndex: 'ckb_nclinical_resist',
                            renderer: ckbResistanceRenderer
                        }, 
                //        {
                //            header: '# <b>Preclinical</b><br>annotations<br>predicting<br>resistance',
                //            width: 70,
                //            sortable: true,
                //            dataIndex: 'ckb_npreclinical_resist'
                //        },  
                        {
                            header: 'Potential<br>treatment<br>approaches',
                            width: 100,
                            sortable: true,
                            dataIndex: 'ckb_potential_treat_approach',
                            renderer: ckbPotTreatRenderer
                        }, 
                        
                        {
                            header: 'Platform',
                            width: 80,
                            sortable: true,
                            dataIndex: 'platform'
                        },
                        {
                            header: 'Chromosome',
                            width: 70,
                            sortable: true,
                            dataIndex: 'chromosome'
                        },
                        {
                            header: 'Seq Position',
                            width: 80,
                            sortable: true,
                            dataIndex: 'seq_position'
                        },
                        {
                            header: 'Ref Allele',
                            width: 65,
                            sortable: true,
                            dataIndex: 'ref_allele'

                        },
                        {
                            header: 'Alt Allele',
                            width: 65,
                            sortable: true,
                            dataIndex: 'alt_allele'

                        },
                        
                        {
                            header: 'Amino Acid Change',
                            width: 110,
                            sortable: true,
                            dataIndex: 'amino_acid_change'
                        },
                        {
                            header: 'RS Variants',
                            width: 80,
                            sortable: true,
                            dataIndex: 'rs_variants'
                        },
                        {
                            header: 'Read Depth',
                            width: 70,
                            sortable: true,
                            dataIndex: 'read_depth'
                        },
                        {
                            header: 'Allele Frequency',
                            width: 100,
                            sortable: true,
                            dataIndex: 'allele_frequency'
                        },
                        {
                            header: 'Transcript ID',
                            width: 100,
                            sortable: true,
                            dataIndex: 'transcript_id'
                        },
                        {
                            header: 'Filtered Rationale',
                            width: 100,
                            sortable: true,
                            dataIndex: 'filtered_rationale'

                        },
                        {
                            header: 'Filter',
                            width: 50,
                            sortable: true,
                            dataIndex: 'filter'

                        },
                        {
                            header: 'Passage Num',
                            width: 50,
                            sortable: true,
                            dataIndex: 'passage_num'
                        },
                        {
                            header: 'Gene ID',
                            width: 60,
                            sortable: true,
                            dataIndex: 'gene_id'
                        },
                        {
                            header: 'Count Human Reads',
                            width: 70,
                            sortable: true,
                            dataIndex: 'count_human_reads'
                        },
                        {
                            header: 'PCT Human Reads',
                            width: 70,
                            sortable: true,
                            dataIndex: 'pct_human_reads'
                        }

                    ],
                    stripeRows: true,
                    height: 700,
                    width: 1000,
                    id: 'pdxGrid'
                    , bbar: new Ext.PagingToolbar({
                        pageSize: 30,
                        store: store,
                        displayInfo: true,
                        displayMsg: 'Displaying results {0} - {1} of {2}'
                    }),
                    plugins:group



                });
                
                // not used
                 function ckbGeneRenderer(value, p, record){
                    if(record.get("ckb_gene_id").length>0){
                        return String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_gene_id"),record.get("gene_symbol"));
                    }else{
                        if(record.get("gene_symbol")){
                            return record.get("gene_symbol");
                        }else{
                            return "";
                        }
                    }
                   
                }
                
                 function ckbMolProRenderer(value, p, record){
                     val = record.get("ckb_molpro_name");
                     
                     if(record.get("ckb_molpro_name").length>0 && record.get("ckb_molpro_link").length>0){
                        val =  String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_molpro_link"), record.get("ckb_molpro_name"));
                    }
                        
                    return val;
                    
                }
                
                function ckbPotTreatRenderer(value, p, record){
                     val = record.get("ckb_potential_treat_approach");
                     
                     if(record.get("ckb_potential_treat_approach").length>0 && record.get("ckb_molpro_link").length>0){
                        val =  String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_molpro_link")+"?tabType=TREATMENT_APPROACH_EVIDENCE", record.get("ckb_potential_treat_approach"));
                    }
                        
                    return val;
                    
                }
                
                function ckbResistanceRenderer(value, p, record){
                    val = "";
                    if(record.get("ckb_nclinical_resist").trim().length>0 || record.get("ckb_npreclinical_resist").trim().length>0){
                        val = "0/";
                        if(record.get("ckb_nclinical_resist").trim().length>0){
                            val = record.get("ckb_nclinical_resist")+"/"
                        }            
                        if(record.get("ckb_npreclinical_resist").trim().length>0){
                            val = val+record.get("ckb_npreclinical_resist");
                        }else{
                            val = val+"0";
                        }
                    }
                    return val;
                }
                
                
                function ckbSensitivityRenderer(value, p, record){
                    val = "";
                    if(record.get("ckb_nclinical_sens").trim().length>0 || record.get("ckb_npreclinical_sens").trim().length>0){
                        val = "0/";
                        if(record.get("ckb_nclinical_sens").trim().length>0){
                            val = record.get("ckb_nclinical_sens")+"/"
                        }            
                        if(record.get("ckb_npreclinical_sens").trim().length>0){
                            val = val+record.get("ckb_npreclinical_sens");
                        }else{
                            val = val+"0";
                        }
                    }
                    return val;
                }

                Ext.EventManager.onWindowResize(function (w, h) {
                    panel.doLayout();
                });

                // there must be a better way...
                var colNames = [];
                colNames.push( 'sample_name');
                colNames.push( 'gene_symbol');
                colNames.push( 'ckb_molpro_name');
                colNames.push( 'consequence');
                colNames.push( 'ckb_protein_effect');
                colNames.push( 'ckb_nclinical_sens');
                colNames.push( 'ckb_nclinical_resist');
                colNames.push('ckb_potential_treat_approach');
                colNames.push( 'platform');
                colNames.push( 'chromosome');
                colNames.push( 'seq_position');
                colNames.push( 'ref_allele');
                colNames.push( 'alt_allele');
                colNames.push( 'amino_acid_change');
                colNames.push( 'rs_variants');
                colNames.push( 'read_depth');
                colNames.push( 'allele_frequency');
                colNames.push( 'transcript_id');
                colNames.push( 'filtered_rationale');
                colNames.push( 'filter');
                colNames.push( 'passage_num');
                colNames.push( 'gene_id');
                colNames.push( 'count_human_reads');
                colNames.push( 'pct_human_reads');
     


                // focus on sort column otherwise focus always jumps to first column
                grid.on("sortChange", function (grid, sortInfo) {
                    if ('gene_symbol' != sortInfo.field) {
                        (function () {
                            grid.getView().focusCell(1, colNames.indexOf(sortInfo.field));
                        }).defer(75);
                    }
                })
                // keep track of the index of columns when they move
                grid.on("columnmove", function (oldInd, newInd) {
                    col = colNames[oldInd];
                    colNames.splice(oldInd, 1);
                    colNames.splice(newInd, 0, col);

                })

                panel = new Ext.Panel({
                    applyTo: 'variantSummary',
                    collapsible: true,
                    collapsed: true,
                    collapseFirst: true,
                    title: 'Click to expand/collapse',
                    layout: {
                        type: 'fit',
                        align: 'stretch',
                        pack: 'start'
                    },
                    titleCollapse: true,
                    hideCollapseTool: true,
                    items: [grid]
                });

                panel.render();

                panel.doLayout();
                
              //  grid.getView().renderHeaders();

                checkVariants = function () {
                    if (store.getTotalCount() == 0) {
                        document.getElementById("noVariantSummary").style.display = "block";
                        document.getElementById("variantData").style.display = "none";
                        document.getElementById("variantSummary").style.display = "none";
                    }
                }

                store.on("load", checkVariants);
                store.load({params: {start: 0, limit: 30}});

                if (document.getElementById("geneExpressionDiv") != null) {

                    panel2 = new Ext.Panel({
                        applyTo: 'geneExpressionDiv',
                        collapsible: true,
                        collapsed: true,
                        collapseFirst: false,
                        title: 'Click to expand/collapse',
                        forceLayout: true,
                        layout: {
                            type: 'fit',
                            align: 'stretch',
                            pack: 'start'
                        },
                        titleCollapse: true,
                        hideCollapseTool: true,
                        items: [{html: '<b>Sort by:</b><input type="button" value="Gene" onclick="expSortGene()">' +
                                        '&nbsp;<input type="button" value="Rank" onclick="expSortRank()">' +
                                        '<br><div id="geneExpressionChart" style="height:${expChartSize}px"></div>'}]
                    });

                    panel2.on('expand', doExpressionBarChart);
                    panel2.render();
                    panel2.doLayout();
                }

                if (document.getElementById("geneCNV") != null) {

                    panel3 = new Ext.Panel({
                        applyTo: 'geneCNV',
                        collapsible: true,
                        collapsed: true,
                        collapseFirst: false,
                        title: 'Click to expand/collapse',
                        forceLayout: true,
                        layout: {
                            type: 'fit',
                            align: 'stretch',
                            pack: 'start'
                        },
                        titleCollapse: true,
                        hideCollapseTool: true,
                        items: [{html: '<p style="text-align:center;">Bars are colored by sample, CNV values a calculated as log2(cn raw/sample ploidy).</p>' +
                                        '<br>' +
                                        '&nbsp;<b>Sort by:</b><input type="button" value="Gene" onclick="cnvSortGene()">' +
                                        '&nbsp;<input type="button" value="Rank" onclick="cnvSortRank()">' +
                                        ' <div id="geneCNVChart" style="height:${cnvChartSize}px" ></div>'}]

                    });

                    panel3.on('expand', doCnvBarChart);
                    panel3.render();
                    panel3.doLayout();
                }
                
                if(document.getElementById("references") != null){
                
                    panel4 = new Ext.Panel({
                           applyTo: 'references',
                           collapsible: true,
                           collapsed: ${collapseReferences},
                           collapseFirst: false,
                           title: 'Click to expand/collapse',
                           forceLayout: true,
                           border:false,
                           bodyBorder:false,
                           header:${collapseReferences},
                          
                           layout: {
                               type: 'fit',
                               align: 'stretch',
                               pack: 'start'
                           },
                           titleCollapse: true,
                           hideCollapseTool: true,
                           items: [{html:'<c:forEach var="link" items="${referenceLinks}" varStatus="status">
                                            <p>${link.description}&nbsp;<a href="${link.url}" target="_blank">${link.linkText}</a>\
                                             <c:if test="${not empty sessionScope.pdxEditor}">
                                                  <a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">\
                                                  <input type="button" value="Edit"/>\
                                                  </a>\
                                             </c:if>
                                             </p>\
                                        </c:forEach>'
                                   }]

                       });

                       panel4.render();
                       panel4.doLayout();
                }
                
          
            
             if(document.getElementById("cnvPlots") != null){
                panel5 = new Ext.Panel({
                        applyTo: 'cnvPlots',
                        collapsible: true,
                        collapsed: true,
                        collapseFirst: false,
                        title: 'Click to expand/collapse',
                        forceLayout: true,
                        layout: {
                            type: 'fit',
                            align: 'stretch',
                            pack: 'start'
                        },
                        titleCollapse: true,
                        hideCollapseTool: true,
                           items: [{html:'<c:forEach var="plot" items="${cnvPlots}" varStatus="status">
                                                <div style="text-align:center"> <img src="${applicationScope.pdxFileURL}../cnvPlots/tumor_only/${plot}" height="450" width="975"/></div><br>\
                                             </c:forEach>'
                                   }]

                       });

                       panel5.render();
                       panel5.doLayout();
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
                                                            <input type="button" value="Request more &#x00A; information on this &#x00A; PDX model." class="pdxRequestButton" onclick="window.location = 'pdxRequest.do?mice=${mouse.modelID}'">    
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    
                                      <c:if test="${fn:contains(mouse.institution,'Dana-Farber')}">
                                            <tr class="stripe2">
                                                <td class="cat2">Notices</td>
                                                <td class="data2" >
                                                    The use of this material by a company is subject to the terms of the attached <a target="_blank" href="${applicationScope.urlBase}/html/DFCICompany.pdf">notice</a>.
                                                    <br>
                                                    The use of this material by an academic institution is subject to the terms of the attached <a target="_blank" href="${applicationScope.urlBase}/html/DFCIAcademic.pdf">notice</a>.
                                                </td>
                                            </tr>


                                        </c:if>     

                                    <tr class="stripe1">
                                        <td class="cat1">
                                            Model Details
                                        </td>
                                        <td class="data1">
                                            <table border=0 cellpadding=5 cellspacing=0 width="100%">
                                                
                                                

                                                <tr>
                                                    <td colspan="6" class="normal" style="width:100%; text-align:center">
                                                        <c:if test="${not empty unavailable}">
                                                            <b> This PDX model is not available. (No inventory)</b>
                                                        </c:if>
                                                    </td>
                                                <tr>
                                                    <td class="label" style="width:10%">Model ID:</td><td class="normal" style="width:22%">${mouse.modelID}</td>

                                                    <td class="label" style="width:10%">Previous ID:</td><td class="normal" style="width:18%">${mouse.previousID}</td>
                                                    
                                                     <c:if test="${applicationScope.publicDeployment == true}">
                                                           <td class="label" style="width:14%"></td><td class="normal" style="width:26%"></td>
                                                     </c:if>
                                                     <c:if test="${applicationScope.publicDeployment == false}">
                                                        <td class="label" style="width:14%">Model Status</td><td class="normal" style="width:26%">${mouse.modelStatus}</td>
                                                     </c:if>
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
                                                <tr>
                                                    <td class="label">Treatment Naive:</td><td class="normal">${mouse.treatmentNaive}</td>
                                                    <td></td><td></td>
                                                    <td></td><td></td>
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


                                    <c:set var="a" value="1"/>
                                    <c:set var="b" value="2"/>

                                    <c:if test="${not empty referenceLinks or not empty sessionScope.pdxEditor}">

                                        <c:set var="a" value="2"/>
                                        <c:set var="b" value="1"/>

                                        <tr class="stripe${a}">
                                            <td class="cat${a}">
                                                Publications citing this model
                                            </td>
                                            <td class="data${a}">
                                                <div id="references">
                                                         <c:if test="${not empty sessionScope.pdxEditor}" > 
                                                                    <input type="submit" name="reference" value="add">
                                                            </c:if>
                                                </div>
                                            </td>
                                        </tr>

                                    </c:if>

                                    <tr class="stripe${b}">
                                        <td class="cat${b}">
                                            Variant Summary <a class="help" href="userHelp.jsp#pdxVariant"><img src="${applicationScope.urlImageDir}/help_small.jpg" border=0 width=15 height=15 alt="Help" style="vertical-align:middle"></a>
                                        </td>
                                        <td class="data${b}">

                                            <table id="noVariantSummary" style="display: none" border=0 cellpadding=5 cellspacing=0 width="100%">
                                                <tr>
                                                    <td class="normal">
                                                        Variant Summary currently not available.
                                                    </td>
                                                </tr>
                                            </table>

                                            <div id="variantSummary"></div>
                                            <br>
                                            <c:choose>
                                                <c:when test="${applicationScope.publicDeployment == false}">
                                                <input id="variantData" type="button" value="Download summary data in CSV format" onClick="window.location = 'pdxDetails.do?csvSummary=true&modelID=${modelID}'">
                                                </c:when>
                                                <c:otherwise>
                                                    <input id="variantData" type ="hidden"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>

                                    <tr class="stripe${a}">
                                        <td class="cat${a}">
                                            Gene Expression <a class="help" href="userHelp.jsp#pdxExpression"><img src="${applicationScope.urlImageDir}/help_small2.jpg" border=0 width=15 height=15 alt="Help" style="vertical-align:middle"></a>
                                        </td>
                                        <td class="data${a}">
                                            <c:choose>
                                                <c:when test="${not empty geneExpressionData}">
                                                    Platforms:${platforms} <br>
                                                    <c:choose>
                                                        <c:when test="${fn:contains(platforms,'RNA_Seq')}">
                                                            Hatched bars indicate genes with expression levels determined to be mildly affected by alignment calculations. <a href="userHelp.jsp#pdxalternateloci">Details</a>.
                                                        </c:when>
                                                    </c:choose>    
                                                        <c:choose>
                                                            <c:when test="${fn:contains(mouse.institution,'Dana-Farber') or fn:contains(mouse.institution,'Baylor')}">
                                                                <br><b>Please Note:</b> Expression data for this model is calculated as Log2(TPM+1)    
                                                            </c:when>
                                                        </c:choose>        
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

                                    <tr class="stripe${b}">
                                        <td class="cat${b}">
                                            Gene CNV <a class="help" href="userHelp.jsp#pdxCNV"><img src="${applicationScope.urlImageDir}/help_small.jpg" border=0 width=15 height=15 alt="Help" style="vertical-align:middle"></a>
                                        </td>
                                        <td class="data${b}">
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
                                    
                                     <tr class="stripe${a}">
                                            <td class="cat${a}">
                                                CNV Plots <a class="help" href="userHelp.jsp#pdxCNV"><img src="${applicationScope.urlImageDir}/help_small2.jpg" border=0 width=15 height=15 alt="Help" style="vertical-align:middle"></a>
                                            </td>
                                            <td class="data${a}">
                                            <c:choose>
                                                <c:when test="${not empty cnvPlots}">
                                                    <div id ="cnvPlots"></div>
                                                </c:when>

                                                 <c:otherwise>
                                                    <table  border=0 cellpadding=5 cellspacing=0 width="100%">
                                                        <tr>
                                                            <td class="normal">
                                                                No gene CNV plots currently available.
                                                            </td>
                                                        </tr>
                                                    </table>
                                                 </c:otherwise>

                                            </c:choose>
                                    </tr>
                                             
                                             
                                        
                                    <tr class="stripe${b}">
                                        <td class="cat${b}">
                                            Model Characterization
                                        </td>
                                        <td class="data${b}">
                                            <table  border=0 cellpadding=5 cellspacing=0 width="100%">

                                                <!-- Histology -->                
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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;">
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


                                                <!--  Tumor Markers -->

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
                                                                            <td style="border:none;  padding:5px; ">
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


                                                <!-- Gene Expresssion -->                 

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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;">
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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;">
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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;"><img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}"></a>
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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;">
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
                                                                                <a href="nojavascript.jsp" onClick="popSizedPathWin('pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}', '', 1200, 1200);
                                                                                        return false;"><img  height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}"></a>
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
                                    <c:choose>
                                        <c:when test="${mouse.socGraph > 0}">
                                            <c:forEach var="socGraph" begin="1" end="${mouse.socGraph}" >
                                                <tr class="stripe${b}">
                                                    <td class="cat${b}">
                                                        Dosing Studies:
                                                    </td>
                                                    <td style="border:0px none">
                                                        <c:choose>
                                                            <c:when test="${mouse.socGraph == 1}">
                                                                <iframe width="100%" height="1300px" src='${applicationScope.socURL}${mouse.modelID}.html' style="border:0px none">
                                                                </iframe>
                                                            </c:when>
                                                            <c:otherwise>  
                                                                <iframe width="100%" height="1300px" src='${applicationScope.socURL}${mouse.modelID}_${socGraph}.html' style="border:0px none">
                                                                </iframe>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                        </c:when>
                                    </c:choose>
                                                


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