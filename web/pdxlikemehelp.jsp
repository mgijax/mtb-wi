<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Using PDX Like Me">
<jsp:attribute name="head">
<style>
	#keyword {
	border-collapse: collapse;
	border: 1px;
	padding: 5px;
	}
	#keywords tr:nth-child(even){background-color: #D0E0F0;}
	#keywords tr:nth-child(odd){background-color: #DFEFFF;}
	#keywords th{
	background-color: blue;
	color: white;
	}
	#keywords td{
	padding:5px;
	}
	
</style>
</jsp:attribute>
<jsp:body>	
		<section class="container content">

	
	<h3>Introduction:</h3>
	
	PDX Like Me uses a search language similar to cBioPortal's <a href="https://www.cbioportal.org/oql" target="_blank">Onco Query Language</a> to find PDX tumors that match user specified molecular profiles. The profiles can include mutation, expression, and/or copy number aberration criteria.
	
	<br>
	<ul>
		<li>The input must start with the word CASE followed by and unique identifier.</li>
		<li>Following the line for the case, include one or more lines of search criteria using the format &lt;GeneSymbol&gt;:&lt;search parameter&gt;.</li>
		<li>One criterion per line.</li>
		<li>Gene symbols must conform to official HUGO Gene Nomenclature <a href="https://www.genenames.org/" target="_blank">(HGNC)</a>.</li>
		<li>More than one CASE can be submitted at one time.</li>
		<li>Criteria are combined using 'OR'.</li>
	</ul>
	
	<table> 
		<tr>
			<td><h3>Example:</h3></td><td></td>
		</tr>
		
		<tr><td>CASE 1</td><td></td></tr>
		<tr><td>
			<table>
				<tr><td>KRAS:Amp</td></tr>
				<tr><td>TP53:MUT=A159V</td></tr>
				<tr><td>ALB:DEL</td></tr>
				<tr><td>KIT:EXP&gt;2.5</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>CASE 2</td></tr>
				<tr><td>CDK4:AMP</td></tr>
				<tr><td>ETNK1:GOF</td></tr>
				<tr><td>KRAS:NOCNV</td></tr>
				<tr><td>KRAS:MUT</td></tr>
			</table>
			</td>
			<td>
				<table>
					<tr><td>search for models with amplified KRAS</td></tr>
					<tr><td>search for models with A159V variant of TP53</td></tr>
					<tr><td>search for models with deleted ALB</td></tr>
					<tr><td>search for models with high expression levels of KIT</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
	</table>
			
	<h3>Keywords:</h3>
	<table id="keywords">
		<tr><th>Data Type</th><th>Parameters</th><th>Notes</th></tr>
		<tr><td>Mutations</td><td>MUT<br>MUT=&lt;protein change&gt;</td><td>MUT will return all protein changes<br>MUT=&lt;protein change&gt; will return the specific protein change</td></tr>
		<tr><td>Copy Number Alterations</td><td>AMP<br>DEL<br>NOCNV</td><td>LRP:Log Ratio Ploidy = log2(raw copy number / ploidy)<br>AMP is when LRP is greater than 0.5<br>DEL is when LRP is less than -0.5<br>NOCNV is for LRP values greater than -0.5 and less than 0.5</td></tr>
		<tr><td>Expression</td><td>EXP &gt; #<br> EXP &lt; #</td><td> # can be a positive or negative integer or decimal value for Z score percentile rank</td></tr>
		<tr><td>Functional consequence</td><td>GOF<br>LOF<br>UNK<br>NONE</td><td>GOF = Gain of function <br> LOF = Loss of function<br>UNK = Unknown functional mutation<br>NONE = No functional mutation<br>Functional consequence annotations are derived from the JAX Clinical Knowledgebase <a href="https://ckb.jax.org" target="_blank">(CKB)</a></td></tr>
	</table>
	
	<h3>Example Search Results:</h3>
	Search results are returned as one table per case. Rows correspond to matching models and columns to search criteria. An <b>X</b> in a cell indicates the model matches the criteria.<br>
	Rows are sorted with the most matches first then by model ID. If selected, CNV and expression values are only shown when matching, clinically relevant variants are shown for all genes where applicable.
	<br>
	<b>CASE 1</b>
	
	<table border="1" style="border-collapse:collapse">
		<tr><td>Model ID</td><td style="text-align:center;padding:5px">KRAS Amp</td><td style="text-align:center;padding:5px">TP53 MUT=A159V</td><td style="text-align:center;padding:5px">ALB Del</td><td style="text-align:center;padding:5px">KIT EXP>1.5</td>
		<tr><td><a href="pdxDetails.do?modelID=TM00098">TM00098</a><br>invasive ductal carcinoma:Breast</td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = 0.65</td><td style="text-align:center"><br>Clinically relevant TP53 variant<br>P72R<br>Effect: unknown<br> </td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = -1.16</td><td style="text-align:center"><b>X</b><br>Z score percentile rank = 1.89</td></tr>
		<tr style="background-color:#eff0f1"><td><a href="pdxDetails.do?modelID=TM00231">TM00231</a><br>lung squamous cell carcinoma:Lung</td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = 1.86<br>Clinically relevant KRAS variant<br>G12C<br>Effect: loss of function<br>Treatment Approach: MEK inhibitor (Pan),MEK1 Inhibitor </td><td style="text-align:center"><br>Clinically relevant TP53 variant<br>P72R<br>Effect: unknown<br> </td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = -1.5</td><td style="text-align:center"><br>Clinically relevant KIT variant<br>M541L<br>Effect: unknown<br> </td></tr>
		<tr><td><a href="pdxDetails.do?modelID=TM01517">TM01517</a><br>adenocarcinoma:Rectum</td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = 0.64<br>Clinically relevant KRAS variant<br>G12C<br>Effect: loss of function<br>Treatment Approach: MEK inhibitor (Pan),MEK1 Inhibitor,MEK2 Inhibitor,PI3K Inhibitor (Pan)</td><td style="text-align:center"><br>Clinically relevant TP53 variant<br>E286K<br>Effect: loss of function - predicted<br>Treatment Approach: p53 Activator,p53 Gene Therapy<br> </td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = -0.57</td><td style="text-align:center"><br>Clinically relevant KIT variant<br>V530I<br>Effect: gain of function<br>Treatment Approach: KIT Inhibitor<br> </td></tr>
		<tr style="background-color:#eff0f1"><td><a href="pdxDetails.do?modelID=J000094707">J000094707</a><br>rectum adenocarcinoma:Rectum</td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = 0.79<br>Clinically relevant KRAS variant<br>Q61H<br>Effect: loss of function<br>Treatment Approach:PI3K Inhibitor (Pan),PIK3CA inhibitor,RAS Inhibitor (Pan),AZD4785<br> </td><td style="text-align:center"><br>Clinically relevant TP53 variant<br>P72R<br>Effect: unknown<br> </td><td style="text-align:center"><b>X</b><br>Log ratio ploidy = -0.93</td><td style="text-align:center"></td></tr>
		
	</table>
	
	
	
	<h3>Visualization Results</h3>
	The same results are displayed as a regular search but formatted differently.<br>
	Rows display search criteria, columns correspond to matching models.<br>
	If multiple cases are used each is displayed in its own tab. Select the tab to see the case results.<br>
	Columns can be reordered. Click and hold on the model name, drag to move, click to drop.<br>
	Clicking on model names will link to PDX details page for selected model.<br>
	If displaying actionable variants, results with an "x" have actionable variants and details will be displayed on mouse-over.<br>
	In some cases the tables may render such that the column headers don't align with the rest of the table, usually resizing the browser window width by a small amount will resolve this.
	<a id="vis"></a>
		</section>
		</jsp:body>
</jax:mmhcpage>
		
