<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes" />

<xsl:variable name="filepath" select="/PAGE/PATH"/>

<xsl:template match="PAGE">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
    <head>
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="icon" type="image/png" href="../icon.png" />
    <xsl:comment>[if IE]&gt;&lt;link rel="shortcut icon" type="image/x-icon" href="../favicon.ico"/&gt;&lt;![endif]</xsl:comment>
    <title>
      <xsl:value-of select="/PAGE/TITLE"/>
    </title>
    <xsl:if test="count(/PAGE/SCRIPT)=1">
      <script type="module">
        <xsl:value-of disable-output-escaping="yes" select="/PAGE/SCRIPT"/>
      </script>
    </xsl:if>
    </head>
    <body>
      <header id="header">
        <h1><xsl:value-of select="/PAGE/TITLE"/></h1>
      </header>
      <section id="content">
        <xsl:if test="@status='unmaintained'">
          <div id="unmaintained">
            <xsl:text>This page is unmaintained. It may contain out-of-date data, broken links...</xsl:text>
          </div>
        </xsl:if>
        <xsl:apply-templates select="/PAGE/CONTENT"/>
      </section>
      <hr id="footerSeparator"/>
      <footer id="footer">
        <div style="display:grid;">
          <div style="grid-column:1;grid-row:1;">
            <xsl:if test="count(/PAGE/X)>0">
              <xsl:text>See also: </xsl:text>
              <xsl:for-each select="/PAGE/X">
                <xsl:apply-templates select="."/>
                <xsl:if test="not(position()=last())" >
                  <xsl:text> | </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </div>
          <div style="grid-column:2;grid-row:1;text-align:right;">
            <xsl:text>Last update: </xsl:text>
            <xsl:apply-templates select="/PAGE/DATE"/>
          </div>
        </div>
        <div id="searchPanel" style="display:none">
          <form id="searchForm" style="display:grid;" name="search" onsubmit="do_search(); return false;">
            <input id="searchText" style="grid-column:1/span 3;grid-row:1;" size="32" name="terms" type="text"/>
            <input id="searchButton" style="grid-column:4;grid-row:1;" value="Search" onclick="do_search();" type="button"/>
          </form>
        </div>
        <div style="display:grid;">
          <div style="grid-column:1;grid-row:1;font-size:300%;text-align:center;">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>../content/map.html?page=</xsl:text>
                <xsl:value-of select = "substring($filepath,1,string-length($filepath)-3)"/>
                <xsl:text>html</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="id">
                <xsl:text>goToMap</xsl:text>
              </xsl:attribute>
              <xsl:text>🧭</xsl:text>
            </xsl:element>
          </div>
          <div style="grid-column:2;grid-row:1;font-size:300%;text-align:center;">
            <a id="doEmail" title="contact" target="_self" href="javascript:do_email()">✉️</a>
          </div>
          <div style="grid-column:3;grid-row:1;font-size:300%;text-align:center;">
            <a id="displaySearch" title="site search" target="_self" href="javascript:display_search()">🔎</a>
          </div>
        </div>
      </footer>
      <xsl:if test="count(/PAGE//MATH)>0">
        <script>MathJax = { tex: { inlineMath: [['£[','£]']] }, svg: { fontCache: 'global' } };</script>
        <xsl:element name="script">
          <xsl:attribute name="type">text/javascript</xsl:attribute>
          <xsl:attribute name="async"/>
          <xsl:attribute name="src">https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js</xsl:attribute>
        </xsl:element>
      </xsl:if>
      <script src="../scripts/common.js" type="module"></script>
      <xsl:if test="@special='indexed'">
        <script>document.addEventListener("DOMContentLoaded", function(e) { window.onLoad = create_index();});</script>
      </xsl:if>
    </body>
  </html>
</xsl:template>

<xsl:template match="ARTICLE">
  <xsl:if test="@predecessor">
    <xsl:text>↪</xsl:text>
  </xsl:if>
  <xsl:for-each select="./X">
    <xsl:if test="position()=2" >
      <xsl:text> (</xsl:text>
    </xsl:if>
    <xsl:if test="position()>2" >
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="position()=1" >
      <xsl:apply-templates select=".">
        <xsl:with-param name="titleclass" select="'articletitle'" />
        <xsl:with-param name="subtitleclass" select="'articlesubtitle'" />
      </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="position()>1" >
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="./A"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>c͟o͟p͟y͟</xsl:text>
          <xsl:text>&#xA;title:</xsl:text>
          <xsl:for-each select="./T"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
          <xsl:text>&#xA;subtitle:</xsl:text>
          <xsl:for-each select="./ST"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
          <xsl:text>&#xA;URL:</xsl:text>
          <xsl:for-each select="./A"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
          <xsl:text>&#xA;language:</xsl:text>
          <xsl:for-each select="./L"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
          <xsl:text>&#xA;format:</xsl:text>
          <xsl:for-each select="./F"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
          <xsl:if test="count(./DURATION)=1">
            <xsl:text>&#xA;duration: </xsl:text>
            <xsl:apply-templates select="./DURATION"/>
          </xsl:if>
          <xsl:if test="count(./DATE)=1">
            <xsl:text>&#xA;publication date: </xsl:text>
            <xsl:apply-templates select="./DATE"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
        <span class='articletitle'>⧉</span>
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
    <xsl:text> ► </xsl:text>
    <xsl:apply-templates select="./COMMENT"/>
  </xsl:if>
</xsl:template>

<xsl:template match="KEYWORD">
  <xsl:element name="span">
    <xsl:attribute name="class">keyword</xsl:attribute>
    <xsl:attribute name="onClick">
      <xsl:text>do_keyword(event, "</xsl:text>
      <xsl:value-of select="./KEYID"/>
      <xsl:text>")</xsl:text>
    </xsl:attribute>
    <xsl:value-of select="KEYEDTEXT"/>
  </xsl:element>
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
  </code>
</xsl:template>

<xsl:template match="CODEMENU">
  <span class="codemenu"><xsl:if test="name(..)='CODEMENU'"><xsl:text> &#x25BA; </xsl:text></xsl:if><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="MATH">
  <xsl:text>£[</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>£]</xsl:text>
</xsl:template>

<xsl:template match="X">
  <xsl:param name="titleclass" select="'linktitle'" />
  <xsl:param name="subtitleclass" select="'linksubtitle'" />
  <xsl:element name="a">
    <xsl:for-each select="./ATTRIBUTE">
    <xsl:attribute name="{./ATTRIBUTENAME}">
      <xsl:value-of select="./ATTRIBUTEVALUE"/>
    </xsl:attribute>
    </xsl:for-each>
    <xsl:attribute name="href">
      <xsl:value-of select="./A"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:text>language:</xsl:text>
      <xsl:for-each select="./L"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
      <xsl:text>&#xA;format:</xsl:text>
      <xsl:for-each select="./F"><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:for-each>
      <xsl:if test="count(./DURATION)=1">
        <xsl:text>&#xA;duration: </xsl:text>
        <xsl:apply-templates select="./DURATION"/>
      </xsl:if>
      <xsl:if test="count(./DATE)=1">
        <xsl:text>&#xA;publication date: </xsl:text>
        <xsl:apply-templates select="./DATE"/>
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
    <xsl:element name="span">
      <xsl:attribute name="class">
        <xsl:value-of select="$titleclass"/>
      </xsl:attribute>
      <xsl:value-of select="./T"/>
    </xsl:element>
    <xsl:for-each select="./ST">
      <xsl:text> — </xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="$subtitleclass"/>
        </xsl:attribute>
      <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:element>
  <xsl:for-each select="./FEED">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="./A"/></xsl:attribute>
      <xsl:attribute name="title">RSS feed</xsl:attribute>
      <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="$titleclass"/>
        </xsl:attribute>
        <xsl:text>📡</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="@quality='2'">
      <span title="very good"><xsl:text>⇈</xsl:text></span>
    </xsl:when>
    <xsl:when test="@quality='1'">
      <span title="good"><xsl:text>↑</xsl:text></span>
    </xsl:when>
    <xsl:when test="@quality='-1'">
      <span title="bad"><xsl:text>↓</xsl:text></span>
    </xsl:when>
    <xsl:when test="@quality='-2'">
      <span title="very bad"><xsl:text>⇊</xsl:text></span>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="@status='removed'">
      <span title="removed page"><xsl:text>🗑️</xsl:text></span>
    </xsl:when>
    <xsl:when test="@status='dead' or @status='zombie'">
      <span title="dead link"><xsl:text>🚫</xsl:text></span>
    </xsl:when>
    <xsl:when test="@status='obsolete'">
      <span title="obsolete"><xsl:text>🏚️</xsl:text></span>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="@protection='free_registration'">
      <span title="free registration required"><xsl:text>🆓</xsl:text></span>
    </xsl:when>
    <xsl:when test="@protection='payed_registration'">
      <span title="payed registration required"><xsl:text>💰</xsl:text></span>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="ANCHOR">
  <xsl:element name="span">
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
    <xsl:for-each select="./HEADERROW">
      <tr>
        <xsl:for-each select="./CELL">
          <xsl:element name="th">
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

<xsl:template match="AUTHOR">
  <xsl:element name="span">
    <xsl:attribute name="class">author</xsl:attribute>
    <xsl:attribute name="onClick">
      <xsl:text>do_person(event, {</xsl:text>
      <xsl:choose>
        <xsl:when test="count(./NAMEPREFIX)=1">
          <xsl:text>namePrefix:"</xsl:text><xsl:value-of select="./NAMEPREFIX"/><xsl:text>",</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(./FIRSTNAME)=1">
          <xsl:text>firstName:"</xsl:text><xsl:value-of select="./FIRSTNAME"/><xsl:text>",</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(./MIDDLENAME)=1">
          <xsl:text>middleName:"</xsl:text><xsl:value-of select="./MIDDLENAME"/><xsl:text>",</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(./LASTNAME)=1">
          <xsl:text>lastName:"</xsl:text><xsl:value-of select="./LASTNAME"/><xsl:text>",</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(./NAMESUFFIX)=1">
          <xsl:text>nameSuffix:"</xsl:text><xsl:value-of select="./NAMESUFFIX"/><xsl:text>",</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(./GIVENNAME)=1">
          <xsl:text>givenName:"</xsl:text><xsl:value-of select="./GIVENNAME"/><xsl:text>"</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text> })</xsl:text>
    </xsl:attribute>
    <xsl:for-each select="NAMEPREFIX/text() | FIRSTNAME/text() | MIDDLENAME/text() | LASTNAME/text() | NAMESUFFIX/text() | GIVENNAME/text()">
      <xsl:if test="name(parent::*)='GIVENNAME'"><xsl:text>"</xsl:text></xsl:if>
      <xsl:value-of select="."/>
      <xsl:if test="name(parent::*)='GIVENNAME'"><xsl:text>"</xsl:text></xsl:if>
      <xsl:if test="not(position() = last())"><xsl:text> </xsl:text></xsl:if>
    </xsl:for-each>
  </xsl:element>
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
  <xsl:if test="count(./TITLE)>0">
    <xsl:apply-templates select="./TITLE"/><br/>
  </xsl:if>
  <xsl:if test="count(./SUBTITLE)>0">
    <xsl:apply-templates select="./SUBTITLE"/><br/>
  </xsl:if>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <xsl:apply-templates select="./ITEM"/>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="BLIST">
  <xsl:if test="count(./TITLE)>0">
    <xsl:apply-templates select="./TITLE"/>
    <xsl:if test="count(./SUBTITLE)>0">
      <br/>
    </xsl:if>
  </xsl:if>
  <xsl:if test="count(./SUBTITLE)>0">
    <xsl:apply-templates select="./SUBTITLE"/>
  </xsl:if>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <ul><xsl:apply-templates select="./ITEM"/></ul>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="NLIST">
  <xsl:if test="count(./TITLE)>0">
    <xsl:apply-templates select="./TITLE"/>
    <xsl:if test="count(./SUBTITLE)>0">
      <br/>
    </xsl:if>
  </xsl:if>
  <xsl:if test="count(./SUBTITLE)>0">
    <xsl:apply-templates select="./SUBTITLE"/>
  </xsl:if>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <ol><xsl:apply-templates select="./ITEM"/></ol>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="CLIST">
  <xsl:if test="count(./TITLE)>0">
    <xsl:apply-templates select="./TITLE"/>:
    <xsl:if test="count(./SUBTITLE)>0">
      <xsl:text> — </xsl:text>
    </xsl:if>
  </xsl:if>
  <xsl:if test="count(./SUBTITLE)>0">
    <xsl:apply-templates select="./SUBTITLE"/>
  </xsl:if>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <xsl:apply-templates select="./ITEM"/>
     </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="LLIST">
  <xsl:if test="count(./TITLE)>0">
    <h2><xsl:apply-templates select="./TITLE"/></h2>
    <xsl:if test="count(./SUBTITLE)>0">
      <br/>
    </xsl:if>
  </xsl:if>
  <xsl:if test="count(./SUBTITLE)>0">
    <xsl:apply-templates select="./SUBTITLE"/>
  </xsl:if>
  <xsl:choose>
     <xsl:when test="count(./ITEM)>0">
       <xsl:apply-templates select="./ITEM"/>
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
    <xsl:when test="name(parent::*)='CLIST'">
      <xsl:apply-templates/>
      <xsl:if test="position()&lt;last()" >
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:when test="name(parent::*)='LLIST'">
      <xsl:apply-templates/>
      <xsl:if test="position()&lt;last()" >
        <hr class="line"/>
      </xsl:if>
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

<xsl:template match="SUP">
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template match="SUB">
  <sub><xsl:apply-templates/></sub>
</xsl:template>

<xsl:template match="BR">
  <xsl:element name="br"/>
</xsl:template>

<xsl:template match="LINE">
  <hr class="line"/>
</xsl:template>

<xsl:template match="TAB">&#xA0;&#xA0;&#xA0;&#xA0;</xsl:template>

<xsl:template match="PROMPT">#&gt; </xsl:template>

<xsl:template match="MODIFIERKEY">
  <span class="modifierkey">
    <xsl:choose>
      <xsl:when test="./@id='Windows'"><xsl:text>⊞Win</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="KEY">
  <span class="key">
    <xsl:choose>
      <xsl:when test="./@id='Left'"><xsl:text>←</xsl:text></xsl:when>
      <xsl:when test="./@id='Up'"><xsl:text>↑</xsl:text></xsl:when>
      <xsl:when test="./@id='Right'"><xsl:text>→</xsl:text></xsl:when>
      <xsl:when test="./@id='Down'"><xsl:text>↓</xsl:text></xsl:when>
      <xsl:when test="./@id='Begining'"><xsl:text>↖</xsl:text></xsl:when>
      <xsl:when test="./@id='PageDown'"><xsl:text>⇞</xsl:text></xsl:when>
      <xsl:when test="./@id='PageUp'"><xsl:text>⇟</xsl:text></xsl:when>
      <xsl:when test="./@id='Backspace'"><xsl:text>⟵</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

</xsl:stylesheet>
