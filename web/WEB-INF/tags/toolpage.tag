<%@ tag description="Tool page template" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ attribute name="defaultTitle" required="true" %>
<%@ attribute name="defaultKeywords" required="true" %>
<%@ attribute name="defaultDescription" required="true" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="subtitle" required="false" %>
<%@ attribute name="keywords" required="false" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="defaultHead" fragment="true" %>
<%@ attribute name="header" fragment="true" %>
<%@ attribute name="defaultSubnav" fragment="true" %>
<%@ attribute name="footer" fragment="true" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<c:choose>
	<c:when test="${empty keywords}">
	<meta name="keywords" content="${defaultKeywords}">
	</c:when>
	<c:otherwise>
	<meta name="keywords" content="${keywords}">
	</c:otherwise>	 
	</c:choose>				
	<c:choose>
	<c:when test="${empty description}">
	<meta name="description" content="${defaultDescription}">
	</c:when>
	<c:otherwise>
	<meta name="description" content="${description}">
	</c:otherwise>	 
	</c:choose>				
	<c:choose>
	<c:when test="${empty title}">
	<title><c:out value="${defaultTitle}" escapeXml="false"/></title>
	</c:when>
	<c:otherwise>
	<title><c:out value="${title}" escapeXml="false"/></title>
	</c:otherwise>	 
	</c:choose>	
	<link rel="stylesheet" type="text/css" href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/_res/css/fonts.css"/>	
	<link rel="stylesheet" type="text/css" href="/_res/css/tool-base.css"/>
	<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
	<!--<script type="text/javascript" src="/_res/js/tool-base.js"></script> -->
	
	<jsp:invoke fragment="defaultHead" />
</head>

<body>
	<header>
		<nav class="container">
			<jsp:invoke fragment="header" />
		</nav>
	</header>
	<main>
		<header class="container">
			<h1>${title}<c:if test="${not empty subtitle}"><span>${subtitle}</span></c:if></h1>
			<jsp:invoke fragment="defaultSubnav" />
		</header>
		<jsp:doBody/>
	</main>
	<footer>
		<div class="container">
			<div>
				<div class="footer-logo">
					<p>Hosted by</p>
					<a href="https://www.jax.org">
						<img src="/_res/img/logo-mono.png" alt="The Jackson Laboratory">
					</a>
				</div>
				<jsp:invoke fragment="footer" />
			</div>
		</div>
	</footer>
	<script type="text/javascript" id="mod-loader">
        (function () {
            var i, l, u, s, c, modLoader, jp, cp,
                modLoader = document.getElementById('mod-loader'),
                docHead = document.getElementsByTagName('head')[0],
                jsPath = '/_res/js/',
                cssPath = '/_res/css/',
                sf = [],
                cf = [];

            if (typeof mods !== 'undefined' && Array.isArray(mods) && mods.length > 0) {
                u = {};
                for (i = 0, l = mods.length; i < l; i += 1) {	                
                    if (!u.hasOwnProperty(mods[i])) {
	                    if (/^[\.\/]/.test(mods[i])) {
		                    jp = '';
		                    cp = '';
		                } else {
			                jp = jsPath;
			                cp = cssPath;
		                }
		                if (/\.js$/.test(mods[i])) {
		                    sf.push(jp + mods[i]);
	                    } else if (/\.css$/.test(mods[i])) {
		                    cf.push(cp + mods[i]);
	                    } else {
		                    sf.push(jp + mods[i] + '.js');
		                    cf.push(cp + mods[i] + '.css');
	                    }
                        u[mods[i]] = 1;
                    }
                }
            }
            for (i = 0, l = sf.length; i < l; i += 1) {
                s = document.createElement('script');
                s.type = 'text/javascript';
                s.async = false;
                s.src = sf[i];
                modLoader.parentNode.insertBefore(s, modLoader);
            }
            for (i = 0, l = cf.length; i < l; i += 1) {
                c = document.createElement('link');
                c.type = 'text/css';
                c.rel = 'stylesheet';
                c.href = cf[i];
                docHead.appendChild(c);
            }
        })();
    </script>	
</body>
</html>
