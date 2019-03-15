<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<!-- Combo-handled YUI CSS files: -->
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/reset-fonts-grids/reset-fonts-grids.css&2.7.0/build/base/base-min.css&2.7.0/build/assets/skins/sam/skin.css">
<!-- Combo-handled YUI JS files: -->
<script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/element/element-min.js&2.7.0/build/paginator/paginator-min.js&2.7.0/build/datasource/datasource-min.js&2.7.0/build/dragdrop/dragdrop-min.js&2.7.0/build/datatable/datatable-min.js&2.7.0/build/resize/resize-min.js"></script>

<html>
  <head>
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="Tumor Search Results"/>
    </c:import>
  </head>
  
  <c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Tumor Search Results"/>
  </c:import>
  
  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td width="200" valign="top">
        <c:import url="../../../toolBar.jsp" />
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
              <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr class="pageTitle">
                  <td colspan="11" width="100%">
                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                      <tr>
                        <td width="20%" valign="middle" align="left">
                          <a class="help" href="userHelp.jsp#tumorresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                        </td>
                        <td width="60%" class="pageTitle">
                          Tumor Search Results
                        </td>
                        <td width="20%" valign="middle" align="center">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
                <tr class="summary">
                  <td colspan="11" align="left">
                    <font class="label">Search Summary</font><br>
                    
                    <c:if test="${not empty anatomicalSystemOriginName}">
                      <font class="label">Anatomical System of Origin:</font> ${anatomicalSystemOriginName}<br>
                    </c:if>
                    
                    <c:if test="${not empty organTissueOrigins}">
                      <c:choose>
                        <c:when test="${fn:length(organTissueOrigins)>1}">
                          <font class="label">Organs/Tissues of Origin:</font>
                        </c:when>
                        <c:otherwise>
                          <font class="label">Organ/Tissue of Origin:</font>
                        </c:otherwise>
                      </c:choose>
                      
                      <c:forEach var="organ" items="${organTissueOrigins}" varStatus="status">
                        <c:choose>
                          <c:when test="${status.last != true}">
                            ${organ},
                          </c:when>
                          <c:otherwise>
                            ${organ}
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <br>
                    </c:if>
                    
                    <c:if test="${not empty organOriginName}">
                      <font class="label">Organ/Tissue of Origin:</font> ${organOriginName}<br>
                    </c:if>
                      
                    <c:if test="${not empty organOfOriginName}">
                      <font class="label">Organ/Tissue of Origin:</font> Contains "${organOfOriginName}"<br>
                    </c:if>
                      
                    <c:if test="${not empty tumorClassifications}">
                      <c:choose>
                        <c:when test="${fn:length(tumorClassifications)>1}">
                          <font class="label">Tumor Classifications:</font>
                        </c:when>
                        <c:otherwise>
                          <font class="label">Tumor Classification:</font>
                        </c:otherwise>
                      </c:choose>
                      
                      <c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
                        <c:choose>
                          <c:when test="${status.last != true}">
                            ${classification},
                          </c:when>
                          <c:otherwise>
                            ${classification}
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <br>
                    </c:if>
                    
                    <c:if test="${not empty tumorName}">
                      <font class="label">Tumor Name:</font> Contains "${tumorName}"<br>
                    </c:if>
                    
                    <c:if test="${not empty agentType}">
                      <font class="label">Treatment Type:</font> ${agentType}<br>
                    </c:if>
                    
                    <c:if test="${not empty agent}">
                      <font class="label">Treatment:</font>  Contains "${agent}"<br>
                    </c:if>
                    
                    <c:if test="${not empty metastasisLimit}">
                      <font class="label">Restrict search to metastatic tumors only.</font><br>
                    </c:if>
                    
                    <c:if test="${not empty organsAffected}">
                      <c:choose>
                        <c:when test="${fn:length(organsAffected)>1}">
                          <font class="label">Organs/Tissues Affected:</font>
                        </c:when>
                        <c:otherwise>
                          <font class="label">Organ/Tissue Affected:</font>
                        </c:otherwise>
                      </c:choose>
                      
                      <c:forEach var="organ" items="${organsAffected}" varStatus="status">
                        <c:choose>
                          <c:when test="${status.last != true}">
                            ${organ},
                          </c:when>
                          <c:otherwise>
                            ${organ}
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <br>
                    </c:if>
                    
                    <c:if test="${not empty organAffectedName}">
                      <font class="label">Organ/Tissue Affected:</font> ${organAffectedName}<br>
                    </c:if>
                    
                    
                    <c:if test="${not empty mustHaveImages}">
                      <font class="label">Restrict search to entries with associated pathology images.</font><br>
                    </c:if>
                    
                    <c:if test="${not empty geneticChange}">
                      <font class="label">Genetic Change:</font> ${geneticChange}<br>
                    </c:if>
                    
                    <c:if test="${not empty cytogeneticChange}">
                      <font class="label">Cytogenetic Change:</font> ${cytogeneticChange}<br>
                    </c:if>
                    
                    <c:if test="${not empty colonySize}">
                      <font class="label">Colony Size:</font> ${colonySize}<br>
                    </c:if>
                    
                    <c:if test="${not empty frequency}">
                      <font class="label">Frequency:</font> ${frequency}<br>
                    </c:if>
                    
                    <c:if test="${not empty strainName}">
                      <font class="label">Strain:</font> ${strainName}<br>
                    </c:if>
                    
                    <c:if test="${not empty strainFamilyName}">
                      <font class="label">Strain Family:</font> ${strainFamilyName}<br>
                    </c:if>
                    
                    <c:if test="${not empty strainTypes}">
                      <c:choose>
                        <c:when test="${strainTypesSize>'1'}">
                          <font class="label">Strain Types:</font>
                        </c:when>
                        <c:otherwise>
                          <font class="label">Strain Type:</font>
                        </c:otherwise>
                      </c:choose>
                      
                      <c:forEach var="strainType" items="${strainTypes}" varStatus="status">
                        <c:choose>
                          <c:when test="${status.last != true}">
                            ${strainType},
                          </c:when>
                          <c:otherwise>
                            ${strainType}
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <br>
                    </c:if>
                    
                    <c:if test="${not empty accId}">
                      <font class="label">Accession Id:</font> ${accId}<br>
                    </c:if>
                    
                    <font class="label">Sort By:</font> ${sortBy}<br>
                    <font class="label">Display Limit:</font> ${maxItems}
                  </td>
                </tr>
                <tr class="summary">
                  <td colspan="11">
                    <!--======================= Start Display Limit ============================-->
                    <c:choose>
                      <c:when test="${numberOfResults != totalResults}">
                        <c:choose>
                          <c:when test="${numberOfResults==1}">
                            <c:choose>
                              <c:when test="${tumorFrequencyRecords==1}">
                                ${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
                              </c:when>
                              <c:otherwise>
                                ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
                              </c:otherwise>
                            </c:choose>
                          </c:when>
                          <c:otherwise>
                            <c:choose>
                              <c:when test="${tumorFrequencyRecords==1}">
                                ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency record returned.
                              </c:when>
                              <c:otherwise>
                                ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
                              </c:otherwise>
                            </c:choose>
                          </c:otherwise>
                        </c:choose>
                      </c:when>
                      <c:otherwise>
                        <c:choose>
                          <c:when test="${numberOfResults==1}">
                            <c:choose>
                              <c:when test="${tumorFrequencyRecords==1}">
                                ${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
                              </c:when>
                              <c:otherwise>
                                ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
                              </c:otherwise>
                            </c:choose>
                          </c:when>
                          <c:otherwise>
                            <c:choose>
                              <c:when test="${tumorFrequencyRecords==1}">
                                ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency record returned.
                              </c:when>
                              <c:otherwise>
                                ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
                              </c:otherwise>
                            </c:choose>
                          </c:otherwise>
                        </c:choose>
                      </c:otherwise>
                    </c:choose>
                    <!--======================= End Display Limit ==============================-->
                  </td>
                </tr>
                <!--======================= End Search Summary =============================-->
                <!--======================= Start Results ==================================-->
                <c:choose>
                  <c:when test="${not empty tumors}">
                    <script type="text/javascript" >
                      YAHOO.util.Event.addListener(window, "load", function() { 
                        buildTable = new function() { 
                          var resultsDataSource = new YAHOO.util.LocalDataSource( [
                              <c:forEach var="tumor" items="${tumors}" varStatus="status">
                            {tumorname:"<c:out value="${tumor.tumorName}" escapeXml="false"/>",
                              organ:"<c:out value="${tumor.organAffectedName}" escapeXml="false"/>",
                              agent:["<c:out value="${tumor.treatmentType}" escapeXml="false"/>"
                                  <c:if test="${(not empty tumor.agentsCollection) && (fn:length(tumor.agentsCollection) > 0)}">
                                  <c:forEach var="agentInfo" items="${tumor.agentsCollection}" varStatus="status">
                                  <c:if test="${(not empty agentInfo) && (fn:length(agentInfo) > 0)}">,"<c:out value="${agentInfo}" escapeXml="false"/>"
                                  </c:if>
                                  </c:forEach>
                                  </c:if>],strain:["<c:out value="${tumor.strainKey}"/>"
                                ,"<c:out value="${tumor.strainName}" escapeXml="false"/>"<c:if test="${not empty tumor.strainTypesCollection}"><c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">,"${strainType}"
                                  </c:forEach>
                                  </c:if>],
                              f:"<c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/>",
                              m:"<c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/>",
                              mixed:"<c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/>",
                              unk:"<c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/>",
                              mets:<c:choose>
                                <c:when test="${not empty tumor.metastasizesToDisplay}">"<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">${organ}<c:if test="${status.last != true}"><br></c:if>
                                </c:forEach>",
                                </c:when>
                                <c:otherwise>"",</c:otherwise>
                                </c:choose>
                                image:<c:choose><c:when test="${tumor.images==true}">"image",</c:when>
                                <c:otherwise>"",</c:otherwise>
                                </c:choose>
                                summary:"tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}",},
                                </c:forEach>
                              ]);
    
                            resultsDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY; 
                            resultsDataSource.responseSchema = {fields:["tumorname","organ","agent","strain","f","m","mixed","unk","mets","image","summary"]};
                            var linkFormat = function(elCell, oRecord, oColumn, oData){
                              var ref = oData;
                              elCell.innerHTML = '<a href="'+ref+'">Summary</a>';
                            }
                            var strainFormat = function(elCell, oRecord, oColumn, oData){
                              var data = oData;
                              elCell.innerHTML = '<a href="strainDetails.do?key='+data[0]+'">'+data[1]+'</a>';
                              for(i=2; i<data.length; i++){
                                if(i==2){
                                  elCell.innerHTML = elCell.innerHTML+"<br>"+data[i];
                                }else{
                                  elCell.innerHTML = elCell.innerHTML+", "+data[i];
                                }
                              }
                            }
                            var columnDefs = [{key:"tumorname",label:"Tumor Name", width:200, sortable:true,resizeable:true},
                              {key:"organ",label:"Organ", width:200, sortable:true,resizeable:true},
                              {key:"agent",label:"Agent", width:200, sortable:true,resizeable:true},
                              {key:"strain",label:"Strain", formatter:strainFormat, width:300, sortable:true,resizeable:true},
                              {label:"Tumor Frequency Range", children:[{key:"f",label:"F", width:60},
                                  {key:"m",label:"M", width:60, sortable:true},
                                  {key:"mixed",label:"Mixed", width:60, sortable:true},
                                  {key:"unk",label:"Unk.", width:60, sotrable:true}],resizeable:true},
                              {key:"mets",label:"Metastasizes<br>to",width:100,resizeable:true},
                              {key:"image",label:"Images",width:60,resizeable:true},
                              {key:"summary",label:"Summary", formatter:linkFormat, width:100,resizeable:true},
                            ];
                    
                            var columnDefs2 = [{key:"tumorname",label:"Tumor Name", width:200, sortable:true,resizeable:true},
                              {key:"organ",label:"Organ", width:200, sortable:true,resizeable:true},
                              {key:"agent",label:"Agent", width:200, sortable:true,resizeable:true},
                            ];
                    
                            var tableConfigs = {paginator : new YAHOO.widget.Paginator({rowsPerPage:35}) };

                    
                            var dataTable = new YAHOO.widget.DataTable("resultsTable",columnDefs,resultsDataSource,tableConfigs);
    
    
                            YAHOO.widget.DataTable.prototype.getTdEl = function(cell) {

                              var Dom = YAHOO.util.Dom,

                              lang = YAHOO.lang,
                              elCell,
                              el = Dom.get(cell);

                              // Validate HTML element
                              if(el && (el.ownerDocument == document)) {

                                // Validate TD element
                                if(el.nodeName.toLowerCase() != "td") {

                                  // Traverse up the DOM to find the corresponding TR element
                                  elCell = Dom.getAncestorByTagName(el, "td");

                                }
                                else {

                                  elCell = el;

                                }

                                // Make sure the TD is in this TBODY
                                if(elCell && (elCell.parentNode.parentNode == this._elTbody)) {

                                  // Now we can return the TD element
                                  return elCell;

                                }

                              }
                              else if(cell) {

                                var oRecord, nColKeyIndex;

                                if(lang.isString(cell.columnKey) && lang.isString(cell.recordId)) {

                                  oRecord = this.getRecord(cell.recordId);
                                  var oColumn = this.getColumn(cell.columnKey);
                                  if(oColumn) {

                                    nColKeyIndex = oColumn.getKeyIndex();

                                  }

                                }
                                if(cell.record && cell.column && cell.column.getKeyIndex) {

                                  oRecord = cell.record;
                                  nColKeyIndex = cell.column.getKeyIndex();

                                }
                                var elRow = this.getTrEl(oRecord);
                                if((nColKeyIndex !== null) && elRow && elRow.cells && elRow.cells.length > 0) {

                                  return elRow.cells[nColKeyIndex] || null;

                                }

                              }

                              return null;

                            };
    
    
    
                            return {
                              oDS: resultsDataSource,
                              oDT: dataTable
                            }
                          }();
                        });
                    </script>
                    <tr class="summary"><td><div class="yui-skin-sam" id="resultsTable">There should be stuff here</div></td></tr>
                  </c:when>
                  <c:otherwise>
                    <!-- No results found. //-->
                  </c:otherwise>
                </c:choose>
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

