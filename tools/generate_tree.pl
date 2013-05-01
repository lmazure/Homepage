#!/bin/perl -w

use strict;
use warnings;
use diagnostics;

my $mapFile="../hack/map.xml";
my $outFile="../tree.html";
my $depth = 0;
my @count;
$count[0] = 0;

open(MAP,$mapFile) or die("cannot open file $mapFile ($!)"); 
open(OUT,"> ".$outFile) or die("cannot open file $outFile ($!)");

#----------------------------------------------------------------------------------------------

print OUT <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>Default TreeView</title>

<style type="text/css">
/*margin and padding on body element
  can introduce errors in determining
  element position and are not recommended;
  we turn them off as a foundation for YUI
  CSS treatments. */
body {
	margin:0;
	padding:0;
}
</style>

<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.6.0/build/fonts/fonts-min.css">
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.6.0/build/treeview/assets/skins/sam/treeview.css">

<!--begin custom header content for this example-->
<style>
    #treeDiv1 {background: #fff; padding:1em;}
</style>
<!--end custom header content for this example-->

</head>

<body class="yui-skin-sam">

<!--BEGIN SOURCE CODE FOR EXAMPLE =============================== -->

<div id="treeDiv1"><ul>
EOF
;

#----------------------------------------------------------------------------------------------

while ( my $line = <MAP> ) {

  if ( $line =~ m{<ITEM><X[^>]*><T>(.*?)</T><A>../(.*?)</A>(<L>..</L>)+<F>.*?</F></X></ITEM>} ) {
    #print OUT "," if ($count[$depth]>0);
    print OUT "  "x$depth, "<li><a href='$2' target='frame2'>$1</a></li>\n";
    $count[$depth]++;
    next;
  }

  if ( $line =~ m{<ITEM><BLIST><TITLE><X[^>]*><T>(.*?)</T><A>../(.*?)</A>(<L>..</L>)+<F>.*?</F></X></TITLE>} ) {
    #print OUT "," if ($count[$depth]>0);
    print OUT "  "x$depth, "<li><a href='$2' target='frame2'>$1</a></li>\n";
    print OUT "  "x$depth, "<ul>";
    $count[$depth]++;
    $depth++;
    $count[$depth]=0;
    next;
  }

  if ( $line =~ m{<ITEM><BLIST><TITLE>(.*?)</TITLE>} ) {
    #print OUT "," if ($count[$depth]>0);
    print OUT "  "x$depth, "<li>$1</li>\n";
    print OUT "  "x$depth, "<ul>";
    $count[$depth]++;
    $depth++;
    $count[$depth]=0;
    next;
  }

  if ( $line =~ m{</BLIST></ITEM>} ) {
    $depth--;
    print OUT "  "x$depth, "</ul>";
    next;
  }

}

#----------------------------------------------------------------------------------------------

print OUT <<EOF
</lu></div>

<script type="text/javascript" src="http://yui.yahooapis.com/2.6.0/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="http://yui.yahooapis.com/2.6.0/build/treeview/treeview-min.js"></script>
<script type="text/javascript">

//global variable to allow console inspection of tree:
var tree;

//anonymous function wraps the remainder of the logic:
(function() {

	//function to initialize the tree:
    function treeInit() {
        buildRandomTextNodeTree();
    }
    
	//Function  creates the tree and 
	//builds between 3 and 7 children of the root node:
    function buildRandomTextNodeTree() {
	
		//instantiate the tree:
//        tree = new YAHOO.widget.TreeView("treeDiv1");
tree = new YAHOO.widget.TreeView(document.getElementById("treeDiv1")); 

       // Expand and collapse happen prior to the actual expand/collapse,
       // and can be used to cancel the operation
       tree.subscribe("expand", function(node) {
              YAHOO.log(node.index + " was expanded", "info", "example");
              // return false; // return false to cancel the expand
           });

       tree.subscribe("collapse", function(node) {
              YAHOO.log(node.index + " was collapsed", "info", "example");
           });

       // Trees with TextNodes will fire an event for when the label is clicked:
       tree.subscribe("labelClick", function(node) {
              YAHOO.log(node.index + " label was clicked", "info", "example");
           });

		//The tree is not created in the DOM until this method is called:
        tree.draw();
    }


	//Add an onDOMReady handler to build the tree when the document is ready
    YAHOO.util.Event.onDOMReady(treeInit);

})();

</script>
</body>
</html>
EOF
;

#----------------------------------------------------------------------------------------------


close(MAP) or die("cannot close file $mapFile ($!)"); 
close(OUT) or die("cannot close file $outFile ($!)");
