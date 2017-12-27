/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.util.ArrayList;
import java.util.HashMap;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;

/**
 * The collections for diagnosis and primary sites are built when loading the
 * mice This object makes passing the three lists easier for a single method
 *
 * @author sbn
 */
public class PDXMouseSearchData {

    private ArrayList<String> diagnosis = new ArrayList<String>();
    private ArrayList<String> primarySites = new ArrayList<String>();
    private ArrayList<String> tags = new ArrayList<String>();

    private ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();
    
    private HashMap<String, String> ids = new HashMap<>();

    PDXMouseSearchData() {
    }

    /**
     * @return diagnosis
     */
    public ArrayList<String> getDiagnosis() {
        return diagnosis;
    }

    /**
     * @param diagnosis the diagnosis to set
     */
    public void setDiagnosis(ArrayList<String> diagnosis) {
        this.diagnosis = diagnosis;
    }

    /**
     * @return the primarySites
     */
    public ArrayList<String> getPrimarySites() {
        return primarySites;
    }

    /**
     * @param primarySites the primarySites to set
     */
    public void setPrimarySites(ArrayList<String> primarySites) {
        this.primarySites = primarySites;
    }

    /**
     * @return the mice
     */
    public ArrayList<PDXMouse> getMice() {
        return mice;
    }

    /**
     * @param mice the mice to set
     */
    public void setMice(ArrayList<PDXMouse> mice) {
        this.mice = mice;
    }

    /**
     * @return the tags
     */
    public ArrayList<String> getTags() {
        return tags;
    }

    /**
     * @param tags the tags to set
     */
    public void setTags(ArrayList<String> tags) {
        this.tags = tags;
    }

    /**
     * @return the ids
     */
    public HashMap<String, String> getIds() {
        return ids;
    }

    /**
     * @param ids the ids to set
     */
    public void setIds(HashMap<String, String> ids) {
        this.ids = ids;
    }

}
