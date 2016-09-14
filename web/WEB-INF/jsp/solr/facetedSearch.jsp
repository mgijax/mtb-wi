<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" session="false"%>



<html>

  
    
<head>
   <title>MTB Faceted Search</title>
   
<style type="text/css">

.filter{
 color: red;
 width: 300px;}

.facet{
 margin-left: 5px;
 white-space: nowrap;}

.facetBox{
 width: 300px;}

.facetList{
 height: 150px; 
 width: 300px; 
 overflow:auto; 
 border: 1px solid black;
 margin: 0px;
 padding: 0px;}

.facetLabel{
 font-weight: bold;
 float:left;}

.moreFacets{
 float: right;
 color: blue;}

.clear{
 clear:both;}

.type{
 font-size: 0.8em;
 font-style: italic;}

th{
    font-size: 12px;
    font-family: Arial,Helvetica;
    vertical-align: middle;
    color: #000001;
    background-color: #D0E0F0;
    font-weight: bold;
    text-align: center; }


td{
    font-family: Verdana,Arial,Helvetica;
    font-size: 12px; }

td.high{
    color: white;
    background-image: url(${applicationScope.urlImageDir}/high.png);}

td.veryhigh{
    color: white;
    background-image: url(${applicationScope.urlImageDir}/veryhigh.png);}

td.moderate{
    background-image: url(${applicationScope.urlImageDir}/moderate.png);}

td.low{
    background-image: url(${applicationScope.urlImageDir}/low.png);}

td.verylow{
    background-image: url(${applicationScope.urlImageDir}/verylow.png);}

td.observed{
    background-image: url(${applicationScope.urlImageDir}/observed.png);}

img{
    vertical-align: middle; }

</style>

<script type="text/javascript">

var  rsp;
var  f_field=['organParent','agentType','tcParent','strainType','metsTo','tumorMarker','strainMarker'];
var  f_field_display=['Organ of Origin','Agent Type','Tumor Classification','Strain Type','Mets. To','Tumor Marker','Strain Marker'];
var  sortCols = ['organOrigin','organAffected','strain','freqNum'];
var  filters =[];
var  displayFilters=[];
var  url = "/mtbwi/solrQuery.do";
var  resLimit = 30;
var  facetLimit = 25;
var  fs = 0;
var  facetSortParam = ["count","index"];
var  facetSortDisp = ["term","count"];
var  start = 0;
var  sort = "tcParent";
var  ad = 0;
var  ascdesc=["asc","desc"];
// false means don't require images
var  assayImages = false;
var  pathologyImages = false;
var  untreated = false;
var  metastatic = false;
var  geneExpression = false;
// runs in mtb
var  mtbURL = "";

// derived from http://www.degraeve.com/reference/simple-ajax-example.php

function xmlhttpPost() {
    var xmlHttpReq = false;
    var self = this;
    if (window.XMLHttpRequest) { // Mozilla/Safari
        self.xmlHttpReq = new XMLHttpRequest(); 
    }
    else if (window.ActiveXObject) { // IE
        self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
    self.xmlHttpReq.open('POST', url , true);
    self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    self.xmlHttpReq.onreadystatechange = function() {
        if (self.xmlHttpReq.readyState == 4) {
            updatepage(self.xmlHttpReq.responseText);
        }
    }

    var params = getStandardArgs().concat(getQueryString());
    var strData = params.join('&');
    self.xmlHttpReq.send(strData);
}

function getStandardArgs() {
    var params = [
        'wt=json'
        , 'indent=on'
        , 'facet=true'
        , 'facet.field=organParent'
        , 'facet.field=agentType'
        , 'facet.field=tcParent'
        , 'facet.field=strainType'
        , 'facet.field=metsTo'
        , 'facet.field=tumorMarker'
        , 'facet.field=strainMarker'
        , 'facet.limit='+facetLimit
        , 'facet.sort='+facetSortParam[fs]
        , 'facet.mincount=1'
        , 'sort='+sort+'%20'+ascdesc[ad]
        , 'q=*:*'
        , 'rows='+resLimit
        , 'start='+start
        ];

    return params;
}

function getQueryString() {
  var query="";
  for(var i=0;i<filters.length;i++){
   query +="&fq="+myEscape(filters[i]);
  }
  if(assayImages){
   query += "&fq=assayImages:[* TO *]";
  }
  if(pathologyImages){
   query += "&fq=pathologyImages:[* TO *]";
  }
  if(untreated){
   query += "&fq=-agent:[* TO *]";
  }
  if(metastatic){
   query += "&fq=metastatic:true";
  }
  if(geneExpression){
   query += "&fq=geneExpression:true";
  }
  
  // remove the first & it will be added by join
  return query.substring(1);
  
}

function myEscape(filter){
  var parts = filter.split("=");
  var vals =parts[1].split(" ");

  if(vals.length > 1){
    parts[1] = '"'+vals.join("+")+'"';
  }
  return escape(parts[0]+":"+parts[1]);
}

function facetSearch(f,i){
  var type = f_field[f];
  var fDisplay = f_field_display[f];
  var val = rsp.facet_counts.facet_fields[type][--i];
  filters.push(type+"="+val);
  displayFilters.push(fDisplay+'='+val);
  start = 0;
  xmlhttpPost();
}

function showFilters(){
  document.getElementById("filters").innerHTML="";
  for(var i=0; i< displayFilters.length; i++){
    document.getElementById("filters").innerHTML += 
      "<span>"+displayFilters[i]+"&nbsp;&nbsp;<span class='filter' onclick='removeFilter("+i+")'>&nbsp;<a href='#'>x</a>&nbsp;</span></span><br>";
  }
}

function facetSort(){
 fs =(fs+1)%2;
 xmlhttpPost();
}


function showFacetCount(){
 if(facetLimit < 0){
   document.getElementById("facetCount").innerHTML =
     "Displaying <b>all</b> facets. <span onClick='moreFacets();'> Reset to <a href='#'>25</a></span>.<br>";
 }else{
    document.getElementById("facetCount").innerHTML =
     "Dispalying up to <span onclick='moreFacets();'><a href='#'><b>"+facetLimit+"</b></a></span> facets per category.<br>";
 }
 document.getElementById("facetCount").innerHTML += 
      "<span onclick='facetSort();'>Facets sorted by "+facetSortDisp[(fs+1)%2]+". (<a href='#'>Sort by <b>"+facetSortDisp[fs]+"</b></a>)</span>.";
}

function removeFilter(i){
  filters.splice(i,1);
  displayFilters.splice(i,1);
  start = 0;
  xmlhttpPost();
}

// this function does all the work of parsing the solr response and updating the page.
function updatepage(str){
  showFilters();
  showFacetCount();
  //document.getElementById("raw").innerHTML = str;
  rsp = eval("("+str+")"); // use eval to parse Solr's JSON response
  //var html= "<br>numFound=" + rsp.response.numFound;
  for(var f = 0; f < f_field.length; f++){
    var html = "";
    for(var i = 0; i < rsp.facet_counts.facet_fields[f_field[f]].length; i++){
      var type = rsp.facet_counts.facet_fields[f_field[f]][i++];
      var val = rsp.facet_counts.facet_fields[f_field[f]][i]; 
      if(val != 0){
        html += "<span class='facet' onclick='facetSearch("+f+","+i+")'><a href='#'>"+type+"&nbsp;("+val+")</a></span><br>";
      }
    } 
  document.getElementById(f_field[f]).innerHTML=html;

  showResults();

 }
}

function colSort(col){
 if(sort == sortCols[col]){

   ad = (ad+1)%2;
 }
 sort = sortCols[col];
 xmlhttpPost();
}

function getSortImage(col){
  if(sort == sortCols[col]){
    if(ad == 1){
      return "${applicationScope.urlImageDir}/sortableDown.gif";
    }else{
      return "${applicationScope.urlImageDir}/sortableUp.gif";
    }
  }else{
    return "${applicationScope.urlImageDir}/sortable.gif";
  }
}

function showResults(){
  var resCount = rsp.response.numFound;
  var html = "<div style='text-align: center;'>";
  if(resCount <= resLimit){
    html += "Displaying all "+resCount+" results<br>";
  }else{
    if(start > 0){
      html += "<span class='moreResults' onClick='lessResults()'><a href='#'><--</a>&nbsp;</span>";
    }
    to = start + resLimit;
    if(to > resCount){
        to = resCount;
    }
    html += "Displaying "+(start+1)+" to " +to+" of "+resCount+" results &nbsp;";
    if(start + resLimit < resCount){
        html += "<span class='moreResults' onClick='moreResults("+resCount+")'><a href='#'>--></a></span></br>";
    }
  }
  html += "</div><br><table style='border-collapse: collapse;' border='1' cellpadding='5'><tr>";
  html += "<th onclick='colSort(0)' rowspan='2'>Tumor Name <img src='"+getSortImage(0)+"'></th>";
  html += "<th width='120' onclick='colSort(1)' rowspan='2'>Organ Affected <img src='"+getSortImage(1)+"'></th>";
  html += "<th rowspan='2'>Treatment Type<br><span class='type'>Agents</span></th>";
  html += "<th onclick='colSort(2)' rowspan='2'>Strain Name <img src='"+getSortImage(2)+"'><br><span class='type'>Strain Types</span></th>";
  html += "<th colspan='4' onclick='colSort(3)'>Frequency <img src='"+getSortImage(3)+"'></th><th rowspan='2'>Metastasizes<br>To</th>";
  html += "<th rowspan='2'>Additional Info.</th><th rowspan='2'>Tumor<br>Summary</th></tr>";
  html += "<tr><th width='40'>F</th><th width='40'>M</th><th width='40'>Mixed</th><th width='40'>Un.</th></tr>";
  for(var i=0; i < rsp.response.docs.length; i++){
     var doc = rsp.response.docs[i];
     html += "<tr>";
     html += "<td>"+doc.organOrigin+" "+doc.tumorClassification+"</td>";
     html += "<td>"+doc.organAffected+"</td>";
     if(doc.hasOwnProperty("agentType")){
       html += "<td>";
       for(var j=0; j < doc.agentType.length; j++){
         html += doc.agentType[j]+"<br>";
       }
       if(doc.hasOwnProperty("agent")){
         for(var j=0; j < doc.agent.length; j++){
           html +="<span class='type'>"+ doc.agent[j]+"</span><br>";
         }
       }
       html +="</td>";
     }else{
       html += "<td></td>"; 
     }
     html += "<td>"+doc.strain+"<br>";
     for(var j=0; j < doc.strainType.length; j++){
       html += "<span class='type'>"+doc.strainType[j]+"</span><br>";
     }

     html += "</td>";
     html += freqsToString(doc);
     if(doc.hasOwnProperty("metsTo")){
      html += "<td>";
      for(var j=0; j < doc.metsTo.length; j++){
        html += doc.metsTo[j]+"<br>";
      }
      html += "</td>";
     }else{
      html += "<td></td>";
     }
     html += "<td>"
     if(doc.hasOwnProperty("reference")){
        if(doc.reference.length == 1){
           html += "1 Reference<br>";
        }else{
           html += doc.reference.length+" References<br>";
        }
     }
     if(doc.hasOwnProperty("pathologyImages")){
        html +=doc.pathologyImages+" Pathology Image(s)<br>";
     }
     if(doc.hasOwnProperty("assayImages")){
        html += doc.assayImages+" Assay Image(s)";
     }
     html += "<td><a target='_blank' href='"+mtbURL+"tumorSummary.do?tumorFrequencyKeys="
     for(var j=0; j < doc.tumorFrequencyKey.length; j++){
       if(j>0){
        html +=",";
       }
       html += doc.tumorFrequencyKey[j];
     }
     html += "'>Summary</a></td></tr>"
  }
  document.getElementById("results").innerHTML=html;

}

function getFeqStyle(freqStr){
  var strRet = "";
  freqStr = freqStr.replace("=","");
  var parts = freqStr.split(/-|~|>|</);
  if(parts.length > 1){
    freqStr = parts[1];
  }
  try{
      freqStr = freqStr.trim();
  }catch(e){
      // ie 8
      freqStr = freqStr.replace(/ /g,'');
  }
 var freq = parseFloat(freqStr);

 if(freqStr == "very high"){
   strRet = "veryhigh";
 }else if(freqStr == "high"){
   strRet = "high";
 }else if(freqStr == "moderate"){
   strRet = "moderate";
 }else if(freqStr == "low"){
   strRet = "low";
 }else if(freqStr == "very low"){
   strRet = "verylow";
 }else if(freqStr == "observed"){
   strRet = "observed";
 }else if(freq > 80.0){ 
   strRet = "veryhigh";
 }else if (freq > 50.0){
   strRet = "high";
 }else if (freq > 20.0){
   strRet = "moderate";
 }else if (freq > 10.0){
   strRet = "low";
 }else if (freq > 0.10){
   strRet = "verylow";
 }else if (freq > 0){
   strRet = "observed";
 }else{
   strRet = "";
 }
 return strRet
}

function freqsToString(doc){
  var str;
  if(doc.hasOwnProperty("freqF")){
   str = "<td class='"+getFeqStyle(doc.freqF)+"'>";
   str += doc.freqF
   
  }else{
   str = "<td>&nbsp;";
  }
  str +="</td>";
  if(doc.hasOwnProperty("freqM")){
   str += "<td class='"+getFeqStyle(doc.freqM)+"'>";
   str += doc.freqM;
  }else{
   str += "<td>&nbsp;";
  }
  str +="</td>";
  if(doc.hasOwnProperty("freqX")){
   str += "<td class='"+getFeqStyle(doc.freqX)+"'>";
   str += doc.freqX;
  }else{
   str += "<td>&nbsp;";
  }
  str +="</td>";
  if(doc.hasOwnProperty("freqU")){
   str += "<td class='"+getFeqStyle(doc.freqU)+"'>";
   str += doc.freqU;
  }else{
   str += "<td>&nbsp;";
  }
  str +="</td>";
 return str;
}

function moreFacets(){
  if(facetLimit < 25){
    facetLimit = 25;
  }else{
   facetLimit += 25;
  }
  if(facetLimit > 100){
   facetLimit = -1;
  }
  xmlhttpPost();
}

function moreResults(max){
  start += resLimit;
  if(start >= max - resLimit){
  //  start = max - resLimit;
  }
  xmlhttpPost();
}

function lessResults(){
  start -= resLimit;
  if(start<0){
   start = 0;
  }
  xmlhttpPost();
}

function pathologyImagesCB(){
  pathologyImages = document.getElementById("pathologyImages").checked;
  xmlhttpPost();
}
function assayImagesCB(){
  assayImages = document.getElementById("assayImages").checked;
  xmlhttpPost();
}
function untreatedCB(){
  untreated = document.getElementById("unTreated").checked;
  xmlhttpPost();
}
function metastaticCB(){
  metastatic = document.getElementById("metastatic").checked;
  xmlhttpPost();
}
function geneExpressionCB(){
  geneExpression = document.getElementById("geneExpression").checked;
  xmlhttpPost();
}
</script>
</head>

<body onload="xmlhttpPost()">
<table>
    
<tr>
<td valign="top">
    <table width="100%">
        <tr>
            <td align="center">
                <a href="index.do"><img src="${applicationScope.urlImageDir}/mtb_logo_side.png" border=0 alt="Mouse Tumor Biology Database (MTB)"></a>
            </td>
        </tr>
    </table>
    <br>
        
  <b>Filters:</b><br>
  <input type="checkbox" id="pathologyImages" onClick="pathologyImagesCB()">Pathology Images<br>
  <input type="checkbox" id="assayImages" onClick="assayImagesCB()">Assay Images<br>
  <input type="checkbox" id="unTreated" onClick="untreatedCB()">Spontaneous<br>
  <input type="checkbox" id="metastatic" onClick="metastaticCB()">Metastatic<br>
  <input type="checkbox" id="geneExpression" onClick="geneExpressionCB()">Gene Expression Data<br>
  <div id="filters"></div><br>  
  
<div id="facetCount"></div>
<div class="facetBox">
 <span class="facetLabel">Organ of Origin</span>
<div class="clear"></div>
</div>
<div class="facetList" id="organParent"></div>

<div class="facetBox">
 <span class="facetLabel">Tumor Classification</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="tcParent"></div>

<div class="facetBox">
<span class="facetLabel">Agent Type</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="agentType"></div>

<div class="facetBox">
<span class="facetLabel">Strain Type</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="strainType"></div>


<div class="facetBox">
<span class="facetLabel">Metastasizes To</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="metsTo"></div>

<div class="facetBox">
<span class="facetLabel">Tumor Markers</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="tumorMarker"></div>

<div class="facetBox">
<span class="facetLabel">Strain Markers</span>
 <div class="clear"></div>
</div>
<div class="facetList" id="strainMarker"></div>


</td>
<td valign="top"><div id="results"></div></td>
</tr>
</table>
<div id ="raw"></div>
</body>
</html>