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

<jax:toolpage title="${title}" keywords="${keywords}" description="${description}" defaultTitle="Mouse Models of Human Cancer"
	defaultKeywords="mtb, mmhc, mouse, tumor, biology, jax, lab, laboratory, jackson, mgi, genome, informatics"
	defaultDescription="MMHC has been designed to aid researchers in such areas as choosing experimental models, reviewing patterns of mutations in specific cancers, and identifying genes that are commonly mutated across a spectrum of cancers.">
	<jsp:attribute name="defaultHead">
		<link rel="icon" href="${applicationScope.urlImageDir}/favicon.ico" type="image/ico">
		<link href="${applicationScope.urlStyleSheet}" rel="stylesheet" type="text/css"/>
		<script type="text/javascript" src="${applicationScope.urlBase}/js/jquery.min.js"></script>
		<script type="text/javascript" src="${applicationScope.urlJavaScript}"></script>
		<jsp:invoke fragment="head" />
	</jsp:attribute>		
	<jsp:attribute name="header">
		<!-- To do: include tag manager -->
		<a href="${pageContext.request.contextPath}/index.do">
			<img src="${applicationScope.urlImageDir}/mmhc-logo.png" alt="Mouse Models of Human Cancer">
			<h3>Mouse&nbsp;Models<br>of&nbsp;Human&nbsp;Cancer</h3>
		</a>
		<c:import url="/quick-search.jsp" />
		<ul>
			<li class="dropdown"><span>Advanced Search</span>
				<ul>
					<li><a>Tumor</a></li>
					<li><a>Strain</a></li>
					<li><a>Genetics</a></li>
					<li><a>Pathology Images</a></li>
					<li><a>Reference</a></li>
					<li><a>Tumor + Strain + Genetics</a></li>
					<li><a>Human Genes</a></li>
					<li><a>Gene Expression</a></li>
				</ul>
			</li>
			<li><a>Faceted Tumor Search</a></li>
			<li><a>PDX Model Search</a></li>						
			<li class="dropdown"><a>PDX Tools</a>
				<ul>
					<li><a>PDX Comparison</a></li>
					<li><a>PDX Genomics Dashboard</a></li>
					<li><a>PDX Sample Name Lookup</a></li>
					<li><a>PDX Sample Sheet Generator</a></li>
				</ul>
			</li>
			<li class="dropdown"><span>Additional Resources</span>
				<ul>
					<li><a>Cancer QTL Viewer</a></li>
					<li><a>Tumor Frequency Grid</a></li>
					<li><a>Dynamic Tumor Frequency Grid</a></li>					
					<li><a>Immunohistochemistry</a></li>
					<li><a>Lymphoma Pathology</a></li>
					<li><a>Cancer Web Resources</a></li>
				</ul>
			</li>	
		</ul>
	</jsp:attribute>
	<jsp:attribute name="sectionHeader">
		<c:choose>
		<c:when test="${not empty help}">
			<a class="help" href="${help}"></a>
		</c:when>
		</c:choose>
	</jsp:attribute>
	<jsp:attribute name="footer">
		<ul>
			<li><a href="http://www.informatics.jax.org"><img src="${applicationScope.urlImageDir}/mgi-logo.png" alt="Mouse Genome Informatics"></a></li>
			<li>
				<p><a href="${applicationScope.urlBase}/citation.jsp">Citing These Resources</a></p>
				<p><a href="${applicationScope.urlBase}/copyright.jsp">Warranty Disclaimer &amp; Copyright Notice</a></p>
				<p>Send questions and comments to <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support</a>.</p>
			</li>
			<li>
				<h6>Last Database Update:</h6>
				<p>2017-02-06</p>
				<p>MTB 3.0</p>
			</li>
		</ul>
	</jsp:attribute>		
	<jsp:body>
        <jsp:doBody/>
    </jsp:body>

</jax:toolpage>




