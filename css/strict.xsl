<xsl:stylesheet version = '1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output method="html" encoding="utf-8" indent="yes" />

<xsl:variable name="filepath" select="/PAGE/PATH"/>

<xsl:template match="PAGE">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>
      <xsl:value-of select="/PAGE/TITLE"/>
    </title>
    <script src="../css/common.js"></script>
    <xsl:if test="count(/PAGE/SCRIPT)=1">
      <script type="text/javascript">
        <xsl:value-of disable-output-escaping="yes" select="/PAGE/SCRIPT"/>
      </script>
    </xsl:if>
    </head>
    <body>
      <div id="header">
        <h1><xsl:value-of select="/PAGE/TITLE"/></h1>
      </div>
      <div id="body">
        <xsl:if test="@status='unmaintained'">
          <div id="unmaintained">
            <xsl:text>This page is unmaintained. It may contain out-of-date data, broken links...</xsl:text>
          </div>
        </xsl:if>
        <xsl:apply-templates select="/PAGE/CONTENT"/>
      </div>
      <hr id="footerseparator"/>
      <div id ="footer">
        <table class="footertable">
          <tr>
            <td>
              <xsl:text>See also: </xsl:text>
              <xsl:for-each select="/PAGE/X">
                <xsl:apply-templates select="."/>
                <xsl:if test="not(position()=last())" >
                  <xsl:text> | </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </td>
            <td>
              <a href="javascript:do_search()">search</a>
            </td>
          </tr>
          <xsl:apply-templates select="document('../hack/map.xml')/PAGE/CONTENT/BLIST//X[substring(A,4,string-length(A)-7)=substring($filepath,1,string-length($filepath)-3)]/parent::*" mode="map">
            <xsl:with-param name="target">_self</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="document('../hack/map.xml')/PAGE/CONTENT/BLIST//X[substring(A,4,string-length(A)-7)=concat(substring-before($filepath ,'/'),'/list_',substring(substring-after($filepath,'/'),1,string-length(substring-after($filepath,'/'))-3))]/parent::*" mode="map">
            <xsl:with-param name="target">_parent</xsl:with-param>
          </xsl:apply-templates>
          <tr>
            <td>
              <xsl:text>Last update: </xsl:text>
              <xsl:apply-templates select="/PAGE/DATE"/>
            </td>
            <td>
              <a href="javascript:do_disclaimer()">disclaimer</a>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:text>Version: </xsl:text>
              <xsl:choose>
                <xsl:when test="system-property('xsl:vendor-url')='http://xml.apache.org/xalan-j'" >
                  <xsl:element name="a">
                   <xsl:attribute name="href">
                      <xsl:text>../</xsl:text>
                      <xsl:value-of select = "$filepath"/> 
                    </xsl:attribute>
                    <xsl:text>XML</xsl:text>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:text>../</xsl:text>
                      <xsl:value-of select = "substring($filepath,1,string-length($filepath)-3)"/> 
                      <xsl:text>html</xsl:text>
                    </xsl:attribute>
                    <xsl:text>HTML</xsl:text>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <a href="javascript:do_help()">help</a>
            </td>
          </tr>
        </table>
      </div>
    </body>
  </html>
</xsl:template>

<xsl:template match="ARTICLE">
  <xsl:for-each select="./X">
    <xsl:if test="position()=2" >
      <xsl:text> (</xsl:text>
    </xsl:if>
    <xsl:if test="position()>2" >
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="position()=1" >
      <xsl:text>"</xsl:text>
      <xsl:apply-templates select="."/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:if test="position()>1" >
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="./A"/>
        </xsl:attribute>
        <xsl:attribute name="title"><xsl:text>mirror</xsl:text></xsl:attribute>
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
        <xsl:text disable-output-escaping='yes'>M</xsl:text>
      </xsl:element>
    </xsl:if>
    <xsl:if test="(position()=last()) and (position()>1)" >
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:if test="count(./AUTHOR)>0">
    <xsl:text> by </xsl:text>
    <xsl:for-each select="./AUTHOR">
      <xsl:if test="(position()>1) and (position()&lt;last())" >
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="(position()=2) and (position()=last())" >
        <xsl:text> and </xsl:text>
      </xsl:if>
      <xsl:if test="(position()>2) and (position()=last())" >
        <xsl:text>, and </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:if>
  <xsl:if test="count(./DATE)=1">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="./DATE"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="count(./COMMENT)=1">
    <xsl:text disable-output-escaping='yes'> &amp;#x25BA; </xsl:text>
    <xsl:apply-templates select="./COMMENT"/>
  </xsl:if>
</xsl:template>

<xsl:template match="CODESAMPLE">
  <table class="file"><tr><td><code>
    <xsl:apply-templates/>
  </code></td></tr></table>
</xsl:template>

<xsl:template match="TEXTBLOCK">
  <table class="textblock"><tr><td>
    <xsl:apply-templates/>
  </td></tr></table>
</xsl:template>

<xsl:template match="CODEROUTINE">
  <code>
    <xsl:apply-templates/>
  </code>
</xsl:template>

<xsl:template match="CODEFILENAME">
  <code>
    <xsl:apply-templates/>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:text>file://</xsl:text>
        <xsl:choose>
          <xsl:when test="count(./X)>=1">
            <xsl:value-of select="./X/T"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      <xsl:text disable-output-escaping='yes'>&amp;#x25c8;</xsl:text>
    </xsl:element>
  </code>
</xsl:template>

<xsl:template match="CODEMENU">
  <span class="codemenu"><xsl:if test="name(..)='CODEMENU'"><xsl:text disable-output-escaping='yes'> &amp;#x25BA; </xsl:text></xsl:if><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="X">
  <xsl:element name="a">
    <xsl:attribute name="href">
      <xsl:value-of select="./A"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:text>language: </xsl:text>
      <xsl:for-each select="./L"><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:for-each>
      <xsl:text>| format: </xsl:text>
      <xsl:for-each select="./F"><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:for-each>
      <xsl:if test="count(./DURATION)=1">
        <xsl:text>| duration: </xsl:text>
        <xsl:apply-templates select="./DURATION"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="@type='feed'">
        <xsl:attribute name="target"><xsl:text>_self</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:when test="starts-with(./A,'ftp://')">
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:when test="starts-with(./A,'http://')">
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:when test="starts-with(./A,'https://')">
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:when test="starts-with(./A,'file://')">
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:when test="starts-with(./A,'../')">
        <xsl:attribute name="target"><xsl:text>_self</xsl:text></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="target"><xsl:text>_self</xsl:text></xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <span class="linktitle"><xsl:value-of select="./T"/></span>
    <xsl:for-each select="./ST">
      <xsl:text> &#8212; </xsl:text><span class="linksubtitle"><xsl:value-of select="."/></span>
    </xsl:for-each>
  </xsl:element>
  <xsl:for-each select="./FEED">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="./A"/></xsl:attribute>
      <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      <xsl:element name="img">
        <xsl:attribute name="src"><xsl:text>../images/feed.jpg</xsl:text></xsl:attribute>
        <xsl:attribute name="alt"><xsl:value-of select="./F"/><xsl:text> feed</xsl:text></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="./F"/><xsl:text> feed</xsl:text></xsl:attribute>
        <xsl:attribute name="border"><xsl:text>0</xsl:text></xsl:attribute>
        <xsl:attribute name="width"><xsl:text>16</xsl:text></xsl:attribute>
        <xsl:attribute name="height"><xsl:text>16</xsl:text></xsl:attribute>
        <xsl:attribute name="class">inlinedimage</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:for-each>
  <xsl:for-each select="./LISTEN">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="./A"/></xsl:attribute>
      <xsl:element name="img">
        <xsl:attribute name="src"><xsl:text>../images/listen.gif</xsl:text></xsl:attribute>
        <xsl:attribute name="alt"><xsl:value-of select="./F"/><xsl:text> stream</xsl:text></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="./F"/><xsl:text> stream</xsl:text></xsl:attribute>
        <xsl:attribute name="border"><xsl:text>0</xsl:text></xsl:attribute>
        <xsl:attribute name="width"><xsl:text>11</xsl:text></xsl:attribute>
        <xsl:attribute name="height"><xsl:text>9</xsl:text></xsl:attribute>
        <xsl:attribute name="class">inlinedimage</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="@quality='2'">
      <img src="../images/thumbup.gif" alt="very good" title="very good" width="16" height="16" class="inlinedimage"/>
      <img src="../images/thumbup.gif" alt="very good" title="very good" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@quality='1'">
      <img src="../images/thumbup.gif" alt="good" title="good" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@quality='-1'">
      <img src="../images/thumbdown.gif" alt="bad" title="bad" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@quality='-2'">
      <img src="../images/thumbdown.gif" alt="very bad" title="very bad" width="16" height="16" class="inlinedimage"/>
      <img src="../images/thumbdown.gif" alt="very bad" title="very bad" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="@status='dead' or @status='zombie'">
      <img src="../images/dead.gif" alt="dead link" title="dead link" width="6" height="14" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@status='obsolete'">
      <img src="../images/obsolete.gif" alt="obsolete" title="obsolete" width="6" height="14" class="inlinedimage"/>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="@protection='firewall'">
      <img src="../images/firewall.png" alt="protected behind a firewall" title="protected behind a firewall" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@protection='free_registration'">
      <img src="../images/free_registration.png" alt="free registration required" title="free registration required" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@protection='payed_registration'">
      <img src="../images/payed_registration.png" alt="payed registration required" title="payed registration required" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
    <xsl:when test="@protection='protected'">
      <img src="../images/lock.png" alt="protected" title="protected" width="16" height="16" class="inlinedimage"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="ANCHOR">
  <xsl:element name="div">
    <xsl:attribute name="id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="IMAGE">
  <xsl:element name="img">
    <xsl:attribute name="src">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="TABLE">
  <table class="table">
    <xsl:for-each select="./ROW">
      <tr>
        <xsl:for-each select="./CELL">
          <xsl:element name="td">
            <xsl:if test="@width>1">
              <xsl:attribute name="colspan">
                <xsl:value-of select="@width"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@height>1">
              <xsl:attribute name="rowspan">
                <xsl:value-of select="@height"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="."/>
          </xsl:element>
        </xsl:for-each>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="DEFINITIONTABLE">
  <table class="table">
    <xsl:for-each select="./ROW">
      <tr>
        <td>
          <xsl:apply-templates select="./TERM"/>
        </td>
        <td>
          <xsl:apply-templates select="./DESC"/>
        </td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="DEFINITION2TABLE">
  <table class="table">
    <xsl:for-each select="./ROW">
      <tr>
        <td>
          <xsl:apply-templates select="./TERM1"/>
        </td>
        <td>
          <xsl:apply-templates select="./TERM2"/>
        </td>
        <td>
          <xsl:apply-templates select="./DESC"/>
        </td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="DURATION">
  <xsl:if test="count(./HOUR)=1">
    <xsl:value-of select="./HOUR"/>
    <xsl:text>h</xsl:text>
  </xsl:if>
  <xsl:if test="count(./MINUTE)=1">
    <xsl:if test="count(./HOUR)=1"><xsl:text> </xsl:text></xsl:if>
    <xsl:value-of select="./MINUTE"/>
    <xsl:text>m</xsl:text>
  </xsl:if>
  <xsl:if test="count(./SECOND)=1">
    <xsl:if test="count(./MINUTE)=1"><xsl:text> </xsl:text></xsl:if>
    <xsl:value-of select="./SECOND"/>
    <xsl:text>s</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="DATE">
  <xsl:apply-templates select="MONTH"/>
  <xsl:apply-templates select="DAY"/>
  <xsl:apply-templates select="YEAR"/>
</xsl:template>

<xsl:template match="MONTH">
  <xsl:choose>
    <xsl:when test=".=1">January </xsl:when>
    <xsl:when test=".=2">February </xsl:when>
    <xsl:when test=".=3">March </xsl:when>
    <xsl:when test=".=4">April </xsl:when>
    <xsl:when test=".=5">May </xsl:when>
    <xsl:when test=".=6">June </xsl:when>
    <xsl:when test=".=7">July </xsl:when>
    <xsl:when test=".=8">August </xsl:when>
    <xsl:when test=".=9">September </xsl:when>
    <xsl:when test=".=10">October </xsl:when>
    <xsl:when test=".=11">November </xsl:when>
    <xsl:when test=".=12">December </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="DAY">
  <xsl:value-of select="."/>
  <sup>
    <xsl:choose>
      <xsl:when test=".=1 or .=21 or .=31">st</xsl:when>
      <xsl:when test=".=2 or .=22">nd</xsl:when>
      <xsl:when test=".=3 or .=23">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose>
  </sup>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="SLIST">
  <xsl:apply-templates select="./TITLE"/><br/>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <xsl:apply-templates select="./ITEM"/>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="BLIST">
  <xsl:apply-templates select="./TITLE"/>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <ul><xsl:apply-templates select="./ITEM"/></ul>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="NLIST">
  <xsl:apply-templates select="./TITLE"/>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <ol><xsl:apply-templates select="./ITEM"/></ol>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="ITEM">
  <xsl:choose>
    <xsl:when test="name(parent::*)='NLIST'">
      <li><xsl:apply-templates/></li>
    </xsl:when>
    <xsl:when test="name(parent::*)='BLIST'">
      <li><xsl:apply-templates/></li>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/><br/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="U">
  <u><xsl:apply-templates/></u>
</xsl:template>

<xsl:template match="B">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="I">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="SMALL">
  <small><xsl:apply-templates/></small>
</xsl:template>

<xsl:template match="STRIKE">
  <span style="text-decoration: line-through"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="SUP">
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template match="SUB">
  <sub><xsl:apply-templates/></sub>
</xsl:template>

<xsl:template match="SCRIPT">
  <script><xsl:value-of disable-output-escaping="yes" select="."/></script>
</xsl:template>

<xsl:template match="BR">
  <xsl:element name="br"/>
</xsl:template>

<xsl:template match="LINE">
  <hr class="line"/>
</xsl:template>

<xsl:template match="TAB">&#xA0;&#xA0;&#xA0;&#xA0;</xsl:template>

<xsl:template match="TABCHAR"><xsl:text disable-output-escaping='yes'>&amp;perp;</xsl:text></xsl:template>

<xsl:template match="PROMPT">#&gt; </xsl:template>

<xsl:template match="MODIFIERKEY">
  <span class="modifierkey">
    <xsl:value-of select="@ID"/>
  </span>
</xsl:template>

<xsl:template match="KEY">
  <span class="key">
    <xsl:choose>
      <xsl:when test="./@ID='Left'"><xsl:text disable-output-escaping='yes'>&amp;larr;</xsl:text></xsl:when>
      <xsl:when test="./@ID='Up'"><xsl:text disable-output-escaping='yes'>&amp;uarr;</xsl:text></xsl:when>
      <xsl:when test="./@ID='Right'"><xsl:text disable-output-escaping='yes'>&amp;rarr;</xsl:text></xsl:when>
      <xsl:when test="./@ID='Down'"><xsl:text disable-output-escaping='yes'>&amp;darr;</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="@ID"/></xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="*" mode="map">
  <xsl:param name="target">_self</xsl:param>  
  <tr>
    <td>
      <xsl:text>Pages above: </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="href">../perso/main.html</xsl:attribute>
        <xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>homepage</xsl:element>

      <xsl:choose>
        <xsl:when test="count(./self::TITLE)=1">
          <xsl:for-each select="./parent::*/parent::*/ancestor::*[self::ITEM]">
            <xsl:text>&gt;</xsl:text>
            <xsl:call-template name="map_item">
              <xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="./ancestor::*[self::ITEM]">
            <xsl:text>&gt;</xsl:text>
            <xsl:call-template name="map_item">
              <xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:element name="a">
        <xsl:attribute name="href">../hack/map.html</xsl:attribute>
        <xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>map</xsl:element>

    </td>
  </tr>
  <tr>
    <td>
      <xsl:text>Pages below: </xsl:text>
      <xsl:if test="count(./self::TITLE)=1" >
        <xsl:for-each select="./parent::*/child::*[self::ITEM]">
          <xsl:call-template name="map_item">
            <xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
          </xsl:call-template>
          <xsl:if test="not(position()=last())" >
            <xsl:text> | </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </td>
    <td>
      <xsl:element name="a">
        <xsl:attribute name="href">javascript:do_email()</xsl:attribute>
        <xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>contact me</xsl:element>

    </td>
  </tr>
</xsl:template>

<xsl:template name="map_item">
  <xsl:param name="target">_self</xsl:param>  
  <xsl:choose>
    <xsl:when test="count(./X)=1">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="./X/A"/>
        </xsl:attribute>
        <xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
        <xsl:value-of select="./X/T"/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="count(./BLIST/TITLE/X)=1">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="./BLIST/TITLE/X/A"/>
        </xsl:attribute>
        <xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
        <xsl:value-of select="./BLIST/TITLE/X/T"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="./BLIST/TITLE"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
