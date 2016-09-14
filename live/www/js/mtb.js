
// FileName: mtb.js




function popPathWin(url, winId) {
    var mtbDefWindow=window.open(url,winId,'toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes,width=700,height=500');
	mtbDefWindow.focus();
}

function popSizedPathWin(url,winId,height,width) {
    var mtbDefWindow=window.open(url,winId,'toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes,width='+width+',height='+height+"'");
	mtbDefWindow.focus();
    //    return mtbDefWindow;
   
}

function focusBackToOpener(url) {

    if(window.opener && !window.opener.closed)
	{
      opener.location.href = url;
      opener.focus();
	}else{
	
	 var newWin = window.open(url);
	 newWin.focus();
	}
}


