package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import javax.mail.*;
import java.util.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn
 * This doesn't work on DEV!
 */
public class PDXRequestAction extends Action {
    
  
    
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String mice = request.getParameter("mice");
        String email = request.getParameter("email");
        String org = request.getParameter("org");
        String name = request.getParameter("name");
        String title = request.getParameter("title");
        String comments = request.getParameter("comments");
        String mr = request.getParameter("Mr");

        String result = "form";

        if (email != null) {
            sendEmail(mice, email, org, name, title, comments, mr);
            result = "search";
        } else {
            request.setAttribute("mice", mice);
        }
        return mapping.findForward(result);

    }

    private void sendEmail(String mice, String email, String org, String name, String title, String comments, String mr) throws Exception{
      
            String smtpHost = "smtp.jax.org";
            
      
            String recipient = WIConstants.getInstance().getPDXEmail();
        //   String recipient2 = "micetech@jax.org";
            
    
            String subject = "PDX Information Request";
            
            
            StringBuffer body = new StringBuffer();
            body.append("A request for information from the MTB PDX search form.\n");
            body.append(mr).append(" ").append(name).append("\n");
            body.append("A ").append(title).append(" at ").append(org).append(".\n");
            body.append("Has requested information on PDX mice: ").append(mice).append(".\n");
            body.append("Comments: ").append(comments);

            Properties props = new Properties();
            props.put("mail.smtp.host", smtpHost);

            javax.mail.Session session = Session.getDefaultInstance(props, null);

            // create a message
            Message msg = new MimeMessage(session);

            // set the from and to address
            InternetAddress addressFrom = new InternetAddress(email);
      
            msg.setFrom(addressFrom);

            InternetAddress addressTo1 = new InternetAddress(recipient);
    //        InternetAddress addressTo2 = new InternetAddress(recipient2);
            //InternetAddress addressTo3 = new InternetAddress(recipient3);
            InternetAddress recipients[] = {addressTo1};

            msg.setRecipients(Message.RecipientType.TO, recipients);

            // Setting the Subject and Content Type
            msg.setSubject(subject);
            msg.setContent(body.toString(), "text/plain");
            try{
             Transport.send(msg);
            }catch (Exception e){
                e.printStackTrace();
            }
    }
}
