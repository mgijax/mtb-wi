<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<c:import url="meta.jsp" />

<title>Lymphoma Pathology</title>

</head>
<body>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td width="200" valign="top">
    <c:import url="toolBar.jsp" />
</td>
<td class="separator">
    &nbsp;
</td>
<td valign="top">
<table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
    <tr>
        <td>

<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Lymphoma Pathology
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
                    
<!--======================= Start Main Section =============================-->

<br>

Click <a href="${applicationScope.urlBase}/html/Lymphoma.html">here</a> for Lymphoma Pathology in HTML format.
<br><br>
Click <a href="${applicationScope.urlBase}/html/Lymphoma.xlsx">here</a> to download in Microsoft<sup>&reg;</sup> Excel format.


<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</td></tr></table>
</body>
</html> 
