/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.forms;



import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.*;
import java.util.ArrayList;
import java.util.Collection;


/**
 * QuickSearchForm
 *
 * This class is essentially a JavaBean that is used to encapsulate and 
 * validate the request parameters submitted by an HTTP request.
 * 
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.ActionForm
 */
public class QuickSearchForm extends ActionForm {
    
    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 3333368468528737325L;
    
    // ----------------------------------------------------- Instance Variables
    
    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes
    private Collection quickSearchSectionValues = new ArrayList();
    private String[] quickSearchSections = new String[0];
    private String quickSearchTerm;

    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    /**
     * 
     * @return 
     */
    public final Collection getQuickSearchSectionValues() {
        return this.quickSearchSectionValues;
    }
    
    /**
     * 
     * @param quickSearchSectionValues 
     */
    public final void setQuickSearchSectionValues(Collection vals) {
        this.quickSearchSectionValues = vals;
    }

    /**
     * 
     * @return 
     */
    public final String[] getQuickSearchSections() {
        return this.quickSearchSections;
    }

    /**
     * 
     * @param quickSearchSections 
     */
    public final void setQuickSearchSections(String[] arr) {
        this.quickSearchSections = arr;
    }
    
    /**
     * 
     * @return 
     */
    public final String getQuickSearchTerm() {
        return this.quickSearchTerm;
    }

    /**
     * 
     * @param quickSearchTerm 
     */
    public final void setQuickSearchTerm(String term) {
        this.quickSearchTerm = term;
    }
    
    /**
     * Validate the properties that have been sent from the HTTP request,
     * and return an ActionErrors object that encapsulates any validation
     * errors that have been found.  If no errors are found, return an
     * empty ActionErrors object.
     * <p>
     * This method is called by the RequestProcessor if the
     * ActionForm has been configured for validation.
     *
     * @param mapping 
     */
    public ActionErrors validate(ActionMapping mapping, 
            HttpServletRequest request) {

        final ActionErrors errors=new ActionErrors();

        return errors;
    }
   
    /**
     * Becuase this ActionForm should be request-scoped, do 
     * nothing here.  The fields will be reset when a new instance is created.
     */
    public void reset() {
    }
    
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none
}