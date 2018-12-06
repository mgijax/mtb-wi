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

    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes

    private String sortBy = "organ";
    private String maxItems = "25";

    // Tumor
    
    private String tumorName;
    private String agent;
    private String agentType;
    private boolean metastasisLimit;
    private boolean mustHaveImages = false;
    private String[] organTissueOrigin = new String[0];
    private Collection organTissueOriginValues = new ArrayList();
    private String[] tumorClassification = new String[0];
    private Collection tumorClassificationValues = new ArrayList();
    private String[] organTissueAffected = new String[0];
    private Collection organTissueAffectedValues = new ArrayList();
    
    // Strain
    
	private String likeClause;
    private String strainName;
    private Collection strainTypeValues = new ArrayList();
    private String[] strainTypes = new String[0]; // { "No Value Selected " };
    private String geneticName;
    private String jaxStockNumber;
    private String referenceKey;
    private boolean siteJaxMice = false;
    private boolean siteNCIMR = false;  
    
	// Reference
	
    private String firstAuthor;
    private String firstAuthorComparison = "equals";
    private String authors;
    private String authorsComparison = "contains";
    private String journal;
    private String journalComparison = "contains";
    private String year;
    private String yearComparison = "equals";
    private String volume;
    private String volumeComparison = "equals";
    private String pages;
    private String pagesComparison = "begins";
    private String title;
    private String titleComparison = "contains";
    

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
    
    
    // Strain section
    
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
   
    
    // Reference
    
	/**
     *
     * @return
     */
    public final String getFirstAuthor() {
        return this.firstAuthor;
    }

    /**
     *
     * @param firstAuthor
     */
    public final void setFirstAuthor(String author) {
        this.firstAuthor = author;
    }

    /**
     *
     * @return
     */
    public final String getFirstAuthorComparison() {
        return this.firstAuthorComparison;
    }

    /**
     *
     * @param firstAuthorComparison
     */
    public final void setFirstAuthorComparison(String authorComparison) {
        this.firstAuthorComparison = authorComparison;
    }

    /**
     *
     * @return
     */
    public final String getAuthors() {
        return this.authors;
    }

    /**
     *
     * @param authors
     */
    public final void setAuthors(String auths) {
        this.authors = auths;
    }

    /**
     *
     * @return
     */
    public final String getAuthorsComparison() {
        return this.authorsComparison;
    }

    /**
     *
     * @param authorsComparison
     */
    public final void setAuthorsComparison(String authsComparison) {
        this.authorsComparison = authsComparison;
    }

    /**
     *
     * @return
     */
    public final String getJournal() {
        return this.journal;
    }

    /**
     *
     * @param journal
     */
    public final void setJournal(String j) {
        this.journal = j;
    }

    /**
     *
     * @return
     */
    public final String getJournalComparison() {
        return this.journalComparison;
    }

    /**
     *
     * @param journalComparison
     */
    public final void setJournalComparison(String jComparison) {
        this.journalComparison = jComparison;
    }

    /**
     *
     * @return
     */
    public final String getYear() {
        return this.year;
    }

    /**
     *
     * @param year
     */
    public final void setYear(String yr) {
        this.year = yr;
    }

    /**
     *
     * @return
     */
    public final String getYearComparison() {
        return this.yearComparison;
    }

    /**
     *
     * @param yearComparison
     */
    public final void setYearComparison(String yrComparison) {
        this.yearComparison = yrComparison;
    }

    /**
     *
     * @return
     */
    public final String getVolume() {
        return this.volume;
    }

    /**
     *
     * @param volume
     */
    public final void setVolume(String vol) {
        this.volume = vol;
    }

    /**
     *
     * @return
     */
    public final String getVolumeComparison() {
        return this.volumeComparison;
    }

    /**
     *
     * @param volumeComparison
     */
    public final void setVolumeComparison(String volComparison) {
        this.volumeComparison = volComparison;
    }

    /**
     *
     * @return
     */
    public final String getPages() {
        return this.pages;
    }

    /**
     *
     * @param pages
     */
    public final void setPages(String pgs) {
        this.pages = pgs;
    }

    /**
     *
     * @return
     */
    public final String getPagesComparison() {
        return this.pagesComparison;
    }

    /**
     *
     * @param pagesComparison
     */
    public final void setPagesComparison(String pgsComparison) {
        this.pagesComparison = pgsComparison;
    }

    /**
     *
     * @return
     */
    public final String getTitle() {
        return this.title;
    }

    /**
     *
     * @param title
     */
    public final void setTitle(String ttl) {
        this.title = ttl;
    }

    /**
     *
     * @return
     */
    public final String getTitleComparison() {
        return this.titleComparison;
    }

    /**
     *
     * @param titleComparison
     */
    public final void setTitleComparison(String ttlComparison) {
        this.titleComparison = ttlComparison;
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