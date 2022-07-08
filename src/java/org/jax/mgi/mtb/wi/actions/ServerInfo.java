/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/ServerInfo.java,v 1.3 2005/05/20 13:31:45 mjv Exp $
 * Author: $Author: mjv $
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
//import javax.servlet.jsp.JspFactory;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.LabelValueBean;

/**
 * Debugging struts servlet.
 *
 * @author $Author: mjv $
 * @date $Date: 2005/05/20 13:31:45 $
 * @version $Revision: 1.3 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/ServerInfo.java,v 1.3 2005/05/20 13:31:45 mjv Exp $
 * @see org.apache.struts.action.Action
 */
public class ServerInfo extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(ServerInfo.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception.
     * @see org.apache.struts.action.ActionMapping
     * @see org.apache.struts.action.ActionForm
     * @see javax.servlet.http.HttpServletRequest
     * @see javax.servlet.http.HttpServletResponse
     */
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        log.warn("Server Info invoked!");

       
        String strTarget="success";
        response.setContentType("text/plain");

        ///////////////////////////////////////////////////////////////////////
        // system properties
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrSystemProperties = new ArrayList<LabelValueBean<String,String>>();
        LabelValueBean<String,String> bean = null;

        Properties props = System.getProperties();
        Enumeration eProps = props.propertyNames();
        while (eProps.hasMoreElements()) {
            String propName = (String)eProps.nextElement();
            String propValue = (String)props.get(propName);
            bean = new LabelValueBean<String,String>(propName, propValue);
            arrSystemProperties.add(bean);
        }

        ///////////////////////////////////////////////////////////////////////
        // servlet init parameters
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrServletInitParams = new ArrayList<LabelValueBean<String,String>>();
        bean = null;
        Enumeration e = getServlet().getInitParameterNames();
        while (e.hasMoreElements()) {
            String strKey = (String)e.nextElement();
            String strValue = getServlet().getInitParameter(strKey);
            bean = new LabelValueBean<String,String>(strKey, strValue);
            arrServletInitParams.add(bean);
        }

        ///////////////////////////////////////////////////////////////////////
        // context init parameters
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrContextInitParams = new ArrayList<LabelValueBean<String,String>>();
        bean = null;
        ServletContext context = getServlet().getServletContext();
        Enumeration enumParams = context.getInitParameterNames();
        while (enumParams.hasMoreElements()) {
            String strKey = (String)enumParams.nextElement();
            String strValue = context.getInitParameter(strKey);
            bean = new LabelValueBean<String,String>(strKey, strValue);
            arrContextInitParams.add(bean);
        }

        ///////////////////////////////////////////////////////////////////////
        // context attributes
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrContextAttributes = new ArrayList<LabelValueBean<String,String>>();
        bean = null;
        Enumeration enumAttribs = context.getInitParameterNames();
        enumAttribs = context.getAttributeNames();
        while (enumAttribs.hasMoreElements()) {
            String strKey = (String)enumAttribs.nextElement();
            Object objValue = context.getAttribute(strKey);
            String tempValue = null;

            if (strKey.toLowerCase().indexOf("classpath") >= 0) {
                if (objValue != null) {
                    tempValue = objValue.toString().replace(':', '\n');
                }
            } else {
                if (objValue != null) {
                    tempValue = objValue.toString();
                }
            }

            bean = new LabelValueBean<String,String>(strKey, tempValue);
            arrContextAttributes.add(bean);
        }

        ///////////////////////////////////////////////////////////////////////
        // JVM
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrJVM = new ArrayList<LabelValueBean<String,String>>();
        arrJVM.add(new LabelValueBean<String,String>("Version",
                                   System.getProperty("java.runtime.version")));
        arrJVM.add(new LabelValueBean<String,String>("Vendor",
                                   System.getProperty("java.vm.vendor")));

        arrJVM.add(new LabelValueBean<String,String>("Free Memory",
                formatSize(new Long(Runtime.getRuntime().freeMemory()),
                        true)));
        arrJVM.add(new LabelValueBean<String,String>("Total Memory",
                formatSize(new Long(Runtime.getRuntime().totalMemory()),
                        true)));
        arrJVM.add(new LabelValueBean<String,String>("Max Memory",
                formatSize(new Long(Runtime.getRuntime().maxMemory()),
                        true)));

        ///////////////////////////////////////////////////////////////////////
        // OS
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean> arrOS = new ArrayList<LabelValueBean>();

        arrOS.add(new LabelValueBean<String,String>("Name",
                                  System.getProperty("os.name")));
        arrOS.add(new LabelValueBean<String,String>("Version",
                                  System.getProperty("os.version")));
        arrOS.add(new LabelValueBean<String,String>("Architecture",
                                  System.getProperty("os.arch")));


        ///////////////////////////////////////////////////////////////////////
        // request attributes
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrRequestAttributes = new ArrayList<LabelValueBean<String,String>>();
        bean = null;
        Enumeration enumReqsAtts = request.getAttributeNames();
        while (enumReqsAtts.hasMoreElements()) {
            String strKey = (String)enumReqsAtts.nextElement();
            Object objValue = context.getAttribute(strKey);
            bean = new LabelValueBean<String,String>(strKey, objValue + "");
            arrRequestAttributes.add(bean);
        }

        ///////////////////////////////////////////////////////////////////////
        // details request information
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrRequestInfoDetail = new ArrayList<LabelValueBean<String,String>>();
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Servlet Name",
                                   getServlet().getServletName()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Protocol",
                                   request.getProtocol()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Scheme",
                                   request.getScheme()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Server Name",
                                   request.getServerName()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Server Port",
                                   request.getServerPort()+""));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Server Info",
                                   context.getServerInfo()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Remote Address",
                                   request.getRemoteAddr()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Remote Host",
                                   request.getRemoteHost()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Character Encoding",
                                   request.getCharacterEncoding()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Content Length",
                                   request.getContentLength() + ""));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Content Type",
                                   request.getContentType()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Locale",
                                   request.getLocale() + ""));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Default Response Buffer",
                                   response.getBufferSize() + ""));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Request Is Secure",
                                   request.isSecure() + ""));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Auth Type",
                                   request.getAuthType()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("HTTP Method",
                                   request.getMethod()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Remote User",
                                   request.getRemoteUser()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Request URI",
                                   request.getRequestURI()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Context Path",
                                   request.getContextPath()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Servlet Path",
                                   request.getServletPath()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Path Info",
                                   request.getPathInfo()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Path Translated",
                                   request.getPathTranslated()));
        arrRequestInfoDetail.add(
                new LabelValueBean<String,String>("Query String",
                                   request.getQueryString()));


        ///////////////////////////////////////////////////////////////////////
        // parameter names
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrParamNames = new ArrayList<LabelValueBean<String,String>>();
        Enumeration enumParamNames = request.getParameterNames();
        while (enumParamNames.hasMoreElements()) {
            String strKey = (String)enumParamNames.nextElement();
            String[] arrStrValues = request.getParameterValues(strKey);
            StringBuffer tempVal = new StringBuffer();
            for(int i = 0; i < arrStrValues.length; i++) {
                tempVal.append(arrStrValues[i]);

                if (i != arrStrValues.length - 1) {
                    tempVal.append("<br>");
                }
            }
            arrParamNames.add(
                    new LabelValueBean<String,String>(strKey,
                                       tempVal.toString()));
        }

        ///////////////////////////////////////////////////////////////////////
        // headers
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrHeaders = new ArrayList<LabelValueBean<String,String>>();
        Enumeration enumHeaders = request.getHeaderNames();
        while (enumHeaders.hasMoreElements()) {
            String strKey = (String)enumHeaders.nextElement();
            String strValue = request.getHeader(strKey);
            arrHeaders.add(
                    new LabelValueBean<String,String>(strKey,
                                       strValue));
        }

        ///////////////////////////////////////////////////////////////////////
        // cookies
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrCooks = new ArrayList<LabelValueBean<String,String>>();
        Cookie[] arrCookies = request.getCookies();
        for (int i = 0; i < arrCookies.length; i++) {
            Cookie cookie = arrCookies[i];
            arrCooks.add(
                    new LabelValueBean<String,String>(cookie.getName(),
                                       cookie.getValue()));
        }

        ///////////////////////////////////////////////////////////////////////
        // session info
        ///////////////////////////////////////////////////////////////////////
        List<LabelValueBean<String,String>> arrSessionInfo = new ArrayList<LabelValueBean<String,String>>();
        HttpSession session = request.getSession();
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Requested Session ID",
                                   request.getRequestedSessionId()));
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Current Session ID",
                                   session.getId()));
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Session Created Time",
                                   session.getCreationTime() + ""));
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Session Last Accessed Time",
                                   session.getLastAccessedTime() + ""));
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Requested Session ID",
                                   request.getRequestedSessionId()));
        arrSessionInfo.add(
                new LabelValueBean<String,String>("Max Inactive Interval Seconds",
                                   session.getMaxInactiveInterval() + ""));

        Enumeration enumSessionAttributes = session.getAttributeNames();
        while (enumSessionAttributes.hasMoreElements()) {
            String strName = (String) enumSessionAttributes.nextElement();
            arrHeaders.add(
                    new LabelValueBean<String,String>(strName,
                                       session.getAttribute(strName) + ""));
        }

        String servletSpec = context.getMajorVersion() + "." +
                             context.getMinorVersion();
        //String jspSpec = JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion();

        request.setAttribute("sysProps", arrSystemProperties);
        request.setAttribute("servletSpec", servletSpec);
       // request.setAttribute("jspSpec", jspSpec);
        request.setAttribute("sessionInfo", arrSessionInfo);
        request.setAttribute("cookies", arrCooks);
        request.setAttribute("headers", arrHeaders);
        request.setAttribute("paramNames", arrParamNames);
        request.setAttribute("detailRequestInfo", arrRequestInfoDetail);
        request.setAttribute("servletInitParams", arrServletInitParams);
        request.setAttribute("contextAttributes", arrContextAttributes);
        request.setAttribute("requestAttributes", arrRequestAttributes);
        request.setAttribute("os", arrOS);
        request.setAttribute("jvm", arrJVM);

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }



    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Display the given size in bytes, either as KB or MB.
     *
     * @param mb true to display megabytes, false for kilobytes
     */
    private String formatSize(Object obj, boolean bMB) {

        String strRet = "";
        long lBytes = -1L;

        if (obj instanceof Long) {
            lBytes = ((Long) obj).longValue();
        } else if (obj instanceof Integer) {
            lBytes = ((Integer) obj).intValue();
        }

        if (bMB) {
            long lMegabytes = lBytes / (1024 * 1024);
            long lRest =
                    ((lBytes - (lMegabytes * (1024 * 1024))) * 100) /
                    (1024 * 1024);
            strRet = (lMegabytes + "." + ((lRest < 10) ? "0" : "") +
                   lRest + " MB");
        } else {
            strRet = ((lBytes / 1024) + " KB");
        }

        return strRet;
    }
}
