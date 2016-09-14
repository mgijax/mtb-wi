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

/**
 * Redirect to the appropriate detail page based upon the id.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class AccessionAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log = 
            Logger.getLogger(AccessionAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the detail information about a strain record.
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
        
        if (log.isDebugEnabled()) {
            log.debug("Accession Action invoked!");
        }
/*
        // default target to error
        String strTarget = "error";
        Timer timer = new Timer();
        timer.start();

        String strId = request.getParameter("id");
        String strKey = null;
        String strType = null;
        Timer daoTimer = new Timer();
        daoTimer.start();

        if (StringUtils.hasValue(strId)) {
            try {
                MTBStrainUtilDAO daoStrainUtil = MTBStrainUtilDAO.getInstance();
                MTBStrainDetailDTO dtoStrainDetail = null;

                try {
                    dtoStrainDetail = daoStrainUtil.getStrain(lKey, bSimple);
                } catch (Exception e) {
                    log.error("Error retrieving MTBStrainDetailDTO, key: " + lKey, e);
                }
            } catch (Exception e) {
                log.error("Error retrieving strain detail, key =" + strId, e);
            }
        }

        daoTimer.stop();

        if (log.isDebugEnabled()) {
            log.debug("AccessionAction: DAO TIME: " + daoTimer.toString());
        }

        ActionRedirect redirect = new ActionRedirect(mapping.findForward(strTarget));
        redirect.addParameter("key",strKey);

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("AccessionAction: " + timer.toString());
            log.debug("AccessionAction: " + strTarget);
        }

        timer = null;

        return redirect;
 */
        return null;
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none

}
