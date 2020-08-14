<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                xmlns="http://www.w3.org/2005/xpath-functions"
                version="3.0"
                xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
                exclude-result-prefixes="#all">
   <xsl:output indent="yes"
               method="text"
               omit-xml-declaration="yes"
               use-character-maps="delimiters"/>
   <!-- METASCHEMA conversion stylesheet supports XML->JSON conversion -->
   <!-- 88888888888888888888888888888888888888888888888888888888888888 -->
   <xsl:character-map name="delimiters"/>
   <xsl:param name="json-indent" as="xs:string">no</xsl:param>
   <!-- Pass $diagnostic as 'rough' for first pass, 'rectified' for second pass -->
   <xsl:param name="diagnostic" as="xs:string">no</xsl:param>
   <xsl:template match="text()" mode="md">
      <xsl:value-of select="replace(., '([`~\^\*&#34;])', '\\$1')"/>
   </xsl:template>
   <xsl:variable name="write-options" as="map(*)" expand-text="true">
      <xsl:map>
         <xsl:map-entry key="'indent'">{ $json-indent='yes' }</xsl:map-entry>
      </xsl:map>
   </xsl:variable>
   <xsl:variable name="xpath-json">
      <map>
         <xsl:apply-templates select="/" mode="xml2json"/>
      </map>
   </xsl:variable>
   <xsl:variable name="rectified">
      <xsl:apply-templates select="$xpath-json" mode="rectify"/>
   </xsl:variable>
   <xsl:template match="/">
      <xsl:choose>
         <xsl:when test="$diagnostic = 'rough'">
            <xsl:copy-of select="$xpath-json"/>
         </xsl:when>
         <xsl:when test="$diagnostic = 'rectified'">
            <xsl:copy-of select="$rectified"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="xml-to-json($rectified, $write-options)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="node() | @*" mode="rectify">
      <xsl:copy copy-namespaces="no">
         <xsl:apply-templates mode="#current" select="node() | @*"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template mode="rectify"
                 xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
                 match="/*/@key | array/*/@key"/>
   <xsl:template mode="rectify" match="@m:*"/>
   <xsl:template mode="rectify"
                 match="array[count(*) eq 1][not(@m:in-json = 'ARRAY')]"
                 xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
      <xsl:for-each select="*">
         <xsl:copy>
            <xsl:copy-of select="../@key"/>
            <xsl:apply-templates mode="#current"/>
         </xsl:copy>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="prose">
      <xsl:param name="key" select="'PROSE'"/>
      <xsl:param name="wrapped" select="false()"/>
      <xsl:variable name="blocks"
                    select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"/>
      <xsl:if test="exists($blocks) or $wrapped">
         <xsl:variable name="string-sequence" as="element()*">
            <xsl:apply-templates mode="md" select="$blocks"/>
         </xsl:variable>
         <string key="{$key}">
            <xsl:value-of select="string-join($string-sequence, '\n')"/>
         </string>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="as-string" match="@* | *">
      <xsl:param name="key" select="local-name()"/>
      <xsl:param name="mandatory" select="false()"/>
      <xsl:if test="$mandatory or matches(., '\S')">
         <string key="{ $key }">
            <xsl:value-of select="."/>
         </string>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="as-boolean" match="@* | *">
      <xsl:param name="key" select="local-name()"/>
      <xsl:param name="mandatory" select="false()"/>
      <xsl:if test="$mandatory or matches(., '\S')">
         <boolean key="{ $key }">
            <xsl:value-of select="."/>
         </boolean>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="as-integer" match="@* | *">
      <xsl:param name="key" select="local-name()"/>
      <xsl:param name="mandatory" select="false()"/>
      <xsl:if test="$mandatory or matches(., '\S')">
         <integer key="{ $key }">
            <xsl:value-of select="."/>
         </integer>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="as-number" match="@* | *">
      <xsl:param name="key" select="local-name()"/>
      <xsl:param name="mandatory" select="false()"/>
      <xsl:if test="$mandatory or matches(., '\S')">
         <number key="{ $key }">
            <xsl:value-of select="."/>
         </number>
      </xsl:if>
   </xsl:template>
   <xsl:template name="conditional-lf">
      <xsl:variable name="predecessor"
                    select="preceding-sibling::p | preceding-sibling::ul | preceding-sibling::ol | preceding-sibling::table | preceding-sibling::pre"/>
      <xsl:if test="exists($predecessor)">
         <string/>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="md" match="p | link | part/*">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template mode="md" match="h1 | h2 | h3 | h4 | h5 | h6">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates select="." mode="mark"/>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template mode="mark" match="h1"># </xsl:template>
   <xsl:template mode="mark" match="h2">## </xsl:template>
   <xsl:template mode="mark" match="h3">### </xsl:template>
   <xsl:template mode="mark" match="h4">#### </xsl:template>
   <xsl:template mode="mark" match="h5">##### </xsl:template>
   <xsl:template mode="mark" match="h6">###### </xsl:template>
   <xsl:template mode="md" match="table">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates select="*" mode="md"/>
   </xsl:template>
   <xsl:template mode="md" match="tr">
      <string>
         <xsl:apply-templates select="*" mode="md"/>
      </string>
      <xsl:if test="empty(preceding-sibling::tr)">
         <string>
            <xsl:text>|</xsl:text>
            <xsl:for-each select="th | td"> --- |</xsl:for-each>
         </string>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="md" match="th | td">
      <xsl:if test="empty(preceding-sibling::*)">|</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text> |</xsl:text>
   </xsl:template>
   <xsl:template mode="md" priority="1" match="pre">
      <xsl:call-template name="conditional-lf"/>
      <string>```</string>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
      <string>```</string>
   </xsl:template>
   <xsl:template mode="md" priority="1" match="ul | ol">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates select="*" mode="md"/>
      <string/>
   </xsl:template>
   <xsl:template mode="md" match="ul//ul | ol//ol | ol//ul | ul//ol">
      <xsl:apply-templates select="*" mode="md"/>
   </xsl:template>
   <xsl:template mode="md" match="li">
      <string>
         <xsl:for-each select="../ancestor::ul">
            <xsl:text xml:space="preserve">  </xsl:text>
         </xsl:for-each>
         <xsl:text>* </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template mode="md" match="ol/li">
      <string/>
      <string>
         <xsl:for-each select="../ancestor::ul">
            <xsl:text xml:space="preserve">  </xsl:text>
         </xsl:for-each>
         <xsl:text>1. </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template mode="md" match="code | span[contains(@class, 'code')]">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>`</xsl:text>
   </xsl:template>
   <xsl:template mode="md" match="em | i">
      <xsl:text>*</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>*</xsl:text>
   </xsl:template>
   <xsl:template mode="md" match="strong | b">
      <xsl:text>**</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>**</xsl:text>
   </xsl:template>
   <xsl:template mode="md" match="q">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template mode="md" match="insert">
      <xsl:text>{{ </xsl:text>
      <xsl:value-of select="@param-id"/>
      <xsl:text> }}</xsl:text>
   </xsl:template>
   <xsl:key name="element-by-id" match="*[exists(@id)]" use="@id"/>
   <xsl:template mode="md" match="a">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@href"/>
      <xsl:text>)</xsl:text>
   </xsl:template>
   <!-- 88888888888888888888888888888888888888888888888888888888888888 -->
   <xsl:template match="prose" mode="xml2json">
      <string key="prose">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="metadata" mode="xml2json">
      <map key="metadata">
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="published" mode="#current"/>
         <xsl:apply-templates select="last-modified" mode="#current"/>
         <xsl:apply-templates select="version" mode="#current"/>
         <xsl:apply-templates select="oscal-version" mode="#current"/>
         <xsl:for-each select="revision-history">
            <xsl:if test="exists(revision)">
               <array key="revision-history" m:in-json="ARRAY">
                  <xsl:apply-templates select="revision" mode="#current"/>
               </array>
            </xsl:if>
         </xsl:for-each>
         <xsl:if test="exists(doc-id)">
            <array key="document-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="doc-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(role)">
            <array key="roles" m:in-json="ARRAY">
               <xsl:apply-templates select="role" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(location)">
            <array key="locations" m:in-json="ARRAY">
               <xsl:apply-templates select="location" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party)">
            <array key="parties" m:in-json="ARRAY">
               <xsl:apply-templates select="party" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each-group select="responsible-party" group-by="local-name()">
            <map key="responsible-parties">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="back-matter" mode="xml2json">
      <map key="back-matter">
         <xsl:if test="exists(resource)">
            <array key="resources" m:in-json="ARRAY">
               <xsl:apply-templates select="resource" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="revision" mode="xml2json">
      <map key="revision">
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="published" mode="#current"/>
         <xsl:apply-templates select="last-modified" mode="#current"/>
         <xsl:apply-templates select="version" mode="#current"/>
         <xsl:apply-templates select="oscal-version" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="link" mode="xml2json">
      <xsl:variable name="text-key">text</xsl:variable>
      <map key="link">
         <xsl:apply-templates mode="as-string" select="@href"/>
         <xsl:apply-templates mode="as-string" select="@rel"/>
         <xsl:apply-templates mode="as-string" select="@media-type"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="published" mode="xml2json">
      <string key="published">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="last-modified" mode="xml2json">
      <string key="last-modified">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="version" mode="xml2json">
      <string key="version">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="oscal-version" mode="xml2json">
      <string key="oscal-version">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="doc-id" mode="xml2json">
      <xsl:variable name="text-key">identifier</xsl:variable>
      <map key="doc-id">
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="prop" mode="xml2json">
      <xsl:variable name="text-key">value</xsl:variable>
      <map key="prop">
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates mode="as-string" select="@ns"/>
         <xsl:apply-templates mode="as-string" select="@class"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="annotation" mode="xml2json">
      <map key="annotation">
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates mode="as-string" select="@ns"/>
         <xsl:apply-templates mode="as-string" select="@value"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="location" mode="xml2json">
      <map key="location">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="address" mode="#current"/>
         <xsl:if test="exists(email)">
            <array key="email-addresses" m:in-json="ARRAY">
               <xsl:apply-templates select="email" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(phone)">
            <array key="telephone-numbers" m:in-json="ARRAY">
               <xsl:apply-templates select="phone" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(url)">
            <array key="URLs" m:in-json="ARRAY">
               <xsl:apply-templates select="url" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="location-uuid" mode="xml2json">
      <string key="location-uuid">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="party" mode="xml2json">
      <map key="party">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:apply-templates select="party-name" mode="#current"/>
         <xsl:apply-templates select="short-name" mode="#current"/>
         <xsl:if test="exists(external-id)">
            <array key="external-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="external-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(address)">
            <array key="addresses" m:in-json="ARRAY">
               <xsl:apply-templates select="address" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(email)">
            <array key="email-addresses" m:in-json="ARRAY">
               <xsl:apply-templates select="email" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(phone)">
            <array key="telephone-numbers" m:in-json="ARRAY">
               <xsl:apply-templates select="phone" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(member-of-organization)">
            <array key="member-of-organizations" m:in-json="ARRAY">
               <xsl:apply-templates select="member-of-organization" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(location-uuid)">
            <array key="location-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="location-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="party-uuid" mode="xml2json">
      <string key="party-uuid">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="external-id" mode="xml2json">
      <xsl:variable name="text-key">id</xsl:variable>
      <map key="external-id">
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="member-of-organization" mode="xml2json">
      <string key="member-of-organization">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="rlink" mode="xml2json">
      <map key="rlink">
         <xsl:apply-templates mode="as-string" select="@href"/>
         <xsl:apply-templates mode="as-string" select="@media-type"/>
         <xsl:if test="exists(hash)">
            <array key="hashes" m:in-json="ARRAY">
               <xsl:apply-templates select="hash" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="party-name" mode="xml2json">
      <string key="party-name">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="short-name" mode="xml2json">
      <string key="short-name">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="address" mode="xml2json">
      <map key="address">
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:if test="exists(addr-line)">
            <array key="postal-address" m:in-json="ARRAY">
               <xsl:apply-templates select="addr-line" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="city" mode="#current"/>
         <xsl:apply-templates select="state" mode="#current"/>
         <xsl:apply-templates select="postal-code" mode="#current"/>
         <xsl:apply-templates select="country" mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template match="addr-line" mode="xml2json">
      <string key="addr-line">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="city" mode="xml2json">
      <string key="city">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="state" mode="xml2json">
      <string key="state">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="postal-code" mode="xml2json">
      <string key="postal-code">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="country" mode="xml2json">
      <string key="country">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="email" mode="xml2json">
      <string key="email">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="phone" mode="xml2json">
      <xsl:variable name="text-key">number</xsl:variable>
      <map key="phone">
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="url" mode="xml2json">
      <string key="url">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="desc" mode="xml2json">
      <string key="desc">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="text" mode="xml2json">
      <string key="text">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="biblio" mode="xml2json">
      <map key="biblio"/>
   </xsl:template>
   <xsl:template match="resource" mode="xml2json">
      <map key="resource">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="desc" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(doc-id)">
            <array key="document-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="doc-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="citation" mode="#current"/>
         <xsl:if test="exists(rlink)">
            <array key="rlinks" m:in-json="ARRAY">
               <xsl:apply-templates select="rlink" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(base64)">
            <array key="attachments" m:in-json="ARRAY">
               <xsl:apply-templates select="base64" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="citation" mode="xml2json">
      <map key="citation">
         <xsl:apply-templates select="text" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="biblio" mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template match="hash" mode="xml2json">
      <xsl:variable name="text-key">value</xsl:variable>
      <map key="hash">
         <xsl:apply-templates mode="as-string" select="@algorithm"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="role" mode="xml2json">
      <map key="role">
         <xsl:apply-templates mode="as-string" select="@id"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="short-name" mode="#current"/>
         <xsl:apply-templates select="desc" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="responsible-party" mode="xml2json">
      <map key="{@role-id}">
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="title" mode="xml2json">
      <string key="title">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="base64" mode="xml2json">
      <xsl:variable name="text-key">value</xsl:variable>
      <map key="base64">
         <xsl:apply-templates mode="as-string" select="@filename"/>
         <xsl:apply-templates mode="as-string" select="@media-type"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="description" mode="xml2json">
      <string key="description">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="remarks" mode="xml2json">
      <string key="remarks">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="responsible-role" mode="xml2json">
      <map key="{@role-id}">
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="status" mode="xml2json">
      <map key="status">
         <xsl:apply-templates mode="as-string" select="@state"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="user" mode="xml2json">
      <map key="{@uuid}">
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:apply-templates select="short-name" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(role-id)">
            <array key="role-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="role-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(authorized-privilege)">
            <array key="authorized-privileges" m:in-json="ARRAY">
               <xsl:apply-templates select="authorized-privilege" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="role-id" mode="xml2json">
      <string key="role-id">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="authorized-privilege" mode="xml2json">
      <map key="authorized-privilege">
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(function-performed)">
            <array key="functions-performed" m:in-json="ARRAY">
               <xsl:apply-templates select="function-performed" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="function-performed" mode="xml2json">
      <string key="function-performed">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="component" mode="xml2json">
      <map key="{@uuid}">
         <xsl:apply-templates mode="as-string" select="@component-type"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:apply-templates select="purpose" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="status" mode="#current"/>
         <xsl:for-each-group select="responsible-role" group-by="local-name()">
            <map key="responsible-roles">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:if test="exists(protocol)">
            <array key="protocols" m:in-json="ARRAY">
               <xsl:apply-templates select="protocol" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="protocol" mode="xml2json">
      <map key="protocol">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:if test="exists(port-range)">
            <array key="port-ranges" m:in-json="ARRAY">
               <xsl:apply-templates select="port-range" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="port-range" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="port-range">
         <xsl:apply-templates mode="as-number" select="@start"/>
         <xsl:apply-templates mode="as-number" select="@end"/>
         <xsl:apply-templates mode="as-string" select="@transport"/>
      </map>
   </xsl:template>
   <xsl:template match="purpose" mode="xml2json">
      <string key="purpose">
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template match="inventory-item" mode="xml2json">
      <map key="{@uuid}">
         <xsl:apply-templates mode="as-string" select="@asset-id"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each-group select="responsible-party" group-by="local-name()">
            <map key="responsible-parties">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each-group select="implemented-component" group-by="local-name()">
            <map key="implemented-components">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="implemented-component" mode="xml2json">
      <map key="{@component-uuid}">
         <xsl:apply-templates mode="as-string" select="@use"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each-group select="responsible-party" group-by="local-name()">
            <map key="responsible-parties">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="import-ssp" mode="xml2json">
      <map key="import-ssp">
         <xsl:apply-templates mode="as-string" select="@href"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="objectives" mode="xml2json">
      <map key="objectives">
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(controls)">
            <array key="control-group" m:in-json="ARRAY">
               <xsl:apply-templates select="controls" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(control-objectives)">
            <array key="control-objective-group" m:in-json="ARRAY">
               <xsl:apply-templates select="control-objectives" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(objective)">
            <array key="objectives">
               <xsl:apply-templates select="objective" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(method)">
            <array key="method-definitions" m:in-json="ARRAY">
               <xsl:apply-templates select="method" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="controls" mode="xml2json">
      <map key="controls">
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="all" mode="#current"/>
         <xsl:if test="exists(include-control)">
            <array key="include-controls" m:in-json="ARRAY">
               <xsl:apply-templates select="include-control" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(exclude-control)">
            <array key="exclude-controls" m:in-json="ARRAY">
               <xsl:apply-templates select="exclude-control" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="control-objectives" mode="xml2json">
      <map key="control-objectives">
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="all" mode="#current"/>
         <xsl:if test="exists(include-objective)">
            <array key="include-objectives" m:in-json="ARRAY">
               <xsl:apply-templates select="include-objective" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(exclude-objective)">
            <array key="exclude-objectives" m:in-json="ARRAY">
               <xsl:apply-templates select="exclude-objective" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="include-control" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="include-control">
         <xsl:apply-templates mode="as-string" select="@control-id"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="exclude-control" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="exclude-control">
         <xsl:apply-templates mode="as-string" select="@control-id"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="include-objective" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="include-objective">
         <xsl:apply-templates mode="as-string" select="@objective-id"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="exclude-objective" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="exclude-objective">
         <xsl:apply-templates mode="as-string" select="@objective-id"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="objective" mode="xml2json">
      <map key="objective">
         <xsl:apply-templates mode="as-string" select="@id"/>
         <xsl:apply-templates mode="as-string" select="@control-id"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="part" mode="#current"/>
         <xsl:if test="exists(assessment-method)">
            <array key="methods" m:in-json="ARRAY">
               <xsl:apply-templates select="assessment-method" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="assessment-method" mode="xml2json">
      <xsl:variable name="text-key">STRVALUE</xsl:variable>
      <map key="assessment-method">
         <xsl:apply-templates mode="as-string" select="@method-uuid"/>
         <xsl:apply-templates mode="as-string" select=".">
            <xsl:with-param name="key" select="$text-key"/>
            <xsl:with-param name="mandatory" select="true()"/>
         </xsl:apply-templates>
      </map>
   </xsl:template>
   <xsl:template match="method" mode="xml2json">
      <map key="method">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="part" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="include-subject" mode="xml2json">
      <map key="include-subject">
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates mode="as-string" select="@class"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="all" mode="#current"/>
         <xsl:if test="exists(subject-reference)">
            <array key="subject-references" m:in-json="ARRAY">
               <xsl:apply-templates select="subject-reference" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="exclude-subject" mode="xml2json">
      <map key="exclude-subject">
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates mode="as-string" select="@class"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="all" mode="#current"/>
         <xsl:if test="exists(subject-reference)">
            <array key="subject-references" m:in-json="ARRAY">
               <xsl:apply-templates select="subject-reference" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="subject-reference" mode="xml2json">
      <map key="subject-reference">
         <xsl:apply-templates mode="as-string" select="@uuid-ref"/>
         <xsl:apply-templates mode="as-string" select="@type"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="props" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="all" mode="xml2json">
      <string key="all">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="assets" mode="xml2json">
      <map key="assets">
         <xsl:apply-templates select="tools" mode="#current"/>
         <xsl:apply-templates select="origination" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(part)">
            <array key="parts" m:in-json="ARRAY">
               <xsl:apply-templates select="part" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="tools" mode="xml2json">
      <map key="tools">
         <xsl:for-each-group select="component" group-by="local-name()">
            <map key="components">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
      </map>
   </xsl:template>
   <xsl:template match="origination" mode="xml2json">
      <map key="origination">
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="assessment-activities" mode="xml2json">
      <map key="assessment-activities">
         <xsl:if test="exists(test-method)">
            <array key="test-methods" m:in-json="ARRAY">
               <xsl:apply-templates select="test-method" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="schedule" mode="#current"/>
         <xsl:if test="exists(include-activity)">
            <array key="include-activities" m:in-json="ARRAY">
               <xsl:apply-templates select="include-activity" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(exclude-activity)">
            <array key="exclude-activities" m:in-json="ARRAY">
               <xsl:apply-templates select="exclude-activity" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="test-method" mode="xml2json">
      <map key="test-method">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(test-step)">
            <array key="test-steps" m:in-json="ARRAY">
               <xsl:apply-templates select="test-step" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="compare-to" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="compare-to" mode="xml2json">
      <string key="compare-to">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="test-step" mode="xml2json">
      <map key="test-step">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="sequence" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(role-id)">
            <array key="role-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="role-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="compare-to" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="sequence" mode="xml2json">
      <number key="sequence">
         <xsl:apply-templates mode="#current"/>
      </number>
   </xsl:template>
   <xsl:template match="schedule" mode="xml2json">
      <map key="schedule">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:if test="exists(task)">
            <array key="tasks" m:in-json="ARRAY">
               <xsl:apply-templates select="task" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="task" mode="xml2json">
      <map key="task">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="start" mode="#current"/>
         <xsl:apply-templates select="end" mode="#current"/>
         <xsl:if test="exists(activity-uuid)">
            <array key="activity-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="activity-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(role-id)">
            <array key="role-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="role-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(location-uuid)">
            <array key="location-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="location-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="compare-to" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="start" mode="xml2json">
      <string key="start">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="end" mode="xml2json">
      <string key="end">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="activity-uuid" mode="xml2json">
      <string key="activity-uuid">
         <xsl:apply-templates mode="#current"/>
      </string>
   </xsl:template>
   <xsl:template match="include-activity" mode="xml2json">
      <map key="include-activity">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(role-id)">
            <array key="role-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="role-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(location-uuid)">
            <array key="location-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="location-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="compare-to" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="exclude-activity" mode="xml2json">
      <map key="exclude-activity">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:for-each select="description">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">description</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(annotation)">
            <array key="annotations" m:in-json="ARRAY">
               <xsl:apply-templates select="annotation" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(role-id)">
            <array key="role-ids" m:in-json="ARRAY">
               <xsl:apply-templates select="role-id" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(party-uuid)">
            <array key="party-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="party-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(location-uuid)">
            <array key="location-uuids" m:in-json="ARRAY">
               <xsl:apply-templates select="location-uuid" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="compare-to" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="part" mode="xml2json">
      <map key="part">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates mode="as-string" select="@name"/>
         <xsl:apply-templates mode="as-string" select="@ns"/>
         <xsl:apply-templates mode="as-string" select="@class"/>
         <xsl:apply-templates select="title" mode="#current"/>
         <xsl:if test="exists(prop)">
            <array key="properties" m:in-json="ARRAY">
               <xsl:apply-templates select="prop" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:call-template name="prose">
            <xsl:with-param name="key">prose</xsl:with-param>
         </xsl:call-template>
         <xsl:if test="exists(part)">
            <array key="parts" m:in-json="ARRAY">
               <xsl:apply-templates select="part" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(link)">
            <array key="links" m:in-json="ARRAY">
               <xsl:apply-templates select="link" mode="#current"/>
            </array>
         </xsl:if>
      </map>
   </xsl:template>
   <xsl:template match="assessment-plan" mode="xml2json">
      <map key="assessment-plan">
         <xsl:apply-templates mode="as-string" select="@uuid"/>
         <xsl:apply-templates select="metadata" mode="#current"/>
         <xsl:apply-templates select="import-ssp" mode="#current"/>
         <xsl:apply-templates select="objectives" mode="#current"/>
         <xsl:apply-templates select="assessment-subjects" mode="#current"/>
         <xsl:apply-templates select="assets" mode="#current"/>
         <xsl:apply-templates select="assessment-activities" mode="#current"/>
         <xsl:apply-templates select="back-matter" mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template match="assessment-subjects" mode="xml2json">
      <map key="assessment-subjects">
         <xsl:if test="exists(include-subject)">
            <array key="includes" m:in-json="ARRAY">
               <xsl:apply-templates select="include-subject" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:if test="exists(exclude-subject)">
            <array key="excludes" m:in-json="ARRAY">
               <xsl:apply-templates select="exclude-subject" mode="#current"/>
            </array>
         </xsl:if>
         <xsl:apply-templates select="local-definitions" mode="#current"/>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
   <xsl:template match="local-definitions" mode="xml2json">
      <map key="local-definitions">
         <xsl:for-each-group select="component" group-by="local-name()">
            <map key="components">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each-group select="inventory-item" group-by="local-name()">
            <map key="inventory-items">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each-group select="user" group-by="local-name()">
            <map key="users">
               <xsl:apply-templates select="current-group()" mode="#current"/>
            </map>
         </xsl:for-each-group>
         <xsl:for-each select="remarks">
            <xsl:call-template name="prose">
               <xsl:with-param name="key">remarks</xsl:with-param>
               <xsl:with-param name="wrapped" select="true()"/>
            </xsl:call-template>
         </xsl:for-each>
      </map>
   </xsl:template>
</xsl:stylesheet>
