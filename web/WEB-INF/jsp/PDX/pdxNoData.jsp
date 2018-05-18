<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<html>
		<head>
		<c:import url="../../../meta.jsp">
				<c:param name="pageTitle" value="No PDX Data"/>
		</c:import>

</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>The PDX data is not currently available.</h1>
	<a class="help" href="userHelp.jsp#pdxdetails"></a>
</header>
<table >

										<tr class="summary">
												<td colspan="11">

														<table>

																<tr>
																		<td>
																				The PDX data is not currently available, please try again soon.

																		</td>
																</tr>
														</table>
												</td>
										</tr>
								</table>
</section>
</div>
</body>
								</html> 

