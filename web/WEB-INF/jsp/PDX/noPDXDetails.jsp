<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 

<jax:mmhcpage title="No matching PDX models" help="pdxsearch">

<c:import url="../../../pdxToolBar.jsp" />

<h1>There is no available PDX model with ID <em>${modelID}</em></h1>

<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">

</jax:mmhcpage>

