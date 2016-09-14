/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Used to set the values for the Genetics Search page.  Any variables that
 * require initialization are initialized from the database,
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class GeneticsSearchAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(GeneticsSearchAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Set the values for the Genetics Search Form.
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

        Map mapChromosomes = WIConstants.getInstance().getChromosomes();
        Map mapTypes = WIConstants.getInstance().getAlleleGroupTypes();

        // set the target to failure if we could not retrieve the chromosomes
        // or the allele group types
        if ((mapTypes == null) || (mapChromosomes == null)) {
            strTarget = "error";
        } else {
            // put the variables in the request
            request.setAttribute("chromosomeValues", mapChromosomes.values());
            request.setAttribute("alleleGroupTypeValues", mapTypes.values());
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
