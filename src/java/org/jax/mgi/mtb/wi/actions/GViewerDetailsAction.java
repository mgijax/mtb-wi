/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.net.URL;
import java.util.ArrayList;
import java.util.Scanner;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.wi.utils.GViewerFeature;

/**
 * Generate query for MGI, parse results and display them
 * or forward to MGI for tabbed results
 * 
 * @author $Author: sbn $
 * @date $Date: 2016/04/05 20:18:41 $
 * @version $Revision: 1.12 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/GViewerDetailsAction.java,v 1.12 2016/04/05 20:18:41 sbn Exp $
 * @see org.apache.struts.action.Action
 */
public class GViewerDetailsAction extends Action {
    
     private static final Logger log =
            Logger.getLogger(GViewerDetailsAction.class.getName());


    private static String featureTypesJSON = null;
    private static String defaultColor = "green";

    /*
     * 
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception.
     * @see org.apache.struts.action.ActionMapping
     * @see org.apache.struts.action.ActionForm
     * @see javax.servlet.http.HttpServletRequest
     * @see javax.servlet.http.HttpServletResponse
     */
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        if ("json".equals(request.getParameter("featureTypes"))) {

            response.setContentType("text/xml");

            if (featureTypesJSON == null) {
                MTBSynchronizationUtilDAO util = MTBSynchronizationUtilDAO.getInstance();
                featureTypesJSON = util.getFeatureTypeJSON();
            }
            response.getWriter().write(featureTypesJSON);

            response.flushBuffer();
            return null;
        }


        String strTarget = "success";

        String start = request.getParameter("searchStart");
        String end = request.getParameter("searchEnd");
        String chrom = request.getParameter("chrom");
        String name = request.getParameter("gsmname_term");
        String nameOp = request.getParameter("gsmname_op");
        String pheno = request.getParameter("phenotype");
        String mgiId = request.getParameter("mgiId");
        String go_op = request.getParameter("go_op");
        String go_term = request.getParameter("go_term");
        String sortBy = request.getParameter("sortBy");
        String[] ontology_keys = request.getParameterValues("ontology_key");
        String mcv = request.getParameter("featureTypes");
        String[] mcvs = mcv.split(",");

        //Use the QTL's MGI id to get the associated strains
        MTBSynchronizationUtilDAO syncDAO = MTBSynchronizationUtilDAO.getInstance();
        request.setAttribute("strains", syncDAO.getStrainsForQTL(mgiId));

        String urlStr = buildURL(start, end, chrom, name, nameOp, pheno, go_op, go_term, sortBy, ontology_keys, mcvs);

        //for tabbed results redirect to mgi
        if ("tab".equals(request.getParameter("display"))) {
            response.sendRedirect(response.encodeRedirectURL(urlStr));
            return null;
        }

        //build the features from the URL
        ArrayList<GViewerFeature> features = parseMGIURL(urlStr);

        // build a string of MGI:ids to pass to the batch query
        StringBuffer ids = new StringBuffer();
        for (GViewerFeature feature : features) {
            ids.append("\n");
            ids.append(feature.getMgiId());
        }

        // set flag to display no results message if results are empty
        if (features.size() == 0) {
            request.setAttribute("noResults", "noResults");
        }

        request.setAttribute("features", features);
        request.setAttribute("ids", ids.toString());
        return mapping.findForward(strTarget);


    }
    // -------------------------------------------------------- Private Methods
   
      public String buildURL(String start, String end, String chrom, String name, String nameOp, String pheno, String go_op, String go_term, String sortBy, String[] ontology_keys, String[] mcvs) {


        // build the MGI URL to get the genes from the QTL and query params
        StringBuffer go = new StringBuffer();
        go.append("&go=");
        go.append(go_term);
        go.append("&");

        if (ontology_keys == null) {
            ontology_keys = new String[]{"goFunctionTerm", "goProcessTerm", "goComponentTerm"};
        }
        for (int i = 0; i < ontology_keys.length; i++) {
            go.append("goVocab=" + ontology_keys[i]);
            go.append("&");

        }


        String sort = "Nomenclature";
        
        if ("coord".equals(sortBy)) {
            sort = "Genome+Coordinates";
        }
        if ("cm".equals(sortBy)) {
            sort = "cM+Position";
        }

        if (pheno != null && pheno.length() > 1) {

            pheno = "&phenotype=" + pheno.replace(' ', '+') + "&";
        }

        String dash = "-";
        if ((start.trim().length() == 0) && (end.trim().length() == 0)) {
            dash = "";
        }
        String nameParams = "";
        if (name != null) {
            nameParams = "&nomen=" + name;

        }

        String url =
                "http://www.informatics.jax.org/marker/report.txt?"
                + "chromosome=" + chrom
                + "&coordinate=" + start
                + dash + end + "&coordUnit=bp" + nameParams + go
                + pheno;

        if (mcvs != null) {
            for (int i = 0; i < mcvs.length; i++) {
                url = url + "&mcv=" + mcvs[i];

            }
        }

        return url;
    }

   // convert results from the mgi url into GViewerFeatures
    public ArrayList<GViewerFeature> parseMGIURL(String urlStr) {
        ArrayList<GViewerFeature> features = new ArrayList<GViewerFeature>();
        try {
            urlStr = urlStr.trim();

            urlStr = urlStr.replaceAll("\n", "");

            URL url = new URL(urlStr);

            Scanner lineScanner = new Scanner(url.openStream());
            lineScanner.useDelimiter("\n");

            // skip the header line 
            lineScanner.next();


            while (lineScanner.hasNext()) {
                String line = lineScanner.next();
              
                Scanner tabScanner = new Scanner(line);
                tabScanner.useDelimiter("\t");
                if (tabScanner.hasNext()) {
                    GViewerFeature feature = new GViewerFeature();
                    
                    feature.setChromosome(tabScanner.next());
                    feature.setStart(tabScanner.next());
                    feature.setEnd(tabScanner.next());
                    tabScanner.next();//cm
                    feature.setStrand(tabScanner.next());
                    feature.setMgiId(tabScanner.next());
                    String type = tabScanner.next().toLowerCase();
                    if (type.length() < 1) {
                        type = "gene";
                    }
                    feature.setType(type);
                    feature.setGroup(type);  // 
                    feature.setName(tabScanner.next());
                    feature.setDescription(tabScanner.next());
                    feature.setColor("blue");
                    feature.buildMGILink();
                    try {
                        if (((feature.getChromosome().equalsIgnoreCase("X")
                                || feature.getChromosome().equalsIgnoreCase("Y")
                                || Integer.parseInt(feature.getChromosome()) > 0)
                                && (Integer.parseInt(feature.getStart()) >= 0)
                                && (Integer.parseInt(feature.getEnd()) > 0))) {

                            features.add(feature);
                        }
                    } catch (NumberFormatException nfe) {
                      
                    }

                }

            }
        } catch (Exception e) {
           log.error("Error parsing MGI URL for features",e);
        }

       
        return features;
    }
    
}
