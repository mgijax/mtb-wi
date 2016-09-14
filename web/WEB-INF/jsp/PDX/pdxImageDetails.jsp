<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="PDX Image Detail"/>
    </c:import>



</head>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="PDX Image Detail"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
                        <!--======================= Start Main Section =============================-->
                        <!--======================= Start Form Header ==============================-->
                        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                            <tr class="pageTitle">
                                <td colspan="2">
                                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width="20%" valign="middle" align="left">
                                                <a class="help" href="userHelp.jsp#imagedetail"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                            </td>
                                            <td width="60%" class="pageTitle">
                                                PDX Image Detail
                                            </td>
                                            <td width="20%" valign="middle" align="center">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <!--======================= End Form Header ================================-->
                            <!--======================= Start Detail Section ===========================-->
                            <!--======================= Start Pathology Image ==========================-->    
                            <tr class="stripe1">
                                <td colspan="2">
                                    <center>

                                        <img height=800 width=800 src="${applicationScope.pdxFileURL}${fileName}">

                                    </center>
                                </td>
                            </tr>
                            <!--======================= End Pathology Image ============================-->    
                            <!--======================= Start Pathology ================================-->    

                            <tr class="stripe1">
                                <td class="cat1">Description</td>
                                <td>${description}</td>
                            </tr>



                            <!--======================= End Pathology ==================================-->    
                        </table>



                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html> 



