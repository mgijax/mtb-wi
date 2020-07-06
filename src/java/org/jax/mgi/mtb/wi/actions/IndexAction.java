 /**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.URLDownloader;
import org.jax.mgi.mtb.wi.pdx.ModelCounts;

/**
 * Retrieve the required information needed on the home page.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class IndexAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(IndexAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the required information needed on the home page.
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception
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

        // default target to success
        String strTarget = "success";
        Timer timer = new Timer();
        timer.start();

        String strWhatsNew = getWhatsNew(request.getRequestURL());
        List arrOrganTissues = getTumorFrequencyOrgansofOrigin();
        int nTFCount = WIConstants.getInstance().getTumorFrequencyCount();
        NumberFormat nfFormatter = new DecimalFormat("#,###,###");
        String strTFCount = nfFormatter.format(nTFCount);
        
        
        
        
        ModelCounts mc = new ModelCounts();
        String modelCounts = mc.getHTML();
        String allModelCounts = mc.getHTMLAll();
        String dataYear = mc.getDataYear();
        
        
        // set the target to failure if we could not retrieve the organ list
        if (arrOrganTissues == null) {
            strTarget = "error";
        } else {
            // put all the servers in the request
            request.setAttribute("whatsNewText", strWhatsNew);
            request.setAttribute("organTissueValues", arrOrganTissues);
            request.setAttribute("tumorFrequencyCount", strTFCount);
            request.setAttribute("modelCounts",modelCounts);
            request.setAttribute("allModelCounts",allModelCounts);
            request.setAttribute("dataYear", dataYear);
        }

        timer.stop();

       
        log.debug("IndexAction: " + timer.toString());
        

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Retrive the specified contents of the "What's New" url.
     *
     * @param sbRequestURL A StringBuffer containing the base url of the webapp
     * @return A string containing the needed portion of the "What's New" url
     */
    private String getWhatsNew(StringBuffer sbRequestURL) {
        StringBuffer sbUrl = new StringBuffer();
        String strHtml = null;

        sbUrl.append(sbRequestURL.substring(0, sbRequestURL.lastIndexOf("/")));
        sbUrl.append('/');
        sbUrl.append(WIConstants.getInstance().WHATS_NEW_URL);

        URLDownloader urldownloader = new URLDownloader(sbUrl.toString());

        urldownloader.start();

        // wait for the thread to finish but don't wait longer than 20 secs
        long delayMillis = 20 * 1000; // 20 seconds

        try {
            urldownloader.join(delayMillis);

            if (!urldownloader.isAlive()) {
                // finished successfully
                strHtml = StringUtils.getBetween(urldownloader.getData(), 
                        WIConstants.getInstance().SEARCH_SECTION_START,
                        WIConstants.getInstance().SEARCH_SECTION_END);
            }
        } catch (InterruptedException ie) {
            // Thread was interrupted
            log.error("Error retrieving What's New Url", ie);
        }

        return strHtml;
    }

    /**
     * Get the elements for the Organ "Quick Search".
     *
     * @return a List of LabelValueBeans.
     *
     */
    private List getTumorFrequencyOrgansofOrigin() {
        List<LabelValueBean<String,Long>> listOrgans = 
                new ArrayList<LabelValueBean<String,Long>>();

        try {
            // get the organs
            MTBTumorUtilDAO daoTumor = MTBTumorUtilDAO.getInstance();
           listOrgans = daoTumor.getOrgansOfOriginWithTFRecord();
           
        } catch (Exception e) {
            log.error("Error retrieving organ list", e);
        }

        return listOrgans;
    }
}
