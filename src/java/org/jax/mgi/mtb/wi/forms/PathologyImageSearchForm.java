/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.forms;

import java.util.ArrayList;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/**
 * PathologySearchForm
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
public class PathologyImageSearchForm extends ActionForm {
    
    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 2222268468528737325L;
    
    // ----------------------------------------------------- Instance Variables

    private String sortBy = "organ";
    private String maxItems = "5";
    private String method;
    private String referenceKey;

    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes
    private String[] organTissueOrigin = new String[0];
    private Collection organTissueOriginValues = new ArrayList();
    
    private String[] tumorClassification = new String[0];
    private Collection tumorClassificationValues = new ArrayList();

    private String[] antibody = new String[0]; // { "No Value Selected " };
    private Collection antibodyValues = new ArrayList();
    
    private String strOrganTissueAffected;
    private String strDiagnosisDescription;

    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    /**
     * 
     * @return 
     */
    public final String getSortBy() {
        return this.sortBy;
    }
    
    /**
     * 
     * @param sortBy 
     */
    public final void setSortBy(String sort) {
        this.sortBy = sort;
    }

    /**
     * 
     * @return 
     */
    public final String getMaxItems() {
        return this.maxItems;
    }
    
    /**
     * 
     * @param maxItems 
     */
    public final void setMaxItems(String max) {
        this.maxItems = max;
    }
    
    public String getDiagnosisDescription() {
        return this.strDiagnosisDescription;
    }
    
    public void setDiagnosisDescription(String val) {
        this.strDiagnosisDescription = val;
    }
                     
    public String getOrganTissueAffected() {
        return this.strOrganTissueAffected;
    }
    
    public void setOrganTissueAffected(String val) {
        this.strOrganTissueAffected = val;
        
    }

    /**
     * 
     * @return 
     */
    public final String[] getOrganTissueOrigin() {
        return this.organTissueOrigin;
    }
    
    /**
     * 
     * @param organTissueOrigin 
     */
    public final void setOrganTissueOrigin( String[] origin) {
        this.organTissueOrigin = origin;
    }

    /**
     * 
     * @return 
     */
    public final Collection getOrganTissueOriginValues() {
        return this.organTissueOriginValues;
    }
    
    /**
     * 
     * @param organTissueOriginValues 
     */
    public final void setOrganTissueOriginValues(Collection vals) {
        this.organTissueOriginValues = vals;
    }

    /**
     * 
     * @return 
     */
    public final String getReferenceKey() {
        return this.referenceKey;
    }
    
    /**
     * 
     * @param refKey 
     */
    public final void setReferenceKey(String key) {
        this.referenceKey = key;
    }

    /**
     * 
     * @return 
     */
    public final Collection getOrganTissueAffectedValues() {
        return this.organTissueOriginValues;
    }
    
    /**
     * 
     * @param organTissueOriginValues 
     */
    public final void setOrganTissueAffectedValues(Collection vals) {
        this.organTissueOriginValues = vals;
    }

    /**
     * 
     * @return 
     */
    public final String[] getTumorClassification() {
        return this.tumorClassification;
    }
    
    /**
     * 
     * @param tumorClassification 
     */
    public final void setTumorClassification( String[] classification) {
        this.tumorClassification = classification;
    }

    /**
     * 
     * @return 
     */
    public final Collection getTumorClassificationvValues() {
        return this.tumorClassificationValues;
    }
    
    /**
     * 
     * @param tumorClassificationValues 
     */
    public final void setTumorClassificationValues(Collection vals) {
        this.tumorClassificationValues = vals;
    }

    /**
     * 
     * @return 
     */
    public final String getMethod() {
        return this.method;
    }
    
    /**
     * 
     * @param method 
     */
    public final void setMethod(String meth) {
        this.method = meth;
    }

    /**
     * 
     * @return 
     */
    public final String[] getAntibody() {
        return this.antibody;
    }
    
    /**
     * 
     * @param antibody 
     */
    public final void setAntibody(String[] arr) {
        this.antibody = arr;
    }

    /**
     * 
     * @return 
     */
    public final Collection getAntibodyValues() {
        return this.antibodyValues;
    }
    
    /**
     * 
     * @param antibodyValues 
     */
    public final void setAntibodyValues(Collection vals) {
        this.antibodyValues = vals;
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