<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Gene Expression"/>
    </c:import>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        
        
        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(drawBarCharts); 
        
        
        function drawBarCharts(){
            rankData = google.visualization.arrayToDataTable([${rank}]);
            rankBarChart = new google.visualization.BarChart(document.getElementById('bar_chart_div3'));
            rank();    
        }
      
         
        function rankSelectHandler(e){
            var selection = rankBarChart.getSelection();
            var item = selection[0];
            if (item.row != null){
                window.open("pdxDetails.do?modelID="+rankData.getValue(item.row,2),"rankData.getValue(item.row,2)");
            }  
        }
                  
        function rank() { 
            if(rankData.getNumberOfRows()>0){
                rankData.sort(1);
                var rankView = new google.visualization.DataView(rankData);
                
                if(rankData.getNumberOfColumns()==3){
                    rankView.setColumns([0, 1]);
                }
                if(rankData.getNumberOfColumns() == 4){
                     rankView.setColumns([0, 1, 3]);
                }
                var options = {
                    fontSize:10,
                    vAxis: {title: 'Model : Sample', titleTextStyle: {color: 'red'}},
                    legend: {position: 'none'},
                    chartArea:{top:20, height:${chartSize}},
                    bar:{groupWidth:10}

                };
               
                google.visualization.events.addListener(rankBarChart, 'select', rankSelectHandler);
                    
                rankBarChart.draw(rankView, options);
            }
        }
  
         
    </script>


    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Gene Expression"/>
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
                    <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                        <tr class="pageTitle">
                            <td colspan="2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="20%" valign="middle" align="left">
                                            <a class="help" href="userHelp.jsp#pdxExpression"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                        </td>
                                        <td width="60%" class="pageTitle">
                                            Patient Derived Xenograft Gene Expression
                                        </td>
                                        <td width="20%" valign="middle" align="right">
                                            <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location='pdxRequest.do'">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <!--======================= End Form Header ================================-->


                        <tr class="summary">
                            <td colspan="1">


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

                                        
                        <font class="label">Gene:</font>${gene2}<br>
                        
                        <c:choose>
                            <c:when test="${not empty variant}">
                                <font class="label">Variant:</font>${variant}<br>
                            </c:when>
                        </c:choose>

                </td>
            </tr>
            <tr class="buttons">
            <c:choose>
                <c:when test="${not empty noResults}">
                     <td colspan="2" align="center">
                         <b>${noResults}</b>
                     </td>
                </c:when>
                     <c:otherwise>
                    
                        <td colspan="2" align="center">
                            <br>
                            <b>Rank based Z score expression of ${gene2}</b>
                            <br>
                            ${message}
                            <br>
                            Click on a rank bar to go to the model's details page.
                            <br>
                            <div id="bar_chart_div3" style="height:${divSize}px"></div>
                        </td>
                     </c:otherwise>
            </c:choose>
            </tr>
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