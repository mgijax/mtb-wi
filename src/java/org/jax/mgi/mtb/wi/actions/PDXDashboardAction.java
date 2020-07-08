package org.jax.mgi.mtb.wi.actions;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.wi.forms.PDXDashboardForm;
import org.jax.mgi.mtb.utils.LabelValueBeanComparator;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * @author sbn
 */
public class PDXDashboardAction extends Action {

    private static ArrayList<ArrayList<String>> status = null;
    private static HashMap<String, String> allTissues = new HashMap<String, String>();
    private static HashMap<String, String> allSites = new HashMap<String, String>();
    private static ArrayList<LabelValueBean<String, String>> lvbSites = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> lvbTissues = new ArrayList<LabelValueBean<String, String>>();

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        String result = "success";
        String tissue = "Any";
        String site = "Any";
        String site2 = "";
        PDXDashboardForm pdxForm = (PDXDashboardForm) form;
        String[] tissues = pdxForm.getTissues();
        if ((tissues != null) && tissues.length > 0) {
            tissue = tissues[0];
        }

        String[] sites = pdxForm.getSites();
        if ((sites != null) && sites.length > 0) {
            site = sites[0];
        }

        String[] sites2 = pdxForm.getSites2();
        if ((sites2 != null) && sites2.length > 0) {
            site2 = sites2[0];
        }

   
        PDXMouseStore store = new PDXMouseStore();
        String source = "ELIMS-";
        String report = null;
        boolean tabDelimited = false;
        String delimiter = ",";  // this is also hard coded in the mousestore fyi
        Date d = new Date(System.currentTimeMillis());
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String date = sdf.format(d);
        String fileName = "";
        if (request.getParameter("statusReport") != null) {
            report = store.getPDXStatusReport(delimiter);
            fileName = source + "PDXStatusReport";
        }
        if (request.getParameter("engraftmentSummary") != null) {
            report = store.getPDXEngraftmentStatusSummary(delimiter);
            fileName = source + "PDXEngraftmentStatusSummary";
        }
        
        if (request.getParameter("familyHistory") != null) {
            report = store.getPDXPatientHistory(delimiter);
            fileName = source + "PDXPatientHistory";
        }
        if (request.getParameter("patientClinical") != null) {
            report = store.getPDXPTClinical(delimiter);
            fileName = source + "PDXPatientClinical";
        }
        if (request.getParameter("consortium") != null) {
            report = store.getPDXConsortiumReport(delimiter);
            fileName = source + "PDXConsortiumReport";
        }
        
        if (request.getParameter("houseSpecial") != null) {
            report = store.getPDXHouseSpecialReport(delimiter);
            fileName = source + "PDXHouseSpecialReport";
        }
       

        if (request.getParameter("aipReportSheet") != null) {
            report = getActiveModelReport(0);
            fileName = source + "ActiveInProgress";
        }
        if (request.getParameter("aipReport5Sheet") != null) {
            report = getActiveModelReport(5);
            fileName = source + "ActiveInProgressOver5";
        }

        if (request.getParameter("refresh") != null) {
            store.refreshReports();
        }


        if (report != null) {
            if (tabDelimited) {
                response.setContentType("text");
                response.setHeader("Content-disposition", "attachment; filename=" + fileName + "-" + date + ".txt");
                response.getWriter().write(report);
            } else {
                // csv
                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=" + fileName + "-" + date + ".csv");
                response.getWriter().write(report);

            }
            response.flushBuffer();
            return null;
        }

        

       
        if (request.getSession().getAttribute("pdxUser") == null) {
            result = "search";
        } else {



            
            status = store.getPDXModelStatus();

            if (status == null || status.size() < 1) {
                result = "noData";
            } else {

                allTissues.clear();
                lvbSites.clear();
                allSites.clear();

                for (ArrayList<String> line : status) {
                    allTissues.put(line.get(0), line.get(0));
                    allSites.put(line.get(1), line.get(1));
                }

                for (String s : allSites.keySet()) {
                    if (s != null && s.length() > 0) {
                        LabelValueBean<String, String> lvb = new LabelValueBean<>(s, s);
                        lvbSites.add(lvb);
                    }
                }

                Collections.sort(lvbSites, new LabelValueBeanComparator(1));

                String stacked = "";

                if (site2.length() > 0) {
                 
                    String modelStatsByTissue = getModelStatsByTissue(site2);

                    // testing this out


                    request.setAttribute("modelStatsByTissue", modelStatsByTissue);
                    String[] lines = modelStatsByTissue.split("\\[");
                    int size = 50 + lines.length * 40;
                    request.setAttribute("chartSize", size + "");
                    size = size + 200;
                    request.setAttribute("divSize", size + "");
                    request.setAttribute("bySite", "yes");
                    
                } else {
                    request.setAttribute("chartSize", "10");
                }

                if (request.getParameter("aipReport") != null) {
                    String modelStatsByTissue = getActiveModelStats(0);
                    request.setAttribute("modelStatsByTissue", modelStatsByTissue);
                    String[] lines = modelStatsByTissue.split("\\[");
                    int size = 50 + lines.length * 20;
                    request.setAttribute("chartSize", size + "");
                    size = size + 200;
                    request.setAttribute("divSize", size + "");
                    request.setAttribute("bySite", "yes");
                    stacked = ", isStacked: true";
                }

                if (request.getParameter("aipReport5") != null) {
                    String modelStatsByTissue = getActiveModelStats(5);
                    request.setAttribute("modelStatsByTissue", modelStatsByTissue);
                    String[] lines = modelStatsByTissue.split("\\[");
                    int size = 50 + lines.length * 20;
                    request.setAttribute("chartSize", size + "");
                    size = size + 200;
                    request.setAttribute("divSize", size + "");
                    request.setAttribute("bySite", "yes");
                    stacked = ", isStacked: true";
                }

                request.setAttribute("stacked",stacked);

                request.setAttribute("modelStats", getModelStats(tissue, site));
                request.setAttribute("tissueValues", lvbTissues);
                request.setAttribute("siteValues", lvbSites);
                request.setAttribute("tissue", tissue);
                request.setAttribute("tissue2", site2);
                request.setAttribute("freshnessDate", store.getReportFreshnessDate());

                site = site.replace("\'", "");
                request.setAttribute("site", site);

            }
        }

        return mapping.findForward(result);
    }
    
    //i guess this need to be primary site not specimen site
    //SPECIMEN_SITE,DONATING_ORG,MODEL_STATUS,NUM

    private String getModelStatsByTissue(String organization) {
        StringBuffer sb = new StringBuffer();

        LinkedHashMap<String, LinkedHashMap<String, String>> stats = new LinkedHashMap<String, LinkedHashMap<String, String>>();

        ArrayList<ArrayList<String>> statsByOrg = new ArrayList<ArrayList<String>>();
        HashMap<String, String> statuses = new HashMap<String, String>();
        ArrayList<String> statusList = new ArrayList<String>();
        HashMap<String, String> sites = new HashMap<String, String>();
        ArrayList<String> sitesList = new ArrayList<String>();
        for (ArrayList<String> line : status) {
            if (organization.equalsIgnoreCase("any") || line.get(1).equals(organization)) {
                statsByOrg.add(line);
                statuses.put(line.get(2), line.get(2));
                sites.put(line.get(0), line.get(0));
            }
        }

        statusList.addAll(statuses.keySet());
        Collections.sort(statusList);

        sitesList.addAll(sites.keySet());
        Collections.sort(sitesList);



        sb.append("['Tissue'");
        for (String status : statusList) {
            sb.append(",'").append(status).append("'");
        }
        sb.append("]");

        for (String site : sites.keySet()) {
            stats.put(site, newStatusMap(statusList));

        }


        for (ArrayList<String> line : statsByOrg) {
            LinkedHashMap<String, String> map = stats.get(line.get(0));
            map.put(line.get(2), line.get(3));

        }


        // [['Tissue','Active: Available','Active: P0 in progress','Active: P1 in progress','Discontinued: No engraftment','No Engraftment Record Entered'],
        // ['Abdominal wall',0,0,0,1,0],['Brain',0,3,0,4,1]]

        for (String tissue : sitesList) {
            sb.append(",['").append(tissue).append("'");
            LinkedHashMap<String, String> map = stats.get(tissue);
            for (String statusStr : map.keySet()) {
                sb.append(",").append(map.get(statusStr));
            }
            sb.append("]");

        }
        return sb.toString();

    }

    // convert the active model data format from google vis to csv
    private String getActiveModelReport(int min) {
        String report = getActiveModelStats(min);
        report = report.substring(report.indexOf("],") + 2);
        report = report.replaceAll("\\[", "");
        report = report.replaceAll("\\],", "\n");
        report = report.replaceAll("'", "");
        return "Organ,Available,In Progress\n" + report;
    }
    /*
     * Active models only across all sites by tissue
     * min is the minimum number of models to report
     */

    private String getActiveModelStats(int min) {

        StringBuffer sb = new StringBuffer();

        LinkedHashMap<String, LinkedHashMap<String, String>> stats = new LinkedHashMap<String, LinkedHashMap<String, String>>();

        // organ, active,inprogress
        HashMap<String, int[]> countsByOrg = new HashMap<String, int[]>();

        ArrayList<String> statusList = new ArrayList<String>();
        statusList.add("Available");
        statusList.add("In Progress");

        HashMap<String, String> sites = new HashMap<String, String>();
        ArrayList<String> sitesList = new ArrayList<String>();
        String statusStr, site;

        for (ArrayList<String> line : status) {


            statusStr = line.get(2).toLowerCase();
            site = line.get(0);
            if ((statusStr.indexOf("available") != -1) || (statusStr.indexOf("progress") != -1)) {
                sites.put(site, site);
                int[] counts = {0, 0};
                if (countsByOrg.get(site) != null) {
                    counts = countsByOrg.get(site);
                }

                if (statusStr.indexOf("available") != -1) {
                    counts[0] = counts[0] + new Integer(line.get(3)).intValue();
                }
                if (statusStr.indexOf("progress") != -1) {
                    counts[1] = counts[1] + new Integer(line.get(3)).intValue();
                }
                countsByOrg.put(site, counts);

            }
        }


        sitesList.addAll(sites.keySet());
        Collections.sort(sitesList);



        sb.append("['Tissue'");
        for (String status : statusList) {
            sb.append(",'").append(status).append("'");
        }
        sb.append("]");



        // [['Tissue','Available','In Progress'],
        // ['Abdominal wall',0,0],['Brain',0,3]]

        for (String tissue : sitesList) {
            if ((countsByOrg.get(tissue)[0] + countsByOrg.get(tissue)[1]) > min) {
                sb.append(",['").append(tissue).append("',");
                int[] counts = countsByOrg.get(tissue);
                sb.append(counts[0]).append(",").append(counts[1]);
                sb.append("]");
            }
        }
        return sb.toString();

    }

    private LinkedHashMap<String, String> newStatusMap(ArrayList<String> statuses) {

        LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
        for (String status : statuses) {
            map.put(status, "0");
        }
        return map;
    }

    private String getModelStats(String tissue, String site) {
        StringBuffer sb = new StringBuffer();
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        HashMap<String, String> tissues = new HashMap<String, String>();
        sb.append(" ['Model Status', 'Mice']");
        for (ArrayList<String> line : status) {
            if ((tissue.equalsIgnoreCase("any") || line.get(0).equals(tissue))
                    && (site.equalsIgnoreCase("any") || line.get(1).equals(site))) {
                if (map.containsKey(line.get(2))) {
                    int i = map.get(line.get(2)).intValue() + new Integer(line.get(3)).intValue();
                    map.put(line.get(2), new Integer(i));
                } else {
                    map.put(line.get(2), new Integer(line.get(3)));
                }

            }
            if (site.equals(line.get(1))) {
                tissues.put(line.get(0), line.get(0));
            }
        }
        lvbTissues.clear();
        if (!site.equalsIgnoreCase("any")) {
            for (String t : tissues.keySet()) {
                LabelValueBean<String, String> lvb = new LabelValueBean<>(t, t);
                lvbTissues.add(lvb);
            }


        } else {
            for (String t : allTissues.keySet()) {
                LabelValueBean<String, String> lvb = new LabelValueBean<>(t, t);
                lvbTissues.add(lvb);
            }
        }
        Collections.sort(lvbTissues, new LabelValueBeanComparator(1));


        // consolidate by status to 
       // Available models (Active:Available, Active: Available (blood cancer))
      // Models in progress (P0 in progress, P1 in progress)
      // Discontinued (and reason except “no inventory remaining”)
      // Other
        String a = "Available";
        String ip = "In Progress";
        String d = "Discontinued";
        String o = "Other";
         HashMap<String, Integer> consolidatedMap = new HashMap<>();
         Integer zero = new Integer(0);
         consolidatedMap.put(a,zero );
         consolidatedMap.put(ip,zero );
         consolidatedMap.put(d,zero );
         consolidatedMap.put(o,zero );
        for(String key: map.keySet()){
            if(key.contains(a)){
                   int i = map.get(key).intValue() + new Integer(consolidatedMap.get(a)).intValue();
                    consolidatedMap.put(a, new Integer(i));
            }else if (key.contains("progress")){
                 int i = map.get(key).intValue() + new Integer(consolidatedMap.get(ip)).intValue();
                    consolidatedMap.put(ip, new Integer(i));
            }else if (key.contains(d) && ! key.contains("Inventory")){
                 int i = map.get(key).intValue() + new Integer(consolidatedMap.get(d)).intValue();
                    consolidatedMap.put(d, new Integer(i));
            }else{
                int i = map.get(key).intValue() + new Integer(consolidatedMap.get(o)).intValue();
                    consolidatedMap.put(o, new Integer(i));
            }
            
        }
        
        
       String[] status= {a,d,ip,o};
        
        for (String key : status) {
            sb.append(",['").append(key).append(" (").append(consolidatedMap.get(key)).append(")',").append(consolidatedMap.get(key)).append("]");
        }

        return sb.toString();

    }
}
