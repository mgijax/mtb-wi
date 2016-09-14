/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.Collection;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Used to set the values for the Advanced Search Form.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class AdvancedSearchAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log = 
            Logger.getLogger(AdvancedSearchAction.class.getName());


    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Set the values for the Tumor Search Form.
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

        // default target to success
        String strTarget = "success";
        Timer timerTotal = new Timer();
        timerTotal.start();

        // create a MTBTumorUtilDAO
        MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
        Collection colOrgans = null;

        try {
            // search for organs that only are used by a tumor frequency record
            colOrgans = daoTumorUtil.getOrgansOfOriginWithTFRecord();
        } catch (Exception e) {
            log.error("Error getOrgansOfOriginWithTFRecord", e);
        }

        Map mapStrainTypes = WIConstants.getInstance().getStrainTypes();
        Map mapTumorClass =
                WIConstants.getInstance().getTumorClassifications();
        Map mapAgentTypes = WIConstants.getInstance().getAgentTypes();

        // set the target to failure if we could not retrieve the strain types
        if ((mapStrainTypes == null) || (colOrgans == null) ||
            (mapTumorClass == null)) {
            strTarget = "error";
        } else {
            // put all the variables in the request
            request.setAttribute("organTissueValues", colOrgans);
            request.setAttribute("tumorClassificationValues",
                                 mapTumorClass.values());
            request.setAttribute("agentTypes", mapAgentTypes.values());
            request.setAttribute("strainTypeValues", mapStrainTypes.values());
        }

        timerTotal.stop();

        if (log.isDebugEnabled()) {
            log.debug("TOTAL TIME: " + timerTotal.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none
}
