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
            $(window).on("load", function () {
                $('#comparisonTable').DataTable().draw();
            });


        </script>

        <c:import url="../../../body.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Visualization"/>
        </c:import>
        
           <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Visualization"/>
        </c:import>

    </head>
    <body>

        <div style="position:fixed;left:5;top:5;width:225px;height:100%; border-right:4px solid grey;font-size:12px;font-family:verdana">

            <c:import url="../../../pdxToolBar.jsp" />
        </div>



        <div style="width:auto;padding-left:300px;height:100%;top:5px;padding-right:40px">
            <div style="border:1px solid black; padding:5px">

                 <table width="100%" border="1" cellpadding="4" cellspacing="0" style="background:#D0E0F0">
                    <tr>
                        <td width="25%" valign="middle" align="left" style="border:none">
                            <a class="help" href="${applicationScope.urlBase}/html/PDXLikeMeVisHelp.html"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                        </td>
                        <td width="50%" class="pageTitle" style="border:none;font-family:Arial; font-weight:bold; font-size:18px; text-align:center">
                            Patient Derived Xenograft PDX Like Me Visualization
                        </td>
                        <td width="25%" valign="middle" align="right" style="border:none">
                            <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location = 'pdxRequest.do'">
                        </td>
                    </tr>
                </table>

                <table>
                    <tr><td>Rank Z based expression scale</td>
                    <tr>
                        <td>


                            <table>			
                                <tr>				
                                    <td style="text-align:center;background-color:#007300"><-10</td>
                                    <td style="text-align:center;background-color:#009b00">-10 <b>-</b> -2</td>
                                    <td style="text-align:center;background-color:#00d700">-2 <b>-</b> -0.5</td>
                                    <td style="text-align:center;background-color:#00f500">-.05 <b>-</b> -.01</td>
                                    <td style="text-align:center;background-color:#808080">-.01 <b>-</b> +.01</td>
                                    <td style="text-align:center;background-color:#f50000">+.01 <b>-</b> +0.5</td>
                                    <td style="text-align:center;background-color:#d70000">+0.5 <b>-</b> +2</td>
                                    <td style="text-align:center;background-color:#9b0000">+2 <b>-</b> +10</td>
                                    <td style="text-align:center;background-color:#730000">>10</td>
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
                    </tr>
                </table>

                ${table}

            </div>
        </div>
    </body>
</html> 
