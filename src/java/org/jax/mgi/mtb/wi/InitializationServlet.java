/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Properties;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.dao.mtb.DAOManagerMTB;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.pdx.ElimsUtil;
import org.jax.mgi.mtb.wi.pdx.ModelCounts;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * The servlet that starts when the server starts.  Configured via the web.xml
 * file, this servlet initializes all variables that will be used in this
 * webapp.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see javax.servlet.http.HttpServlet
 */
public class InitializationServlet extends HttpServlet {

    // -------------------------------------------------------------- Constants
    private final String JDBC_DRIVER = "jdbc.driver";
    private final String JDBC_PASSWORD = "jdbc.password";
    private final String JDBC_URL = "jdbc.url";
    private final String JDBC_USER = "jdbc.user";
    private final String MGI_JDBC_DRIVER = "mgi.jdbc.driver";
    private final String MGI_JDBC_PASSWORD = "mgi.jdbc.password";
    private final String MGI_JDBC_URL = "mgi.jdbc.url";
    private final String MGI_JDBC_USER = "mgi.jdbc.user";
   
    private final String PDX_JDBC_USER = "pdx.jdbc.user";
    private final String PDX_JDBC_PWD = "pdx.jdbc.password";
    private final String ELIMS_USER = "elims.username";
    private final String ELIMS_PWD = "elims.password";
    private final static Logger log =
            Logger.getLogger(InitializationServlet.class.getName());

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

        log.info("Initialization started...");

        // attempt to use the properties file
        log.info("=> Initializing variables from properties file...");

        Properties properties = new Properties();

        try {
            String fileName = config.getInitParameter("propertiesFile");
            File file = new File(fileName);
            if (!file.canRead()) {
                fileName = config.getServletContext().getRealPath(fileName);
            }
            if (StringUtils.hasValue(fileName)) {
                log.info("=> Using file: " + fileName);
                // load the properties file from disk
                properties.load(new FileInputStream(fileName));
                log.info("=> Property file loaded!");

                // set the DAO connection properties
                log.info("=> Setting JDBC properties...");
                //DAOFactoryMTB.setProperties(properties);
                DAOManagerMTB.getInstance().setJdbcDriver(
                        properties.getProperty(JDBC_DRIVER));

                DAOManagerMTB.getInstance().setJdbcUrl(
                        properties.getProperty(JDBC_URL));

                DAOManagerMTB.getInstance().setJdbcUsername(
                        properties.getProperty(JDBC_USER));

                DAOManagerMTB.getInstance().setJdbcPassword(
                        properties.getProperty(JDBC_PASSWORD));
                log.info("=> JDBC properties set!");

                MTBSynchronizationUtilDAO daoSynch =
                        MTBSynchronizationUtilDAO.getInstance();

                daoSynch.setMGIInfo(properties.getProperty(MGI_JDBC_USER),
                        properties.getProperty(MGI_JDBC_PASSWORD),
                        properties.getProperty(MGI_JDBC_DRIVER),
                        properties.getProperty(MGI_JDBC_URL));

                log.info("Set mgi info");

           

                PDXDAO.getInstance().setConnectionInfo(
                        properties.getProperty(JDBC_DRIVER),
                        properties.getProperty(JDBC_URL),
                        properties.getProperty(PDX_JDBC_PWD),
                        properties.getProperty(PDX_JDBC_USER));

                
                
                log.info("set pdx info");

                try{
                ElimsUtil eu = new ElimsUtil();
                eu.setAuthentication(
                        properties.getProperty(ELIMS_USER),
                        properties.getProperty(ELIMS_PWD));
                   log.info("=> ELIMS properties set!");


                }catch(Error e){
                    log.error("Cant load ElimsUtil (OK if public deployment)",e);
                }

             
                // this is simple, just instantiate the constants class to
                // initialize all the constants used in the WI
                log.info("=> Initializing RDBMS components...");
                WIConstants.getInstance();
                log.info("=> RDBMS components initialized successfully!");

                // set properties
                log.info("=> Setting global properties...");
                WIConstants.getInstance().setProperties(properties);
                log.info("==> Global properties initialized!");
              
            } else {
                log.error("=> ERROR: Unable to find \"propertiesFile\" [" + fileName + "] specified in web.xml!");
            }

        } catch (IOException ioe) {
            log.fatal("Initialization Failure", ioe);
        } catch (Exception e) {
            log.fatal("Initialization Failure", e);
        } catch (Error e) {
            log.fatal("Initialization Error:", e);
        }

        // put the variables we need in application scope
        getServletContext().setAttribute("urlBase",
                WIConstants.getInstance().getUrlBase());

        getServletContext().setAttribute("urlJavaScript",
                WIConstants.getInstance().getUrlJavaScript());

        getServletContext().setAttribute("urlImageDir",
                WIConstants.getInstance().getUrlImageDir());

        getServletContext().setAttribute("urlStyleSheet",
                WIConstants.getInstance().getUrlStylesheet());

        getServletContext().setAttribute("urlZoomify",
                WIConstants.getInstance().getUrlZoomify());

        getServletContext().setAttribute("urlMTBPathWI",
                WIConstants.getInstance().getUrlMTBPathWI());

        getServletContext().setAttribute("wiVersion",
                WIConstants.getInstance().getWIVersion());

        getServletContext().setAttribute("dbVersion",
                WIConstants.getInstance().getDBVersion());

        getServletContext().setAttribute("dbLastUpdateDate",
                WIConstants.getInstance().getDBLastUpdateDate());

        getServletContext().setAttribute("assayImageURL",
                WIConstants.getInstance().getAssayImageURL());

        getServletContext().setAttribute("assayImagePath",
                WIConstants.getInstance().getAssayImagePath());

        getServletContext().setAttribute("gViewerPath",
                WIConstants.getInstance().getGViewerPath());

        getServletContext().setAttribute("pathologyImagePath",
                WIConstants.getInstance().getPathologyImagePath());

        getServletContext().setAttribute("pathologyImageUrl",
                WIConstants.getInstance().getPathologyImageURL());

        getServletContext().setAttribute("mouseIdeoFile",
                WIConstants.getInstance().getMouseIdeoFile());

        getServletContext().setAttribute("pdxFileURL",
                WIConstants.getInstance().getPDXFileURL());

        getServletContext().setAttribute("pdxFilePath",
                WIConstants.getInstance().getPDXFilePath());

        getServletContext().setAttribute("publicDeployment",
                WIConstants.getInstance().getPublicDeployment());
        
        getServletContext().setAttribute("socURL",
                WIConstants.getInstance().getSocURL());
        
        getServletContext().setAttribute("tumorFrequencyCount",
                NumberFormat.getNumberInstance(Locale.US).format(WIConstants.getInstance().getTumorFrequencyCount()));
        

        // google analytics only on public
        // fyi not all pages include the meta.jsp which is where the google snippet is
        // fyi which don't?
        
        if(WIConstants.getInstance().getPublicDeployment()){
           getServletContext().setAttribute("googleID","UA-38295128-2");
        }

        // loads static mice
    
        PDXMouseStore pdxStore = new PDXMouseStore();
       
        
        // values for About Us data counts
        
        // we show PDX Model Numbers from PDXFinder not just JAX
        getServletContext().setAttribute("pdxModelCount",
                NumberFormat.getNumberInstance(Locale.US).format(pdxStore.getPDXFinderModelCount()));
        
        MTBReferenceUtilDAO refUtil = MTBReferenceUtilDAO.getInstance();
        getServletContext().setAttribute("referenceCount",
                NumberFormat.getNumberInstance(Locale.US).format(refUtil.getReferenceCount()));
        
        ModelCounts mc  = new ModelCounts();
        getServletContext().setAttribute("modelCount",
                NumberFormat.getNumberInstance(Locale.US).format(new Integer(mc.getModelCount())));
        
        MTBPathologyImageUtilDAO imageDAO = MTBPathologyImageUtilDAO.getInstance();
        getServletContext().setAttribute("pathologyImageCount",
                NumberFormat.getNumberInstance(Locale.US).format(imageDAO.getImageCount()));
        
        

        log.error("No Errors! : MTBWI up.");
        System.out.println("MTBWI up.");
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
        resp.sendRedirect(resp.encodeRedirectURL("/"));
    }

    /**
     * Clean up resources, remove objects from application scope.
     *
     * This method is called by the servlet container just after this servlet
     * is removed from service.
     */
    public void destroy() {
        // Shutdown code...
        log("Destroying the initialization servlet!");
    }  // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    // none
}
