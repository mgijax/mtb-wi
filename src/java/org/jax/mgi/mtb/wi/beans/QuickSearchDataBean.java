/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.beans;

/**
 * Simple Java bean to data associated with the Quick Search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 */
public class QuickSearchDataBean {

    // -------------------------------------------------------------- Constants
    // none
    
    // ----------------------------------------------------- Instance Variables

    private String strId = null;
    private String strSearchName = null;
    private String strSearchUrl = null;
    private String strMainSearchName = null;
    private String strMainSearchUrl = null;
    private String strSearchText = null;
    private String strSearchCriteriaText = null;
    private String strSearchResultsText = null;
    private String strViewAllName =  null;
    private String strViewAllUrl =  null;
    
    // ----------------------------------------------------------- Constructors
    // none

    
    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the identifier for the search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the identifier for the search.
     */
    public final String getId() {
        return this.strId;
    }

    /**
     * 
     * @param identifier
     */
    public final void setId(String identifier) {
        this.strId = identifier;
    }

    /**
     * Retrieve the name of the search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search name.
     */
    public final String getSearchName() {
        return this.strSearchName;
    }

    /**
     * 
     * @param name
     */
    public final void setSearchName(String name) {
        this.strSearchName = name;
    }

    /**
     * Retrieve the url of the search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search url.
     */
    public final String getSearchUrl() {
        return this.strSearchUrl;
    }

    /**
     * 
     * @param url
     */
    public final void setSearchUrl(String url) {
        this.strSearchUrl = url;
    }

    /**
     * Retrieve the name of the main search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search name.
     */
    public final String getMainSearchName() {
        return this.strMainSearchName;
    }

    /**
     * 
     * @param name
     */
    public final void setMainSearchName(String name) {
        this.strMainSearchName = name;
    }

    /**
     * Retrieve the url of the main search for this section.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search url.
     */
    public final String getMainSearchUrl() {
        return this.strMainSearchUrl;
    }

    /**
     * 
     * @param url
     */
    public final void setMainSearchUrl(String url) {
        this.strMainSearchUrl = url;
    }

    /**
     * Retrieve the search results text for this section.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search results text.
     */
    public final String getSearchText() {
        return this.strSearchText;
    }

    /**
     * 
     * @param text
     */
    public final void setSearchText(String text) {
        this.strSearchText = text;
    }

    /**
     * Retrieve the search results criteria text for this section.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search results text.
     */
    public final String getSearchCriteriaText() {
        return this.strSearchCriteriaText;
    }

    /**
     * 
     * @param text
     */
    public final void setSearchCriteriaText(String text) {
        this.strSearchCriteriaText = text;
    }

    /**
     * Retrieve the search results text for this section.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search results text.
     */
    public final String getSearchResultsText() {
        return this.strSearchResultsText;
    }

    /**
     * 
     * @param text
     */
    public final void setSearchResultsText(String text) {
        this.strSearchResultsText = text;
    }


    /**
     * Retrieve the name of the view all search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the view all name.
     */
    public final String getViewAllName() {
        return this.strViewAllName;
    }

    /**
     * 
     * @param name
     */
    public final void setViewAllName(String name) {
        this.strViewAllName = name;
    }

    /**
     * Retrieve the url of the search.
     * <p>
     * <i>Note this is declared as final for optimation purposes.  Java can 
     * inline functions that are static, private, or declared final.</i>
     *
     * @return A String containing the search url.
     */
    public final String getViewAllUrl() {
        return this.strViewAllUrl;
    }

    /**
     * 
     * @param url
     */
    public final void setViewAllUrl(String url) {
        this.strViewAllUrl = url;
    }
    
    /**
     * Initialize this object's values from ref
     * . 
     * @param ref The object to copy.
     */
    public void copy(QuickSearchDataBean ref) {
        setId(ref.getId());
        setMainSearchName(ref.getMainSearchName());
        setMainSearchUrl(ref.getMainSearchUrl());
        setSearchName(ref.getSearchName());
        setSearchCriteriaText(ref.getSearchCriteriaText());
        setSearchResultsText(ref.getSearchResultsText());
        setSearchText(ref.getSearchText());
        setSearchUrl(ref.getSearchUrl());
        setViewAllName(ref.getViewAllName());
        setViewAllUrl(ref.getViewAllUrl());
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none
}
