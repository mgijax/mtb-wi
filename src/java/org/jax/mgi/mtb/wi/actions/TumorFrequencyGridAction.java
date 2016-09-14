/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Create the information for the tumor frequency grid.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class TumorFrequencyGridAction extends Action {
    
    // -------------------------------------------------------------- Constants
    // none
    
    // ----------------------------------------------------- Instance Variables
    
    private final static Logger log =
            Logger.getLogger(TumorFrequencyGridAction.class.getName());
    
    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    /**
     * Create the information for the tumor frequency grid.
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
        String target = "success";
        
        String strStrainFamilyKey = request.getParameter("strainFamilyKey");
        String strCurrentStrainFamilyKey = request.getParameter("currentStrainFamilyKey");
        String strOrganParentKey = request.getParameter("organKey");
        String strCurrentOrganParentKey = request.getParameter("currentOrganKey");
        
       // MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
        
       
        Map mapGridData = WIConstants.getInstance().getTFGrid();
        
        //List arrOrgans = daoTumorUtil.getTFGridOrgans();
        List arrOrgans = WIConstants.getInstance().getTFGridOrgans();
       
        //List arrStrains = daoTumorUtil.getTFGridStrains();
        List arrStrains = WIConstants.getInstance().getTFGridStrains();
        
        
        request.setAttribute("anatomicalSystems", arrOrgans);
        request.setAttribute("strains", arrStrains);
        request.setAttribute("gridData", mapGridData);

        // for exapand and collapse of strain families and organs
        if (StringUtils.equals(strStrainFamilyKey, strCurrentStrainFamilyKey)) {
            strStrainFamilyKey = "";
            strCurrentStrainFamilyKey = "";
        } else {
            strCurrentStrainFamilyKey = strStrainFamilyKey;
        }

        if (StringUtils.equals(strOrganParentKey, strCurrentOrganParentKey)) {
            strOrganParentKey = "";
            strCurrentOrganParentKey = "";
        } else {
            strCurrentOrganParentKey = strOrganParentKey;
        }
        
        request.setAttribute("strainFamilyKey", strStrainFamilyKey);
        request.setAttribute("currentStrainFamilyKey", strCurrentStrainFamilyKey);
        request.setAttribute("organKey", strOrganParentKey);
        request.setAttribute("currentOrganKey", strCurrentOrganParentKey);
        
           
        // forward to the appropriate View
        return mapping.findForward(target);
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none
}
