<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns="http://csrc.nist.gov/ns/oscal/1.0"
    exclude-result-prefixes="xs math oscal"
    expand-text="true"
    version="3.0">
    
    <xsl:import href="xsd-exploder.xsl"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--<xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="node()"/>
            <xsl:for-each-group select="//oscal:prop[@class='xsd']" group-by=".">
              <xsl:for-each select="document(current-grouping-key(),/)">
                  <group class="exploded-declarations">
                      <prop class="xsd">{ current-grouping-key() }</prop>
                      <xsl:apply-templates mode="explode"/>
                  </group>
              </xsl:for-each>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="oscal:component[@class='element-description']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="." mode="schema-extract"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="oscal:component[@class='element-description']" mode="schema-extract">
        <xsl:variable name="tag" select="oscal:prop[@class='tag']"/>
        <xsl:for-each select="document(ancestor::oscal:*/oscal:prop[@class = 'xsd'], /)">
            <xsl:element name="part"  namespace="http://csrc.nist.gov/ns/oscal/1.0">
                <xsl:attribute name="class">schema-docs</xsl:attribute>
                <!--<xsl:text expand-text="true"> schema { document-uri(/) }</xsl:text>-->
                
                <xsl:variable name="declarations" select="/*/xs:element[@name = $tag]"/> 
                <!--<xsl:text expand-text="true">{ count($declarations) }</xsl:text>-->
                
                <xsl:variable name="exploded">
                  <xsl:apply-templates select="$declarations" mode="explode"/>
                </xsl:variable>
                <!--<xsl:copy-of select="$declarations"/>-->
                <xsl:copy-of         select="$exploded"/>
                <xsl:apply-templates select="$exploded" mode="oscalize"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="/element" mode="oscalize" expand-text="true">
        <title>Content declaration (reduced)</title>
            <ul>
                <xsl:apply-templates mode="#current"/>
            </ul>
    </xsl:template>
    
    <xsl:template match="element" mode="oscalize" expand-text="true">
        <li>element <em>{ @name }</em>'{ if (@minOccurs='0') then ' (optional)' else '' }, containing:
            <ul>
                <xsl:apply-templates mode="#current"/>
            </ul>
        </li>
    </xsl:template>
    
    
    <xsl:template match="element[empty(*)]" priority="2" mode="oscalize" expand-text="true">
        <li>element <code>{ @name | @ref }</code></li>
    </xsl:template>
    
    
    
    <xsl:template match="attribute" mode="oscalize" expand-text="true">
        <li>attribute <code>@{ @name }</code>{ if (@use='required') then ' (required)' else ' (optional)' }
          <xsl:apply-templates select="@type" mode="#current"/>
          <xsl:if test="empty(@type)">, with (plain) text</xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="attribute/@type" mode="oscalize" expand-text="true"> valid to constraints for type '{ QName('http://www.w3.org/2001/XMLSchema',.) ! local-name-from-QName(.) }'</xsl:template>
    
    <xsl:template match="optionalRepeatable" mode="oscalize" expand-text="true">
        <li>as needed:<ul>
                <xsl:apply-templates mode="#current"/>
            </ul>
        </li>
    </xsl:template>
    
    <xsl:template match="optionalRepeatable/optionalRepeatable" mode="oscalize" expand-text="true">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="elements" mode="oscalize" expand-text="true">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="mixed" mode="oscalize" expand-text="true">
        <li>text content</li>
    </xsl:template>
    
    <xsl:template match="mixed[exists(*)]" mode="oscalize" expand-text="true">
        <li>text content, possibly mixed with
          <ul>
              <xsl:apply-templates mode="#current"/>
          </ul>
        </li>
    </xsl:template>
    
    <xsl:template match="*" mode="oscalize">
        <li><xsl:value-of select="(name(),@*!(name() || ':' || .))" separator=" "/></li>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
</xsl:stylesheet>