
function URLencode(sStr) {
    return escape(sStr).
             replace(/\+/g, '%2B').
                replace(/\"/g,'%22').
                   replace(/\'/g, '%27').
                      replace(/\//g,'%2F');
  }

// ---------------------------------------------------------------------------------------------------------------

function do_email() {
    window.location = "mailto:"
                      + "lmazure.website%40gmail.com"
                      + "?subject="
                      + encodeURIComponent("about the '"
                               + document.title
                               +"' page");
}

// ---------------------------------------------------------------------------------------------------------------

function do_search() {
    window.open('../hack/search.htm','_blank','width=500,height=150');
}

// ---------------------------------------------------------------------------------------------------------------

function do_disclaimer() {
    window.open('../hack/disclaim.htm','_blank','width=900,height=600,scrollbars');
}

// ---------------------------------------------------------------------------------------------------------------

function do_help() {
    window.open('../hack/help.htm','_blank','width=900,height=600,scrollbars');
}

// ---------------------------------------------------------------------------------------------------------------

// rfc/<rfc-number>
// man/linux/<man-section-number>/<command>
// man/macosx/<man-section-number>/<command>
// man/x11/<man-section-number>/<command>
// j2se/<class>
// j2se/<class>/<method>
// clearcase/command

function do_reference(str) {
    var a = str.split("/");
    var url="?";
    if ( a[0] == "rfc" ) {
        //url = "http://www.zvon.org/tmRFC/RFC"+a[1]+"/Output/index.html";
        url = "http://www.ietf.org/rfc/rfc"+a[1]+".txt";
    } else if ( a[0] == "man" && a[1] == "linux" ) {
        url = "http://man-wiki.net/index.php/"+a[2]+":"+a[3];
    } else if ( a[0] == "man" && a[1] == "macosx" ) {
        url = "http://developer.apple.com/documentation/Darwin/Reference/ManPages/man"+a[2]+"/"+a[3]+"."+a[2]+".html";
    } else if ( a[0] == "man" && a[1] == "x11" ) {
        url = "http://www.x.org/X11R6.8.2/doc/"+a[3]+"."+a[2]+".html"
    } else if ( a[0] == "j2se" && a.length == 2 ) {
        url = "http://java.sun.com/j2se/1.5.0/docs/api/" + a[1].replace(/\./g,"/") + ".html";
    } else if ( a[0] == "j2se" && a.length == 3 ) {
        url = "http://java.sun.com/j2se/1.5.0/docs/api/" + a[1].replace(/\./g,"/") + ".html#" + escape(a[2]);
    } else if ( a[0] == "clearcase" && a.length == 2 ) {
        url = "http://www.agsrhichome.bnl.gov/Controls/doc/ClearCaseEnv/v4.0doc/cpf_4.0/ccase_ux/ccref/" + a[1] + ".html";
    }
    window.open(url,'_blank');
}

// ---------------------------------------------------------------------------------------------------------------

function create_alpha_page_cb(url) {
    var letters="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var w=100.0/letters.length;
    frames["frame21"].document.writeln('<TABLE WIDTH="100%" BGCOLOR="#E2FFE2"><TR>')
    for (var i=0; i < letters.length; i++ ) {
        frames["frame21"].document.writeln('<TD ALIGN="CENTER" BGCOLOR="#404080" WIDTH="'
                                           +w
                                           +'%"><A HREF="'
                                           +url
                                           +'#'
                                           +letters.charAt(i)
                                           +'" TARGET="frame22"><FONT COLOR="white">'
                                           +letters.charAt(i)
                                           +'</FONT></A></TD>');
  }
  frames["frame21"].document.writeln('<TR></TABLE>');
}
function dump() {
    var parentLocation = parent.location.href;
    var pathLength = parentLocation.lastIndexOf("/");
    if ( parentLocation.substring(pathLength+1, pathLength+6) == "list_" ) {
        var anchors = document.getElementsByTagName("a");
        for ( var i=0; i<anchors.length; i++ ) {
            if ( anchors[i].target == "_self" ) {
                anchors[i].target = "_parent";
            }
        }
    }
}

function toto() {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-45789787-1', 'neuf.fr');
  ga('send', 'pageview');
}

function initialize() {
  dump();
  toto();
}
  
window.onload=initialize;

function create_alpha_page(title, url) {
    document.write("<HTML><HEAD><TITLE>"
                   +title
                   +"</TITLE><LINK REL='STYLESHEET TYPE='text/css' HREF='../css/standard' TITLE='standard'></HEAD>"
                   +"<FRAMESET ROWS='24,*' ONLOAD='create_alpha_page_cb(" +'"' +url +'"' +");'>"
                   +"<FRAME SRC='about:blank' NAME='frame21' MARGINWIDTH='1' MARGINHEIGHT='1' FRAMEBORDER='0' NORESIZE SCROLLING='no'>"
                   +"<FRAME SRC='" +url +"' NAME='frame22' MARGINWIDTH='1' MARGINHEIGHT='1' FRAMEBORDER='0' NORESIZE'>"
                   +"</FRAMESET></HTML>");
}
