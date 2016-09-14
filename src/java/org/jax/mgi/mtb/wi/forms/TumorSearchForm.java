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
 * TumorSearchForm
 *
 * This class is essentially a JavaBean that is used to encapsulate and
 * validate the request parameters submitted by an HTTP request for the
 * Tumor search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.ActionForm
 */
public class TumorSearchForm extends ActionForm {

    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 7777768468528737325L;

    // ----------------------------------------------------- Instance Variables
    private String sortBy = "organ";
    private String maxItems = "25";
    private String tumorName;
    private String agent;
    private String agentType;
    private boolean metastasisLimit;
    private boolean mustHaveImages = false;

    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes
    private String[] organTissueOrigin = new String[0];
    private Collection organTissueOriginValues = new ArrayList();

    private String[] tumorClassification = new String[0];
    private Collection tumorClassificationValues = new ArrayList();

    private String[] organTissueAffected = new String[0];
    private Collection organTissueAffectedValues = new ArrayList();


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
    public final String getTumorName() {
        return this.tumorName;
    }

    /**
     *
     * @param tumorName
     */
    public final void setTumorName(String name) {
        this.tumorName = name;
    }

    /**
     *
     * @return
     */
    public final String getAgent() {
        return this.agent;
    }

    /**
     *
     * @param agent
     */
    public final void setAgent(String ag) {
        this.agent = ag;
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
    public final String[] getOrganTissueAffected() {
        return this.organTissueAffected;
    }

    /**
     *
     * @param organTissueAffected
     */
    public final void setOrganTissueAffected(String[] arr) {
        this.organTissueAffected = arr;
    }

    /**
     *
     * @return
     */
    public final Collection getOrganTissueAffectedValues() {
        return this.organTissueAffectedValues;
    }

    /**
     *
     * @param organTissueAffectedValues
     */
    public final void setOrganTissueAffectedValues(Collection vals) {
        this.organTissueAffectedValues = vals;
    }

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

}