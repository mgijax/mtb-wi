<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Cancer QTL Viewer" help="QTL">
	<jsp:attribute name="head">
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/JavaScriptFlashGateway.js"></script>
	<script type="text/javascript">
	var flashProxy = new FlashProxy("1234","${applicationScope.urlBase}/GViewer/javascript/JavaScriptFlashGateway.swf");
	function doHighlight1(action) {
		var newMessage = document.textform.messageText.value;
		if(action == 'set') {
			flashProxy.call('setHighlight', newMessage);
		}
		else {
			flashProxy.call('unsetHighlight', newMessage);
		}
	}
	function doHighlight2(action, featureName) {
		if(action == 'set') {
			flashProxy.call('setHighlight', featureName);
		}
		else {
			flashProxy.call('unsetHighlight', featureName);
		}
	}
	// Function to trigger the Flash method to get the annotation data
	function getAnnotationData() {
		flashProxy.call('getAnnotationData', 'html');
	}
	// Function called by flash to display the annotation data
	function displayAnnotationData(data) {
		var generator=window.open('','Annotation Data','height=400,width=600, resizable=1, scrollbars=1');
		generator.document.write('<title>Annotation Data</title>');
		generator.document.write('<link rel="stylesheet" href="style.css">');
		generator.document.write('
		');
		generator.document.write('<h3>GViewer Annotation Data</h3>');
		generator.document.write(data);
		generator.document.write('<p><a href="javascript:self.close()">Close</a> this window.</p>');
		generator.document.write('</jax:mmhcpage>');
		generator.document.close();
	}
	function showHTMLList(){
		document.forms[1].target="_blank";
		document.forms[1].qtlList.value="HTML";
		document.forms[1].submit();
		document.forms[1].qtlList.value="";
		document.forms[1].target="_self";
	}
	function showTabbedList(){
		document.forms[1].target="_blank";
		document.forms[1].qtlList.value="tabbed";
		document.forms[1].submit();
		document.forms[1].qtlList.value="";
		document.forms[1].target="_self";
	}
</script>
</jsp:attribute>
<jsp:body>
<table>
	<!-- ////  Start Detail Section  //// -->
	<%--			 <html:form action="gViewer" method="GET"> --%>
	<tr>
		<td colspan="2">
			<table width="560">
				<tr>
					<td colspan="2">
						<h3>Cancer and Tumorigenesis QTLs</h3>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<dl class="tip"><dt>
					Select QTL Type(s) to view</dt><dd>Select a type of QTL using a pick list. Ctrl+Click to select more than one.</dd></dl>:
					<!-- \n -->
					<%--						<html:select property="selectedQTLTypes" size="8" multiple="true">
					<html:option value="ALL">ALL</html:option>
					<html:options collection="qtlTypes" property="value" labelProperty="label"/> 
					</html:select> --%>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="hidden" name="qtlList" value="">
					<input type="submit" VALUE="View">
					<input type="submit" VALUE="Reset" name="reset">
					<input type="button" Value="List QTLs (HTML)" onClick="javascript:showHTMLList();">
					<input type="button" Value="List QTLs (Tab delimited)" onClick="javascript:showTabbedList();">					 
				</td>
			</tr>
			<tr>
				<td colspan="2">
					Click on the information icon below the chromosome figures for instructions on using the GViewer.
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td colspan="1">
					<p>
						<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="500" height="400" id="GViewer2" align="middle">
							<param name="allowScriptAccess" value="sameDomain" />
							<param name="movie" value="${applicationScope.urlBase}/GViewer/GViewer2.swf" />
							<param name="quality" value="high" />
							<param name="bgcolor" value="#FFFFFF" />
							<param name="FlashVars" value="&lcId=$1234&baseMapURL=${applicationScope.urlBase}/GViewer/data/mouse_ideo.xml&annotationXML=&dimmedChromosomeAlpha=40&bandDisplayColor=0x0099FF&wedgeDisplayColor=0xCC0000&browserURL=gViewer.do?${linkParam}name=&" />
							<embed src="${applicationScope.urlBase}/GViewer/GViewer2.swf" quality="high" bgcolor="#FFFFFF" width="500" height="400" name="GViewer2" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" FlashVars="&lcId=${uid}&baseMapURL=${applicationScope.urlBase}/GViewer/data/mouse_ideo.xml&annotationXML=${data}&dimmedChromosomeAlpha=40&bandDisplayColor=0x0099FF&wedgeDisplayColor=0xCC0000&browserURL=gViewer.do?${linkParam}name=&"	pluginspage="http://www.macromedia.com/go/getflashplayer" />			 
						</object>
					</td>
					<c:choose>
					<c:when test="${not empty legend}">
					<td>
						${legend}
					</td> 
					</c:when>
					</c:choose>
				</tr>
				<tr>
					<td colspan="2">Genome coordinates used for the mouse cancer QTL are from NCBI Build 37.
						<!-- \n -->
				GViewer software courtesy of <a href="http://rgd.mcw.edu/"RGD>RGD</a>.</td>
			</tr>
		</table>
	</td>
	<tr>
		<%--				</html:form> --%>
	</table>
	</jsp:body>
</jax:mmhcpage>

