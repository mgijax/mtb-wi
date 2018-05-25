<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>

<jax:mmhcpage title="PDX Image Detail" help="imagedetail">

<table class="results">

<!-- ////  Start Detail Section  //// -->

<!-- ////  Start Pathology Image  //// -->

<tr class="stripe-1">
																<td colspan="2">
																		<div>

<img height=800 width=800 src="${applicationScope.pdxFileURL}${fileName}">

</div>
																</td>
														</tr>

<!-- ////  End Pathology Image  //// -->

<!-- ////  Start Pathology  //// -->

<tr class="stripe-1">
																<td class="cat-1">Description</td>
																<td>${description}</td>
														</tr>

<!-- ////  End Pathology  //// -->

</table>

</jax:mmhcpage>

