<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>

        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.css"/>
        <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.js"></script>
        <script type="text/javascript" src="${applicationScope.urlBase}/js/jquery-ui.min.js"></script>
        <script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>


        <script language="javascript">

            $(document).ready(function () {
                table = $('#comparisonTable').DataTable({
                    "colReorder": true,
                    "info": false,
                    "scrollX": true,
                    "paging": false,
                    "searching": false,
                    "ordering": false,
                    "fixedColumns": {
                        "leftColumns": 1
                    }
                });
            });
            
            // redraw the table once all the images for model names have loaded
            $(window).on("load", function() {
                $('#comparisonTable').DataTable().draw();
            });


        </script>

    </head>
    <body>

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
                        <td style="text-align:center;background-color:#FFFFFF; border:1px solid black">No Value</td>
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
                        <td style="text-align:center;color:#000000;background-color:#FFFFFF; border: 1px solid black">No Value</td>
                    </tr>
                </table>
                <br>
                <br>
                This visualization tool is still under development and results are for demonstration only.
            </td>
        </tr>
        <tr>
        <%--    <td>This is something<br>
                ${gradient}
            </td>
        --%>
        </tr>
        



    </table>


  
        ${table}
    

</body>
</html> 
