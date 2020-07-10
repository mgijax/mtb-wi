<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft" subtitle="PDX Like Me Search" help="${pageContext.request.contextPath}/pdxlikemehelp.jsp">
    <jsp:attribute name="head">
        <style type="text/css">
            /* force the horizontal scroll bars into hiding */
            .dataTables_scrollBody
            {
             overflow-x:hidden !important;
             overflow-y:auto !important;
            }          
            /* seems to be needed for striping of results */
            .even{
               background-color:#eff0f1 !important;
            }
            #pdx {
                padding:25px 0 100px;
            }
            #pdx form {
                display:flex;
                justify-content: space-between;
                margin-bottom:25px;
            }
            #pdx form > div {
                width:calc(50% - 15px);
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            #pdx fieldset {
                margin-bottom:25px;
                border:1px solid #c7c7c7;
            }

            #pdx textarea {
                display:block;
                width:100%;
                padding:10px;
            }

        </style>
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script type="text/javascript" charset="utf8">

            $(document).ready( function () {
            for(i = 1; i < ${caseCount}; i++){
            table = $('#results'+i).DataTable( {
            searching:      false,
            info:           false,
            scrollY:        '50vh',
            scrollCollapse: true,
            paging:         false,
            ordering:       false,
            stripe:         true
            } );
            
            }
            
            // three times is the charm
            // anything less fails for "Case 1 \n KRAS:AMP"
            $('.dataTable').DataTable().columns.adjust();
            $('.dataTable').DataTable().columns.adjust();
            $('.dataTable').DataTable().columns.adjust();

            } );

            function clearForm() {
            document.forms[0].cases.value = "";
            document.forms[0].submit();
            }         
        </script>        
    </jsp:attribute> 
    <jsp:body>    
    
    <section id="summary">
        <div class="container">
            <p>Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.  PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.  The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.</p>
            <p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p>
            <!-- <img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" border=0 alt="NSG Mouse"> 
        -->
            <p>Use PDX Like Me to search for PDX models with tumor samples that meet multiple genomic criteria. Molecular profiles can combine mutation, expression, and/or copy number aberration criteria. Multiple profiles can be searched at one time.</p>
            
            <p><a href="${pageContext.request.contextPath}/pdxlikemehelp.jsp" target="_blank">Learn how to use PDX Like Me </a></p>
        
        </div>
    </section>
    
    
    <section id="pdx">
        <div class="container">

            <html:form action="pdxLikeMe" method="POST">

                <div>
                    <fieldset>
                        <legend>Enter case information here<c:if test="${empty cases}"> (example shown)</c:if></legend>               
                        <textarea rows="10" cols="45" name="cases" placeholder="Example search:&#10;CASE 1&#10;KRAS:AMP&#10;TP53:MUT=A159V&#10;ALB:DEL&#10;KIT:EXP&gt;2.5"><c:if test="${empty cases}">CASE 1&#10;KRAS:AMP&#10;TP53:MUT=A159V&#10;ALB:DEL&#10;KIT:EXP&gt;2.5</c:if>${cases}</textarea>
                    </fieldset>
                </div>
                
                <div>
                    <fieldset>
                        <legend>Output options</legend>
                        <div><input type="checkbox" name="asCSV" value="asCSV" ${csvChecked}/> <label>Return results as a CSV file</label></div>
                        <div><input type="checkbox" name="actionable" value="actionable" ${actionableChecked}/> <label>Include models with clinically relevant variants for supplied genes</label></div>
                        <div><input type="checkbox" name="LRP" value="LRP" ${lrpChecked}> <label>If searching by CNV display log ratio ploidy values</label></div>
                        <div><input type="checkbox" name="EXP" value="EXP" ${expChecked}> <label>If searching by expression level display Z score percentile rank values</label></div>
                    </fieldset>                  
                    
                    <input type="submit" VALUE="Search">
                    <input type="button" VALUE="Reset" onclick="clearForm();">
                    <input name="viz" type="submit" VALUE="Visualize">
                </div>

            </html:form>
            
            ${table}
            
    </section>
</jsp:body>
</jax:mmhcpage>

