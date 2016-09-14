<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
   
    <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
     <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Search Results"/>
    </c:import>

  <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

<script language="javascript">
    
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
                    return '<b>NA</b>';
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

            onGridMouseDown: function(g, rowIndex,  columnIndex, e) {
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
            var bucketDiv = document.getElementById("bucketDiv");
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
    
        org.jax.mgi.mtb.PDXGrid =  Ext.extend(Ext.grid.EditorGridPanel,({
            
            initComponent: function(){
                
                org.jax.mgi.mtb.PDXGrid.superclass.initComponent.apply(this,arguments);
                this.on("rowclick",this.rowClickHandler);
                this.setTitle(this.getStore().getTotalCount()+" matching PDX Model(s)");
                 
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
                    width    : 70, 
                    sortable : true, 
                    dataIndex: 'modelID',
                    renderer: idRenderer
                },
                {
                    header   : 'Previous ID', 
                    width    : 75, 
                    sortable : true, 
                    dataIndex: 'previousID'
                },
                {
                    header   : 'Primary Site', 
                    width    : 100, 
                    sortable : true, 
                    dataIndex: 'primarySite'
                    
                },
                {
                    header   : 'Diagnosis (Initial : Final)', 
                    width    : 140, 
                    sortable : true, 
                    dataIndex: 'diagnosis'
                },
                {
                    header   : 'Tumor Site', 
                    width    : 120, 
                    sortable : true, 
                    dataIndex: 'tissue'
                },
                {
                    header   : 'Tumor Type',  
                    width    : 120, 
                    sortable : true, 
                    dataIndex: 'tumorType'
                    
                },
                {
                    header   : 'Fusion genes',
                    width    : 330,
                    sortable : false,
                    dataIndex: 'fusionGenes',
                    hidden   : ${hideFusionGenes}
                    
                },
                {
                    header   : 'Gene',
                    width    : 70,
                    sortable : true,
                    dataIndex: 'gene',
                    hidden   : ${hideGene}
                    
                },
                {
                    header   : 'Variant(s)',
                    width    : 90,
                    sortable : true,
                    dataIndex: 'variant',
                    hidden   : ${hideGene}
                    
                },
                {
                    header   : 'Consequence(s)',
                    width    : 100,
                    sortable : true,
                    dataIndex: 'consequence',
                    hidden   : ${hideGene}
                    
                },
                {
                    header   : 'Sex', 
                    width    : 70, 
                    sortable : true,  
                    dataIndex: 'sex'
                },
                {
                    header   : 'Age', 
                    width    : 70, 
                    sortable : true, 
                    dataIndex: 'age'
                },
                {
                    header   : 'Tag', 
                    width    : 100, 
                    sortable : true, 
                    dataIndex: 'tag',
                    hidden   : true
                },
                {
                    header   : 'Additional data', 
                    width    : 170, 
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


<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Patient Derived Xenograft Search Results"/>
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
                <table  border="0" cellpadding="5" cellspacing="1" width="100%" class="results" >
                    <tr class="pageTitle">
                        <td width="100%">
                            <table width="100%" cellpadding="4" cellspacing="4" >
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Patient Derived Xenograft Search Results
                                    </td>
                                    <td width="20%" valign="middle" align="right">
                                 <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location='pdxRequest.do'">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <!--======================= Start Search Summary ===========================-->
                    <tr class="summary">
                        <td >
                            <font class="label">Search Summary</font><br>

                    <c:choose>
                        <c:when test="${not empty modelID}">
                            <font class="label">Model ID:</font>${modelID}<br>
                        </c:when>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty primarySites}">
                            <c:choose>
                                <c:when test="${fn:length(primarySites)>1}">
                                    <font class="label">Primary Sites:</font>
                                </c:when>
                                <c:otherwise>
                                    <font class="label">Primary Site:</font>
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
                            <br>
                        </c:when>
                        <c:otherwise>
                            <font class="label">Primary Sites:</font> Any<br>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty diagnoses}">
                            <c:choose>
                                <c:when test="${fn:length(diagnoses)>1}">
                                    <font class="label">Diagnoses:</font>
                                </c:when>
                                <c:otherwise>
                                    <font class="label">Diagnosis:</font>
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
                            <br>
                        </c:when>
                        <c:otherwise>
                            <font class="label">Diagnosis:</font> Any<br>
                        </c:otherwise>
                    </c:choose>
                                    
                                    
                  <c:choose>
                        <c:when test="${not empty tags}">
                            <c:choose>
                                <c:when test="${fn:length(tags)>1}">
                                    <font class="label">Tags:</font>
                                </c:when>
                                <c:otherwise>
                                    <font class="label">Tag:</font>
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
                            <br>
                        </c:when>
                        <c:otherwise>
                            <font class="label">Tags:</font> Any<br>
                        </c:otherwise>
                    </c:choose>
                                                       
        
                                    
                 <c:choose>
                        <c:when test="${not empty genes}">
                            <c:choose>
                                <c:when test="${fn:length(genes)>1}">
                                    <font class="label">Genes:</font>
                                </c:when>
                                <c:otherwise>
                                    <font class="label">Gene:</font>
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
                            <br>
                        </c:when>
                        <c:otherwise>
                            <font class="label">Genes:</font> Any<br>
                        </c:otherwise>
                    </c:choose>
                                    
               <c:choose>
                        <c:when test="${not empty variants}">
                            <c:choose>
                                <c:when test="${fn:length(variants)>1}">
                                    <font class="label">Variants:</font>
                                </c:when>
                                <c:otherwise>
                                    <font class="label">Variant:</font>
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
                            <br>
                        </c:when>
                        <c:otherwise>
                            <font class="label">Variants:</font> Any<br>
                        </c:otherwise>
                    </c:choose>
                            
                    
                     <c:if test="${not empty fusionGenes}">
                        <font class="label">Fusion Gene:</font> ${fusionGenes}<br>
                    </c:if>  
                                   
                                    
                    <c:if test="${not empty tumorGrowth}">
                        <font class="label">Tumor Growth Data:</font> Required<br>
                    </c:if>    
                                    
                     <c:if test="${not empty drugResponse}">
                        <font class="label">Drug Response Graph:</font> Required<br>
                    </c:if>  
                        
                   
                   
            </td>
        </tr>
        <tr class="buttons">
            <td>
                <table border=0 cellspacing=5 width="100%">
           
                 <c:choose>
                    <c:when test="${not empty mice}">
                        <td>
                        <div id="dataDiv"></div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            <div id="bucketDiv" style="display:none">
                                <form method="get" action="pdxRequest.do">
                                    <label>Selected Models: </label>
                                    <input type="text" id="bucket"  name="mice">
                                    <input type="submit" value="Request Details" >
                                </form>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            Check boxes can be used to select models to request details on availability.<br>
                            Models without check boxes (<b>NA</b>) are no longer available (no inventory remaining).
                        </td>

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


