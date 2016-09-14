package org.jax.mgi.mtb.wi.forms;

import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

public class PDXDashboardForm extends ActionForm {
    
    private String[] tissues = new String[0];
    private Collection tissueValues = new ArrayList();
    
    private String[]sites2 = new String[0];
    
    private String[] sites = new String[0];
    private Collection siteValues = new ArrayList();

  
    public String[] getTissues() {
        return tissues;
    }

    public void setTissues(String[] tissues) {
        this.tissues = tissues;
    }
    
    public String[] getSites2() {
        return sites2;
    }

    public void setSites2(String[] sites2) {
        this.sites2 = sites2;
    }

    /**
     * @return the tissueSitesValues
     */
    public Collection getTissueValues() {
        return tissueValues;
    }

    /**
     * @param tissueSitesValues the tissueSitesValues to set
     */
    public void setTissueValues(Collection tissueValues) {
        this.tissueValues = tissueValues;
    }

      
   

    /**
     * @return the sites
     */
    public String[] getSites() {
        return sites;
    }

    /**
     * @param sites the sites to set
     */
    public void setSites(String[] sites) {
        this.sites = sites;
    }

    /**
     * @return the siteValues
     */
    public Collection getSiteValues() {
        return siteValues;
    }

    /**
     * @param siteValues the siteValues to set
     */
    public void setSiteValues(Collection siteValues) {
        this.siteValues = siteValues;
    }
    
}