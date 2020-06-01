<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns="http://csrc.nist.gov/ns/oscal/1.0"
    version="3.0">
    
<!-- This XSLT, applied to an XML document valid to the Milestone 2 OSCAL schema version for Catalog or Profile,
     will produce a similar XML document, valid or closer to valid to the Milestone 3 OSCAL schema.
    We say 'closer to valid' in this case because we implement only necessary mappings we have seen, not all conceivable, given Issue ; plus of course we depend on valid inputs. -->
    
    
    
    <!-- Catalog, M2 and M3   -->
    <xsl:strip-space elements="param guideline select part metadata back-matter revision annotation location party rlink address biblio resource citation role responsible-party catalog group control person org"/>
    
    <!-- Profile, M2 and M3   -->
    <xsl:strip-space elements="metadata back-matter revision annotation location party rlink address biblio resource citation role responsible-party param guideline select part profile import merge custom group modify include exclude set-parameter alter add person org set"/>
   
    <!-- SSP, M2 and M3   -->
    <xsl:strip-space elements="metadata back-matter revision annotation location party rlink address biblio resource citation role responsible-party system-security-plan import-profile system-characteristics system-information information-type confidentiality-impact integrity-impact availability-impact security-impact-level status leveraged-authorization authorization-boundary diagram network-architecture data-flow system-implementation user authorized-privilege component protocol system-inventory inventory-item implemented-component control-implementation implemented-requirement statement responsible-role by-component set-parameter person org service interconnection set-param"/>
    
    <xsl:output indent="yes"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:mode name="copy" on-no-match="shallow-copy"/>
    
    <xsl:template match="/*">
        <xsl:comment expand-text="true"> Modified by conversion XSLT { current-dateTime() } - Milestone 2 OSCAL becomes Milestone 3 OSCAL  - </xsl:comment>
        <xsl:next-match/>
    </xsl:template>
    
    <!-- Rewriting top-level @id -->
    <xsl:template match="/*/@id[function-available('uuid:randomUUID')]" xmlns:uuid="java:java.util.UUID">
        <xsl:attribute name="uuid" select="uuid:randomUUID()"/>
    </xsl:template>
    
    <!-- copy metadata, mostly -->
    <xsl:template match="metadata">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="title"/>
            <!-- time stamp it at runtime -->
            <xsl:apply-templates select="child::*[1]" mode="ws"/>
            <last-modified xsl:expand-text="true">{ current-dateTime() }</last-modified>
            <xsl:apply-templates select="* except title | version"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="last-modified" priority="6"/>
    
    <xsl:template match="oscal-version" priority="6">
        <xsl:apply-templates select="." mode="ws"/>
        <oscal-version>1.0.0-milestone3</oscal-version>
    </xsl:template>
    
    <xsl:template match="metadata/*" priority="5">
        <xsl:apply-templates select="." mode="ws"/>
        <xsl:next-match/>
        <xsl:if test="empty(following-sibling::*)">
            <xsl:apply-templates select=".." mode="ws"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*" mode="ws">
        <xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="ancestor::*">
            <xsl:text>    </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="set | set-param">
        <set-parameter>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </set-parameter>
    </xsl:template>
    
    <xsl:template match="back-matter/citation">
        <resource uuid="{@id}">
            <xsl:apply-templates select="title" mode="copy"/>
            <xsl:apply-templates select="doc-id" mode="copy"/>
            <xsl:next-match/>
            <xsl:apply-templates select="target"/>
        </resource>
    </xsl:template>
    
    <xsl:template match="citation/desc">
        <text>
            <xsl:apply-templates/>
        </text>
    </xsl:template>
    
    <xsl:template name="target">
        <rlink href="{ . }"/>
    </xsl:template>
    
    <xsl:template match="citation/title">
        <text>
            <xsl:apply-templates/>
        </text>
    </xsl:template>
    
    <xsl:template match="citation/@id | citation/target | citation/text() | citation/doc-id"/>
    
    <!-- @id to @uuid migration ... does *not* rewrite UUID values ... see rewrite-uuid for this ...   -->
    
    
<!-- changing to 'uuid' but keeping the value  -->
    <xsl:template match="resource/@id">
        <xsl:attribute name="uuid" select="."/>
    </xsl:template>
    
</xsl:stylesheet>