<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>

       <meta charset="utf-8">
        <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.css"/>
        <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.js"></script>
        
          <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
            
            <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
       
        <script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>


        <script language="javascript">
            
              

            $(document).ready(function () {
                
                configs = {
                    "colReorder": true,
                    "info": false,
                    "scrollX": true,
                    "paging": false,
                    "searching": false,
                    "ordering": false,
                    "fixedColumns": {
                        "leftColumns": 1
                    },
                    "retrieve": true
                }
                
                 for(i = 1; i < ${caseCount}; i++){
                    table = $('#comparisonTable'+i).DataTable( configs);
                }
                
                

                $('#comparisonTable tbody').on('mouseenter', 'td', function () {
                    var colIdx = table.cell(this).index().column;
                    

                    $(table.cells().nodes()).removeClass('highlight');
                    $(table.columns().header()).removeClass('highlight');
                    if(colIdx>0){
                        $(table.column(colIdx).nodes()).addClass('highlight');
                        $(table.column(colIdx).header()).addClass('highlight');
                    }
                });
                
                 $('#comparisonTable tbody').on('mouseout', 'td', function () {
                   
                    $(table.cells().nodes()).removeClass('highlight');
                    $(table.columns().header()).removeClass('highlight');
                    
                });


            });

            // redraw the table once all the images for model names have loaded
             
            $(window).on("load", function () {
                for(i = 1; i < ${caseCount}; i++){
                    $('#comparisonTable'+i).DataTable().draw();
                }
            });
            
            
            
            
            

            $(window).on("load", function(){
                $('#loading').hide();
                
                $( function() {
                  $( "#tabs" ).tabs({heightStyle:"auto"});
                } );
            });
            
               
                          
              
  </script>



        </script>

      

        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Visualization"/>
        </c:import>


        <style>

            td.highlight, th.highlight {
                padding:0px 5px 5px 8px !important;
            }

        </style>

    </head>
    <body>
        
        
        <div id="loading" style="top:0px;left:0px;background-color:grey; z-index:99; width:100%;height:100%;position: fixed;
   display: block;
   opacity: 0.7;
   text-align: center; 
   line-height:500px;
   font-size:40px;">Loading please wait....<br></div>

        <div style="position:fixed;left:5px;top:5px;width:225px;height:100%; border-right:4px solid grey;font-size:12px;font-family:verdana">

            <c:import url="../../../pdxToolBar.jsp" />
        </div>



        <div style="width:auto;padding-left:300px;height:100%;top:5px;padding-right:40px">
            <div style="border:1px solid black; padding:5px">

                <table width="100%" border="1" cellpadding="4" cellspacing="0" style="background:#D0E0F0">
                    <tr>
                        <td width="25%" valign="middle" align="left" style="border:none">
                            <a class="help" href="${applicationScope.urlBase}/html/PDXLikeMeHelp.html#vis"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
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
                                    <td style="text-align:center;background-color:#007300">&lt;-10</td>
                                    <td style="text-align:center;background-color:#009b00">-10 <b>-</b> -2</td>
                                    <td style="text-align:center;background-color:#00d700">-2 <b>-</b> -0.5</td>
                                    <td style="text-align:center;background-color:#00f500">-.05 <b>-</b> -.01</td>
                                    <td style="text-align:center;background-color:#808080">-.01 <b>-</b> +.01</td>
                                    <td style="text-align:center;background-color:#f50000">+.01 <b>-</b> +0.5</td>
                                    <td style="text-align:center;background-color:#d70000">+0.5 <b>-</b> +2</td>
                                    <td style="text-align:center;background-color:#9b0000">+2 <b>-</b> +10</td>
                                    <td style="text-align:center;background-color:#730000">&gt;10</td>
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
                     

 
                <div id="tabs">
                  <ul>
                        <c:forEach var="cases" items="${caseList}" varStatus="status">
                            <li><a href="#tabs-${status.count}">${cases}</a></li>
                        </c:forEach>
                    
                  </ul>
                  ${table}
                </div>

               

            </div>
        </div>
    </body>
</html> 
