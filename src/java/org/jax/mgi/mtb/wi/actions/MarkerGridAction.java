/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/SolrAction.java,v 1.1 2016/04/05 20:18:41 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Build the marker grid and handle any sorting, or constraints
 *
 * Returns a big hunk of HMTL. markerGrid.jsp has the css and javascript to make
 * it all work.
 *
 *
 *
 */
public class MarkerGridAction extends Action {

    // these two where the way it worked befor 01-10-17
   //  private final static String ORGAN_FIELD = "organOrigin";
   //  private final static String ORGAN_SORT = "organAffected";
    
    // thought these two would be correct for parent organ but I think organ affected is what we want
    private final static String ORGAN_FIELD = "organParent"; 
    private final static String ORGAN_SORT = "organParent";
    
    private final static String solrURL = WIConstants.getInstance().getSolrURL();

    private final static String legend = "<table class=\"mg\" border=\"1\">\n"
            + "<tr><td class=\"veryhigh\"></td><td class=\"grid\">&nbsp;Very High</td></tr>\n"
            + "<tr><td class=\"high\"></td><td class=\"grid\">&nbsp;High</td></tr>\n"
            + "<tr><td class=\"moderate\"></td><td class=\"grid\">&nbsp;Moderate</td></tr>\n"
            + "<tr><td class=\"low\"></td><td class=\"grid\">&nbsp;Low</td></tr>\n"
            + "<tr><td class=\"verylow\"></td><td class=\"grid\">&nbsp;Very Low</td></tr>\n"
            + "<tr><td class=\"observed\"></td><td class=\"grid\">&nbsp;Observed</td></tr>\n"
            + "<tr><td align=\"center\" bgcolor=\"#ffffff\" width=\"20\">0</td><td class=\"grid\">Zero</td></tr>\n"
            + "</table>";

    private final static Logger log
            = Logger.getLogger(MarkerGridAction.class.getName());

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        ArrayList<String> strainList = new ArrayList<>();
        ArrayList<String> organList = new ArrayList<>();

        //strain name then a list of unique strain keys with the same name
        HashMap<String, ArrayList<String>> strains = new HashMap<>();

        // Solr objects for tumor frequencies stored first by strain then organ
        HashMap<String, HashMap<String, JSONObject>> mapMap = new HashMap<>();

        ArrayList<String> selectedOrgans = new ArrayList<>();

        String sponCB = null;
        String maleCB = "checked";
        String femaleCB = "checked";
       
        // for TumorSearchResultsAction
        String grid = "2";

        // depending on organ text the height of the header can vary quite  a bit
        // keep it to a minimum when possible
        String oHeight = "50px";
        int oMax = 0;

        StringBuilder html = new StringBuilder();

        String marker = request.getParameter("marker");

        String sortOrgan = null;

        try {

            if (marker != null && marker.trim().length() > 0) {

                sponCB = request.getParameter("spontaneous");
                maleCB = request.getParameter("male");
                femaleCB = request.getParameter("female");

                String[] organArray = request.getParameterValues("organ");
                
               

                if (organArray != null && organArray.length > 0) {
                    selectedOrgans.addAll(Arrays.asList(organArray));
                }

                if (request.getParameter("allOrgans") != null) {
                    selectedOrgans.clear();
                }

                // if the marker changed don't keep selected organs, they won't apply
                String om = request.getParameter("oldMarker");
                if (!om.equals(marker)) {
                    selectedOrgans.clear();
                }

                sortOrgan = request.getParameter("sortOrgan");

                // enough to get them all
                String rows = "100000";

                String spontaneous = "&fq=-agent:*";
                String male = "&fq=freqM:*";
                String female = "&fq=freqF:*";

               
                /*
                String query = "wt=json&indent=on&facet=true&facet.field=organParent"
                        + "&facet.field="+ORGAN_FACET+"&facet.field=strain&facet.field=strainMarker&facet.sort=name&facet.mincount=1"
                        + "&sort="+ORGAN_FACET+"%20asc,strain%20asc&&q=humanTissue:*&fq=metastatic:false&rows=" + rows + "&start=0&fq=strainMarker:" + marker;
                */
                
                String query = "wt=json&indent=on&facet=true&facet.field=strainMarker"
                             + "&sort="+ORGAN_SORT+"%20asc,strain%20asc&&q=humanTissue:*&rows=" + rows + "&start=0&fq=singleMutant:true&fq=strainMarker:%22" + URLEncoder.encode(marker, "UTF-8")+"%22";
                if (sponCB != null) {
                    query += spontaneous;
                    sponCB = "checked";
                    grid = "3"; // only return spontaneous in tumor search
                } else {
                    sponCB = "";
                }

                if (maleCB == null) {
                    query += female;
                    maleCB = "";
                } else {
                    maleCB = "checked";
                }

                if (femaleCB == null) {
                    query += male;
                    femaleCB = "";
                } else {
                    femaleCB = "checked";
                }

                String json = getJSON(query);

                JSONObject job = new JSONObject(json);

                JSONArray docs = (JSONArray) ((JSONObject) job.get("response")).getJSONArray("docs");

                HashMap<String, String> organs = new HashMap<>();
                HashMap<String, String> strainMarkers = new HashMap<>();

                HashMap<String, String> strainKeysToNames = new HashMap<>();

                for (int i = 0; i < docs.length(); i++) {

                    JSONObject doc = (JSONObject) docs.get(i);
                    
                    String organ = doc.getString(ORGAN_FIELD);
                    String strain = doc.getString("strain");
                    String strainKey = doc.getInt("strainKey") + "";
                    String strainMarker = doc.getString("strainMarker");
                    strainMarkers.put(strainMarker,strainMarker);
                    
                    strainKeysToNames.put(strainKey, strain);

                    organs.put(organ, organ);

                    if (strains.containsKey(strain)) {
                        if (!strains.get(strain).contains(strainKey)) {
                            strains.get(strain).add(strainKey);
                        }
                    } else {
                        ArrayList<String> list = new ArrayList<String>();
                        list.add(strainKey);
                        strains.put(strain, list);
                    }

                    if (mapMap.containsKey(strainKey)) {

                        if (mapMap.get(strainKey).containsKey(organ)) {
                            doc = consolidateDoc(doc, mapMap.get(strainKey).get(organ));
                        }
                        mapMap.get(strainKey).put(organ, doc);

                    } else {
                        HashMap<String, JSONObject> map = new HashMap<>();
                        map.put(organ, doc);
                        mapMap.put(strainKey, map);

                    }

                }
                
              

                // if there is a sort organ:
                // we need to hijack the strain list and the strains map
                // rather than listing strains by name alpabetically we need to list them
                // by decending tumorfrequency for the selected organ
                // strainList now needs to have sorted strain keys (cant use names since they are redundant)
                // strains now needs to be keyed to strain key not strain name.
                if (sortOrgan != null) {
                    Object[] mess = sortByOrgan(mapMap, sortOrgan, strainKeysToNames);
                   
                    // strainList needs to be the sorted list of strainKeys
                    strainList = (ArrayList<String>) mess[0];
                    // strains needs to be a map of <strainkey, arraylist<name>>
                    strains = (HashMap<String, ArrayList<String>>) mess[1];

                } else {
                    strainList.addAll(strains.keySet());
                    Collections.sort(strainList);
                }

                if (selectedOrgans.isEmpty()) {
                    organList.addAll(organs.keySet());
                } else {
                    organList.addAll(selectedOrgans);
                    
                }

                Collections.sort(organList);

                //    System.out.println("Grid for " + marker + " is " + organs.size() + " by " + strains.size());
            }

            // all the css is in markgerGrid.jsp
            html.append("<table class=\"mg\" border=\"1\">");
            html.append("<tr><td style=\"vertical-align:top; font-size:110%\">");

            //put some controls here
            html.append("<table width=\"100%\"><tr><td><table border =\"1\" style=\"border-collapse:collapse\"><tr class=\"stripe1\"><td class=\"data1 center\"  colspan=\"2\">Configure Grid</td></tr>");
            html.append("<tr class=\"stripe2\"><td class=\"cat2\">Mutant type</td><td class=\"data2\"><div class=\"cbox\"><input type=\"checkbox\" name=\"spontaneous\" value=\"spontaneous\" ");
            html.append(sponCB);
            html.append(" >Only spontaneous");
            html.append("</td></tr><tr class=\"stripe1\"><td class=\"cat1\">Strain sex</td><td class=\"data1\"><input type=\"checkbox\" name=\"male\" value=\"male\" ");
            html.append(maleCB);
            html.append(" >Male<br>");
            html.append("<input type=\"checkbox\" name=\"female\" value=\"female\" ");
            html.append(femaleCB);
            html.append(" >Female</div>");

            html.append("<tr class=\"stripe2\"><td class=\"cat2\">Strain Genetics</td><td class=\"data2\"><div class=\"left\">");
            
            html.append("<a href=\"javascript:void(0);\" style=\"text-decoration: none; cursor:help;\" onmouseover=\"return overlib('The grid will display tumor frequency details for <br>strains with the selected marker.', CAPTION, 'Strain Marker');\" onmouseout=\"return nd();\">");
            
            html.append("Strain Marker:</a><div id=\"markerSelect\"></div>");

            html.append("<input type=\"submit\" value=\"Generate Grid\">");
           
            html.append("</div>");

            html.append("</td></tr></table></td>");

            if (marker != null && marker.length() > 0) {
                html.append("<td class=\"center\">");
                html.append(legend);
                html.append("</td></tr>");
                html.append("<tr><td  class=\"center\" colspan=\"3\"><br><br>Strains linked to marker <b>");
                html.append(marker);
                html.append("</b></td></tr><tr><td colspan=\"3\" class=\"right\">");
                
                if (!selectedOrgans.isEmpty()) {
                    html.append("<input type=\"submit\" name=\"allOrgans\" value=\"Show all organs\">");
                }
                    
                html.append("<input type=\"submit\" name=\"selectedOrgans\" value=\"Limit to selected organs\"></td>");
                
            }
            

            html.append("</tr></table></td>");

            for (String o : organList) {

                if (o.length() > oMax) {
                    oMax = o.length();
                }

                if(sortOrgan != null && sortOrgan.equals(o)){
                    html.append("<td class=\"mg\" style=\"vertical-align:bottom;\"><table class=\"mg\" ><tr><td id =\"sorted\" class=\"sorted\" title=\"Strains are sorted by decending tumor frequency for "+o+".\" onclick=\"organSort('");
                }else{
                    html.append("<td class=\"mg\" style=\"vertical-align:bottom;\"><table class=\"mg\" ><tr><td class=\"sort\" title=\"Sort strains by tumor frequency for "+o+".\" onclick=\"organSort('");
                }
                html.append(o);
                html.append("');\">&nbsp;</td></tr><tr><td class=\"organ\"><div class=\"vertical\">");
                html.append(o);
                html.append("</div></td></tr><td class=\"oCbox\"><input style=\"margin:0px\" type=\"checkbox\" name=\"organ\" value=\"");
                html.append(o);
                html.append("\"");
                if(selectedOrgans.contains(o)){
            //    if (!selectedOrgans.isEmpty()) {
                    html.append(" checked ");
                }
                html.append("></td></tr></table></td>");
            }
            html.append("</tr>");
            for (String s : strainList) {
                for (String key : strains.get(s)) {

                    String strainName = s;
                    String strainKey = key;

                    // oh the humanity!
                    // we have to switch to order by strain key rather than strain name
                    if (sortOrgan != null) {
                        strainName = key;
                        strainKey = s;
                    }

                    html.append("<tr><td class=\"strain\" nowrap><a class=\"noline\" target=\"_blank\" href=\"strainDetails.do?page=collapsed&amp;key=");
                    html.append(strainKey);
                    html.append("\">");
                    html.append(strainName);
                    html.append("</a></td>");

                    HashMap<String, JSONObject> map = mapMap.get(strainKey);
                    if (map != null) {
                        for (String o : organList) {

                            if (map.containsKey(o)) {

                                String cls = getFreq(map.get(o).getString("freqNum"));
                                String val = "&nbsp;";
                                if ("".equals(cls)) {
                                    val = "0";
                                    cls = "mg";
                                }
                                html.append("<td class=\"");
                                html.append(cls);
                                html.append("\" ");

                                html.append("onmouseover=\"return overlib('<table class=\\'gridDetails\\' border=0><tr><td class=\\'gridDetails\\'>Strain:</td><td class=\\'gridDetails\\'>");
                                html.append(strainName);
                                html.append("</td></tr><tr><td class=\\'gridDetails\\'>Organ:</td><td class=\\'gridDetails\\'>");
                                html.append(o);
                                html.append("</td></tr><tr><td class=\\'gridDetails\\'>Highest reported tumor frequency:</td><td class=\\'gridDetails\\'>");
                                html.append(map.get(o).getString("freqNum"));
                                html.append("</td></tr><tr><td class=\\'gridDetails\\'># Tumor Frequency Records:</td><td class=\\'gridDetails\\'>");
                                html.append(map.get(o).getJSONArray("tumorFrequencyKey").length());
                                html.append("</td></tr></table>', TEXTSIZE,'2');\" onmouseout=\"return nd();\" >");

                                html.append("<a class=\"noline\" target=\"_blank\" href=\"/mtbwi/tumorSearchResults.do?grid=");
                                html.append(grid);
                                html.append("&strainKey=");
                                html.append(strainKey);
                                html.append("&organParentKey=");
                                html.append(map.get(o).getInt("organParentKey"));
                                html.append("\">");
                                html.append("<div style=\"height:100%;width:100%\">" + val + "</div></a></td>");
                            } else {
                                html.append("<td class=\"mg\">&nbsp;</td>");
                            }

                        }
                        html.append("</tr>\n");
                    } else {
                        System.out.println(s + " not found in mapMap");
                    }
                }
            }
            html.append("</table>");
            
            

        } catch (Exception e) {

            log.error("Error generating HTML for marker grid.", e);
        }
        
        request.setAttribute("marker", marker);
        request.setAttribute("table", html.toString());

        if (oMax > 0) {
            oHeight = (oMax * 6) + "px";
        }
        request.setAttribute("oHeight", oHeight);

        return mapping.findForward("success");
    }

    // convert the freq to a css class name to color grid cell
    private String getFreq(String freqStr) {
        String strRet = "";
        Double freq = new Double(freqStr);
        if (freq > 80.0) {
            strRet = "veryhigh";
        } else if (freq > 50.0) {
            strRet = "high";
        } else if (freq > 20.0) {
            strRet = "moderate";
        } else if (freq > 10.0) {
            strRet = "low";
        } else if (freq > 0.10) {
            strRet = "verylow";
        } else if (freq > 0) {
            strRet = "observed";
        } else if (freq == 0) {
            strRet = "";
        }
        return strRet;

    }

    // does this consolidate on things it should not (agent)? what other option is there?
    private JSONObject consolidateDoc(JSONObject parent, JSONObject child) throws Exception {
        JSONArray tfKeys = child.getJSONArray("tumorFrequencyKey");
        for (int i = 0; i < tfKeys.length(); i++) {
            parent.getJSONArray("tumorFrequencyKey").put(tfKeys.get(i));

            Double c = child.getDouble("freqNum");
            Double p = parent.getDouble("freqNum");
            if (c > p) {
                parent.put("freqNum", c);
            }
        }

        return parent;

    }

    // need to return a list of strain keys sorted by descending frequency of all the docs for the organ
    // strainList = (ArrayList<String>) mess[0];
    // strains = (HashMap<String,ArrayList<String>>) mess[1];
    private Object[] sortByOrgan(HashMap<String, HashMap<String, JSONObject>> mapMap, String organ, HashMap<String, String> keysToNames) {

        ArrayList<String> strainsList = new ArrayList<>();
        HashMap<String, ArrayList<String>> strains = new HashMap<>();

        try {
            ArrayList<JSONObject> docs = new ArrayList<>();

            for (String key : mapMap.keySet()) {
                JSONObject doc = mapMap.get(key).get(organ);

                // no reason a doc would exist for every strain for a given organ
                // but we still need to show and sort all the strains 
                // so make a fake one
                if (doc == null) {
                    doc = new JSONObject();
                    doc.put("freqNum", -11.0); // whats wrong with -11?
                    doc.put("strainKey", key);
                    doc.put("strain", keysToNames.get(key));

                }
                docs.add(doc);

            }

            TFSorter comparator = new TFSorter();
            Collections.sort(docs, comparator);
            

            for (JSONObject doc : docs) {
                strainsList.add(doc.getString("strainKey"));
                ArrayList<String> list = new ArrayList<>();
                list.add(doc.getString("strain"));
                strains.put(doc.getString("strainKey"), list);
            }

        } catch (Exception e) {
            log.error("Error sorting marker grid by organ:" + organ, e);
        }
        return new Object[]{strainsList, strains};
    }

    // sorts by tumor frequency then strain name
    // allows for sorting by tumor frequency on a given organ
    private class TFSorter implements Comparator<JSONObject> {

        public int compare(JSONObject o1, JSONObject o2) {
            if (o1 == null) {
                if (o2 == null) {
                    return 0;
                } else {
                    return 1;
                }
            } else if (o2 == null) {
                return -1;
            }

            try {

                if (o1.getDouble("freqNum") > o2.getDouble("freqNum")) {
                    return -1;
                }
                if (o1.getDouble("freqNum") < o2.getDouble("freqNum")) {
                    return 1;
                }
                return o1.getString("strain").compareTo(o2.getString("strain"));

            } catch (Exception e) {
                e.printStackTrace();
            }
            // this shouldn't happen
            log.error("MarkerGridAction: failed to compare " + o1 + " to " + o2);
            return 0;
        }
    }

    private String getJSON(String urlIn) throws Exception {

        URL url = new URL(solrURL + "?" + urlIn);

 //       System.out.println(url);
        HttpURLConnection connection
                = (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("GET");

        connection.setDoOutput(true);
        connection.setDoInput(true);
        connection.setUseCaches(false);

        StringBuilder responseStr = new StringBuilder();
        String responseSingle;

        // Open a stream which can read the server response
        InputStream in = connection.getInputStream();
        try {
            BufferedReader rd = new BufferedReader(new InputStreamReader(in));
            while ((responseSingle = rd.readLine()) != null) {
                responseStr.append(responseSingle);
            }
            rd.close();

        } catch (IOException e) {
            log.error("failed getting response for solr query:" + url.toString(), e);

        } finally {
            if (in != null) {
                in.close();
                connection.disconnect();

            }
        }
        
  //      System.out.println(responseStr.toString());
        return responseStr.toString();
    }

}
