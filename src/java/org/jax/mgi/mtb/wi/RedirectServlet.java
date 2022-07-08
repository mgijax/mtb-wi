/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.jax.mgi.mtb.dao.gen.mtb.AccessionDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AccessionDTO;
import org.jax.mgi.mtb.dao.gen.mtb.SiteLinksDAO;
import org.jax.mgi.mtb.dao.gen.mtb.SiteLinksDTO;
import org.jax.mgi.mtb.utils.StringUtils;

/**
 * The servlet redirects the user to the appropriate URL.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see javax.servlet.http.HttpServlet
 */

public class RedirectServlet extends HttpServlet {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(RedirectServlet.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Perform operations to be executed only upon startup of this application,
     * and not during its regular operation. Most of these operations simply
     * distribute config information present in web.xml to various parts of
     * the program.
     * <p>
     * This method is called by the servlet container just before this servlet
     * is put into service. Note that it is possible that more than one
     * instance of this servlet can be created in the same VM.
     *
     * @param config The ServletConfig object
     * @throws javax.servlet.ServletException
     */
    public void init(ServletConfig config)
        throws ServletException {
        // Initialization code...
        super.init(config);
    }

    /**
     * This method is called by the servlet container to process a GET request.
     * There may be many threads calling this method simultaneously.
     *
     * @param req The HttpServletRequest object
     * @param resp The HttpServletResponse object
     * @throws java.io.IOException
     */
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws IOException {
        processRequest(req, resp);
    }

    /**
     * This method is called by the servlet container to process a POST
     * request.  There may be many threads calling this method simultaneously.
     *
     * @param req The HttpServletRequest object
     * @param resp The HttpServletResponse object
     * @throws java.io.IOException
     */
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws IOException {
        processRequest(req, resp);
    }

    /**
     * Handle all requests for this servlet.
     *
     * @param req The HttpServletRequest object
     * @param resp The HttpServletResponse object
     * @throws java.io.IOException
     */
    private void processRequest(HttpServletRequest req,
                                HttpServletResponse resp)
        throws IOException {

        // get the parameters
        String strKey = req.getParameter("key");
        String strAccId = req.getParameter("accId");
        String strType = req.getParameter("type");
        String strUrl = null;
        int nTypeId = -1;

        if (StringUtils.hasValue(strType)) {
            try {
                nTypeId = Integer.parseInt(strType);
            } catch (Exception e) {
                nTypeId = -1;
            }
        }

        switch (nTypeId) {
            case WIConstants.TYPE_MARKER:
                if (StringUtils.hasValue(strKey)) {
                    strUrl = markerKeyToAccId(strKey);
                } else if (StringUtils.hasValue(strAccId)) {
                    strUrl = markerAccIdToKey(strAccId);
                } else {
                    // do nothing
                    ;
                }
                break;
            case WIConstants.TYPE_REFERENCE:
                if (StringUtils.hasValue(strKey)) {
                    strUrl = referenceKeyToAccId(strKey);
                } else if (StringUtils.hasValue(strAccId)) {
                    strUrl = referenceAccIdToKey(strAccId);
                }

                break;
            default:
                break;
        }

        resp.sendRedirect(strUrl);
    }

    /**
     * Clean up resources, remove objects from application scope.
     *
     * This method is called by the servlet container just after this servlet
     * is removed from service.
     */
    public void destroy() {
        // Shutdown code...
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Convert a marker key to an accession id and return the URL.
     *
     * @param strKey The unique marker identifier
     * @return A URL which is the accession id for the marker key.
     */
    private String markerKeyToAccId(String strKey) {
        // create an Accession DAO
        AccessionDAO daoAcc = AccessionDAO.getInstance();
        SiteLinksDAO daoLinks = SiteLinksDAO.getInstance();
        String url = null;

        try {
            AccessionDTO dtoAcc = daoAcc.createAccessionDTO();
            dtoAcc.setMTBTypesKey(2l);
            dtoAcc.setObjectKey(Integer.parseInt(strKey));
            dtoAcc.setSiteInfoKey(1l);

            // should only be 1 element
            List<AccessionDTO> listDTOAcc = daoAcc.loadUsingTemplate(dtoAcc);

            // key 106 is a MGI 5.0 marker specific site link
            SiteLinksDTO DTOSite = daoLinks.loadByPrimaryKey(106L);

            url = StringUtils.replace(DTOSite.getUrl(),
                                      "@@@@",
                                      listDTOAcc.get(0).getAccID());
        } catch (Exception e) {
            log.error("Error converting marker key to accession id", e);
        }

        return url;
    }

    /**
     * Convert a marker accession id to a marker key and return the URL.
     * Currently no-op'd.
     *
     * @param strAccID The marker accession id
     * @return A URL which is the marker key for the accession id.
     */
    private String markerAccIdToKey(String strAccID) {
        log.warn("Method should not be called: markerAccIdToKey");
        return null;
    }

    /**
     * Convert a reference key to an accession id and return the URL.
     * Currently no-op'd.
     *
     * @param strKey The unique reference identifier
     * @return A URL which is the accession id for the reference key.
     */
    private String referenceKeyToAccId(String strKey) {
       log.warn("Method should not be called: referenceKeyToAccId");
        return null;
    }

    /**
     * Convert a reference accession id to a reference key and return the URL.
     * Currently no-op'd.
     *
     * @param strAccID The reference accession id
     * @return A URL which is the reference key for the accession id.
     */
    private String referenceAccIdToKey(String strAccID) {
        log.warn("Method should not be called: referenceAccIdToKey");
        return null;
    }
}
