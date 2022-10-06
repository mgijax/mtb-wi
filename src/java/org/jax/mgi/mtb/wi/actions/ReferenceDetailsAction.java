/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceDetailDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainNotesDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.utils.RefGridsList;

/**
 * Retrieve the detail information about a reference record.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class ReferenceDetailsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(ReferenceDetailsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * There are two ways to display the details of a reference.
     * <ol>
     * <li>By the key value of the reference table (parameter is 
     *     key
     * <li>By the accession id (parameter is accId
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
        

        String strKey = request.getParameter("key");
        String strAccId = request.getParameter("accId");
        MTBReferenceDetailDTO dtoRefDetail = null;
        

        if (StringUtils.hasValue(strKey) && StringUtils.hasValue(strAccId)) {
            // both parameters should not be used because there could
            // potentially be a conflict of them not referring to
            // the same data object
            request.setAttribute("key", strKey);
            request.setAttribute("accId", strAccId);
            return mapping.findForward("error");
        } else if ((!StringUtils.hasValue(strKey)) && 
                   (!StringUtils.hasValue(strAccId))) {
            // one of the paremeters must contain a value
            return mapping.findForward("error");
        } else if ((!StringUtils.hasValue(strKey)) && 
                   (StringUtils.hasValue(strAccId))) {
            // search by accession id
            try {
                dtoRefDetail = getReferenceByAccession(strAccId);
                
            } catch (Exception e) {
                request.setAttribute("accId", strAccId);
                return mapping.findForward("error");
            }
        } else {
            // search by reference key
            try {
                dtoRefDetail = getReference(Long.parseLong(strKey));
            } catch (Exception e) {
                request.setAttribute("key", strKey);
                return mapping.findForward("error");
            }
        }

    

        // set the target to failure if we could not retrieve the reference
        if (dtoRefDetail == null) {
            strTarget = "failure";
        } else {
            // put the reference DTO in the request
            request.setAttribute("reference", dtoRefDetail);
            request.setAttribute("notes", getStrainNotes(dtoRefDetail));
            request.setAttribute("grid",RefGridsList.getGrid(dtoRefDetail.getKey()+""));
        }
        
     //   log.debug(FieldPrinter.getFieldsAsString(dtoRefDetail));


        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Retrieve a MTBReferenceDetailDTO object by it's unique 
     * identifier.
     *
     * @param lKey The unique id
     * @return A MTBReferenceDetailDTO object
     */
    private MTBReferenceDetailDTO getReference(long lKey) {
        // create a MTBReferenceUtilDAO
        MTBReferenceUtilDAO daoRefUtil = MTBReferenceUtilDAO.getInstance();

        MTBReferenceDetailDTO dtoRefDetail = null;

        try {
            dtoRefDetail = daoRefUtil.getReference(lKey);
        } catch (Exception e) {
            log.warn("Error retrieving reference, key = " + lKey, e);
        }

        return dtoRefDetail;
    }

    /**
     * Retrive a MTBReferenceDetailDTO object by it's accession
     * identifier.
     *
     * @param strAccId The accession id
     * @return A MTBReferenceDetailDTO object
     */
    private MTBReferenceDetailDTO getReferenceByAccession(String strAccId) {
        // create a MTBReferenceUtilDAO
        MTBReferenceUtilDAO daoRefUtil = MTBReferenceUtilDAO.getInstance();

        MTBReferenceDetailDTO dtoRefDetail = null;

        try {
            dtoRefDetail = daoRefUtil.getReferenceByAccession(strAccId);
        } catch (Exception e) {
            log.warn("Error retrieving reference, accId = " + strAccId, e);
        }

        return dtoRefDetail;
    }
    
    private List<StrainNotesDTO> getStrainNotes(MTBReferenceDetailDTO detail) {
        // create a MTBReferenceUtilDAO
        MTBReferenceUtilDAO daoRefUtil = MTBReferenceUtilDAO.getInstance();
         List<StrainNotesDTO> notes = new ArrayList<>();
        try {
          notes  = daoRefUtil.getStrainNotes(detail.getKey(),"<br>");
        } catch (Exception e) {
            log.warn("Error retrieving reference for " + detail.getKey(), e);
        }

        return notes;
    }
}
