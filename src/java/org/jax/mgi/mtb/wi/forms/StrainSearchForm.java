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
 * StrainSearchForm
 *
 * This class is essentially a JavaBean that is used to encapsulate and
 * validate the request parameters submitted by an HTTP request for the
 * Strain search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.ActionForm
 */
public class StrainSearchForm extends ActionForm {

    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 5555568468528737325L;

    // ----------------------------------------------------- Instance Variables
    private String likeClause;
    private String strainName;
    // private String caseSensitive;

    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes
    private Collection strainTypeValues = new ArrayList();
    private String[] strainTypes = new String[0]; // { "No Value Selected " };
    private String geneticName;
    private String jaxStockNumber;
    private String referenceKey;
    private String sortBy = "name";
    private String maxItems = "25";
    private boolean siteJaxMice = false;
    private boolean siteNCIMR = false;
    private String siteValJaxMice;
    private String siteValNCIMR;

    // from genetics
    private String allelePairKey;


    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     *
     * @return
     */
    public final String getSortBy() {
        if (StringUtils.hasValue(this.sortBy)) {
            return this.sortBy;
        }

        return "name";

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

        return "25";
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
    public final String getReferenceKey() {
        return this.referenceKey;
    }

    /**
     *
     * @param refKey
     */
    public final void setReferenceKey(String refKey) {
        this.referenceKey = refKey;
    }


    /**
     *
     * @return
     */
    public final String getLikeClause() {
        if (StringUtils.hasValue(this.likeClause)) {
            return this.likeClause;
        }
        return "contains";
    }

    /**
     *
     * @param likeClause
     */
    public final void setLikeClause(String clause) {
        this.likeClause = clause;
    }

    /**
     *
     * @return
     */
    public final String getStrainName() {
        if (StringUtils.hasValue(this.strainName)) {
            this.strainName = StringUtils.replace(this.strainName, "[", "");
            this.strainName = StringUtils.replace(this.strainName, "]", "");
        }
        return this.strainName;
    }

    /**
     *
     * @param strainName
     */
    public final void setStrainName(String name) {
        this.strainName = name;
    }

  
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
    public final String getJaxStockNumber() {
        return this.jaxStockNumber;
    }

    /**
     *
     * @param jaxStockNumber
     */
    public final void setJaxStockNumber(String num) {
        this.jaxStockNumber = num;
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
    public final void setStrainTypes(String[] types) {
        this.strainTypes = types;
    }

    /**
     *
     * @return
     */
    public final boolean getSiteJaxMice() {
        return this.siteJaxMice;
    }

    /**
     *
     * @param siteJaxMice
     */
    public final void setSiteJaxMice(boolean jaxMice) {
        this.siteJaxMice = jaxMice;
    }

    /**
     *
     * @return
     */
    public final boolean getSiteNCIMR() {
        return this.siteNCIMR;
    }

    /**
     *
     * @param ncimr
     */
    public final void setSiteNCIMR(boolean ncimr) {
        this.siteNCIMR = ncimr;
    }

   
    /**
     *
     * @return
     */
    public final String getSiteValJaxMice() {
        return this.siteValJaxMice;
    }

    /**
     *
     * @param siteValJaxMice
     */
    public final void setSiteValJaxMice(String val) {
        this.siteValJaxMice = val;
    }

    /**
     *
     * @return
     */
    public final String getSiteValNCIMR() {
        return this.siteValNCIMR;
    }

    /**
     *
     * @param val
     */
    public final void setSiteValNCIMR(String val) {
        this.siteValNCIMR= val;
    }

    /**
     *
     * @return
     */
    public final String getAllelePairKey() {
        return this.allelePairKey;
    }

    /**
     *
     * @param key
     */
    public final void setAllelePairKey(String key) {
        this.allelePairKey = key;
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
     * @param request
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {

        return new ActionErrors();
    }

    /**
     * Becuase this ActionForm should be request-scoped, do
     * nothing here.  The fields will be reset when a new instance is created.
     */
    public void reset() {
        siteJaxMice = false;
        siteNCIMR = false;
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none
}

