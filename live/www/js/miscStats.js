// FileName: miscStats.js
// You can add this file onto some of your web pages (main home page can
// be enough) by adding the following HTML code to your page body:
//
// <script language=javascript src="/js/miscStats.js"></script>
// <noscript><img src="/js/miscStats.js?nojs=y" height=0 width=0 border=0 style="display: none"></noscript>
//
// * This must be added after the <body> tag, not placed within the
//   <head> tags, or the resulting tracking <img> tag will not be handled
//   correctly by all browsers.  Internet explorer will also not report
//   screen height and width attributes until it begins to render the
//   body.
//
// - Screen size detection (SPYscreen)
// - Browser size detection (SPYwinsize)
// - Screen color depth detection (SPYcdi)
// - Java enabled detection (SPYjava)
// - Macromedia Director plugin detection (SPYshk)
// - Macromedia Shockwave plugin detection (SPYfla)
// - Realplayer G2 plugin detection (SPYrp)
// - QuickTime plugin detection (SPYmov)
// - Mediaplayer plugin detection (SPYwma)
// - Acrobat PDF plugin detection (SPYpdf)

var awstatsmisctrackerurl="http://aragorn.informatics.jax.org:8000/www/mtb/js/miscStats.js";

function awstats_setCookie(SPYNameOfCookie, SPYvalue, SPYexpirehours) {
    var SPYExpireDate = new Date ();
     SPYExpireDate.setTime(SPYExpireDate.getTime() + (SPYexpirehours * 3600 * 1000));
     document.cookie = SPYNameOfCookie + "=" + escape(SPYvalue) + "; path=/" + ((SPYexpirehours == null) ? "" : "; expires=" + SPYExpireDate.toGMTString());
}

function awstats_detectIE(SPYClassID) {
    SPYresult = false;
    document.write('<SCR' + 'IPT LANGUAGE=VBScript>\n on error resume next \n SPYresult = IsObject(CreateObject("' + SPYClassID + '"))</SCR' + 'IPT>\n');
    if (SPYresult) return 'y';
    else return 'n';
}

function awstats_detectNS(SPYClassID) {
    SPYn = "n";
    if (SPYnse.indexOf(SPYClassID) != -1) if (navigator.mimeTypes[SPYClassID].enabledPlugin != null) SPYn = "y";
    return SPYn;
}

function awstats_getCookie(SPYNameOfCookie){
    if (document.cookie.length > 0){
        SPYbegin = document.cookie.indexOf(SPYNameOfCookie+"=");
        if (SPYbegin != -1) {
            SPYbegin += SPYNameOfCookie.length+1;             SPYend = document.cookie.indexOf(";", SPYbegin);
            if (SPYend == -1) SPYend = document.cookie.length;
             return unescape(document.cookie.substring(SPYbegin, SPYend));
        }
        return null;      }
    return null; }

if (window.location.search == "") {

    SPYnow = new Date();
    SPYscreen=screen.width+"x"+screen.height;
    if (navigator.appName != "Netscape") {SPYcdi=screen.colorDepth}
    else {SPYcdi=screen.pixelDepth};
    SPYjava=navigator.javaEnabled();
    
    var SPYrawAgent=navigator.userAgent;
    var SPYencodedAgent=escape(SPYrawAgent);
    var SPYagt=SPYrawAgent.toLowerCase();
    var SPYie  = (SPYagt.indexOf("msie") != -1);
    var SPYns  = (navigator.appName.indexOf("Netscape") != -1);
    var SPYwin = ((SPYagt.indexOf("win")!=-1) || (SPYagt.indexOf("32bit")!=-1));
    var SPYmac = (SPYagt.indexOf("mac")!=-1);

   // Detect the browser internal width and height
   if (document.documentElement && document.documentElement.clientWidth)
       SPYwinsize = document.documentElement.clientWidth + 'x' + document.documentElement.clientHeight;
   else if (document.body)
       SPYwinsize = document.body.clientWidth + 'x' + document.body.clientHeight;
   else
       SPYwinsize = window.innerWidth + 'x' + window.innerHeight;
    
    if (SPYie && SPYwin) {
        var SPYshk = awstats_detectIE("SWCtl.SWCtl.1")
        var SPYfla = awstats_detectIE("ShockwaveFlash.ShockwaveFlash.1")
        var SPYrp  = awstats_detectIE("rmocx.RealPlayer G2 Control.1")
        var SPYmov = awstats_detectIE("QuickTimeCheckObject.QuickTimeCheck.1")
        var SPYwma = awstats_detectIE("MediaPlayer.MediaPlayer.1")
        var SPYpdf = 'n';        if (awstats_detectIE("PDF.PdfCtrl.1") == 'y') { SPYpdf = 'y'; }
        if (awstats_detectIE('PDF.PdfCtrl.5') == 'y') { SPYpdf = 'y'; }
        if (awstats_detectIE('PDF.PdfCtrl.6') == 'y') { SPYpdf = 'y'; }
    }
    if (SPYns || !SPYwin) {
        SPYnse = ""; for (var SPYi=0;SPYi<navigator.mimeTypes.length;SPYi++) SPYnse += navigator.mimeTypes[SPYi].type.toLowerCase();
        var SPYshk = awstats_detectNS("application/x-director")
        var SPYfla = awstats_detectNS("application/x-shockwave-flash")
        var SPYrp  = awstats_detectNS("audio/x-pn-realaudio-plugin")
        var SPYmov = awstats_detectNS("video/quicktime")
        var SPYwma = awstats_detectNS("application/x-mplayer2")
        var SPYpdf = awstats_detectNS("application/pdf");
    }
    document.write('<img src="'+awstatsmisctrackerurl+'?screen='+SPYscreen+'&window='+SPYwinsize+'&colorDepth='+SPYcdi+'&javaEnabled='+SPYjava+'&shockwave='+SPYshk+'&flash='+SPYfla+'&realPlayer='+SPYrp+'&quickTime='+SPYmov+'&wma='+SPYwma+'&pdf='+SPYpdf+'&userAgent='+SPYencodedAgent+'" height=0 width=0 border=0>')
}

