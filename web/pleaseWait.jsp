<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<!-- The following two lines are required, they instruct the browser to not cache the wait page. -->
<!-- This way we can better guarantee that when the user hits the 'Back' button, they don't get the wait page instead of the form. -->
<META http-equiv="CACHE-CONTROL" content="NO-CACHE">  <!-- For HTTP 1.1 -->
<META http-equiv="PRAGMA" content="NO-CACHE">         <!-- For HTTP 1.0 -->
<META http-equiv="refresh" content="0; URL=<bean:write name="action_path_key" property="actionPath"/>">

<c:import url="meta.jsp">
    <c:param name="pageTitle" value="Request Processing.  Please Wait..."/>
</c:import>

</head>

<c:import url="body.jsp">
     <c:param name="pageTitle" value="Request Processing"/>
</c:import>

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
<!--======================= Start Main Section =============================-->
<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href=""><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Processing
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->

Please wait....

<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</body>
</html> 
