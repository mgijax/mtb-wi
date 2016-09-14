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
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

/**
 * ReferenceSearchForm
 *
 * This class is essentially a JavaBean that is used to encapsulate and
 * validate the request parameters submitted by an HTTP request for the
 * Reference search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.ActionForm
 */
public class ReferenceSearchForm extends ActionForm {

    // -------------------------------------------------------------- Constants
    private static final long serialVersionUID = 4444468468528737325L;

    // ----------------------------------------------------- Instance Variables
    private String sortBy = "year desc";
    private String maxItems = "25";
    private String referenceAccessionId;
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
    
      private String[] organTissue = new String[0];
    private Collection organTissueValues = new ArrayList();

    private String[] tumorClassification = new String[0];
    private Collection tumorClassificationValues = new ArrayList();

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
    public final void setMaxItems(String items) {
        this.maxItems = items;
    }

    /**
     *
     * @return
     */
    public final String getReferenceAccessionId() {
        return this.referenceAccessionId;
    }

    /**
     *
     * @param referenceAccessionId
     */
    public final void setReferenceAccessionId(String id) {
        this.referenceAccessionId = id;
    }

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
        final ActionMessages messages = new ActionMessages();
        final ActionMessage message = new ActionMessage("errors.searchForms.reference.valueRequired");

        messages.add(ActionMessages.GLOBAL_MESSAGE, message);
        request.setAttribute("warnings", messages);

        return errors;
    }

    
    public void reset() {
        // no-op'd
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none

    /**
     * @return the organTissueOrigin
     */
    public String[] getOrganTissue() {
        return organTissue;
    }

    /**
     * @param organTissue the organTissue to set
     */
    public void setOrganTissue(String[] organTissue) {
        this.organTissue = organTissue;
    }

    /**
     * @return the organTissueValues
     */
    public Collection getOrganTissueValues() {
        return organTissueValues;
    }

    /**
     * @param organTissueValues the organTissueValues to set
     */
    public void setOrganTissueValues(Collection organTissueValues) {
        this.organTissueValues = organTissueValues;
    }

    /**
     * @return the tumorClassification
     */
    public String[] getTumorClassification() {
        return tumorClassification;
    }

    /**
     * @param tumorClassification the tumorClassification to set
     */
    public void setTumorClassification(String[] tumorClassification) {
        this.tumorClassification = tumorClassification;
    }

    /**
     * @return the tumorClassificationValues
     */
    public Collection getTumorClassificationValues() {
        return tumorClassificationValues;
    }

    /**
     * @param tumorClassificationValues the tumorClassificationValues to set
     */
    public void setTumorClassificationValues(Collection tumorClassificationValues) {
        this.tumorClassificationValues = tumorClassificationValues;
    }


}