/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;


/**
 * WIUtils
 *
 * The WIUtils class is a static class the encapsulates many common utilities
 * used in the WI.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 */
public class WIUtils {

    // -------------------------------------------------------------- Constants

    public static final String SELECT_STRING = "ANY";


    // ----------------------------------------------------- Instance Variables

    private static List<LabelValueBean<String,String>> colInfo = 
            new ArrayList<LabelValueBean<String,String>>();


    // ----------------------------------------------------------- Constructors

    private WIUtils() {
        // no-op'd
    }


    // --------------------------------------------------------- Public Methods

    /**
     * Convert an array of <code>String</code> objects to a <code>List</code>
     * and remove any empty values.
     */
    public static List<String> arrayToCleanList(String[] arr) {
        List<String> ret = null;

        if (arr != null) {
            ret = new ArrayList<String>(Arrays.asList(arr));
            ret.remove("");
        }

        return ret;
    }
    
    
    /**
     * Convert an array of <code>String</code> objects to a <code>List of valid integer strings</code>
     * and remove any empty values.
     */
    public static List<String> arrayToCleanKeyList(String[] arr) {
        List<String> ret = new ArrayList<String>();

        if (arr != null) {
            for(int i = 0; i < arr.length; i++){
               try{
                ret.add(Integer.valueOf(arr[i].trim()).toString());
               }catch(Exception e){
                  
               }
            }
        }

        return ret;
    }

    /**
     * Convert a <code>String</code> to an integer.
     */
    public static int stringToInt(String str) {
        return stringToInt(str, -1);
    }

    /**
     * Convert a <code>String</code> to an integer.
     */
    public static int stringToInt(String str, int defaultVal) {
        int i = defaultVal;

        if (StringUtils.hasValue(str)) {
            try {
                i = Integer.parseInt(str);
            } catch (NumberFormatException nfe) {}
        }

        return i;
    }

    /**
     * Convert a <code>String</code> to a long.
     */
    public static long stringToLong(String str) {
        return stringToLong(str, -1l);
    }

    /**
     * Convert a <code>String</code> to a long.
     */
    public static long stringToLong(String str, long defaultVal) {
        long l = defaultVal;

        if (StringUtils.hasValue(str)) {
            try {
                l = Long.parseLong(str);
            } catch (NumberFormatException nfe) {}
        }

        return l;
    }

    /**
     * Convert a <code>String</code> to a double.
     */
    public static double stringToDouble(String str) {
        return stringToDouble(str, -1l);
    }

    /**
     * Convert a <code>String</code> to a double.
     */
    public static double stringToDouble(String str, double defaultVal) {
        double l = defaultVal;

        if (StringUtils.hasValue(str)) {
            try {
                l = Double.parseDouble(str);
            } catch (NumberFormatException nfe) {}
        }

        return l;
    }

    /**
     * Get a List of comparison items.
     *
     * @return A Lost of LabelValueBeans representing comparisons.
     */
    public static List<LabelValueBean<String,String>> getComparison() {
        if (colInfo.size() == 0) {
            colInfo.add(new LabelValueBean<String,String>(" Equals ", "="));
            colInfo.add(new LabelValueBean<String,String>(" Not Equals ", "!="));
            colInfo.add(new LabelValueBean<String,String>(" Contains ", "contains"));
            colInfo.add(new LabelValueBean<String,String>(" Begins ", "begins"));
            colInfo.add(new LabelValueBean<String,String>(" Ends With ", "ends"));
        }

        return colInfo;
    }

    
    /**
     * Convert the values in the Mao specified by the array.
     *
     * @param arr A list of selected values.
     * @param map The map of all values.
     *
     * @return An List of the selected values from the map.
     */
    public static List<String> convertMapSelectedValuesToArray(List<String> arr,
                                                               Map<String, LabelValueBean> map) {
        if ((arr == null) || (map == null)) {
            return null;
        }

        if (arr.size() == 0) {
            return null;
        }

        List<String> arrRet = new ArrayList<String>();

        for (int i = 0; i < arr.size(); i++) {
            String strKey = arr.get(i);

            if (StringUtils.hasValue(strKey)) {
                arrRet.add(map.get(strKey).toString());
            }
        }

        return arrRet;
    }

    /**
     * Convert the List values in getComparison () to it's "label" given
     * it's "value" or to it's "value" given it's "label".
     *
     * @param str The value or label of the comparison.
     * @return The corresponding value or label of the comparison.
     */
    public static String convertComparison(String str) {
        if (str == null) {
            return null;
        }

        if (str.length() == 0) {
            return "";
        }

        List<LabelValueBean<String,String>> listComparisons = getComparison();

        for (LabelValueBean<String,String> bean : listComparisons) {
            if (str.trim().equalsIgnoreCase(bean.getLabel().trim())) {
                return bean.getValue();
            } else if (str.trim().equalsIgnoreCase(bean.getValue().trim())) {
                return bean.getLabel();
            }
        }

        return null;
    }

    /**
     * Filter the duplicate strain synonyms.
     *
     * @param arrSynonyms the list of <code>StrainSynonymsDTO</code> objects
     * @param strStrainName the name of the strain
     * @return the filtered array of <code>StrainSynonymsDTO</code> objects
     */
    public static List<StrainSynonymsDTO>
            filterStrainSynonyms(List<StrainSynonymsDTO> arrSynonyms,
                                 String strStrainName) {
        List<StrainSynonymsDTO> arrFilteredSynonyms = new ArrayList<StrainSynonymsDTO>();
        Map<String, String> mapSynonyms = new HashMap<String, String>();
        StrainSynonymsDTO dtoSynonym =
                StrainSynonymsDAO.getInstance().createStrainSynonymsDTO();
        dtoSynonym.setName(strStrainName);
        mapSynonyms.put(strStrainName, strStrainName);
        int size = arrSynonyms.size();

        for (int i = 0; i < size; i++) {
            dtoSynonym = arrSynonyms.get(i);
            String strSynonym = dtoSynonym.getName();

            if (!mapSynonyms.containsKey(strSynonym)) {
                mapSynonyms.put(strSynonym, strSynonym);
                arrFilteredSynonyms.add(dtoSynonym);
            }
        }

        return arrFilteredSynonyms;
    }

    /**
     * Retrieve the associated strain type names for the given keys.
     *
     * @param colKeys the Collection of strain type keys
     * @return a Collection of strain type labels
     */
    public static List<String> strainTypeKeysToLabel(Collection<String> colKeys) {
        List<String> arrLabels = new ArrayList<String>();
     
        if ((colKeys != null) && (colKeys.size() > 0)) {
            arrLabels = new ArrayList<String>();
            final Map<Long,LabelValueBean<String,Long>> strainTypes =
                    WIConstants.getInstance().getStrainTypes();

            for (String s : colKeys) {
                arrLabels.add(strainTypes.get(Long.valueOf(s)).getLabel());
            }
        }

        return arrLabels;
    }

    /**
     * Retrieve the associated organ names for the given keys.
     *
     * @param colKeys the Collection of organ keys
     * @return a Collection of organ labels
     */
    public static List<String> organKeysToLabel(Collection<String> colKeys) {
        List<String> arrLabels = new ArrayList<String>();
        try{
          if ((colKeys != null) && (colKeys.size() > 0)) {

              final Map<Long,LabelValueBean<String,Long>> allOrgans =
                      WIConstants.getInstance().getOrgans();

              for (String s : colKeys) {
                  arrLabels.add(allOrgans.get(Long.valueOf(s)).getLabel());
              }
          }
        }catch (Exception e){}

        return arrLabels;
    }

    /**
     * Retrieve the associated tumor classification names for the given keys.
     *
     * @param colKeys the Collection of tumor classification keys
     * @return a Collection of tumor classification labels
     */
    public static List<String> tumorclassificationKeysToLabel(Collection<String> colKeys) {
        List<String> arrLabels = new ArrayList<String>();

        if ((colKeys != null) && (colKeys.size() > 0)) {
            arrLabels = new ArrayList<String>();
            final Map<Long,LabelValueBean<String,Long>> allClasses =
                    WIConstants.getInstance().getTumorClassifications();

            for (String s : colKeys) {
                arrLabels.add(allClasses.get(Long.valueOf(s)).getLabel());
            }
        }

        return arrLabels;
    }

   
   

   

    /**
     * Convert a collection of keys to their associated name values.
     *
     * @param colProbes A collection of unique keys
     * @return A Collection of Strings containing the mutations
     */
    public static Collection<String> probeKeysToLabel(Collection<String> colProbes) {
        // create the collection of matching mutations to return
        List<String> arrLabels = new ArrayList<String>();

        if ((colProbes != null) && (colProbes.size() > 0)) {
            arrLabels = new ArrayList<String>();
            final Map<Long,LabelValueBean<String,Long>> allProbes =
                    WIConstants.getInstance().getProbes();

            for (String s : colProbes) {
                arrLabels.add(allProbes.get(Long.valueOf(s)).getLabel());
            }
        }

        return arrLabels;
    }

    public static String agenttypeKeyToLabel(long lKey) {
        Map<Long,LabelValueBean<String,Long>> mapAgentTypes = null;

        if (lKey == -1) {
            return null;
        }

        mapAgentTypes = WIConstants.getInstance().getAgentTypes();

        final LabelValueBean<String,Long> bean = mapAgentTypes.get(lKey);

        if (bean == null) {
            return null;
        }

        return bean.getLabel();
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none
}
