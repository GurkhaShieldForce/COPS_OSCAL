<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" version="3.0"
   xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
   xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
   exclude-result-prefixes="#all">
   
   <xsl:param as="xs:string" name="model-label">oscal-catalog-xml</xsl:param>
   
   <xsl:variable as="xs:string" name="path-to-docs" select="'../../schemas/' || $model-label"/>
   
   <xsl:output indent="yes" method="html"/>
   <!-- Context node for this template is the definition of the root element or object ...  -->
<!-- first: traverse set of definitions to build a tree
     second: prune the tree to remove duplicate listings
     third: pass this model through a rendering pass to produce a set of nested lists -->
   
  <xsl:import href="metaschema-docs-util.xsl"/>
   
   <!--<xsl:variable name="home" select="/"/>-->
   
   
   <!--<xsl:template name="jekyll-template">
      <xsl:text>-\-\-&#xA;</xsl:text>
      <xsl:text>title: Schema map test&#xA;</xsl:text>
      <xsl:text>description: Schema map test&#xA;</xsl:text>
      <xsl:text>permalink: /schema-map/&#xA;</xsl:text>
      <xsl:text>layout: post&#xA;-\-\-&#xA;</xsl:text>
      <xsl:apply-templates mode="html-render" select="$pruned-tree"/>
   </xsl:template>-->
   
   <!-- For debugging, to produce standalone HTML, call template 'make-page' in metaschema-docs-util.xsl  -->
   
   <xsl:template match="/">
      <div class="OM-map">
         <xsl:apply-templates select="$pruned-tree/*" mode="html-render"/>
      </div>
   </xsl:template>

   <xsl:template mode="html-render" match="@m:*"/>

   <xsl:template mode="html-render" match="m:flag[(@name)= ../@json-key-flag]"/>
   
   <xsl:template priority="4" match="*[@json-behavior='BY_KEY'][@echo='yes']" mode="html-render">
      <div class="OM-entry">
         <p>
            <xsl:call-template name="cardinality-note"/>
            <xsl:text> </xsl:text>
            <xsl:text>{{</xsl:text>
            <xsl:value-of select="@name || '.' || @json-key-flag"/>
            <xsl:text>}}</xsl:text>
            <span class="OM-lit">
               <xsl:text>, labeling </xsl:text>
               <xsl:if test="@max-occurs='1'">
                  <xsl:value-of select="m:indefinite-article(@name)"/>
                  <xsl:text> </xsl:text>
               </xsl:if>
            </span>
            <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
               <xsl:value-of select="@name"/>
            </a>
            <span class="OM-lit">
               <xsl:text> </xsl:text>
               <xsl:value-of select="lower-case(@json-type)"/>
               <xsl:if test="not(@max-occurs='1')">s</xsl:if></span>
            <xsl:if test="not(position() eq last())">, </xsl:if>
         </p>
      </div>
   </xsl:template>
   
   <xsl:template priority="3" match="*[@echo='yes']" mode="html-render">
      <div class="OM-entry">
         <p>
            <xsl:call-template name="cardinality-note"/>
            <xsl:text> '</xsl:text>
            <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
               <xsl:value-of select="(@group-name,@name)[1]"/>
            </a>
            <xsl:text>'</xsl:text>
            <xsl:if test="not(position() eq last())">
               <span class="OM-lit">, </span>
            </xsl:if>
         </p>
      </div>
   </xsl:template>
   
   <xsl:template priority="2" match="*[@json-behavior='BY_KEY'][@json-type='SCALAR']" mode="html-render">
      <p class="OM-entry">
         <xsl:call-template name="cardinality-note"/>
         <xsl:text> </xsl:text>
         <xsl:text>{{</xsl:text>
         <xsl:value-of select="@name || '.' || @json-key-flag"/>
         <xsl:text>}}</xsl:text>
         <span class="OM-lit">
            <xsl:text>, labeling </xsl:text>
            <xsl:if test="@max-occurs='1'">
               <xsl:value-of select="m:indefinite-article(@name)"/>
               <xsl:text> </xsl:text>
            </xsl:if>
         </span>
         <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
            <xsl:value-of select="@name"/>
         </a>
         <span class="OM-lit"> scalar value</span>
         <xsl:text>: </xsl:text>
         <xsl:apply-templates select="." mode="contents-inline"/>
         <xsl:if test="not(position() eq last())">, </xsl:if>
      </p>
   </xsl:template>
   
   <xsl:template priority="2" match="*[@json-behavior='BY_KEY']" mode="html-render">
      <div class="OM-entry">
         <p>
            <xsl:call-template name="cardinality-note"/>
            <xsl:text> </xsl:text>
            <xsl:text>{{</xsl:text>
            <xsl:value-of select="@name || '.' || @json-key-flag"/>
            <xsl:text>}}</xsl:text>
            <span class="OM-lit">
               <xsl:text>, labeling </xsl:text>
               <xsl:if test="@max-occurs='1'">
                  <xsl:value-of select="m:indefinite-article(@name)"/>
                  <xsl:text> </xsl:text>
               </xsl:if>
            </span>
            <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
               <xsl:value-of select="@name"/>
            </a>
            <span class="OM-lit"> object<xsl:if test="not(@max-occurs='1')">s</xsl:if></span>
            <xsl:text>: {</xsl:text>
         </p>
         <xsl:apply-templates select="." mode="contents-as-block"/>
         <p>
            <xsl:text> }</xsl:text>
            <xsl:if test="not(position() eq last())">, </xsl:if>
         </p>
      </div>
   </xsl:template>
   
   <xsl:template match="*[@json-type='OBJECT']" mode="html-render">
      <div class="OM-entry">
         <p><xsl:call-template name="cardinality-note"/>
            <xsl:text> '</xsl:text>
            <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
               <xsl:value-of select="@name"/>
            </a>
            <xsl:text>': {</xsl:text>
         </p>
         <xsl:apply-templates select="." mode="contents-as-block"/>
         <p>
            <xsl:text> }</xsl:text>
            <xsl:if test="not(position() eq last())">, </xsl:if>
         </p>
      </div>
   </xsl:template>
   
   
   <xsl:template match="*[@json-type='ARRAY']" mode="html-render">
      <div class="OM-entry">
         <p><xsl:call-template name="cardinality-note"/>
            <xsl:text> '</xsl:text>
            <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ @name }">
               <xsl:value-of select="(@group-name,@name)[1]"/>
            </a>
            <xsl:text>': [</xsl:text>
         </p>
         <div class="OM-map">
            <p><xsl:call-template name="array-cardinality"/>
               <xsl:if test="@json-behavior='SINGLETON_OR_ARRAY'"><i> (when a singleton, an object not an array)</i></xsl:if>
               <xsl:text> {</xsl:text></p>
            <xsl:apply-templates select="." mode="contents-as-block"/>
            <p>}</p>
         </div>
         <p>
            <xsl:text>]</xsl:text>
            <xsl:if test="not(position() eq last())">, </xsl:if>
         </p>
      </div>
   </xsl:template>
   
   
   
   <!--<xsl:template match="m:field[@as-type='markup-multiline'][not(@wrap-xml='yes')]" mode="html-render">
      <p class="OM-entry"><a href="../../schemas/oscal-prose"><i>Prose contents (paragraphs, lists, headers and tables)</i></a></p>
   </xsl:template>-->
   
   
   <xsl:template match="m:field[@json-type='SCALAR']" mode="html-render">
      <p class="OM-entry">
         <xsl:call-template name="cardinality-note"/>
         <xsl:text> '</xsl:text>
         <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ (@link,@name)[1] }">
            <xsl:value-of select="@name"/>
         </a>
         <xsl:text>': </xsl:text>
         <xsl:apply-templates select="." mode="contents-inline"/>
         <xsl:if test="not(position() eq last())">, </xsl:if>
      </p>
   </xsl:template>
   
   <xsl:template mode="html-render" match="m:flag[@name= ../@json-value-flag]">
      <p class="OM-entry">
         <span class="OM-cardinality">optional</span>
         <xsl:text> {{</xsl:text>
         <xsl:value-of select="../@name || '.' || @name"/>
         <xsl:text>}}: </xsl:text>
         <xsl:apply-templates select="." mode="contents-inline"/>
      </p>
      
   </xsl:template>
   
   <xsl:template match="*" mode="html-render">
      <p class="OM-entry">
         <xsl:call-template name="cardinality-note"/>
         <xsl:text> '</xsl:text>
         <a class="OM-name" href="{ $path-to-docs }#{ $model-label}_{ (@link,@name)[1] }">
            <xsl:value-of select="@name"/>
         </a>
         <xsl:text>': </xsl:text>
         <xsl:apply-templates select="." mode="contents-inline"/>
         <xsl:if test="not(position() eq last())">, </xsl:if>
      </p>
   </xsl:template>
   
   <xsl:template name="cardinality-note">
      <b class="OM-cardinality">
         <xsl:choose>
            <xsl:when test="@min-occurs = '1'">required</xsl:when>
            <xsl:otherwise>optional</xsl:otherwise>
         </xsl:choose>
      </b>
   </xsl:template>
   
   <xsl:template name="array-cardinality">
      <b class="OM-cardinality">
         <xsl:call-template name="occurrences"/>
      </b>
   </xsl:template>
   
   <xsl:template name="occurrences">
      <xsl:param name="leader" select="''"/>
      <xsl:value-of select="$leader"/>
      <xsl:choose>
         <xsl:when test="@max-occurs = '1'">
            <xsl:text>one only</xsl:text>
         </xsl:when>
         <xsl:when test="@min-occurs = @max-occurs">
            <xsl:text>exactly </xsl:text>
            <xsl:value-of select="m:spell-number(@min-occurs)"/>
         </xsl:when>
         <xsl:when test="number(@min-occurs) gt 1">
            <xsl:text>at least </xsl:text>
            <xsl:value-of select="m:spell-number(@min-occurs)"/>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="not(@max-occurs = '1' or (@min-occurs = @max-occurs))">
         <xsl:choose>
            <xsl:when test="@max-occurs = 'unbounded'">as many as needed</xsl:when>
            <xsl:otherwise>
               <xsl:text>at most </xsl:text>
               <xsl:value-of select="m:spell-number(@max-occurs)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>

   </xsl:template>
   
   <xsl:template mode="contents-as-block" match="*">
      <div class="OM-map">
         <xsl:apply-templates select="." mode="value"/>
         <xsl:apply-templates select="*" mode="html-render"/>
      </div>
   </xsl:template>
   
   <xsl:template mode="contents-inline" match="*">
      <xsl:apply-templates select="." mode="datatype"/>
   </xsl:template>
   
   <xsl:template mode="value" match="m:assembly" priority="5"/>
      
   <xsl:template match="*" mode="value">
      <p class="OM-entry">
        <span class="OM-cardinality">optional</span>
        <xsl:text> 'STRVALUE': </xsl:text>
         <xsl:apply-templates select="." mode="datatype"/>
        <xsl:if test="m:flag[not(@name=../(json-key | json-value-key)/@flag-name)]">, </xsl:if>
      </p>
   </xsl:template>
   
   <xsl:template match="*[@as-type='markup-line']" mode="value">
      <span class="OM-cardinality">optional</span>
      <xsl:text> 'RICHTEXT': </xsl:text>
      <xsl:apply-templates select="." mode="datatype"/>
      <xsl:if test="m:flag[not((@name|@ref)=../(json-key | json-value-key)/@flag-name)]">, </xsl:if>
   </xsl:template>
   
   
   <xsl:template match="*[@json-value-flag=m:flag/@name]" mode="value datatype"/>
      
   <xsl:template match="*" mode="datatype">
      <span class="OM-lit">string value</span>
   </xsl:template>
   
   <xsl:template priority="2" match="*[@as-type='markup-multiline']" mode="datatype">
      <span class="OM-lit">text, parsed as Markdown (multiple lines)</span>
   </xsl:template>
   
   <xsl:template match="*[exists(@as-type)]" mode="datatype">
      <span class="OM-lit">
         <xsl:value-of select="@as-type"/>
      </span>
   </xsl:template>
   
   <xsl:template priority="2" match="*[@as-type='empty']" mode="value"/>
   
   
</xsl:stylesheet>