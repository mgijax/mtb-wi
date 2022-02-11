<%-- 
    Document   : pivot
    Created on : Sep 22, 2021, 12:19:29 PM
    Author     : sbn
--%>
<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Pivot Dashboard</title>
        
        <script lang="javascript">
            window.onload = function(){
                
              
            }
            
            
        </script>
    </head>
    <body>
        <h1>Pivot Dashboard: Huddle workspaces</h1>
        
        <table>
            <tr>
        <c:forEach var="task" items="${workspace2}" varStatus="status">
            
            <c:if test="${status.index == 0}">
                <td width="20%">${task.workspace}</td>
            </c:if>
            <td style="background-color:${task.color}">      
                ${task.display}
            </td>
        </c:forEach>
        </tr>
        
          <tr>
        <c:forEach var="task" items="${workspace1}" varStatus="status">
            
            <c:if test="${status.index == 0}">
                <td width="20%">${task.workspace}</td>
            </c:if>
            <td style="background-color:${task.color}">      
                ${task.display}
            </td>
        </c:forEach>
        </tr>
</table>
     <%--   <form action="/mtbwi/pivot.do">
        <input type="hidden" name="token" value="${token}"/>
        <input type="text" name="endpoint"/>.
        <input type="submit">
        </form>
        ${apiResponse}  --%>
    </body>
</html>
