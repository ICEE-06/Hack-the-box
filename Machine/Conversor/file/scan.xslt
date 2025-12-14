<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/scan">
        <html>
        <head>
            <title>Scan Result</title>
        </head>
        <body>
            <h1>Scan Result</h1>
            <h2>Host Info</h2>

            <p><strong>IP:</strong> <xsl:value-of select="host/ip"/></p>
            <p><strong>Status:</strong> <xsl:value-of select="host/status"/></p>

            <h2>Open Ports</h2>
            <table border="1">
                <tr>
                    <th>Port</th>
                    <th>Protocol</th>
                    <th>State</th>
                    <th>Service</th>
                </tr>
                <xsl:for-each select="host/ports/port">
                    <tr>
                        <td><xsl:value-of select="number"/></td>
                        <td><xsl:value-of select="protocol"/></td>
                        <td><xsl:value-of select="state"/></td>
                        <td><xsl:value-of select="service"/></td>
                    </tr>
                </xsl:for-each>
            </table>

        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
