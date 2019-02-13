<%@ tag description="Jax tool page template" pageEncoding="UTF-8" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ attribute name="title" required="false" %>
<%@ attribute name="keywords" required="false" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="help" required="false" %>
<%@ attribute name="head" fragment="true" %>
<%@ attribute name="subnav" fragment="true" %>

<jax:toolpage title="${title}" keywords="${keywords}" description="${description}" defaultTitle="Mouse Models of Human Cancer Database"
	defaultKeywords="mtb, mmhc, mouse, tumor, biology, jax, lab, laboratory, jackson, mgi, genome, informatics"
	defaultDescription="MMHC has been designed to aid researchers in such areas as choosing experimental models, reviewing patterns of mutations in specific cancers, and identifying genes that are commonly mutated across a spectrum of cancers.">
	<jsp:attribute name="defaultHead">
		<link rel="icon" href="${applicationScope.urlImageDir}/favicon.ico" type="image/ico">
		<link rel="stylesheet" type="text/css" href="${applicationScope.urlStyleSheet}"/>
		<script type="text/javascript" src="${applicationScope.urlJavaScript}"></script>
		<jsp:invoke fragment="head" />
	</jsp:attribute>		
	<jsp:attribute name="header">
		<!-- To do: include tag manager -->
		<a href="${pageContext.request.contextPath}/index.do">
			<img src="${applicationScope.urlImageDir}/mmhc-logo.png" alt="Mouse Models of Human Cancer Database">
			<h3>Mouse&nbsp;Models<br>of&nbsp;Human&nbsp;Cancer<br>Database</h3>
		</a>
		<c:import url="/search/quick.jsp" />
		<ul>
			<li><a href="${pageContext.request.contextPath}/advancedSearch.do">Advanced Search</a></li>			
			<li class="dropdown"><span>Other Resources</span>
				<ul>	
					<li><a href="${pageContext.request.contextPath}/dynamicGrid.do">Tumor Frequency Grid</a></li>		
					<li><a href="${pageContext.request.contextPath}/immunohistochemistry.jsp">Immunohistochemistry</a></li>
					<li><a href="${pageContext.request.contextPath}/lymphomaPathology.jsp">Lymphoma Pathology</a></li>
				</ul>
			</li>	
			<li class="dropdown"><span>Searches/Tools</span>
				<ul>
					<li><a href="${pageContext.request.contextPath}/facetedSearch.do">Browse Data (Faceted)</a></li>
					<li><a href="${pageContext.request.contextPath}/advancedSearch.do">Advanced Search</a></li>
					<li><a href="${pageContext.request.contextPath}/tumorFrequencyGrid.do">Tumor Frequency Grid</a></li>
					<li><a href="${pageContext.request.contextPath}/pdxSearch.do">PDX Search (JAX)</a></li>	
					<li><a href="http://www.pdxfinder.org">PDX Finder (Global Search)</a></li>	
				</ul>
			</li>				
			
			<li class="dropdown"><span>About</span>
				<ul>
					<li><a href="${pageContext.request.contextPath}/">Database</a></li>
					<li><a href="${pageContext.request.contextPath}/">Publications</a></li>
					<li><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">Help</a></li>					
					<li><a href="${pageContext.request.contextPath}/whatsNew.jsp">What's New</a></li>
				</ul>
			</li>				
			
		</ul>
	</jsp:attribute>
	<jsp:attribute name="defaultSubnav">
		<c:if test="${not empty help}">
			<a class="help" href="${help}"></a>
		</c:if>
		<jsp:invoke fragment="subnav" />
	</jsp:attribute>
	<jsp:attribute name="footer">
		<ul>
			<li>
				<p>Part of</p>
				<a href="http://www.informatics.jax.org"><img src="/_res/img/mgi-logo.png" alt="Mouse Genome Informatics"></a>
			</li>
			<li>
				<p><a href="${applicationScope.urlBase}/citation.jsp">Citing These Resources</a></p>
				<p><a href="${applicationScope.urlBase}/funding.jsp">Funding Information</a></p>
				<p><a href="${applicationScope.urlBase}/copyright.jsp">Warranty Disclaimer &amp; Copyright Notice</a></p>
				<p>Send questions and comments to <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support</a>.</p>
			</li>
			<li>
				<h6>Last Software Update</h6>
				<p>2017-02-06 | version 3.0</p>
				<h6>Last Data Update</h6>
				<p>2017-02-06</p>
			</li>
		</ul>
	</jsp:attribute>		
	<jsp:body>
        <jsp:doBody/>
    </jsp:body>
</jax:toolpage>
