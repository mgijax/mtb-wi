/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.forms;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collection;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import org.jax.mgi.mtb.utils.StringUtils;

/**
 * AdvancedSearchForm
 * 
 * This class is essentially a JavaBean that is used to encapsulate and 
 * validate the request parameters submitted by an HTTP request for the
 * Tumor search.
 * 
 * 
 * @author $Author$
 * @version $Revision$
 * @see org.apache.struts.action.ActionForm
 * @cvsheader $Header$
 * @date $Date$
 */
public class AdvancedSearchForm extends ActionForm {
    
    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 7771625134342310025L;
    
    // ----------------------------------------------------- Instance Variables
    private String sortBy = "tumorclassification";
    private String maxItems = "25";

    // strain section variables
    private String strainNameComparison;
    private String strainName;
    private String[] strainTypes = new String[0];
    private Collection strainTypeValues = new ArrayList();
    private String geneticName;
    
    // tumor section variables
    private String[] organTissueOrigin = new String[0];
    private Collection organTissueOriginValues = new ArrayList();
    private String[] tumorClassification = new String[0];
    private Collection tumorClassificationValues = new ArrayList();
    private String agentType;
    private boolean metastasisLimit = false;
    private boolean mustHaveImages = false;
    
    // temp
    private String colonySize;
    private String freqNum;

    
    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    
    
    /**
     * 
     * @return 
     */
    public final boolean getMustHaveImages() {
        return this.mustHaveImages;
    }
    
    /**
     * 
     * @param mustHaveImages 
     */
    public final void setMustHaveImages(boolean images) {
        this.mustHaveImages = images;
    }
    
    public final String getGeneticName() {
        return this.geneticName;
    }
    
    /**
     * 
     * @param geneticName 
     */
    public final void setGeneticName(String name) {
        this.geneticName = name;
    }
    
    /**
     * 
     * @return 
     */
    public final String getSortBy() {
        if (StringUtils.hasValue(this.sortBy)) {
            return this.sortBy;
        }
        
        return "organ";
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
        if (StringUtils.hasValue(this.maxItems)) {
            return this.maxItems;
        }
        
        return "100";
    }
    
    /**
     * 
     * @param maxItems 
     */
    public final void setMaxItems(String max) {
        this.maxItems = max;
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
    public final void setOrganTissueOrigin(String[] arr) {
        this.organTissueOrigin = arr;
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
    public final String[] getTumorClassification() {
        return this.tumorClassification;
    }
    
    /**
     * 
     * @param tumorClassification 
     */
    public final void setTumorClassification(String[] arr) {
        this.tumorClassification = arr;
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
    public final boolean getMetastasisLimit() {
        return this.metastasisLimit;
    }
    
    /**
     * 
     * @param metastasisLimit 
     */
    public final void setMetastasisLimit(boolean limit) {
        this.metastasisLimit = limit;
    }
    
    /**
     * 
     * @return 
     */
    public final String getAgentType() {
        return this.agentType;
    }
    
    /**
     * 
     * @param agentType 
     */
    public final void setAgentType(String type) {
        this.agentType = type;
    }

    /**
     * 
     * @return 
     */
    public final String getStrainNameComparison() {
        return this.strainNameComparison;
    }
    
    /**
     * 
     * @param strainNameComparison 
     */
    public final void setStrainNameComparison(String comparison) {
        this.strainNameComparison = comparison;
    }

    /**
     * 
     * @return 
     */
    public final String getStrainName() {
        return this.strainName;
    }
    
    /**
     * 
     * @param strainName 
     */
    public final void setStrainName(String name) {
        this.strainName = name;
    }

    
    /**
     * 
     * @return 
     */
    public final Collection getStrainTypeValues() {
        return this.strainTypeValues;
    }
    
    /**
     * 
     * @param strainTypeValues 
     */
    public final void setStrainTypeValues(Collection vals) {
        this.strainTypeValues = vals;
    }
    
    /**
     * 
     * @return 
     */
    public final String[] getStrainTypes() {
        return this.strainTypes;
    }

    /**
     * 
     * @param strainTypes 
     */
    public final void setStrainTypes(String[] arr) {
        this.strainTypes = arr;
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
        
        // no validation for now

        return errors;
    }
   
    /**
     * Becuase this ActionForm should be request-scoped, do 
     * nothing here.  The fields will be reset when a new instance is created.
     */
    public void reset() {
        mustHaveImages = false;
        metastasisLimit = false;
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none

    /**
     * @return the colonySize
     */
    public String getColonySize() {
        return colonySize;
    }

    /**
     * @param colonySize the colonySize to set
     */
    public void setColonySize(String colonySize) {
        this.colonySize = colonySize;
    }

    /**
     * @return the freqNum
     */
    public String getFreqNum() {
        return freqNum;
    }

    /**
     * @param freqNum the freqNum to set
     */
    public void setFreqNum(String freqNum) {
        this.freqNum = freqNum;
    }
    
}