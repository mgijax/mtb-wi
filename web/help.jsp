<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Help">

	<jsp:body>	
		<section class="container content">
			
			<ul>
                        <li>Have data on mouse models of human cancer you'd like to submit?
			<li>Can't find the mouse model you're looking for?
			<li>Found an error in our database?
			<li>Are we missing your publication on a mouse model of cancer?
			<li>Need a special database report?
			<li>Have a complaint or suggestion?
			</ul>

                        <p>Contact Us!
                        <p>MMHCdb On-line <a href ="${pageContext.request.contextPath}/userHelp.jsp"> User Documentation </a></p>
                        <p>User Support email:<a href="mailto:mgi-help@jax.org">mgi-help@jax.org</a></p>
                        <p><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support contact web form</a></p>
                        <p><b>Other helpful information</b></p>
			<p>Join mgi-list, the mouse genetics community forum. Learn more <a href="http://www.informatics.jax.org/mgihome/lists/lists.shtml">here</a>.</p>
			
                        <p><a href="${pageContext.request.contextPath}/citation.jsp">How to cite MMHCdb</a></p>
                        
                        <p>MMHCdb Web Interface:<a href="https://www.github.com/mgijax/mtb-wi">https://www.github.com/mgijax/mtb-wi</a></p>
                        <p>MMHCdb Data Layer:<a href="https://www.github.com/mgijax/mtb-dao">https://www.github.com/mgijax/mtb-dao</a></p>
                        <p>MMHCdb Web interface:<a href="https://www.github.com/PDXFinder/pdxfinder">https://www.github.com/PDXFinder/pdxfinder</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
