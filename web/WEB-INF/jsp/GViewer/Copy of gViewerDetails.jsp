<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    
    <style type="text/css">
    
    .no-icon {
	display : none;
	background-image:'' !important;
	}
  </style>
    
    
    
    
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="GViewer Details"/>
    </c:import>
    
    
    <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
    
  </head>
  
  <c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="GViewer Details"/>
  </c:import>
  
  <script type="text/javascript">
    
    var treePanel;
    
    var fTypeMap =  [];
    fTypeMap['all feature types'] =6238159;
    fTypeMap['gene'] = 6238160;
    fTypeMap['protein coding gene'] = 6238161;
    fTypeMap['non-coding RNA gene'] = 6238162;
    fTypeMap['rRNA gene'] = 6238163;
    fTypeMap['tRNA gene'] = 6238164;
    fTypeMap['snRNA gene'] = 6238165;
    fTypeMap['snoRNA gene'] = 6238166;
    fTypeMap['miRNA gene'] = 6238167;
    fTypeMap['scRNA gene'] = 6238168;
    fTypeMap['lincRNA gene'] = 6238169;
    fTypeMap['SRP RNA gene'] = 6238180;
    fTypeMap['RNase P RNA gene'] = 6238181;
    fTypeMap['RNase MRP RNA gene'] = 6238182;
    fTypeMap['telomerase RNA gene'] = 6238183;
    fTypeMap['unclassified non-coding RNA gene'] = 6238186;
    fTypeMap['heritable phenotypic marker'] = 6238170;
    fTypeMap['gene segment'] = 6238171;
    fTypeMap['unclassified gene'] = 6238184;
    fTypeMap['other feature type'] = 6238185;
    fTypeMap['pseudogene'] = 6238172;
    fTypeMap['QTL'] = 6238173;
    fTypeMap['transgene'] = 6238174;
    fTypeMap['complex/cluster/region'] = 6238175;
    fTypeMap['cytogenetic marker'] = 6238176;
    fTypeMap['BAC/YAC end'] = 6238177;
    fTypeMap['other genome feature'] = 6238178;
    fTypeMap['DNA segment'] = 6238179;

    Ext.onReady(function(){
    

    treePanel = new Ext.tree.TreePanel({
        renderTo:'featureTypeSelection',
        height: 100,
        width: 450,
        useArrows:true,
        autoScroll:false,
        autoHeight:true,
        animate:true,
        enableDD:false,
        containerScroll: true,
        rootVisible: true,
        frame: false,
        root: {
            nodeType: 'async',
            text:'all feature types',
            checked:false,
            iconCls:'no-icon'
        },
        
        // auto create TreeLoader
        dataUrl:'${applicationScope.urlBase}/GViewer/data/featureTypes.json',
        
        listeners: {
            'checkchange': function(node, checked){
                    var i=0, children = node.childNodes;
                    for(i; i < children.length; i++){
                        children[i].getUI().toggleCheck(checked);
                    }
            }
        }
    });

    treePanel.expandAll();
  //  treePanel.collapseAll();
});
    
    
  
    function batchSwap() {
      changeVisibility("summary");
      changeVisibility("params");
    }

    function changeVisibility(id) {

      var myID = document.getElementById(id);

      if (myID.style.display == "block"){
        myID.style.display = "none";
      } else {
        myID.style.display = "block";
      }
    }
    
    function viewerSubmit(){
    
      // get the data from the form
      var ch = ${QTLForm.chrom};
      var start = document.forms[1].searchStart.value;
      var end = document.forms[1].searchEnd.value;
      
      
      var pheno = document.forms[1].phenotype.value;
    
      
      var ontologyKeys = ""
      for(var i = 0; i < document.forms[1].ontology_key.length; i++){
        if(document.forms[1].ontology_key[i].checked){
          ontologyKeys = ontologyKeys + ('&ontology_key='+document.forms[1].ontology_key[i].value);
        }
      }
          
      var goOp = document.forms[1].go_op.value
      var goTerm = document.forms[1].go_term.value
      
      var mcvs = '', selNodes = treePanel.getChecked();
      
      Ext.each(selNodes, function(node){
          if(mcvs.length > 0){
              mcvs += '&';
          }
          mcvs +="mcv="+fTypeMap[node.text];
      });
      
      window.opener.qtlStore.proxy.setUrl('viewer.do?chromosome='+ch+'&start='+start+'&end='+end
        +'&phenotype='+pheno+'&go_op='+goOp+'&go_term='+goTerm+''+ontologyKeys+"&"+mcvs);
      
      window.opener.qtlStore.load({add:true});
     
      window.opener.alert("Loading MGD results.");
      
    }

  
  </script>
  
  
  
  
  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td>
      <td width="200" valign="top">
        <c:import url="../../../toolBar.jsp" />
      </td>
      <td class="separator">
        &nbsp;
      </td>
      <td valign="top">
        <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
          
          <tr>
            <td><!--======================= Start Main Section =============================-->
  <!--======================= Start Form Header ==============================-->
              <table border="0" cellpadding=5 cellspacing=1" width="100%" class="results">
                
                <tr class="pageTitle">
                  <td colspan="2">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="20%" valign="middle" align="left">
                          <a class="help" href="userHelp.jsp#GViewerDetails">
                          <img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                        </td>
                        <td width="60%" class="pageTitle">
                          Cancer &nbsp; QTL &nbsp; Selection &nbsp; Details
                        </td>
                        <td width="20%" valign="middle" align="center">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <!--======================= End Form Header ================================-->
<!--======================= Start Detail Section ===========================-->
  
                <tr class="stripe1">
                  <td colspan="2">
                    
                    
                    
                    
                    <table width="560" align="center">
                      
                      
                      <c:choose>
                        <c:when test="${not empty QTLForm.label}">
                          <tr class="stripe2">
                            <td class="cat2">
                              QTL
                            </td> 
                            <td>
                              <a href="http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=markerDetail&id=${QTLForm.mgiId}">${QTLForm.label}</a> &nbsp; (links to MGI detail)
                            </td>
                          </tr>
                          <tr class="stripe1">
                            <td class="cat1">
                              Name
                            </td>
                            <td>
                              ${QTLForm.qtlName}
                            </td>
                          </tr>								
                        </c:when>
                        
                      </c:choose>
                      
                      <tr class="stripe2">
                        <td class="cat2">Location</td><td><a href="nojavascript.jsp" onClick="popPathWin('http://genome.ucsc.edu/cgi-bin/hgTracks?org=Mouse&position=Chr${QTLForm.chrom}:${QTLForm.qtlStart}-${QTLForm.qtlEnd}');return false;" >${QTLForm.chrom}:${QTLForm.qtlStart}..${QTLForm.qtlEnd}</a> &nbsp; (links to UCSC genome browser) <br> <i>Build 37</i> </td>
                      </tr>
                      
                      <tr class="stripe1">
                        <td class="cat1">Primary Reference</td><td><a href="http://www.informatics.jax.org/searches/reference.cgi?${QTLForm.primeRefId}">${QTLForm.primeRef}</a></td>
                      </tr>
                      <tr class="stripe2">
                        <td class="cat2">Strain tumor overview</td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty strains}">
                              <c:forEach var="strain" items="${strains}" varStatus="count">
                                <c:choose>
                                  <c:when test="${not empty strain.value}">
                                    <a href='strainDetails.do?page=collapsed&key=${strain.value}'>${strain.label}</a>&nbsp;
                                  </c:when>
                                  <c:otherwise>
                                    ${strain.label}&nbsp;
                                  </c:otherwise>
                                </c:choose>
                              </c:forEach>
                            </c:when>
                            <c:otherwise>
                              No associated strains
                            </c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                      
                    </table>
                  </td>
                </tr>
                <tr class="stripe1">
                  <td colspan="2">
                    <table width="560" align="center">
                      <html:form action="gViewerDetails" method="GET" >
                        <tr>
                          <td colspan="6" align="center">
                            <b>Search for genes within the selected coordinates.</b>
                            <br>
                            Refine search with the following critera.<br>
                          </td>
                        </tr>
                        <tr class="stripe2">
                          <td class="cat2">Chromosome</td>
                          <td>${QTLForm.chrom}</td>
                          <td class="cat2">Start (bp)</td>
                          <td><input type="text" name="searchStart" value="${QTLForm.searchStart}"></td>
                          <td class="cat2">End (bp)</td>
                          <td><input type="text" name="searchEnd" value="${QTLForm.searchEnd}"></td>
                        </tr>
                        <tr class="stripe1">
                          <td class ="cat1">
                            Feature Type
                          </td>
                          <td colspan ="5" id="featureTypeSelection"></td>
                        </tr>
                        <tr class="stripe1">
                          <td class="cat1">
                            Mouse phenotypes & mouse models of human disease
                          </td>
                          <td colspan="5">
                            <i>Enter any combination of phenotype terms, disease terms, or IDs </i><br>
                            <html:textarea property="phenotype" rows="2" cols="50"/>
                            <br>
                            Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/searches/MP_form.shtml');return false;">Mammalian Phenotype Ontology (MP)</a>
                            <br>
                            Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=omimVocab&subset=A');return false;">Human Disease Vocabulary (OMIM)</a>
                          </td>
                        </tr>
                        
                        
                        <tr  class="stripe2">
                          <td class="cat2">
                            Gene Ontology(GO) Classification
                          </td>
                          <td colspan="5">
                            <html:select property="go_op">
                              <html:option value="begins">begins</html:option>
                              <html:option value="%3D">=</html:option>
                              <html:option value="ends">ends</html:option>
                              <html:option value="contains">contains</html:option>
                              <html:option value="like">like</html:option>
                            </html:select>
                            &nbsp;
                            <html:text property="go_term" size="40"/>&nbsp;in<br>
                            
                            <html:multibox property="ontology_key" value="Molecular+Function"/>Molecular Function<br>
                            <html:multibox property="ontology_key" value="Biological+Process"/>Biological Process<br>
                            <html:multibox property="ontology_key" value="Cellular+Component"/>Cellular Component<br>
                            <br>
                            Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/userdocs/marker_help.shtml#gene_ontology');return false;">Gene Ontology</a>
                          </td>
                        </tr>
                        
                        <tr class="stripe1">
                          <td class="cat1">
                            Display Results as
                          </td>
                          <td colspan="3"> 
                            <select size="1" name="display">
                              <option value="web">HTML</option>
                              <option value="tab">Tab Delimited</option>
                            </select>
                          </td>
                          <td class="cat1">
                            Sort by
                          </td>
                          <td>
                            <html:radio property="sortBy" value="nomen">Nomenclature</html:radio>
                            <br>
                            <html:radio property="sortBy" value="coord">Coordinates</html:radio>
                            <br>
                            <html:radio property="sortBy" value="cm">cM Position</html:radio>
                          </td>
                        </tr>
                        
                        <tr>
                          
                          <td>
                            
                            <input type="submit" value="Search"/>
                            
                            <html:hidden property="chrom"/>
                            <html:hidden property="types"/>
                            <html:hidden property="label"/>
                            <html:hidden property="primeRef"/>
                            <html:hidden property="primeRefId"/>
                            <html:hidden property="mgiId"/>
                            <html:hidden property="qtlName"/>
                            <html:hidden property="qtlStart"/>
                            <html:hidden property="qtlEnd"/>
                            <html:hidden property="featureTypes"/>
                            
                          </td>
                          
                          <td colspan="5">
                            <input type="reset" value="Reset" />
                          </td>
                        </tr> 
                      </html:form>
                      <tr>
                        <c:choose>
                          <c:when test="${not empty features}">
                            <tr>
                               <td colspan="6"><input type='button' value="Send results to QTL viewer" onclick="viewerSubmit()"></td>
                             </tr>
                             <tr>
                              <td colspan="6">
                                <form method="post" action="http://www.informatics.jax.org/javawi2/servlet/WIFetch">
                                  <input type="hidden" name="page" value="batchSummary"/>
                                  <input type="hidden" name="IDType" value="MGIMarker" />
                                  <input type="hidden" name="IDSet" value="${ids}"/>
                                  <input type="submit" value="Submit results to MGI Batch Query"/> 
                                  
                                  <div id='params' style='display: none;'>
                                    <table  border='0' cellpadding='0' cellspacing='1'>
                                      <tbody>
                                        <tr>
                                          <a href='#'  onclick='batchSwap()' class='example'>Hide batch query parameters</a>
                                        </tr>
                                        <tr>
                                          
                                          <td valign='top'>
                                            <table border='0' cellpadding='4' cellspacing='1'>
                                              <tr class="stripe2">
                                                <td class="cat2"><font class='label'>Gene Attributes:</font></td>
                                                
                                                <td  colspan='4'>
                                                  <table border='0' cellpadding='4' cellspacing='0'>
                                                    <tr>
                                                      <td><input type='checkbox' name='returnSet' value='Nomenclature' checked="checked" />Nomenclature</td>
                                                      <td><input type='checkbox' name='returnSet' value='Location' checked="checked"/>Genome&nbsp;Location</td>
                                                    </tr>
                                                    <tr>
                                                      <td><input type='checkbox' name='returnSet' value='Ensembl' />Ensembl&nbsp;ID</td>
                                                      <td><input type='checkbox' name='returnSet' value='EntrezGene' />Entrez&nbsp;Gene&nbsp;ID</td>
                                                      <td><input type='checkbox' name='returnSet' value='VEGA' />VEGA&nbsp;ID</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr class="stripe1">
                                              <td class="cat1">Additional Information</td>
                                              <td colsan='4'>
                                                <table border='0' cellpadding='4' cellspacing='1'>
                                                  <tr>
                                                    <td ><input type='radio' name='returnRad' value='GO' />Gene&nbsp;Ontology&nbsp;(GO)</td>
                                                    <td colspan="2"><input type='radio' name='returnRad' value='MP' />Mammalian&nbsp;Phenotype&nbsp;(MP)</td>
                                                    
                                                  </tr>
                                                  <tr >
                                                    <td><input type='radio' name='returnRad' value='omim' />Human Disease (OMIM)</td>
                                                    <td><input type='radio' name='returnRad' value='MGIAllele' />Alleles</td>
                                                    <td><input type='radio' name='returnRad' value='RefSNP'/>RefSNP&nbsp;ID</td>
                                                    
                                                  </tr>
                                                  <tr> 
                                                    <td><input type='radio' name='returnRad' value='UniProt'/>UniProt&nbsp;ID</td>
                                                    <td><input type='radio' name='returnRad' value='GenBankRefSeq' />GenBank/RefSeq&nbsp;ID</td>
                                                    <td><input type='radio' name='returnRad' value='None' checked="checked" />None</td>
                                                  </tr>
                                                </table>
                                              </td>
                                              
                                              <tr class="stripe2">
                                                <td class="cat2">Format</td>
                                                <td  colspan='4'>
                                                  <table border='0' cellpadding='4' cellspacing='0'>
                                                    <tr>
                                                      <td>
                                                        <input name='printFormat' value='toolbar' checked='checked' type='radio'/>Web&nbsp;&nbsp;
                                                      <span class='example'>(10,000 row max.)</span></td>
                                                      <td>
                                                        <input name='printFormat' value='dataDisplay' type='radio'/>Tab-delimited Text&nbsp;&nbsp;
                                                      <span class='example'>(200,000 row max.)</span></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        
                                      </tbody>
                                    </table>
                                  </div>
                                  <div id="summary" style="display: block" >
                                    <a href='#' onclick='batchSwap()' class='example'>Modify batch query parameters</a>
                                  </div>
                                  
                                  
                                  
                                </form>
                                
                              </td>
                            </tr>
                            <tr> 
                            <td colspan="6">
                              <table border="0" cellpadding=5 cellspacing=1" width="560" class="results">
                                <tr>
                                  <td class="resultsHeader">Gene</td>
                                  <td class="resultsHeader">Name</td>
                                  <td class="resultsHeader">Chromosome:Start..End</td>
                                  <td class="resultsHeader">MGI ID</td>
                                </tr>
                                <c:forEach var="feature" items="${features}" varStatus="count">
                                  <c:set var="num" value="${num == 1 ? 2 : 1}"/>
                                  <tr class="stripe${num}">
                                    <td>${feature.label}</td>
                                    <td>${feature.name}</td>
                                    <td>${feature.chromosome}:${feature.start}..${feature.end}</td>
                                    <td><a href="http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=markerDetail&id=${feature.mgiId}">${feature.mgiId}</a></td>
                                    
                                  </tr>
                                </c:forEach>
                              </table>
                            </td>
                            <tr>
                            </tr>                    
                          </c:when>
                          <c:when test="${not empty noResults}">
                            
                            <td colspan="6">
                              <table border="0" cellpadding=5 cellspacing=1" width="100%" class="results">
                                <tr>
                                  <td class="resultsHeader">0 Matching Genes</td>
                                </tr>
                              </table>
                            </td>
                            
                          </c:when>
                        </c:choose>
                      </tr>
                      
                    </table>
                  </td> 
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  
</html>
