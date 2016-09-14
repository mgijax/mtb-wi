/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.forms;

import org.apache.struts.action.ActionForm;
import org.apache.struts.upload.FormFile;

/**
 *
 * @author sbn
 */
public class PDXLoginForm extends ActionForm  {
    
    private String userID;
    private String password;
 

    /**
     * @return the userID
     */
    public String getUserID() {
        return userID;
    }

    /**
     * @param userID the userID to set
     */
    public void setUserID(String userID) {
        this.userID = userID;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

   
    
}
