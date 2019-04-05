<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="PDX Login" help="pdxdetails">
	<ul>
		<li><a target="_blank" href="http://pdx-dashboard.jax.org/v4/">Open PDX Genomics Dashboard</a></li>
		<li><a target="_blank" href="http://pdx-dashboard/elims/submission-lookup/')">Open PDX Sample Name Checker</a></li>
		<li><a target="_blank" href="http://pdx-dashboard/elims/generate-sheet/')">Open PDX Sample Sheet Generator</a></li>
	</ul>
	<c:choose>
	<c:when test="${not empty failure}">
	<h4>The User ID and Password pair you entered is not valid.</h4>						
	</c:when>
	</c:choose>
	<p>Please enter your <strong>User ID</strong> and <strong>Password</strong> below.</p>										
	<p>As of Sept 18, the password has changed. Please contact <a href="mailto:emily.jocoy@jax.org">Emily Jocoy</a> for the new password.</p>					
	<html:form action="pdxLogin">
	<label for="userID">
		<h4>User ID</h4>
		<html:text property="userID" size="30" maxlength="255"/>
	</label>
	<label for="password">
		<h4>Password</h4>
		<html:password property="password" size="30" maxlength="255"/>
	</label>
	<div>
		<input type="submit" value="Login">
		<input type="reset"	value="Reset">
	</div>
	</html:form>
</jax:mmhcpage>
