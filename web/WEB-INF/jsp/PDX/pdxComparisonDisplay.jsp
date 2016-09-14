<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Comparison"/>
    </c:import>

    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Comparison"/>
    </c:import>
    
    <script language="javascript">
        
        function showAllMutations(){
            var genes = document.getElementsByName("mtGene");
          
            for(var i=0; i<genes.length; i++){
                if(genes[i].style.cursor == "pointer"){
                    showMutations(genes[i].textContent);
                }
            }
            if(document.getElementById("showAll").textContent =="+"){
                document.getElementById("showAll").textContent ="-";
            }else{
                document.getElementById("showAll").textContent="+";
            }
        
        }
        
        function showMutations(gene){
            var tds = document.getElementsByName(gene);
            for(var i=0; i< tds.length; i++){
                    if(tds[i].textContent.length > 1){
                            tds[i].textContent=" ";
                            tds[i].style ="background-color:#000000";
                            
                    }else{
                            tds[i].removeAttribute("style");
                            tds[i].textContent = tds[i].getAttribute("mutation");
                    }
            }
        }

</script>
    
</head>

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
            <html:form action="pdxComparison" method="GET">

                <table border="0" cellpadding="5" cellspacing="1" width="100%">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a href="nojavascript.jsp" onClick="popSizedPathWin('${applicationScope.urlBase}/html/userHelp.html#pdxcomparison', 'comparisonhelp',350,1000);return false;">
                                        <img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Patient Derived Xenograft Comparison
                                    </td>
                                    <td width="20%" valign="middle" align="right">
                                        <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location='pdxRequest.do'">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                      <tr class="summary">
                        <td >
                            <font class="label">Search Summary</font><br>

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
                </td> 
                <td>
                     <table>
    <tr><td>Rank Z based expression scale</td>
    <tr>
        <td>
            <table>
                <tr>
                <td style="text-align:center;color:#FFFFFF;background-color:#006900">-15</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#007300">-14</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#007d00">-13</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#008700">-12</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#009100">-11</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#009b00">-10</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00a500">-9</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00af00">-8</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00b900">-7</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00c300">-6</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00cd00">-5</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00d700">-4</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00e100">-3</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00eb00">-2</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#00f500">-1</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#808080"> 0 </td>
                <td style="text-align:center;color:#FFFFFF;background-color:#f50000">+1</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#eb0000">+2</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#e10000">+3</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#d70000">+4</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#cd0000">+5</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#c30000">+6</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#b90000">+7</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#af0000">+8</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#a50000">+9</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#9b0000">+10</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#910000">+11</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#870000">+12</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#7d0000">+13</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#730000">+14</td>
                <td style="text-align:center;color:#FFFFFF;background-color:#690000">+15</td>
                <td style="text-align:center;background-color:#FFFFFF">No Value</td>
                </tr>
            </table>
            
        </td>
    </tr>
    <tr><td>
            <table>
                <tr><td>CNV color coding</td></tr>
                <tr>
                    <td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
                    <td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
                    <td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
                    <td style="text-align:center;color:#000000;background-color:#FFFFFF">No Value</td>
                </tr>
            </table>
        </td>
    </tr>
  </table>
                </td>
                </tr>
                    <!--======================= End Form Header ================================-->
                    <tr>
                    <tr><td colspan="4">
                            ${table}
                        </td>
                    </tr>
            <!--        <tr><td>Rank Z based expression scale</td>
                    <tr>
                        <td>
                            ${gradient}
                        </td>
                    </tr>
                    <tr><td>
                            <table>
                                <tr><td>CNV color coding</td></tr>
                                <tr>
                                    <td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
                                    <td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
                                    <td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
                                    <td style="text-align:center;color:#000000;background-color:#FFFFFF">No Value</td>
                                </tr>
                            </table>
                        </td>
                    </tr>    -->



                </table>
            </html:form>
    </td>
</tr>
</table>



<!--======================== End Main Section ==============================-->

</td>
</tr>
</table>

</body>
</html> 
