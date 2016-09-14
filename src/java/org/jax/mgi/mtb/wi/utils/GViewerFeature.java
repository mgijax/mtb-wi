/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

/**
 * Contains data for a GViewerFeature
 *   <feature>
 *		<chromosome>19</chromosome>	
 *			<start>39493267</start>
 *			<end>46826273</end>
 *			<type>qtl</type>
 *			<color>0x009900</color>
 *			<label>Sluc1</label>
 *	<link></link>
 *	</feature>
 * @author sbn
 */
public class GViewerFeature {

    private String chromosome;
    private String start;
    private String end;
    private String type = "";
    private String color;
    private String description; // called name in MGI
    private String link;
    // default to first row on right side.
    private String track = "R1";
    private String group;
    private String mgiId;
    private String name;  // called Symbol in MGI
    private String primeRef;
    private String organ;
    // for gff format
    private String source;
    private String score;
    private String strand;
    private String phase;
    private String col9;

    public String getChromosome() {
        return chromosome;
    }

    public void setChromosome(String chromosome) {
        this.chromosome = chromosome;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
    
    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public void buildLink() {
        String locationVal = getChromosome() + ":" + getStart() + ".." + getEnd();
        String qtlName = getName();
        if (qtlName != null) {
            qtlName = qtlName.replace(' ', '+');
        }
        setLink("viewer.do?method=details%26id=" + getMgiId() + "%26location=" + locationVal + "%26description=" + getDescription() + "%26primeRef=" + getPrimeRef() + "%26name=" +getName());

    }

    // links from QTL details goto QTL details maybe they should goto MGI?
    // can't use MGI id with marker serach when feature is QTL
    public void buildMGILink() {

        String mgiIdStr = getMgiId();
        mgiIdStr = mgiIdStr.replace(":", "%3A");

        setLink("http://www.informatics.jax.org/searchtool/Search.do?query=" + mgiIdStr);
    }

    public String toXML(String linkParam) {
        StringBuffer xml = new StringBuffer();
        xml.append("<feature>");
        xml.append("<chromosome>");
        xml.append(getChromosome());
        xml.append("</chromosome>");

        xml.append("<start>");
        xml.append(getStart());
        xml.append("</start>");

        xml.append("<end>");
        xml.append(getEnd());
        xml.append("</end>");

        xml.append("<type>");
        xml.append(getType());
        xml.append("</type>");

        xml.append("<color>");
        xml.append(getColor());
        xml.append("</color>");

        xml.append("<description>");
        xml.append(format(getDescription()));
        xml.append("</description>");

        xml.append("<link>");
        xml.append(format(getLink()));

        if (linkParam != null && linkParam.length() > 1) {
            xml.append("%26");
            xml.append(format(linkParam));
        }
        xml.append("</link>");

        xml.append("<name>");
        xml.append(format(getName()));
        xml.append("</name>");

        xml.append("<mgiid>");
        xml.append(getMgiId());
        xml.append("</mgiid>");

        xml.append("<group>");
        xml.append(format(getGroup()));
        xml.append("</group>");

        xml.append("<track>");
        xml.append(getTrack());
        xml.append("</track>");
        
         xml.append("<source>");
        xml.append(format(getSource()));
        xml.append("</source>");

         xml.append("<score>");
        xml.append(format(getScore()));
        xml.append("</score>");

         xml.append("<strand>");
        xml.append(format(getStrand()));
        xml.append("</strand>");

        xml.append("<phase>");
        xml.append(format(getPhase()));
        xml.append("</phase>");
        
        xml.append("<col9>");
        xml.append(format(getCol9()));
        xml.append("</col9>");





        xml.append("</feature>");

        return xml.toString();
    }

    public String format(String xml) {

        String formatted = "";
        if (xml != null) {
            formatted = xml.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "&quot;").replaceAll("'", "&apos;");
        }
        return formatted;
    }

    public String getMgiId() {
        return mgiId;
    }

    public void setMgiId(String mgiId) {
        this.mgiId = mgiId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrimeRef() {
        return primeRef;
    }

    public void setPrimeRef(String primeRef) {
        this.primeRef = primeRef;
    }

    public String getOrgan() {
        return organ;
    }

    public void setOrgan(String organ) {
        this.organ = organ;
    }

    public String getTrack() {
        return track;
    }

    public void setTrack(String track) {
        this.track = track;
    }

    public String getGroup() {
        return group.trim();
    }

    public void setGroup(String group) {
        this.group = group;
    }
    
        /**
     * @return the source
     */
    public String getSource() {
        return source;
    }

    /**
     * @param source the source to set
     */
    public void setSource(String source) {
        this.source = source;
    }

    /**
     * @return the score
     */
    public String getScore() {
        return score;
    }

    /**
     * @param score the score to set
     */
    public void setScore(String score) {
        this.score = score;
    }

    /**
     * @return the strand
     */
    public String getStrand() {
        return strand;
    }

    /**
     * @param strand the strand to set
     */
    public void setStrand(String strand) {
        this.strand = strand;
    }

    /**
     * @return the phase
     */
    public String getPhase() {
        return phase;
    }

    /**
     * @param phase the phase to set
     */
    public void setPhase(String phase) {
        this.phase = phase;
    }
    

    public String toGFF() {
        StringBuffer gff = new StringBuffer();
        // gff.append("chr");
        gff.append(this.getChromosome());
        gff.append("\t");
        gff.append(checkGFFValue(this.getSource())); // source
        gff.append(checkGFFValue(this.getType()));
        gff.append(this.getStart()).append("\t");
        gff.append(this.getEnd()).append("\t");
        gff.append(checkGFFValue(this.getScore()));
        gff.append(checkGFFValue(this.getStrand()));
        gff.append(checkGFFValue(this.getPhase()));
        
        gff.append(this.getCol9());
        
        if (this.getMgiId() != null && this.getMgiId().trim().length() > 0) {
            gff.append("mgiID=");
            gff.append(this.getMgiId());
            gff.append(";");
        }

        if (this.getColor() != null && this.getColor().trim().length() > 0) {
            gff.append("color=");
            gff.append(this.getColor());
            gff.append(";");
        }

        if (this.getGroup() != null && this.getGroup().trim().length() > 0) {
            gff.append("group=");
            gff.append(this.getGroup());
            gff.append(";");
        }

        if (this.getName() != null && this.getName().trim().length() > 0) {
            gff.append("Name=");
            gff.append(this.getName());
            gff.append(";");
        }

        if (this.getDescription() != null && this.getDescription().trim().length() > 0) {
            gff.append("description=");
            gff.append(this.getDescription());
            gff.append(";");
        }
        
         gff.append("track=");
        if (this.getTrack() == null || this.getTrack().length() <1) {
            gff.append("R");
        } else {
            gff.append(this.getTrack().charAt(0));
        }
        
        return gff.toString();
    }
    
    
    private String checkGFFValue(String val){
     String ret =".\t";    
    
         if (val != null &&  val.trim().length() > 0) {
             ret = val+"\t";
         }
         return ret;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the col9
     */
    public String getCol9() {
        return col9;
    }

    /**
     * @param col9 the col9 to set
     */
    public void setCol9(String col9) {
        this.col9 = col9;
    }


}
