/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import org.apache.logging.log4j.Logger;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AgentComparator;
import org.jax.mgi.mtb.dao.gen.mtb.AgentDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AgentDTO;
import org.jax.mgi.mtb.dao.gen.mtb.AgentTypeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.AgentTypeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AgentTypeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleGroupTypeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleGroupTypeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleGroupTypeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleTypeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleTypeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleTypeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.AnatomicalSystemComparator;
import org.jax.mgi.mtb.dao.gen.mtb.AnatomicalSystemDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AnatomicalSystemDTO;
import org.jax.mgi.mtb.dao.gen.mtb.ChromosomeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.ChromosomeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.ChromosomeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.MTBInfoDAO;
import org.jax.mgi.mtb.dao.gen.mtb.MTBInfoDTO;
import org.jax.mgi.mtb.dao.gen.mtb.OrganComparator;
import org.jax.mgi.mtb.dao.gen.mtb.OrganDAO;
import org.jax.mgi.mtb.dao.gen.mtb.OrganDTO;
import org.jax.mgi.mtb.dao.gen.mtb.ProbeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.ProbeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.ProbeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainTypeComparator;
import org.jax.mgi.mtb.dao.gen.mtb.StrainTypeDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainTypeDTO;
import org.jax.mgi.mtb.dao.gen.mtb.TumorClassificationComparator;
import org.jax.mgi.mtb.dao.gen.mtb.TumorClassificationDAO;
import org.jax.mgi.mtb.dao.gen.mtb.TumorClassificationDTO;
import org.jax.mgi.mtb.utils.LabelValueBean;

/**
 *
 * @author mjv
 */
public class WIConstants {

    // -------------------------------------------------------------- Constants
    public static final String EOL = System.getProperty("line.separator");
    private final static Logger log = org.apache.logging.log4j.LogManager.getLogger(WIConstants.class.getName());
    public final int DO_NOT_SEARCH = -1;
    public final int SEARCH = 0;
    public final static int TYPE_MARKER = 1;
    public final static int TYPE_REFERENCE = 2;
    private final int SITE_ID_FESTINGS = 104;
    private final int SITE_ID_JAXMICE = 105;
    private final int SITE_ID_MPD = 103;
    private final int SITE_ID_LOTHAR = 100;
    private final int SITE_ID_NCIMR = 101;
    private final int SITE_ID_CARDIFF = 102;
    
    public final String WHATS_NEW_URL = "whatsNew.jsp";
   
    public final String PUBLIC_DEPLOYMENT = "public";
    // these strings are used by the quick search to pull out search results from jsps/urls
    //they must match the comments in the jsp (see tumorSearchResults.jsp)
    public final String SEARCH_SECTION_START = "<!--======================= Start Results ==================================-->";
    public final String SEARCH_SECTION_END = "<!--======================= End Results ====================================-->";
    public final String SEARCH_LIMIT_START = "<!--======================= Start Display Limit ============================-->";
    public final String SEARCH_LIMIT_END = "<!--======================= End Display Limit ==============================-->";
    private final static String JDBC_DRIVER = "jdbc.driver";
    private final static String JDBC_PASSWORD = "jdbc.password";
    private final static String JDBC_URL = "jdbc.url";
    private final static String JDBC_USER = "jdbc.user";
    private final static String URL_BASE = "url.base";
    private final static String URL_IMAGE_DIR = "url.image.dir";
    private final static String URL_JAVASCRIPT = "url.javascript";
    private final static String URL_STYLESHEET = "url.stylesheet";
    private final static String URL_ZOOMIFY = "url.zoomify";
    private final static String URL_MTBPATHWI = "url.mtbpathwi";
    private final static String ASSAY_IMAGE_URL = "assay.image.url";
    private final static String ASSAY_IMAGE_PATH = "assay.image.path";
    private final static String PATHOLOGY_IMAGE_URL = "pathology.image.url";
    private final static String PATHOLOGY_IMAGE_PATH = "pathology.image.path";
    private final static String WI_VERSION = "wi.version";
    private final static String DB_VERSION = "DB_VERSION";
    private final static String DB_LAST_UPDATE_DATE = "DB_LAST_UPDATE_DATE";
    private final static String DB_LAST_UPDATE_TIME = "DB_LAST_UPDATE_TIME";
    private final static String SITE_NAME_LOTHAR = "Lothar";
    private final static String SITE_NAME_NCIMR = "NCI Mouse Repository";
    private final static String SITE_NAME_CARDIFF = "Cardiff";
    private final static String SITE_NAME_MPD = "MPD";
    private final static String SITE_NAME_FESTINGS = "Festings";
    private final static String SITE_NAME_JAXMICE = "JAX Mice";
    private final static String SITE_LONG_NAME_LOTHAR = "Biology of the Mammary Gland Web Site";
    private final static String SITE_LONG_NAME_NCIMR = "NCI Mouse Repository";
    private final static String SITE_LONG_NAME_CARDIFF = "Mammary Cancer Comparative Pathology Web Site";
    private final static String SITE_LONG_NAME_MPD = "Mouse Phenome Database (MPD)";
    private final static String SITE_LONG_NAME_FESTINGS = "Festing's List of Inbred Strains";
    private final static String SITE_LONG_NAME_JAXMICE = "JAX<sup>&reg;</sup>Mice";
   
    private final static String PDX_FILE_PATH = "pdx.file.path";
    private final static String PDX_FILE_URL = "pdx.file.url";
    private final static String PDX_EMAIL = "pdx.email";
    private final static String MTB_DEPLOYMENT = "mtb.deployment";
    private final static String PDX_USER = "pdx.user";
    private final static String PDX_EDITORS = "pdx.editors";
    private final static String PDX_PASSWORD = "pdx.password";
    private final static String PDX_WEBSERVICE = "pdx.webservice";
    private final static String SOLR_URL = "solr.url";
    private final static String SOC_DB = "soc.db";
    private final static String SOC_URL = "soc.url";
    private final static String CNV_PLOTS_PATH = "cnv.plots.path";

    /* ----------------------------------------------------- Instance Variables */
    private static WIConstants instance = new WIConstants();
    /* Q: Why use a map here instead of a hashtable? */
    /* A: Because a LinkedHashMap keeps the order of insertion */
    private Map<Long, LabelValueBean<String, Long>> mapAgents = new LinkedHashMap<>();
    private Map<Long, LabelValueBean<String, Long>> mapAgentTypes = new LinkedHashMap<>();
   
    private Map<Long, LabelValueBean<String, Long>> mapChromosomes = new LinkedHashMap<>();
    private Map<Long, LabelValueBean<String, Long>> mapOrgans = new LinkedHashMap<>();
    private Map<Long, LabelValueBean<String, Long>> mapProbes = new LinkedHashMap<>();
    private Map<Long, LabelValueBean<String, Long>> mapStrainTypes = new LinkedHashMap<>();
    private Map<Long, LabelValueBean<String, Long>> mapTumorClassifications = new LinkedHashMap<>();
   
    private int nTumorFrequencyCount = -1;
    private String strURLBase;
    private String strURLImageDir;
    private String strAssayImageURL;
    private String strAssayImagePath;
    private String strPathologyImageURL;
    private String strPathologyImagePath;
    private String strURLJavaScript;
    private String strURLStylesheet;
    private String strURLZoomify;
    private String strURLMTBPathWI;
    private String strJDBCDriver;
    private String strJDBCUrl;
    private String strJDBCUser;
    private String strJDBCPassword;
    private String strDBVersion = "na";
    private String strDBLastUpdateDate = "na";
    private String strDBLastUpdateTime = "na";
    private String strWIVersion = "na";
    private Map mapTFGrid = null;
    private List arrOrgans = null;
    private List arrStrains = null;
    private String strQTLFile;
    private String strGViewerPath;
    private String strMouseIdeoFile;
    private String pdxFilePath;
    private String pdxFileURL;
    private String pdxEmail;
    private String mtbDeployment;
    private HashMap<String,String> pdxUserMap = new HashMap<>();
    private ArrayList<String> pdxEditors = new ArrayList<>();
    private String solrURL;
    private String socDB;
    private String socURL;
    private String pdxWebservice;
    private String cnvPlotsPath;

    // ----------------------------------------------------------- Constructors
    /**
     * Constructor. This is private so the object cannot be instantiated
     * directly.
     */
    private WIConstants() {
        init();
    }

    // --------------------------------------------------------- Public Methods
    public Map getTFGrid() {
        return this.mapTFGrid;
    }

    public List getTFGridOrgans() {
        return arrOrgans;
    }

    public List getTFGridStrains() {
        return arrStrains;
    }

    public String getPDXFilePath() {
        return this.pdxFilePath;
    }

    public String getPDXFileURL() {
        return this.pdxFileURL;
    }

    public String getPDXEmail() {
        return this.pdxEmail;
    }

    // PDX Dashboard access internal MTB sties only
    public HashMap<String,String> getPDXUserMap(){
        return this.pdxUserMap;
    }

    /**
     * Get a <code>Map</code> of <code>LabelValueBean</code> objects
     * representing <code>Agent</code> data.
     *
     * @return a <code>Map</code> of <code>LabelValueBean</code> objects
     */
    public Map<Long, LabelValueBean<String, Long>> getAgents() {
        return this.mapAgents;
    }

   
    public Map<Long, LabelValueBean<String, Long>> getAgentTypes() {
        return this.mapAgentTypes;
    }
    

   

   

    /**
     * Get a <code>Map</code> of <code>LabelValueBean</code> objects
     * representing <code>Chromosome</code> data.
     *
     * @return a <code>Map</code> of <code>LabelValueBean</code> objects
     */
    public Map<Long, LabelValueBean<String, Long>> getChromosomes() {
        return this.mapChromosomes;
    }

    /**
     *
     * @return
     */
    public final String getDBVersion() {
        return this.strDBVersion;
    }

    /**
     *
     * @return
     */
    public final String getDBLastUpdateDate() {
        return this.strDBLastUpdateDate;
    }

    /**
     *
     * @return
     */
    public final String getDBLastUpdateTime() {
        return this.strDBLastUpdateTime;
    }

    /**
     *
     * @return
     */
    public static WIConstants getInstance() {
        return instance;
    }

    /**
     *
     * @return
     */
    public String getJdbcDriver() {
        return this.strJDBCDriver;
    }

    /**
     *
     * @return
     */
    public String getJdbcPassword() {
        return this.strJDBCPassword;
    }

    /**
     *
     * @return
     */
    public String getJdbcUrl() {
        return this.strJDBCUrl;
    }

    /**
     *
     * @return
     */
    public String getJdbcUser() {
        return this.strJDBCUser;
    }

    

    
    

    /**
     *
     * @param id
     * @return
     */
    public String getLongSiteName(int id) {
        switch (id) {
            case SITE_ID_LOTHAR:
                return SITE_LONG_NAME_LOTHAR;

            case SITE_ID_NCIMR:
                return SITE_LONG_NAME_NCIMR;

            case SITE_ID_CARDIFF:
                return SITE_LONG_NAME_CARDIFF;

            case SITE_ID_MPD:
                return SITE_LONG_NAME_MPD;

            case SITE_ID_FESTINGS:
                return SITE_LONG_NAME_FESTINGS;

            case SITE_ID_JAXMICE:
                return SITE_LONG_NAME_JAXMICE;

            default:
                return null;
        }
    }

   

    /**
     *
     * @return
     */
    public Map<Long, LabelValueBean<String, Long>> getOrgans() {
        return this.mapOrgans;
    }

    /**
     *
     * @return
     */
    public Map<Long, LabelValueBean<String, Long>> getProbes() {
        return this.mapProbes;
    }

    /**
     *
     * @return
     */
    public int getSiteIdLothar() {
        return SITE_ID_LOTHAR;
    }

    /**
     *
     * @return
     */
    public int getSiteIdNCIMR() {
        return SITE_ID_NCIMR;
    }

    /**
     *
     * @return
     */
    public int getSiteIdCardiff() {
        return SITE_ID_CARDIFF;
    }

    /**
     *
     * @return
     */
    public int getSiteIdFestings() {
        return SITE_ID_FESTINGS;
    }

    /**
     *
     * @return
     */
    public int getSiteIdMPD() {
        return SITE_ID_MPD;
    }

    /**
     *
     * @return
     */
    public int getSiteIdJaxMice() {
        return SITE_ID_JAXMICE;
    }

    /**
     *
     * @param id
     * @return
     */
    public String getSiteName(int id) {
        switch (id) {
            case SITE_ID_LOTHAR:
                return SITE_NAME_LOTHAR;

            case SITE_ID_NCIMR:
                return SITE_NAME_NCIMR;

            case SITE_ID_CARDIFF:
                return SITE_NAME_CARDIFF;

            case SITE_ID_MPD:
                return SITE_NAME_MPD;

            case SITE_ID_FESTINGS:
                return SITE_NAME_FESTINGS;

            case SITE_ID_JAXMICE:
                return SITE_NAME_JAXMICE;

            default:
                return null;
        }
    }

    /**
     *
     * @return
     */
    public Map<Long, LabelValueBean<String, Long>> getStrainTypes() {
        return this.mapStrainTypes;
    }

    /**
     *
     * @return
     */
    public Map<Long, LabelValueBean<String, Long>> getTumorClassifications() {
        return this.mapTumorClassifications;
    }

    /**
     *
     * @return
     */
    public int getTumorFrequencyCount() {
        return this.nTumorFrequencyCount;
    }

    /**
     *
     * @return
     */
    public String getUrlBase() {
        return this.strURLBase;
    }

    /**
     * Get the URL for the Path object.
     *
     * @return the URL for the Zoomify object
     */
    public String getUrlImageDir() {
        return this.strURLImageDir;
    }

    /**
     * Get the URL for the JavaScript file.
     *
     * @return the URL for the JavaScript file
     */
    public String getUrlJavaScript() {
        return this.strURLJavaScript;
    }

    /**
     * Get the URL for the stylesheet.
     *
     * @return the URL for stylesheet
     */
    public String getUrlStylesheet() {
        return this.strURLStylesheet;
    }

    /**
     * Get the URL for the Zoomify object.
     *
     * @return the URL for the Zoomify object
     */
    public String getUrlZoomify() {
        return this.strURLZoomify;
    }

    public String getAssayImageURL() {
        return this.strAssayImageURL;
    }

    public String getAssayImagePath() {
        return this.strAssayImagePath;
    }

    public String getPathologyImageURL() {
        return this.strPathologyImageURL;
    }

    public String getPathologyImagePath() {
        return this.strPathologyImagePath;
    }

    /**
     *
     * @return
     */
    public String getUrlMTBPathWI() {
        return this.strURLMTBPathWI;
    }

    /**
     * Get the WI Version.
     *
     * @return the WI Version
     */
    public final String getWIVersion() {
        return this.strWIVersion;
    }

    public String getQTLFile() {
        return strQTLFile;
    }

    public void setQTLFile(String strQTLFile) {
        this.strQTLFile = strQTLFile;
    }

    public String getGViewerPath() {
        return strGViewerPath;
    }

    public void setGViewerPath(String strGViewerPath) {
        this.strGViewerPath = strGViewerPath;
    }

    public String getMouseIdeoFile() {
        return strMouseIdeoFile;
    }

    public void setMouseIdeoFile(String strMouseIdeoFile) {
        this.strMouseIdeoFile = strMouseIdeoFile;
    }

   

    public boolean getPublicDeployment() {
        return "public".equals(this.mtbDeployment);
    }

    public String getSolrURL() {
        return this.solrURL;
    }

    public String getSOCDB() {
        return this.socDB;
    }

    /**
     * Initialize the data used through out the WI.
     */
    private void init() {
        log.info("Initializing WI constants...");

        try {
            // get the chromosomes
            log.info("Initializing chromosomes...");
            initChromosomes();

           

            // get the agent types
            log.info("Initializing agent types...");
            initAgentTypes();

            // get the agents
            log.info("Initializing agents...");
            initAgents();

           

            // get the organs
            log.info("Initializing organs...");
            initOrgans();

            // get the probes (antibodies)
            log.info("Initializing probes...");
            initProbes();
           

            // get the strain types
            log.info("Initializing strain types...");
            initStrainTypes();

            // get the tumor classifications
            log.info("Initializing tumor classifications...");
            initTumorClassifications();

            

            // get the tumor frequency count
            initTumorFrequencyCount();
            // init the database information
            log.info("Initializing database info...");
            initDatabaseInfo();

            // init the TFGRID
            log.info("Initializing tumor frequency grid...");
            initTFGrid();
            log.info("Finished initializing tumor frequency grid.");

            

        } catch (Exception e) {
            log.error("Fatal Initialization Error", e);
        }

        log.info("WI constants initialized!");
    }

    /**
     * Set the properties to use in the WI.
     *
     * @param props the <code>Properties</code>
     */
    public void setProperties(Properties props) {

        try {
            strWIVersion = props.getProperty(WI_VERSION);

            strURLBase = props.getProperty(URL_BASE);
            strURLImageDir = props.getProperty(URL_IMAGE_DIR);
            strURLJavaScript = props.getProperty(URL_JAVASCRIPT);
            strURLStylesheet = props.getProperty(URL_STYLESHEET);
            strURLZoomify = props.getProperty(URL_ZOOMIFY);
            strURLMTBPathWI = props.getProperty(URL_MTBPATHWI);

            strJDBCDriver = props.getProperty(JDBC_DRIVER);
            strJDBCUrl = props.getProperty(JDBC_URL);
            strJDBCUser = props.getProperty(JDBC_USER);
            strJDBCPassword = props.getProperty(JDBC_PASSWORD);

            strAssayImageURL = props.getProperty(ASSAY_IMAGE_URL);
            strAssayImagePath = props.getProperty(ASSAY_IMAGE_PATH);

            strPathologyImageURL = props.getProperty(PATHOLOGY_IMAGE_URL);
            strPathologyImagePath = props.getProperty(PATHOLOGY_IMAGE_PATH);

           
            this.pdxFilePath = props.getProperty(PDX_FILE_PATH);
            this.pdxFileURL = props.getProperty(PDX_FILE_URL);
            this.pdxEmail = props.getProperty(PDX_EMAIL);
            this.pdxWebservice = props.getProperty(PDX_WEBSERVICE);

            
            try{
                
                String[] pdxUsers = props.getProperty(PDX_USER).split(",");
                String[] pdxPwds = props.getProperty(PDX_PASSWORD).split(",");
                
                for(int i=0; i< pdxUsers.length; i++){
                    this.pdxUserMap.put(pdxUsers[i].trim(),pdxPwds[i].trim());
                }
            
                String[] pdxEds = props.getProperty(PDX_EDITORS).split(",");
                for(String editor: pdxEds){
                    this.pdxEditors.add(editor.trim());
                }
            }catch(Exception e){
                log.error("Unable to create PDX user map");
                
            }
            
            this.mtbDeployment = props.getProperty(MTB_DEPLOYMENT);

            this.solrURL = props.getProperty(SOLR_URL);

            this.socDB = props.getProperty(SOC_DB);

            this.socURL = props.getProperty(SOC_URL);
            
            this.cnvPlotsPath = props.getProperty(CNV_PLOTS_PATH);

        } catch (Exception e) {
            log.error("Failed to initialize WIConstants", e);
        }

    }

    // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    private void initTFGrid() {
        try {
            MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
            mapTFGrid = daoTumorUtil.getTFGrid();

            arrOrgans = daoTumorUtil.getTFGridOrgans(null);

            arrStrains = daoTumorUtil.getTFGridStrains(null);

        } catch (Exception e) {
            log.error("Error getting grid data.", e);
        }
    }
    
    private void initTumorFrequencyCount(){
         MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
         nTumorFrequencyCount = daoTumorUtil.getTumorFrequencyCount();
    }

    /**
     * Initialize a <code>Map</code> of <code>LabelValueBean</code> objects
     * representing <code>Agent</code> data.
     */
    private void initAgents() {
        try {
            // get the agents
            AgentDAO daoAgent = AgentDAO.getInstance();
            List<AgentDTO> listAgents = daoAgent.loadAll();

            Collections.sort(listAgents, new AgentComparator(AgentDAO.ID_NAME));

            for (AgentDTO dto : listAgents) {
                mapAgents.put(dto.getAgentKey(),
                        new LabelValueBean<String, Long>(dto.getName(), dto.getAgentKey()));
            }
        } catch (Exception e) {
            log.error("Error initialiazing agents", e);
        }
    }

    /**
     * Initialize a <code>Map</code> of <code>LabelValueBean</code> objects
     * representing <code>AgentType</code> data.
     */
    private void initAgentTypes() {
        Map<Long, LabelValueBean<String, Long>> agentTypes = new LinkedHashMap<Long, LabelValueBean<String, Long>>();

        try {
            // get the agents
            AgentTypeDAO daoAgentType = AgentTypeDAO.getInstance();
            List<AgentTypeDTO> listAgentTypes = daoAgentType.loadAll();

            Collections.sort(listAgentTypes, new AgentTypeComparator(AgentTypeDAO.ID_NAME));

            for (AgentTypeDTO dto : listAgentTypes) {
                agentTypes.put(dto.getAgentTypeKey(),
                        new LabelValueBean<String, Long>(dto.getName(), dto.getAgentTypeKey()));
            }

            mapAgentTypes.put(new Long(0), new LabelValueBean<String, Long>("None (spontaneous)", new Long(0)));
            mapAgentTypes.putAll(agentTypes);
        } catch (Exception e) {
            log.error("Error initializing agent types", e);
        }
    }

   


   

    /**
     * Initialize a <code>Map</code> of <code>LabelValueBean</code> objects
     * representing <code>AnatomicalSystem</code> data.
     */
    private void initChromosomes() {
        try {
            // get the chromosomes
            ChromosomeDAO daoChromosome = ChromosomeDAO.getInstance();
            List<ChromosomeDTO> listChromosomes = daoChromosome.loadByOrganismKey(new Long(1)); // 1 = mouse

            Collections.sort(listChromosomes, new ChromosomeComparator(ChromosomeDAO.ID_ORDERNUM));

            for (ChromosomeDTO dto : listChromosomes) {
                mapChromosomes.put(dto.getChromosomeKey(),
                        new LabelValueBean<String, Long>(dto.getChromosome(), dto.getChromosomeKey()));
            }
        } catch (Exception e) {
            log.error("Error initializing chromosomes", e);
        }
    }

    private void initDatabaseInfo() {
        try {
            // get the info
            MTBInfoDAO daoInfo = MTBInfoDAO.getInstance();
            List<MTBInfoDTO> listInfo = daoInfo.loadAll();

            for (MTBInfoDTO dto : listInfo) {
                if (dto.getMTBProperty().equals(DB_VERSION)) {
                    strDBVersion = dto.getMTBValue();
                } else if (dto.getMTBProperty().equals(DB_LAST_UPDATE_DATE)) {
                    strDBLastUpdateDate = dto.getMTBValue();
                    try {
                        strDBLastUpdateDate = strDBLastUpdateDate.trim().substring(0, strDBLastUpdateDate.trim().indexOf(" "));
                    } catch (Exception e) {
                        // cant format date don't care
                    }
                } else if (dto.getMTBProperty().equals(DB_LAST_UPDATE_TIME)) {
                    strDBLastUpdateTime = dto.getMTBValue();
                }
            }
        } catch (Exception e) {
            log.error("Error initializing database info", e);
        }
    }

    

    private void initOrgans() {
        try {
            // get the organs
            OrganDAO daoOrgan = OrganDAO.getInstance();
            List<OrganDTO> listOrgans = daoOrgan.loadAll();

            Collections.sort(listOrgans, new OrganComparator(OrganDAO.ID_NAME));

            for (OrganDTO dto : listOrgans) {

                mapOrgans.put(dto.getOrganKey(),
                        new LabelValueBean<String, Long>(dto.getName(), dto.getOrganKey()));

            }
        } catch (Exception e) {
            log.error("Error initializing organs", e);
        }
    }

   
     

    private void initProbes() {
        try {
            // get the probes (antibodies)
            ProbeDAO daoProbe = ProbeDAO.getInstance();
            List<ProbeDTO> listProbes = daoProbe.loadAll();

            Collections.sort(listProbes, new ProbeComparator(ProbeDAO.ID_NAME));

            for (ProbeDTO dto : listProbes) {
                mapProbes.put(dto.getProbeKey(),
                        new LabelValueBean<String, Long>(dto.getName(), dto.getProbeKey()));
            }
        } catch (Exception e) {
            log.error("Error initializing probes", e);
        }
    }

    private void initStrainTypes() {
        try {
            // get the strain types
            StrainTypeDAO strainTypeDAO = StrainTypeDAO.getInstance();
            List<StrainTypeDTO> listStrainTypes = strainTypeDAO.loadAll();

            Collections.sort(listStrainTypes, new StrainTypeComparator(StrainTypeDAO.ID_TYPE));

            for (StrainTypeDTO dto : listStrainTypes) {
                mapStrainTypes.put(dto.getStrainTypeKey(),
                        new LabelValueBean<String, Long>(dto.getType(), dto.getStrainTypeKey()));
            }
        } catch (Exception e) {
            log.error("Error intitializing strain types", e);
        }
    }

    private void initTumorClassifications() {
        try {
            /* get the tumor classifications --- This way returns TC's with no TF's
            TumorClassificationDAO tumorClassificationDAO = TumorClassificationDAO.getInstance();
            List<TumorClassificationDTO> listTumorClassifications = tumorClassificationDAO.loadAll();           
             */
            List<TumorClassificationDTO> listTumorClassifications = MTBTumorUtilDAO.getInstance().getTumorClassifications();

            Collections.sort(listTumorClassifications, new TumorClassificationComparator(TumorClassificationDAO.ID_NAME));

            for (TumorClassificationDTO dto : listTumorClassifications) {
                mapTumorClassifications.put(dto.getTumorClassificationKey(),
                        new LabelValueBean<String, Long>(dto.getName(),
                                dto.getTumorClassificationKey()));
            }
        } catch (Exception e) {
            log.error("Error initializing tumor classifications", e);
        }
    }

    /**
     * @return the socURL
     */
    public String getSocURL() {
        return socURL;
    }

    /**
     * @param socURL the socURL to set
     */
    public void setSocURL(String socURL) {
        this.socURL = socURL;
    }

    /**
     * @return the pdxEditors
     */
    public ArrayList<String> getPdxEditors() {
        return pdxEditors;
    }
    
    public String getPDXWebservice(){
        return this.pdxWebservice;
    }
    
    public String getCNVPlotsPath(){
        return this.cnvPlotsPath;
    }
}
