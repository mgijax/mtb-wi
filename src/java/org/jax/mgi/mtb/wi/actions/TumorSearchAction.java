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
 * Used to set the values for the Tumor Search Form.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class TumorSearchAction extends Action {
    
    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables
    
    private final static Logger log =
            Logger.getLogger(TumorSearchAction.class.getName());

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
        Timer timer = new Timer();
        timer.start();
      
        // create a ReferenceUtilDAO
        MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
        Collection colOrgOrig = null;
        
        try {
            colOrgOrig = daoTumorUtil.getOrgansOfOriginWithTFRecord();
        } catch (Exception e) {
            log.error("Error getOrgansOfOriginWithTFRecord");
        }
        
        Map mapTumorClass = 
                WIConstants.getInstance().getTumorClassifications();
        Map mapAgentTypes = WIConstants.getInstance().getAgentTypes();
        Collection colOrgansMetastasize = getOrgansThatMetastasize();

        // set the target to failure if we could not retrieve the strain types
        if ((colOrgOrig == null) || (mapTumorClass == null) || 
            (colOrgansMetastasize == null)) {
            strTarget = "error";
        } else {
            // put all the variables in the request
            request.setAttribute("agentTypes", mapAgentTypes.values());
            request.setAttribute("organTissueValues", colOrgOrig);
            request.setAttribute("organTissueValuesMets", 
                                 colOrgansMetastasize);
            request.setAttribute("tumorClassificationValues", 
                                 mapTumorClass.values());
        }
      
        timer.stop();
        
        if (log.isDebugEnabled()) {
            log.debug("TumorSearchAction: " + timer.toString());
        }
        
        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods

    /**
     * Get a Collection of organ keys that metastasize.
     *
     * @return A Collection of organ keys that metastasize.
     */
    private Collection getOrgansThatMetastasize() {
        Collection colOrgans = null;
        
        try {
            // get the organs with mets
            MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
            colOrgans = daoTumorUtil.getOrgansThatMetastasize();
        } catch (Exception e) {
            log.error("Error retrieving organs that metastasize", e);
        }
        
        return colOrgans;
    }
}
