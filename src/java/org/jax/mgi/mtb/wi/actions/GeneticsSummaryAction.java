/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsSummaryDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;
import org.jax.mgi.mtb.utils.Timer;

/**
 * Retreives the genetics summary.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */ 
public class GeneticsSummaryAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(GeneticsSummaryAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Perform the summary.
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
        Timer timerDao = new Timer();
        MTBGeneticsUtilDAO daoG = null;
        MTBGeneticsSummaryDTO dtoG = null;

        timerTotal.start();

        // parameters
        String strAlleleTypeKey = request.getParameter("alleleTypeKey");
        String strMarkerKey = request.getParameter("markerKey");
        long lAlleleTypeKey = -1l;
        long lMarkerKey = -1l;

        timerDao.start();

        // create the DAO
        daoG = MTBGeneticsUtilDAO.getInstance();

        try {
            lAlleleTypeKey = Long.parseLong(strAlleleTypeKey);
            lMarkerKey = Long.parseLong(strMarkerKey);

            dtoG = daoG.getGeneticsSummary(lAlleleTypeKey, lMarkerKey);
        } catch (Exception e) {
            log.error("Error genetics summary", e);
            log.error("alleleTypeKey=" + lAlleleTypeKey);
            log.error("markerKey=" + lMarkerKey);
        }

        timerDao.stop();
        if (log.isDebugEnabled()) {
            log.debug("GeneticsSummaryAction: DAO TIME: " + 
                        timerDao.toString());
        }

        // set the target to failure if we could not retrieve the strain types
        if (dtoG == null) {
            log.error("GeneticsSummaryAction: ERROR: genetics == null");
            strTarget = "error";
        } else {
            // put the genetics summary in the request
            request.setAttribute("genetics", dtoG);
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
