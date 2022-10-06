<%@ tag description="Jax tool page template" pageEncoding="UTF-8" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ attribute name="title" required="false" %>
<%@ attribute name="subtitle" required="false" %>
<%@ attribute name="keywords" required="false" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="help" required="false" %>
<%@ attribute name="head" fragment="true" %>
<%@ attribute name="subnav" fragment="true" %>

<jax:toolpage title="${title}" subtitle="${subtitle}" keywords="${keywords}" description="${description}" defaultTitle="Mouse Models of Human Cancer Database"
	defaultKeywords="mtb, mmhc, mouse, tumor, biology, jax, lab, laboratory, jackson, mgi, genome, informatics"
	defaultDescription="MMHCdb has been designed to aid researchers in such areas as choosing experimental models, reviewing patterns of mutations in specific cancers, and identifying genes that are commonly mutated across a spectrum of cancers.">
	<jsp:attribute name="defaultHead">
		<link rel="shortcut icon" href="${applicationScope.urlImageDir}/favicon.ico" type="image/ico">
		<link rel="icon" type="image/png" sizes="32x32" href="${applicationScope.urlImageDir}/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="${applicationScope.urlImageDir}/favicon-16x16.png">
		<link rel="stylesheet" type="text/css" href="${applicationScope.urlStyleSheet}"/>
		<script type="text/javascript" src="${applicationScope.urlJavaScript}"></script>
                <script type="text/javascript">
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
				(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m
			)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		ga('create', '${applicationScope.googleID}', 'auto');
		ga('send', 'pageview');
                    
                </script>
                
                <!-- Google tag (gtag.js) -->
                <script async src="https://www.googletagmanager.com/gtag/js?id=G-XH2N5PQ3DT"></script>
                <script>
                  window.dataLayer = window.dataLayer || [];
                  function gtag(){dataLayer.push(arguments);}
                  gtag('js', new Date());

                  gtag('config', 'G-XH2N5PQ3DT');
                </script>

                
                
		<jsp:invoke fragment="head" />
	</jsp:attribute>		
	<jsp:attribute name="header">
		<!-- To do: include tag manager -->
		<a href="${pageContext.request.contextPath}/index.do">
			<img src="${applicationScope.urlImageDir}/mmhc-logo.png" alt="Mouse Models of Human Cancer Database">
		</a>
		<div id="search">
			<input id="search-term" type="text" placeholder="Quick search">
			<a id="submit-search">&#xf002;</a>
		</div>
		<ul>
			<li><a href="${pageContext.request.contextPath}/facetedSearch.do">Advanced Search</a></li>			
			<li class="dropdown"><span>Other Resources</span>
				<ul>		
					<li><a href="${pageContext.request.contextPath}/antibody.jsp">Antibody Staining Report</a></li>
					<li><a href="${pageContext.request.contextPath}/lymphoma.jsp">Lymphoma Pathology Report</a></li>
				</ul>
			</li>	
			<li class="dropdown"><span>Searches/Tools</span>
				<ul>
					<li><a href="${pageContext.request.contextPath}/dynamicGrid.do">Tumor Frequency Grid (inbred strains)</a></li>
					<li><a href="${pageContext.request.contextPath}/pdxSearch.do">Patient Derived Xenograft (PDX) Search</a></li>
					<li><a href="${pageContext.request.contextPath}/pdxLikeMe.do">PDX Like Me</a></li>
                                        
                                         <c:if test="${applicationScope.publicDeployment == false }">
                                            <li><a href="${pageContext.request.contextPath}/pdxComparison.do">PDX Comparison</a>
                                        </c:if>    
                                        
					<li><a class="link-external" href="http://www.pdxfinder.org" target="_new">PDX Finder</a></li>	
                                        
                                         <c:if test="${applicationScope.publicDeployment == false &&  empty sessionScope.pdxUser }">
                                            <li><a href="${pageContext.request.contextPath}/pdxLogin.do">PDX Login</a>
                                        </c:if>    
                                                
                                        <c:if test="${not empty sessionScope.pdxUser}"> 
                                            <li><a href="pdxDashboard.do">PDX Dashboard</a></li>
                                            <li><a href="pdxLogin.do?logout=true">PDX Logout</a></li>

                                        </c:if>    
                                        
                                        
				</ul>
			</li>				
			
			<li class="dropdown"><span>About</span>
				<ul>
					<li><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></li>
					<li><a href="${pageContext.request.contextPath}/publications.jsp">Publications</a></li>
					<li><a href="${pageContext.request.contextPath}/help.jsp">Help</a></li>					
					<li><a href="${pageContext.request.contextPath}/news-events.jsp">News &amp; Events</a></li>
				</ul>
			</li>				
			
		</ul>
	</jsp:attribute>
	<jsp:attribute name="defaultSubnav">
		<div id="subnav">
			<c:if test="${not empty help}">
				<a class="help" href="${help}">Help</a>
			</c:if>
			<jsp:invoke fragment="subnav" />
		</div>
	</jsp:attribute>
	<jsp:attribute name="footer">

				<div class="footer-logo">				
					<p>Part of Mouse&nbsp;Genome&nbsp;Informatics</p>
					<a href="http://www.informatics.jax.org" style="top:-10px;"><img src="/_res/img/mgi-logo-2.png" alt="Mouse Genome Informatics" style="max-width:170px;"></a>
				</div>
		
				<div>
					<p><a href="${pageContext.request.contextPath}/citation.jsp">Citing This Resource</a></p>
					<p><a href="${pageContext.request.contextPath}/funding.jsp">Funding Information</a></p>
					<p><a href="${pageContext.request.contextPath}/copyright.jsp">Warranty Disclaimer &amp; Copyright Notice</a></p>
					<p>Send questions and comments to <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">MGI User Support</a>.</p>
				</div>
		
				<div>				
					<h6>Last Software Update</h6>
					<p>2020-07-17 | version ${applicationScope.wiVersion}</p>
					<h6>Last Data Update</h6>
					<p>${applicationScope.dbLastUpdateDate}</p>
				</div>

	</jsp:attribute>		
	<jsp:body>
        <jsp:doBody/>
    </jsp:body>
</jax:toolpage>
