package org.jax.mgi.mtb.wi.actions;

import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.PDXLoginForm;

/**
 * validate user and password, if valid add userID to session
 * logging out: remove session attribute
 * @author sbn
 */
public class PDXLoginAction extends Action {
    
       private static final Logger log =
            Logger.getLogger(PDXLoginAction.class.getName());

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String password = request.getParameter("password");
        String userID = request.getParameter("userID");
        String result = "login";

         // all ready logged in?
          if (request.getSession().getAttribute("pdxUser") != null) {
              result = "success";
          }
          
        if ((password != null) && (userID != null)) {

            if (validateUser(userID, password)) {
                HttpSession session = request.getSession(true);

                session.setAttribute("pdxUser", userID);
                result = "success";

            } else {
                request.setAttribute("failure", "failure");
               ((PDXLoginForm)form).setPassword("");
               ((PDXLoginForm)form).setUserID("");
            }

        }
        
        // logging out
        if (request.getParameter("logout") != null) {
            request.getSession().removeAttribute("pdxUser");
            result = "logout";

        }

        return mapping.findForward(result);

    }

    private boolean validateUser(String userID, String password) {
        boolean valid = false;
        HashMap<String,String> usersMap = WIConstants.getInstance().getPDXUserMap();
        if(password.equals(usersMap.get(userID))){
            valid = true;
        }
        
        // if no user or password is configured don't let anyone log in
        if((userID.trim().length()==0) || password.trim().length()==0){
            valid = false;
        }
        
        if(!valid){
            log.info("Login faild for userID:"+userID+" and password:"+password);
             
        }

        return valid;
    }
}
