function create_index() {
    var letters="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var w=100.0/letters.length;
    str = '<TABLE WIDTH="100%" BGCOLOR="#E2FFE2"><TR>';
    for (var i=0; i < letters.length; i++ ) {
        str += '<TD ALIGN="CENTER" BGCOLOR="#404080" WIDTH="'
                                           + w
                                           + '%"><A HREF="#'
                                           + letters.charAt(i)
                                           + '"><FONT COLOR="white">'
                                           + letters.charAt(i)
                                           + '</FONT></A></TD>';
  }
  str += '<TR></TABLE>';
  $( "body" ).prepend(str);
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

function display_search() {
	$("#searchPanel").slideToggle({ progress: function() {
  	  scrollTo(0,document.body.scrollHeight);
    }});
}

// ---------------------------------------------------------------------------------------------------------------

function do_search() {
  var request = "http://www.google.com/search?as_sitesearch=mazure.fr&q=";
  var terms = document.search.terms.value.split(" ");
  for (i = 0; i < terms.length; i++)
  {
    if (terms[i]!="") { // to avoid additional space characters
      if (i>0) request += "+";
      request += terms[i];
    }
  }
  open(request, '_self');
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

function initialize() {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-45789787-1', 'neuf.fr');
  ga('send', 'pageview');
}
  
window.onload=initialize;

