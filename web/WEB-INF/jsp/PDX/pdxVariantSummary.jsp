<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Variant Summary"/>
    </c:import>
    <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />

    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base-debug.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>




    <script language="javascript">
    
        Ext.ns('org.jax.mgi.mtb');
    
        Ext.onReady(function(){
      
            var store = new Ext.data.ArrayStore({
                fields: [
                    {name: 'modelID'},
                    {name: 'sample'},
                    {name: 'gene'},
                    {name: 'analysis_id'},
                    {name: 'chromosome'},
                    {name: 'seq_position'},
                    {name: 'ref_allele'},
                    {name: 'alt_allele'},
                    {name: 'consequence'},
                    {name: 'amino_acid_change'},
                    {name: 'rs_variants'},
                    {name: 'cosmic_variants'},
                    {name: 'other_variants'},
                    {name: 'polyphen_prediction'},
                    {name: 'polyphen_score'},
                    {name: 'SIFT_prediction'},
                    {name: 'SIFT_score'},
                    {name: 'read_depth'},
                    {name: 'variant_frequency'}
                ],
                data: ${variants}
            });
    
            org.jax.mgi.mtb.PDXGrid =  Ext.extend(Ext.grid.EditorGridPanel,({
            
                initComponent: function(){
                    org.jax.mgi.mtb.PDXGrid.superclass.initComponent.apply(this,arguments);
                    this.on("rowclick",this.rowClickHandler);
                },
            
                rowClickHandler: function(grid, index, event){
                    var record = grid.getStore().getAt(index);
                }
            }));
            
            
            function idRenderer(value, p, record){
                return String.format('<a href="pdxDetails.do?modelID={0}" target="_blank">{0}</a>',record.get("modelID"));
            }
            
            
            var grid = new org.jax.mgi.mtb.PDXGrid({    
                store: store,
                columns: [
                    {
                        id       :'modelID',
                        header   : 'Model ID', 
                        width    : 60, 
                        sortable : true, 
                        dataIndex: 'modelID',
                        renderer: idRenderer
                    },
                    {
                        header   : 'Sample', 
                        width    : 75, 
                        sortable : true, 
                        dataIndex: 'sample'
                    },
                    {
                        header   : 'Gene', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'gene'
                    },
                    {
                        header   : 'Analysis ID', 
                        width    : 70, 
                        sortable : true, 
                        dataIndex: 'analysis_id'
                    
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
                        width    : 70, 
                        sortable : true, 
                        dataIndex: 'ref_allele'
                    
                    },
                    {
                        header   : 'Alt Allele',
                        width    : 70,
                        sortable : true,
                        dataIndex: 'alt_alele'
                    
                    },
                    {
                        header   : 'Consequence',
                        width    : 170,
                        sortable : true,
                        dataIndex: 'consequence'
                    },
                    {
                        header   : 'Amino Acid Change', 
                        width    : 170, 
                        sortable : true,  
                        dataIndex: 'amino_acid_change'
                    },
                    {
                        header   : 'RS Variants', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'rs_variants'
                    },
                    {
                        header   : 'Cosmic Variants', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'cosmic_variants'
                    },
                    {
                        header   : 'Other Variants',
                        width    : 170,
                        sortable : true,
                        dataIndex: 'other_variants'
                    },
                    {
                        header   : 'Polyphen Prediction', 
                        width    : 170, 
                        sortable : true,  
                        dataIndex: 'polyphen_prediction'
                    },
                    {
                        header   : 'Polyphen Score', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'polyphen_score'
                    },
                    {
                        header   : 'SIFT Prediction', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'sift_prediction'
                    },{
                        header   : 'SIFT Score',
                        width    : 100,
                        sortable : true,
                        dataIndex: 'sift_score'
                    },
                    {
                        header   : 'Read Depth', 
                        width    : 50, 
                        sortable : true,  
                        dataIndex: 'read_depth'
                    },
                    {
                        header   : 'Variant Frequency', 
                        width    : 100, 
                        sortable : true, 
                        dataIndex: 'variant_frequency'
                    }
        
                ],
                stripeRows: true,
                height:700,
                width: 1000,
                title: 'PDX Variant Summary',
                
                id:'pdxGrid'
            });
            
            panel = new Ext.Panel({
                applyTo:'dataDiv',
                collapsible: true,
                collaped: true,
                title:'Variant Summary',
                layout:{
                        type:'fit',
                        align:'stretch',
                        pack:'start'
                }
            });
            
            panel.render();
            panel.add(grid);
            panel.doLayout();
        
   
        });
    
    </script>
</head>
<body>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Patient Derived Xenograft Variant Summary"/>
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
                <table border="0" cellpadding=5 cellspacing=1 width="100%" >
                    <tr class="pageTitle">
                        <td colspan="11" width="100%">
                            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Patient Derived Xenograft Variant Summary
                                    </td>
                                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <!--======================= Start Search Summary ===========================-->

            </td>
        </tr>
        <tr class="summary">
            <td colspan="11">
            </td>
        </tr>
        <tr>
            <td>
                <!--======================= End Search Summary =============================-->
                <!--======================= Start Results ==================================-->
        <c:choose>
            <c:when test="${not empty variants}">
                <div id="dataDiv"></div>
            </c:when>
            <c:otherwise>
                No Results Found
            </c:otherwise>
        </c:choose>
</td></tr>
<!--======================= End Results ====================================-->
</table>
<!--======================== End Main Section ==============================-->
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>


