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
 * This class is essentially a JavaBean that is used to encapsulate and 
 * validate the request parameters submitted by an HTTP request for the
 * Genetics search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.ActionForm
 */
public class GeneticsSearchForm extends ActionForm {
    
    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 1111168468528737325L;
    
    // ----------------------------------------------------- Instance Variables
    private String sortBy = "Gene Symbol";
    private String maxItems = "100";
    // note for a multiselect box to work and retain values on an error
    // you need to have both a collection and an array
    // see the jsp for attributes
    private String alleleName;
    private String alleleNameComparison = "Contains";
    private String markerName;
    private String markerNameComparison = "Contains";
    private String[] chromosome = new String[0]; 
    private Collection chromosomeValues = new ArrayList();
    
    private String[] alleleGroupType = new String[0]; 
    private Collection alleleGroupTypeValues = new ArrayList();
    
    private boolean assayImages = false;
    
   
    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    /**
     * Get the order in which to sort the results.
     *
     * @return The value which specifies which order to sort the results.
     */
    public final String getSortBy() {
        return this.sortBy;
    }
    
    /**
     * Set the order in which to sort the results.
     *
     * @param sortBy The value which specifies which order to sort the results.
     */
    public final void setSortBy(String sort) {
        this.sortBy = sort;
    }

    /**
     * Get the maximum number of items to find.
     *
     * @return The maximum number of items to find.
     */
    public final String getMaxItems() {
        return this.maxItems;
    }
    
    /**
     * Set the maximum number of items to find.
     *
     * @param max The maximum number of items to find.
     */
    public final void setMaxItems(String max) {
        this.maxItems = max;
    }

    /**
     * Get the alleleName value.
     *
     * @return The alleleName value.
     */
    public final String getAlleleName() {
        return this.alleleName;
    }
    
    /**
     * Set the alleleName value.
     *
     * @param name The alleleName value.
     */
    public final void setAlleleName(String name) {
        this.alleleName = name;
    }

    /**
     * Get the alleleNameComparison value.
     *
     * @return The alleleNameComparison value.
     */
    public final String getAlleleNameComparison() {
        return this.alleleNameComparison;
    }
    
    /**
     * Set the alleleNameComparison value.
     *
     * @param comparison The alleleNameComparison value.
     */
    public final void setAlleleNameComparison(String comparison) {
        this.alleleNameComparison = comparison;
    }

    /**
     * Get the markerName value.
     *
     * @return The markerName value.
     */
    public final String getMarkerName() {
        return this.markerName;
    }
    
    /**
     * Set the markerName value.
     *
     * @param name The markerName value.
     */
    public final void setMarkerName(String name) {
        this.markerName = name;
    }
    
    /**
     * Get the markerNameComparison value.
     *
     * @return The markerNameComparison value.
     */
    public final String getMarkerNameComparison() {
        return this.markerNameComparison;
    }
    
    /**
     * Set the markerNameComparison value.
     *
     * @param comparison The markerNameComparison value.
     */
    public final void setMarkerNameComparison(String comparison) {
        this.markerNameComparison = comparison;
    }

    /**
     * Get the chromosome values.
     *
     * @return The chromosome values.
     */
    public final String[] getChromosome() {
        return this.chromosome;
    }
    
    /**
     * Set the chromosome values.
     *
     * @param arr The chromsome values.
     */
    public final void setChromosome(String[] arr) {
        this.chromosome = arr;
    }

    /**
     * Get the chromosomeValues value.
     *
     * @return The chromosomeValues value.
     */
    public final Collection getChromosomeValues() {
        return this.chromosomeValues;
    }
    
    /**
     * Set the chromosomeValues value.
     *
     * @param values The chromosomeValues value.
     */
    public final void setChromosomeValues(Collection values) {
        this.chromosomeValues = values;
    }

    /**
     * Get the alleleGroupType values.
     *
     * @return The alleleGroupType values.
     */
    public final String[] getAlleleGroupType() {
        return this.alleleGroupType;
    }
    
    /**
     * Set the alleleGroupType values.
     *
     * @param arr The alleleGroupType values.
     */
    public final void setAlleleGroupType(String[] arr) {
        this.alleleGroupType = arr;
    }

    /**
     * Get the alleleGroupTypeValues value.
     *
     * @preturn The alleleGroupTypeValues values.
     */
    public final Collection getAlleleGroupTypeValues() {
        return this.alleleGroupTypeValues;
    }
    
    /**
     * Set the alleleGroupTypeValues value.
     *
     * @param values The alleleGroupTypeValues values.
     */
    public final void setAlleleGroupTypeValues(Collection values) {
        this.alleleGroupTypeValues = values;
    }
    
    public final void setAssayImages(boolean value){
      this.assayImages = value;
    }
    
    public final boolean getAssayImages(){
      return this.assayImages;
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

        final ActionErrors errors = new ActionErrors();
        
        // no validation as of now
        
        return errors;
    }
   
    /**
     * Becuase this ActionForm should be request-scoped, do 
     * nothing here.  The fields will be reset when a new instance is created.
     */
    public void reset() {
        // no-op'd
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none
}
