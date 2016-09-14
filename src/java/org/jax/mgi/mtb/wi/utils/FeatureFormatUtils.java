/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.Scanner;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 *  <seqname> <source> <feature> <start> <end> <score> <strand> <frame> [attributes] [comments] 
 * @author sbn
 */
public class FeatureFormatUtils {

  static final String tab = "\t";
  static final String newLine = "\n";

  public String parseGFFToXML(String gffText, String color, String group, String track) {

    StringBuffer xml = new StringBuffer();
    ArrayList<GViewerFeature> list = parseGFF(gffText, color, group, track);
    for (GViewerFeature feature : list) {
      xml.append(feature.toXML(""));
    }
    return xml.toString();
  }

  public ArrayList<GViewerFeature> parseGFF(String gffText, String color, String group, String track) {
    ArrayList<GViewerFeature> list = new ArrayList<GViewerFeature>();
    Scanner gffScanner = new Scanner(gffText);
    gffScanner.useDelimiter(newLine);
    Scanner lineScanner = null;
    while (gffScanner.hasNext()) {
      String line = gffScanner.next();
      if(line.charAt(0)!='#'  && line.trim().length()>0){
          lineScanner = new Scanner(line);
          lineScanner.useDelimiter(tab);
          GViewerFeature feature = new GViewerFeature();
          feature.setColor(color);
          feature.setGroup(group);
          feature.setTrack(track);
          feature.setChromosome(parseChrom(lineScanner.next()));
          feature.setSource(lineScanner.next());
          feature.setType(lineScanner.next());
          feature.setStart(lineScanner.next());
          feature.setEnd(lineScanner.next());
          feature.setScore(lineScanner.next()); //score
          feature.setStrand(lineScanner.next()); //strand
          feature.setPhase(lineScanner.next()); //phase
          // if there are color, group, track attributes they will intentionally overwrite the previously set values 
          parseGFFAttributes(feature, lineScanner.next());
          feature.buildLink();
          list.add(feature);
      }
    }
    return list;
  }
  // sequence may start with Ch or Chr
  // try to extract a number
  private String parseChrom(String cStr) {

    cStr = cStr.toUpperCase().trim();

    try {

      Integer.parseInt(cStr);
      return cStr;
    } catch (NumberFormatException nfe) {
    }

    String chrom = "";
    for (int i = 0; i < cStr.length(); i++) {
      Character c = cStr.charAt(i);
      if (Character.isDigit(c) || c.equals('X') || c.equals('Y')) {
        chrom = chrom + c;
      }
    }
    return chrom;
  }

  private void parseGFFAttributes(GViewerFeature feature, String attributes) {
    Scanner scanner = new Scanner(attributes);
    scanner.useDelimiter(";");
    String pairStr;
    String[] pair = {};
    boolean set = false;
    StringBuffer col9 =  new StringBuffer();
    while (scanner.hasNext()) {
        set= false;
      pairStr = scanner.next().trim();
      pair = pairStr.split("=",2);
      if (pair.length > 1) {
        pair[0].trim();
        pair[1].trim();
        if(pair.length > 2){
          for(int i =2; i < pair.length; i++){
            pair[1] = pair[1]+" "+pair[i].trim();
          }
        }
          pair[1].replace("\"", " ");
        

        if (pair[0].equalsIgnoreCase("mgiID")) {
          set=true;
            feature.setMgiId(pair[1]);
          
        }if (pair[0].equalsIgnoreCase("Name")) {
            set=true;
          feature.setName(pair[1]);
        }if (pair[0].equalsIgnoreCase("color")) {
            set=true;
          if((pair[1].length()>1) && (!pair[1].equalsIgnoreCase("null"))){
            feature.setColor(pair[1]);
          }
        }if (pair[0].equalsIgnoreCase("track")) {
            set=true;
           if((pair[1].length()>0) && (!pair[1].equalsIgnoreCase("null"))){
            feature.setTrack(pair[1]);
           }
        }if (pair[0].equalsIgnoreCase("group")) {
            set=true;
          if((pair[1].length()>0) && (!pair[1].equalsIgnoreCase("null"))){
           feature.setGroup(pair[1]);
          }
        }if(pair[0].equalsIgnoreCase("description")){
            set=true;
            if((pair[1].length()>0) && (!pair[1].equalsIgnoreCase("null"))){
           feature.setDescription(pair[1]);
          }
        }
        if(!set){
           // file has values in column 9 that we need to save 
         col9.append(pairStr).append(";");
        }
      }
    }
    feature.setCol9(col9.toString());
  }

  public String parseXMLtoGFF(String xml) throws Exception {
    StringBuffer gff = new StringBuffer();
    gff.append("##gff-version 3 \n");
    FeatureHandler handler = new FeatureHandler();

    XMLReader xr = XMLReaderFactory.createXMLReader();
    xr.setContentHandler(handler);
    InputSource is = new InputSource();
    is.setCharacterStream(new StringReader(xml));
    xr.parse(is);

    ArrayList<GViewerFeature> features = handler.features;
    for (GViewerFeature feature : features) {
      gff.append(feature.toGFF()).append("\n");
    }

    return gff.toString();
  }

  public class FeatureHandler extends DefaultHandler {

    private String element = "";
    private GViewerFeature feature = null;
    ArrayList<GViewerFeature> features = new ArrayList<GViewerFeature>();
    StringBuffer chars = new StringBuffer();

    public void startElement(String uri, String name, String qName, Attributes atts) {
      element = qName;
      if (qName.equalsIgnoreCase("feature")) {
        feature = new GViewerFeature();
      }
    }

    public void endElement(String uri, String name, String qName) {
      if (qName.equalsIgnoreCase("feature")) {
        features.add(feature);
      } else {
         if(!qName.equalsIgnoreCase("features")){
        setValue();
        chars = new StringBuffer();
         }
      }
    }

    public void characters(char ch[], int start, int length) {
      for (int i = 0; i < length; i++) {
        chars.append(ch[i + start]);
      }
    }

    private void setValue() {
      if (element.equalsIgnoreCase("chromosome")) {
        feature.setChromosome(chars.toString());
      } else if (element.equalsIgnoreCase("start")) {
        feature.setStart(chars.toString());
      } else if (element.equalsIgnoreCase("end")) {
        feature.setEnd(chars.toString());
      } else if (element.equalsIgnoreCase("type")) {
        feature.setType(chars.toString());
      } else if (element.equalsIgnoreCase("color")) {
        feature.setColor(chars.toString());
      } else if (element.equalsIgnoreCase("description")) {
        feature.setDescription(chars.toString());
      } else if (element.equalsIgnoreCase("link")) {
        feature.setLink(chars.toString());
      } else if (element.equalsIgnoreCase("mgiid")) {
        feature.setMgiId(chars.toString());
      } else if (element.equalsIgnoreCase("name")) {
        feature.setName(chars.toString());
      } else if (element.equalsIgnoreCase("group")) {
        feature.setGroup(chars.toString());
      } else if (element.equalsIgnoreCase("track")) {
        feature.setTrack(chars.toString());
        } else if (element.equalsIgnoreCase("source")) {
        feature.setSource(chars.toString());
      } else if (element.equalsIgnoreCase("score")) {
        feature.setScore(chars.toString());
      } else if (element.equalsIgnoreCase("strand")) {
        feature.setStrand(chars.toString());
      } else if (element.equalsIgnoreCase("phase")) {
        feature.setPhase(chars.toString());
      }else if (element.equalsIgnoreCase("col9")){
          feature.setCol9(chars.toString());
      }
     
    }
  }
}
