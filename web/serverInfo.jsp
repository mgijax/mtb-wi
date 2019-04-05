<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Server Information" help="#">
	<!-- ////  Start JVM Information  //// -->
	<table>
		<caption><h2>JVM Information</h2></caption>
		<c:choose>
		<c:when test="${not empty jvm}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="jvmItem" items="${jvm}" varStatus="status">
			<tr>
				<td>${jvmItem.label}</td>
				<td>${jvmItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End JVM Information  //// -->
	
	<!-- ////  Start OS Information  //// -->
	<table>
		<caption><h2>OS Information</h2></caption>
		
		<c:choose>
		<c:when test="${not empty os}">
		<thead>
			<tr>
				<td width="250"	class="results-header">Attribute</td>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="osInfoItem" items="${os}" varStatus="status">
			<tr>
				<td width="250" >${osInfoItem.label}</td>
				<td>${osInfoItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End OS Information  //// -->
	
	<!-- ////  Start System Property Information  //// -->
	<table>
		<caption><h2>System Properties</h2></caption>
		
		<c:choose>
		<c:when test="${not empty sysProps}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="itemVar" items="${sysProps}" varStatus="status">
			<tr>
				<td>${itemVar.label}</td>
				<td>${itemVar.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End System Property Information  //// -->
	
	<!-- ////  Start Request Information  //// -->
	<table>
		<caption>
			<h2>Request Information</h2>
			
			<%-- Use the request object to show the server port and protocol --%>				
			<p>The current request was made on <strong>port 
				<c:out value='${pageContext.request.serverPort}'/></strong>	
				with this <strong>protocol:
			<c:out value='${pageContext.request.protocol}'/></strong>.</p>
			<!-- \n -->
			<%-- Use the request object to show the user's preferred locale --%>
			<p>The request <strong>locale</strong> is 
				<strong><c:out value='${pageContext.request.locale}'/>.</strong></p>
		</caption>
		<c:choose>
		<c:when test="${not empty requestAttributes}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="reqAtt" items="${requestAttributes}" varStatus="status">
			<tr>
				<td>${reqAtt.label}</td>
				<td>${reqAtt.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty detailRequestInfo}">
		<tbody>
			<c:forEach var="reqAttDetail" items="${detailRequestInfo}" varStatus="status">
			<tr>
				<td>${reqAttDetail.label}</td>
				<td>${reqAttDetail.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End Request Information  //// -->
	
	<!-- ////  Start Response Information  //// -->
	<table>
		<caption>
			<h2>Response Information</h2>
			<p>The response <strong>locale</strong> is 
				<strong><c:out value='${pageContext.response.locale}'/>.</strong></p>
			<%-- Use the response object to show whether the response
			has been committed --%>
			<p>The <strong>response
					<c:choose>
					<c:when test='${pageContext.response.committed}'>
					has
					</c:when>
					<c:otherwise>
					has not
					</c:otherwise>
					</c:choose>	 
			</strong> been committed.</p>
		</caption>
	</table>
	<!-- ////  End Response Information  //// -->
	<!-- ////  Start Servlet Init Params Information  //// -->
	<table>
		<caption><h2>Servlet Initialization Parameters</h2></caption>
		
		<c:choose>
		<c:when test="${not empty servletInitParams}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="servletParamItem" items="${servletInitParams}" varStatus="status">
			<tr>
				<td>${servletParamItem.label}</td>
				<td>${servletParamItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End Servlet Init Params Information  //// -->
	<!-- ////  Start Context Information  //// -->
	<table>
		<caption><h2>Context Attributes</h2></caption>
		
		<c:choose>
		<c:when test="${not empty contextAttributes}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="contextAtt" items="${contextAttributes}" varStatus="status">
			<tr>
				<td>${contextAtt.label}</td>
				<td>${contextAtt.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<tbody>
			<tr>
				<td colspan="2">No context information</td>
			</tr>
		</tbody>
		</c:otherwise>
		
		</c:choose>
		
	</table>
	<!-- ////  End Context Information  //// -->
	<!-- ////  Start Session Information  //// -->
	<table>
		<caption><h2>Session Information</h2>
			
			<p>Session ID: 
				<strong><c:out value='${pageContext.session.id}'/></strong></p>
			<p>Max Session Inactive Interval:<strong>
					<c:out	value='${pageContext.session.maxInactiveInterval}'/> 
			</strong>seconds.</p>
		</caption>
		<c:choose>
		<c:when test="${not empty sessionInfo}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="sessInfoItem" items="${sessionInfo}" varStatus="status">
			<tr>
				<td>${sessInfoItem.label}</td>
				<td>${sessInfoItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End Session Information  //// -->
	<!-- ////  Start Application Information  //// -->
	<table>
		<caption><h2>Application Information</h2>
			<%-- Store the servlet context in a page-scoped variable
			named app for better readability --%>
			<c:set var='app' value='${pageContext.servletContext}'/>
			<%-- Use the application object to show the major and minor 
			versions of the servlet API that the container supports --%>
			<p>Your servlet container supports version<strong> 
				<c:out	value='${app.majorVersion}.${app.minorVersion}'/></strong>
			of the servlet API.</p>
		</caption>
		<tbody>
			<tr>
				<td>Servlet Specification</td>
				<td>${servletSpec}</td>
			</tr>
			<tr>
				<td>JSP Specification</td>
				<td>${jspSpec}</td>
			</tr>
		</tbody>
	</table>
	<!-- ////  End Application Information  //// -->
	<!-- ////  Start JSTL Headers Information  //// -->
	<%-- Loop over the JSTL headerValues implicit object,
	which is a map --%>
	<table>
		<caption><h2>JSTL Header Values</h2></caption>
		<thead>
			<tr>
				<th>Name</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items='${headerValues}' var='hv' varStatus="status">
			<tr>		<%-- Display the key of the current item; that item
				is a Map.Entry --%>
				<td><c:out value='${hv.key}'/></td>
				<td>
					<%-- The value of the current item, which is
					accessed with the value method from 
					Map.Entry, is an array of strings 
					representing request header values, so
					we iterate over that array of strings --%>
					<c:forEach items='${hv.value}' var='value'>
					<p><c:out value='${value}'/></p>
					</c:forEach>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	<!-- ////  End JSTL Headers Information  //// -->
	<!-- ////  Start Header Information  //// -->
	<table>
		<caption><h2>Header Information</h2></caption>
		
		<c:choose>
		<c:when test="${not empty headers}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="headerItem" items="${headers}" varStatus="status">
			<tr>
				<td>${headerItem.label}</td>
				<td>${headerItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End Header Information  //// -->
	<!-- ////  Start Param Names Information  //// -->
	<table>
		<caption><h2>Param Names</h2></caption>
		
		<c:choose>
		<c:when test="${not empty paramNames}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="paramNamesItem" items="${paramNames}" varStatus="status">
			<tr>
				<td>${paramNamesItem.label}</td>
				<td>${paramNamesItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<tbody>
			<tr>
				<td colspan="2">No param name information</td>
			</tr>
		</tbody>
		</c:otherwise>
		
		</c:choose>
		
	</table>
	<!-- ////  End Param Names Information  //// -->
	<!-- ////  Start Cookie Information  //// -->
	<table>
		<caption><h2>Cookie Information</h2></caption>
		
		<c:choose>
		<c:when test="${not empty cookies}">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="cookiesItem" items="${cookies}" varStatus="status">
			<tr>
				<td>${cookiesItem.label}</td>
				<td>${cookiesItem.value}</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<tbody>
			<tr>
				<td colspan="2">No cookie information</td>
			</tr>
		</tbody>
		</c:otherwise>
		</c:choose>
		
	</table>
	<!-- ////  End Cookie Information  //// -->
</jax:mmhcpage>
