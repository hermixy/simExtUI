<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="utf-8" indent="yes"/>
    <xsl:template name="functionPrefix">
        <!-- if plugin node defined a prefix attribute, we use it for
             functions prefix, otherwise we use the name attribute -->
        <xsl:text>simExt</xsl:text>
        <xsl:choose>
            <xsl:when test="/plugin/@prefix">
                <xsl:value-of select="/plugin/@prefix"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/plugin/@name"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>_</xsl:text>
    </xsl:template>
    <xsl:template name="renderParams">
        <xsl:choose>
            <xsl:when test="param">
                <xsl:for-each select="param">
                    <div>
                        <strong><xsl:value-of select="@name"/></strong>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="@type"/>
                        <xsl:if test="@type='table'">
                            <xsl:text> of </xsl:text>
                            <xsl:value-of select="@item-type"/>
                        </xsl:if>
                        <xsl:if test="@default">
                            <xsl:text>, default: </xsl:text>
                            <xsl:value-of select="@default"/>
                        </xsl:if>
                        <xsl:text>): </xsl:text>
                        <xsl:copy-of select="description/node()"/>
                    </div>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN"&gt;</xsl:text>
        <html>
            <head>
                <meta http-equiv="Content-Language" content="en-us"/>
                <title>API Functions</title>
                <link rel="stylesheet" type="text/css" href="../../helpFiles/style.css"/>
            </head>
            <body>
                <div align="center">
                    <table class="allEncompassingTable">
                        <tr>
                            <td>
                                <h1><xsl:value-of select="/plugin/@name"/> Plugin API reference</h1>
                                <xsl:if test="/plugin/description and (/plugin/description != '')">
                                    <p class="infoBox">
                                        <xsl:copy-of select="/plugin/description/node()"/>
                                    </p>
                                </xsl:if>
                                <xsl:for-each select="plugin/command">
                                    <xsl:sort select="@name"/>
                                    <xsl:if test="description != ''">
                                        <h3 class="subsectionBar"><a name="{@name}" id="{@name}"></a><xsl:call-template name="functionPrefix"/><xsl:value-of select="@name"/></h3>
                                        <table class="apiTable">
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftDescr">
                                                    Description
                                                </td>
                                                <td class="apiTableRightDescr">
                                                    <xsl:copy-of select="description/node()"/>
                                                    <br/>
                                                </td>
                                            </tr>
                                            <!--
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftCSyn">C synopsis</td>
                                                <td class="apiTableRightCSyn">-</td>
                                            </tr>
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftCParam">C parameters</td>
                                                <td class="apiTableRightCParam">-</td>
                                            </tr>
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftCRet">C return value</td>
                                                <td class="apiTableRightCRet">-</td>
                                            </tr>
                                            -->
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftLSyn">Lua synopsis</td>
                                                <td class="apiTableRightLSyn">
                                                    <xsl:for-each select="return/param">
                                                        <xsl:value-of select="@type"/>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="@name"/>
                                                        <xsl:if test="not(position() = last())">, </xsl:if>
                                                    </xsl:for-each>
                                                    <xsl:if test="return/param">=</xsl:if>
                                                    <xsl:call-template name="functionPrefix"/>
                                                    <xsl:value-of select="@name"/>
                                                    <xsl:text>(</xsl:text>
                                                    <xsl:for-each select="params/param">
                                                        <xsl:value-of select="@type"/>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="@name"/>
                                                        <xsl:if test="@default">=<xsl:value-of select="@default"/></xsl:if>
                                                        <xsl:if test="not(position() = last())">, </xsl:if>
                                                    </xsl:for-each>
                                                    <xsl:text>)</xsl:text>
                                                    <br/>
                                                </td>
                                            </tr>
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftLParam">Lua parameters</td>
                                                <td class="apiTableRightLParam">
                                                    <xsl:for-each select="params">
                                                        <xsl:call-template name="renderParams"/>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftLRet">Lua return values</td>
                                                <td class="apiTableRightLRet">
                                                    <xsl:for-each select="return">
                                                        <xsl:call-template name="renderParams"/>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                            <xsl:if test="see-also/*">
                                            <tr class="apiTableTr">
                                                <td class="apiTableLeftDescr">
                                                    See also
                                                </td>
                                                <td class="apiTableRightDescr">
                                                    <xsl:for-each select="see-also/command">
                                                        <a href="#{@name}">
                                                            <xsl:call-template name="functionPrefix"/>
                                                            <xsl:value-of select="@name" />
                                                        </a>
                                                        <xsl:if test="not(position() = last())">, </xsl:if>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                            </xsl:if>
                                        </table>
                                        <br/>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="plugin/enum/*">
                                    <br/>
                                    <br/>
                                    <h1>Constants</h1>
                                    <xsl:for-each select="plugin/enum">
                                    <h3 class="subsectionBar"><a name="{@name}" id="{@name}"></a><xsl:value-of select="@name"/></h3>
                                    <table class="apiConstantsTable">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <xsl:for-each select="item">
                                                        <div>
                                                            <strong>
                                                                <xsl:value-of select="../@item-prefix"/>
                                                                <xsl:value-of select="@name"/>
                                                            </strong>
                                                            <xsl:if test="description">
                                                                <xsl:text>: </xsl:text>
                                                                <xsl:copy-of select="description/node()"/>
                                                            </xsl:if>
                                                        </div>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="plugin/struct/*">
                                    <br/>
                                    <br/>
                                    <h1>Data structures</h1>
                                    <xsl:for-each select="plugin/struct">
                                    <h3 class="subsectionBar"><a name="{@name}" id="{@name}"></a><xsl:value-of select="@name"/></h3>
                                    <table class="apiTable">
                                        <tr class="apiTableTr">
                                            <td class="apiTableLeftDescr">
                                                Description
                                            </td>
                                            <td class="apiTableRightDescr">
                                                <xsl:copy-of select="description/node()"/>
                                                <br/>
                                            </td>
                                        </tr>
                                        <tr class="apiTableTr">
                                            <td class="apiTableLeftLParam">Fields</td>
                                            <td class="apiTableRightLParam">
                                                <xsl:call-template name="renderParams"/>
                                            </td>
                                        </tr>
                                        <xsl:if test="see-also/*">
                                        <tr class="apiTableTr">
                                            <td class="apiTableLeftDescr">
                                                See also
                                            </td>
                                            <td class="apiTableRightDescr">
                                                <xsl:for-each select="see-also/command">
                                                    <a href="#{@name}">
                                                        <xsl:call-template name="functionPrefix"/>
                                                        <xsl:value-of select="@name" />
                                                    </a>
                                                    <xsl:if test="not(position() = last())">, </xsl:if>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                        </xsl:if>
                                    </table>
                                    <br/>
                                    </xsl:for-each>
                                </xsl:if>
                            </td>
                        </tr>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
