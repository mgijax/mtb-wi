/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.jax.mgi.mtb.wi.utils;

import java.io.File;
import java.util.HashMap;
import java.util.Scanner;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.actions.ViewerAction;

/**
 * Parses a file of XML chromosme banding details
 * Makes them available by chromosme
 * @author sbn
 */

public class BandingParser {
  
     private final static Logger log =  Logger.getLogger(ViewerAction.class.getName());
  
      private static  String fileStr = WIConstants.getInstance().getMouseIdeoFile(); 
      
      // need to wrap these in <genome></genome> tags
      private static HashMap<String,String> mBands  = new HashMap<String,String>();
      
         private static HashMap<String,String> hBands  = new HashMap<String,String>();
      
      private static BandingParser instance;
     
      
      public static String getAllBands(){
        checkInstance();
        StringBuffer buff = new StringBuffer();
         buff.append("<genome>");
        for(String band : mBands.values()){
          buff.append(band);
        }
        buff.append("</genome>");
        return buff.toString();
      }
      
      public static String getBands(String ch){
        checkInstance();
        StringBuffer buff = new StringBuffer();
        buff.append("<genome>");
        buff.append(mBands.get(ch));
        buff.append("</genome>");
        return buff.toString();
      }
      
      public static String getHumanBands(){
        checkInstance();
        StringBuffer buff = new StringBuffer();
         buff.append("<genome>");
        for(String band : hBands.values()){
          buff.append(band);
        }
        buff.append("</genome>");
        return buff.toString();
      }
      
    
      
      private static void checkInstance(){
        if(instance == null){
          instance  = new BandingParser();
          instance.parseMouseFile();
    //      instance.parseHumanFile();
        }
      }
      
      private void  parseMouseFile(){
   
        try{
          String line ="";
          String ch = "";
          StringBuffer buff= new StringBuffer();
          int start = 0;
          int end = 0;
          Scanner scanner = new Scanner(new File(fileStr));
          scanner.useDelimiter("\n");
          while(scanner.hasNext()){
            line = scanner.next();
            if(line.indexOf("<chromosome") != -1){
              if(buff.length() > 0){
                mBands.put(ch, buff.toString());
                buff.setLength(0);
              } 
              start = line.indexOf("number=");
              start = start + 8;
              end = line.indexOf("\"",start);
              ch = line.substring(start, end);
            }
            if(line.indexOf("genome") == -1){
              buff.append(line.trim());
            }
          }
          mBands.put(ch, buff.toString());
      }catch (Exception e){log.error(e);
      }
      }
      
      
      private void  parseHumanFile(){
   
        try{
          String line ="";
          String ch = "";
          StringBuffer buff= new StringBuffer();
          int start = 0;
          int end = 0;
          Scanner scanner = new Scanner(new File("C:/human_ideo.xml"));
          scanner.useDelimiter("\n");
          while(scanner.hasNext()){
            line = scanner.next();
            if(line.indexOf("<chromosome") != -1){
              if(buff.length() > 0){
                hBands.put(ch, buff.toString());
                buff.setLength(0);
              } 
              start = line.indexOf("number=");
              start = start + 8;
              end = line.indexOf("\"",start);
              ch = line.substring(start, end);
            }
            if(line.indexOf("genome") == -1){
              buff.append(line.trim());
            }
          }
          hBands.put(ch, buff.toString());
      }catch (Exception e){log.error(e);
      }
      }
      
      
      
}