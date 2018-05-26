<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="PDX Image Detail" help="imagedetail">
	<table class="results">
		<tr>
			<td colspan="2">
				<div>
					<img height=800 width=800 src="${applicationScope.pdxFileURL}${fileName}">
				</div>
			</td>
		</tr>
		<tr>
			<td><h4>Description</h4></td>
			<td>${description}</td>
		</tr>
	</table>
</jax:mmhcpage>

