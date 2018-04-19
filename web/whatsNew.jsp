<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<c:import url="meta.jsp" />
<title>What's New at MTB?</title>
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
                       What's New in MTB?
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
                    
<!--======================= Start Main Section =============================-->

<c:import url="/live/www/html/whatsNew.html"/>

<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</td></tr></table>
</body>
</html> 
