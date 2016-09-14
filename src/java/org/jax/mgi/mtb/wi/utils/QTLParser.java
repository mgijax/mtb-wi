/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * parses flat file into static collection of GVeiwerDetails
 * provides methods to access collection of GViewerDetails
 * 
 * @author sbn
 */
public class QTLParser {

  public static final int SORT_FOR_VIWER = 1;
  public static final int SORT_FOR_LIST = 2;
  private static final String fileStr = WIConstants.getInstance().getQTLFile();
  private static final String delim = ",";
  private static HashMap<String, ArrayList<GViewerFeature>> features;
  private static String typesListXML;
 
  private static HashMap<String, ArrayList<String>> strainsMap;
  private static HashMap<String, ArrayList<String>> parents = new HashMap<String, ArrayList<String>>();

  
  public QTLParser() {
    if (features == null) {
      HashMap<String, String> colorMap = initMap();
      try {
        File file = new File(fileStr);

        strainsMap = new HashMap<String, ArrayList<String>>();
        Scanner fileScanner = new Scanner(file);
        fileScanner.useDelimiter("\n");
        features = new HashMap<String, ArrayList<GViewerFeature>>();
        while (fileScanner.hasNext()) {

          Scanner lineScanner = new Scanner(fileScanner.next());
          lineScanner.useDelimiter(delim);
          GViewerFeature feature = new GViewerFeature();
          feature.setChromosome(lineScanner.next());
          feature.setType(lineScanner.next().trim().toUpperCase());
          feature.setStart(lineScanner.next());
          feature.setEnd(lineScanner.next());
          feature.setName(lineScanner.next());
          feature.setDescription(lineScanner.next());
          parseStrains(feature, lineScanner.next());
          parseReferences(feature, lineScanner.next());
          String group = lineScanner.next();
          feature.setOrgan(group);
          feature.setGroup(group);
          feature.setColor(colorMap.get(group));
          feature.setMgiId(lineScanner.next().trim());
          feature.buildLink();

          if (features.containsKey(group)) {
            ArrayList<GViewerFeature> list = features.get(group);
            list.add(feature);
          } else {
            ArrayList<GViewerFeature> list = new ArrayList<GViewerFeature>();
            list.add(feature);
            features.put(group, list);
          }
        }
       
      } catch (Exception e) {
      e.printStackTrace();
      }

     // build the list of organ types
        Object[] typesArr = features.keySet().toArray();
        Arrays.sort(typesArr);
        calcParents(typesArr);
         
         typesListXML = buildTypesXML();

    }
  
  }

  /**
   * QTL type T has a child type if there is a type name T*
   * ie intestine may have child intestine-small
   * Creates a HashMap<String,ArrayList<String>> parent:list of children 
   * @param types String[] sorted list of types
   */
  private void calcParents(Object[] types) {
    String parent = null;
    int i = 0;
    while (i < types.length - 1) {
      int j = i + 1;
      parent = (String) types[i];
      while (((String) types[j]).indexOf(parent) != -1) {
        if (parents.containsKey(parent)) {
          ArrayList<String> children = parents.get(parent);
          children.add((String) types[j]);
        } else {
          ArrayList<String> children = new ArrayList<String>();
          children.add((String) types[j]);
          parents.put(parent, children);
        }
        j++;
      }
      i++;
    }
  }

  /**
   * 
   * Not Currently used but gets start and end coordinates 
   * when separated by a hyphen
   * @param feature
   * @param coords
   */
  private void parseCoordinates(GViewerFeature feature, String coords) {
    int index = coords.indexOf("-");
    String start = coords.substring(0, index);
    String end = coords.substring(index + 1, coords.length());
    feature.setStart(start);
    feature.setEnd(end);
  }

  /**
   * Get the strains from a pipe delimited list
   * @param feature
   * @param strains
   */
  private void parseStrains(GViewerFeature feature, String strains) {
    ArrayList<String> list = new ArrayList<String>();
    Scanner s = new Scanner(strains);
    s.useDelimiter("|");
    String strain = "";
    while (s.hasNext()) {
      strain = s.next();
      strain.trim();
      list.add(strain);
    }
    strainsMap.put(feature.getName(), list);
  }

  /**
   * Get the first reference in a space delimited list
   * @param feature
   * @param refs
   */
  private void parseReferences(GViewerFeature feature, String refs) {
    int end = refs.length();
    int otherEnd = refs.indexOf(" ");
    if (otherEnd > 0) {
      end = otherEnd;
    }
    feature.setPrimeRef(refs.substring(0, end));
  }

  /**
   * Provide a set of the various organ types from the list of QTLs
   * @return Set<String> a set with each of the organ types for the QTLs
   */
  private String  buildTypesXML() {
   StringBuffer xml = new StringBuffer();
   xml.append(   "<organs><organ><name>All</name></organ>");
    String[] types =(String[])features.keySet().toArray(new String[features.size()] );
    Arrays.sort(types);
   
    for(String type: types){
     xml.append("<organ><name>"+type+"</name></organ>");
    }
    
    xml.append("</organs>");
  
    return xml.toString();
    
  }
  
  public String getQTLTypesXML(){
    return typesListXML;
    
  }

  /**
   * For a given array of types return all the QTL features for them
   * @param types String[] of QTL organ types
   * @return ArrayList<GViewerFeature> all the features for the types
   */
  public ArrayList<GViewerFeature> getFeaturesForTypes(String[] types, int sortOrder) {
    ArrayList<GViewerFeature> selectedFeatures = new ArrayList<GViewerFeature>();
    if (types != null) {
      if ("All".equals(types[0])) {
        types = features.keySet().toArray(types);
      } else {
        types = getChildTypes(types);
      }
      for (int i = 0; i < types.length; i++) {
        selectedFeatures.addAll(features.get(types[i]));
      }
    }
    GViewerFeature[] featuresArray = new GViewerFeature[selectedFeatures.size()];
    featuresArray = selectedFeatures.toArray(featuresArray);
    Arrays.sort(featuresArray, new FeatureComparator(sortOrder));
    selectedFeatures.clear();
    selectedFeatures.addAll(Arrays.asList(featuresArray));
    return selectedFeatures;
  }

  /**
   * For an array of qtl types check if any types have children
   * Add those types to the list and then remove any duplicates
   * @param types String[]
   * @return String[] all the original qtl type plus any of their children 
   */
  private String[] getChildTypes(String[] types) {
    ArrayList<String> children = new ArrayList<String>();

    for (int i = 0; i < types.length; i++) {
      if (parents.containsKey(types[i])) {
        children.addAll(parents.get(types[i]));
      }
      children.add(types[i]);
    }
    HashSet<String> s = new HashSet<String>();
    s.addAll(children);
    String[] allChildren = new String[s.size()];
    int i = 0;
    for (String child : s) {
      allChildren[i] = child;
      i++;
    }
    return allChildren;
  }

  
  /**
   * For an array of QTL types return the XML for the
   * associated GViewer features
   * @param types String[] of QTL types
   * @return String of annotation XML for selected types
   */
  public String getXMLForTypes(String[] types) {
    types = getChildTypes(types);
    return getXMLForTypes(types, "");
  }

  /**
   * Return the annotation xml for the selected QTL types
   * @param types array of strings with selected QTL types
   * @param linkParams any additional request parameters for QTL link
   * @return String of annotation XML for selected types
   */
  public String getXMLForTypes(String[] types, String linkParams) {
    types = getChildTypes(types);
    ArrayList<GViewerFeature> featuresList = new ArrayList<GViewerFeature>();
    for (int i = 0; i < types.length; i++) {
      featuresList.addAll(features.get(types[i]));
    }
    featuresList = sort(featuresList);
    StringBuffer xml = new StringBuffer();
    Iterator it = featuresList.iterator();
    while (it.hasNext()) {
      GViewerFeature feature = (GViewerFeature) it.next();
      xml.append(feature.toXML(linkParams));
      xml.append("\n");
    }
    return xml.toString();
  }

  /**
   * GViewer annotation XML for all QTLs
   * @return String of GViewer Annotation XML
   */
  public String getXMLForAll() {
    return getXMLForAll("");
  }

  /**
   * Get the annotation xml for all the QTL groups
   * @param linkParams any additional request parameters for the QTL link
   * @return String annotation xml for all QTLs
   */
  public String getXMLForAll(String linkParams) {
    StringBuffer xml = new StringBuffer();
    Set types = features.keySet();
    // sort all the types by chrom then base pair length longest first
    // prevents big QTLs blocking smaller ones when moused over or selected
    Iterator it = types.iterator();
    ArrayList<GViewerFeature> featuresList = new ArrayList<GViewerFeature>();
    while (it.hasNext()) {
      String type = (String) it.next();
      featuresList.addAll(features.get(type));
    }

    //sort
    featuresList = sort(featuresList);
    it = featuresList.iterator();
    while (it.hasNext()) {
      GViewerFeature feat = (GViewerFeature) it.next();
      xml.append(feat.toXML(linkParams)).append("\n");
    }
    return xml.toString();
  }

  private HashMap<String, String> initMap() {
    HashMap<String, String> map = new HashMap<String, String>();
    map.put("adrenal gland", "0xF5DEB3");
    map.put("bone", "0xC4C3D0");
    map.put("brain", "0x666666");
    map.put("eye", "0xC80815");
    map.put("intestine", "0xFF4F00");
    map.put("intestine - large intestine - colon", "0xF28500");
    map.put("intestine - small intestine", "0xFFBF00");
    map.put("leukocyte - lymphocyte", "0x228B22");
    map.put("leukocyte - lymphocyte - B-lymphocyte", "0x32CD32");
    map.put("leukocyte - lymphocyte - B-lymphocyte - plasma cell", "0x3FFF00");
    map.put("leukocyte - lymphocyte - pre-B-lymphocyte", "0x00FF7F");
    map.put("leukocyte - lymphocyte - T-lymphocyte", "0x50C878");
    map.put("leukocyte - myelocyte (granulocyte)", "0x40826D");
    map.put("leukocyte - thymocyte", "0x88CC88");
    map.put("liver", "0x00FFFF");
    map.put("lung", "0x000000");
    map.put("mammary gland", "0xFF55A3");
    map.put("mesodermal cell/mesoblast", "0x1E90bb");
    map.put("muscle - striated", "0x6f9fff");
    map.put("nerve sheath", "0x996633");
    map.put("ovary", "0xFFC0CB");
    map.put("skin", "0xAA66EE");
    map.put("testis", "0x9BDDFF");
    map.put("urinary bladder", "0xFFFF00");

    return map;
  }
  
  

  public ArrayList<GViewerFeature> sort(ArrayList<GViewerFeature> featuresToSort) {
    GViewerFeature[] gvfArray = new GViewerFeature[featuresToSort.size()];
    gvfArray = featuresToSort.toArray(gvfArray);
    Arrays.sort(gvfArray, new FeatureComparator(QTLParser.SORT_FOR_VIWER));
    featuresToSort.clear();
    List<GViewerFeature> tmpList = Arrays.asList(gvfArray);
    featuresToSort.addAll(tmpList);
    return featuresToSort;
  }

  /**
   * Sorts GViewerFeatures by chromosome 1,2...X,Y then by length
   */
  class FeatureComparator implements Comparator<GViewerFeature> {

    private int sortOrder = 0;
    public FeatureComparator(int sortOrder) {
      super();
      this.sortOrder = sortOrder;
    }

    public int compare(GViewerFeature a, GViewerFeature b) {
      int nChromosomeA = -1;
      int nChromosomeB = -1;
      int nReturn = 0;
      try {
        nChromosomeA = Integer.parseInt(a.getChromosome());
      } catch (NumberFormatException ignore) {
      }

      try {
        nChromosomeB = Integer.parseInt(b.getChromosome());
      } catch (NumberFormatException ignore) {
      }

      if ((nChromosomeA == -1) || (nChromosomeB == -1)) {
        nReturn = StringUtils.compare(a.getChromosome(),
                b.getChromosome());
      } else {
        if (nChromosomeA > nChromosomeB) {
          nReturn = 1;
        } else if (nChromosomeA < nChromosomeB) {
          nReturn = -1;
        }
      }
      if (nReturn == 0) {
        if (sortOrder == QTLParser.SORT_FOR_VIWER) {

          // sort by length
          
          try {
            Long lenA = new Long(new Long(a.getEnd()).longValue() - new Long(a.getStart()).longValue());
            Long lenB = new Long(new Long(b.getEnd()).longValue() - new Long(b.getStart()).longValue());
            nReturn = lenB.compareTo(lenA);
          } catch (Exception ignore) {
          }
        } else {
          // sort by start position
          try {
            Long aStart = new Long(a.getStart());
            Long bStart = new Long(b.getStart());
            nReturn = aStart.compareTo(bStart);
          } catch (Exception ignore) {}
        }
      }
      return nReturn;
    }
  }
}
