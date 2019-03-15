<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>

        <style>
            /* force the horizontal scroll bars into hiding */
            .dataTables_scrollBody
            {
             overflow-x:hidden !important;
             overflow-y:auto !important;
            }
            
            .even{
               background-color:#eff0f1 !important;
            }
            
            
        </style>

        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Search"/>
        </c:import>

        
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">

 

<script type="text/javascript" charset="utf8">

       
            $(document).ready( function () {
                for(i =1; i< ${caseCount}; i++){
                $('#results'+i).dataTable( {
                    searching:      false,
                    info:           false,
                    scrollY:        '50vh',
                    scrollCollapse: true,
                    paging:         false,
                    ordering:       false,
                    stripe:         true
                } );
                };
            } );
        



            function clearForm() {
                document.forms[1].cases.value = "";
                document.forms[1].submit();
            }

        </script>



        <c:import url="../../../body.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Search"/>
        </c:import>
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
                            <html:form action="pdxLikeMe" method="POST">

                                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                                    <tr class="pageTitle">
                                        <td colspan="3">
                                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                                <tr>
                                                    <td width="25%" valign="middle" align="left">
                                                        <a class="help" href="${applicationScope.urlBase}/html/PDXLikeMeHelp.html"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                                                    </td>
                                                    <td width="50%" class="pageTitle">
                                                        Patient Derived Xenograft PDX Like Me Search
                                                    </td>
                                                    <td width="25%" valign="middle" align="right">
                                                        <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location = 'pdxRequest.do'">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <!--======================= End Form Header ================================-->
                                    <tr class="pageInfo">
                                        <td colspan="3">
                                            <table border=0 cellspacing=2 width="100%">
                                                <tr>
                                                    <td>
                                                        &nbsp;Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.  PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.  The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.   
                                                        <br>
                                                        &nbsp;
                                                        <br>
                                                        
                                                    </td>

                                                    <td>
                                                        <img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" border=0 alt="NSG Mouse">
                                                    <td>
                                                </tr>
                                               

                                            </table>
                                        </td>

                                    </tr>
                                   
                                     <tr class="pageInfo">
                                        <td colspan="3">
                                            <p style="font-size:17px">Use PDX Like Me to search for PDX models with tumor samples that meet multiple genomic criteria.<br> Molecular profiles can combine mutation, expression, and/or copy number aberration criteria.<br> Multiple profiles can be searched at one time.</p>
                                            
                                            <a href="${applicationScope.urlBase}/html/PDXLikeMeHelp.html" target="_blank">Learn how to use PDX Like Me </a>
                                            <br><br>
                                            <table>
                                                <tr><td>Example search:</td><td></td></tr>
                                                <tr><td>CASE 1</td>
                                                <tr><td>KRAS:AMP</td></tr>
                                                <tr><td>TP53:MUT=A159V</td></tr>
                                                <tr><td>ALB:DEL</td></tr>
                                                <tr><td>KIT:EXP&gt;2.5</td></tr>
                                            </table>
                                        </td>
                                                    
                                   </tr>


                                    <tr class="buttons">
                                        <td colspan="3">
                                            <table border=0 cellspacing=2 width="100%">
                                                <tr>
                                                    <td>
                                                        <input type="submit" VALUE="Search">
                                                        <input type="button" VALUE="Reset" onclick="clearForm();">


                                                    </td>

                                                </tr>
                                            </table>
                                        </td>
                                    </tr>

                                    <tr class="stripe1">

                                        <td class="cat1">
                                            Output options:
                                            <br><br><br><br>
                                            Enter Case information here:

                                        </td>

                                        <td class="data1">
                                            <input type="checkbox" name="asCSV" value="asCSV" ${csvChecked}/> Return results as a CSV file<br>
                                            <input type="checkbox" name="actionable" value="actionable" ${actionableChecked}/> Include models with clinically relevant variants for supplied genes
                                            <br>
                                            <input type="checkbox" name="LRP" value="LRP" ${lrpChecked}> If searching by CNV display log ratio ploidy values <br>
                                            <input type="checkbox" name="EXP" value="EXP" ${expChecked}> If searching by expression level display Z score percentile rank values
                                            <br>
                                            <textarea rows="20" cols="50" name="cases">${cases}</textarea>
                                        </td>
                                        <td class="data1">
                                            <div id="allResults">
                                            ${table}
                                            </div>
                                        </td>
                                    </tr>

                                    <tr class="buttons">
                                        <td colspan="3">
                                            <table border=0 cellspacing=5 width="100%">
                                                <tr>
                                                    <td>
                                                        <input type="submit" VALUE="Search">
                                                        <input type="button" VALUE="Reset" onclick="clearForm();">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </html:form>

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
