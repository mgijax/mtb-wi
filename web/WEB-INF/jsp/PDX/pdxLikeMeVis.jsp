<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft" subtitle="PDX Like Me Visualization">
<jsp:attribute name="head">

        <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.css"/>
        <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.20/cr-1.5.2/fc-3.3.0/datatables.min.js"></script>
        
          <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
            
            <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
       
        <script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>


        <script type="text/javascript">
            
              

            $(document).ready(function () {
                
               var configs = {
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
                   $('#comparisonTable'+i).DataTable( configs);
                }
                
                <c:forEach var="cases" items="${caseList}" varStatus="status">
                          
                          
                    $('#comparisonTable${status.count} tbody').on('mouseenter', 'td', function () {
                        var  table = $('#comparisonTable${status.count}').DataTable();
                        var colIdx = table.cell(this).index().column;
                     
                        $(table.cells().nodes()).removeClass('highlight');
                        $(table.columns().header()).removeClass('highlight');
                        if(colIdx>0){
                            $(table.column(colIdx).nodes()).addClass('highlight');
                            $(table.column(colIdx).header()).addClass('highlight');
                        }
                    });

                     $('#comparisonTable${status.count} tbody').on('mouseout', 'td', function () {
                         var  table = $('#comparisonTable${status.count}').DataTable();
                        $(table.cells().nodes()).removeClass('highlight');
                        $(table.columns().header()).removeClass('highlight');

                    });
                    
              </c:forEach>
                

            });

            // redraw the table once all the images for model names have loaded
             
            $(window).on("load", function () {
                for(i = 1; i < ${caseCount}; i++){
                    $('#comparisonTable'+i).DataTable().draw();
                }
            });
            
            $(window).on("load", function(){
                   
                
            });
            
            

            $(window).on("load", function(){
                $('#loading').hide();
                
                $( function() {
                  $( "#tabs" ).tabs({heightStyle:"auto"});
                } );
                
              
            });
            
               
                          
              
  </script>


        <style>

            th.highlight {
                padding:0px 2px 8px 0px !important;
            }
            
            #pdx-vis {
              margin-top:50px;
              padding-bottom:150px;
            }

        </style>

</jsp:attribute>
<jsp:body>

<section id="summary">
  <div class="container">
    <!-- <p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p>
    <p><a class="help" href="${applicationScope.urlBase}/html/PDXLikeMeHelp.html#vis">Help and Documentation</a></p> -->
    <p>    The visualization functions for PDX Like Me are still under development. Send feedback and error reports to <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml" target="_blank">MGI User Support</a>.</p>
    <table class="scale">  
      <caption>Rank Z based expression scale</caption>
      <tbody>
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
      </tbody>
                            </table>    
                            <table class="scale">
                              <caption>CNV color coding</caption>
                              <tbody>
                                <tr>
                                  <td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
                                  <td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
                                  <td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
                                  <td style="text-align:center;color:#000000;background-color:#FFFFFF; border: 1px solid black">No Value</td>
                                </tr>
                              </tbody>
                            </table> 
                            <input type="button" value="Modify Query" onclick="history.back();">
</div>
</section>
    
    <section id="pdx-vis">

        
        <div id="loading" style="top:0px;left:0px;background-color:grey; z-index:99; width:100%;height:100%;position: fixed;
   display: block;
   opacity: 0.7;
   text-align: center; 
   line-height:500px;
   font-size:40px;">Loading please wait....<br></div>


 
        <div id="tabs">
          <ul>
                <c:forEach var="cases" items="${caseList}" varStatus="status">
                    <li><a href="#tabs-${status.count}">${cases}</a></li>
                </c:forEach>
            
          </ul>
          ${table}
        </div>

    </section>
  </jsp:body>
</jax:mmhcpage>