<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="PDX Login"/>
	<c:import url="../../../meta.jsp"/>
</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp#pdxdetails"></a>
</header>

<table>
	<tr>
		<td>
			<input type="button" value="Open PDX Genomics Dashboard" onClick="window.open('http://pdx-dashboard.jax.org/v4/')">
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" value="Open PDX Sample Name Checker" onClick="window.open('http://pdx-dashboard/elims/submission-lookup/')">
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" value="Open PDX Sample Sheet Generator" onClick="window.open('http://pdx-dashboard/elims/generate-sheet/')">
		</td>
	</tr>
	<tr>
		<td>
			<c:choose>
				<c:when test="${not empty failure}">
					<strong>The User ID and Password pair you entered is not valid.<strong>						
					<!-- \n -->											
					<!-- \n -->
				</c:when>
			</c:choose>
			Please enter your <strong>User ID</strong> and <strong>Password</strong> below.												
			<!-- \n -->
			As of Sept 18, the password has changed. Please contact <a href="mailto:emily.jocoy@jax.org">Emily Jocoy</a> for the new password					
			<!-- \n -->
			<html:form action="pdxLogin">
				<table class="results">
					<tr>
						<td>
							<table class="quick-search">
								<tr>
									<td>
										<table>
											<tr>
												<td>User ID</td>
												<td><html:text property="userID" size="30" maxlength="255"/></td>
											</tr>
											<tr>
												<td>Password</td>
												<td><html:password property="password" size="30" maxlength="255"/></td>
											</tr>
										</table>
										<div align="right">
											<input type="submit" VALUE="Login">
											<input type="reset"	VALUE="Reset">
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>

</section>
</div>
</body>
</html>
 

