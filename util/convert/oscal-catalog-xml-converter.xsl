<?xml version="1.0" encoding="UTF-8"?>
<METASCHEMA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
            xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
            xsi:schemaLocation="http://csrc.nist.gov/ns/oscal/metaschema/1.0 ../../build/metaschema/lib/metaschema.xsd"
            root="catalog"
            module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml">
   <schema-name>OSCAL Control Catalog Format</schema-name>
   <short-name>oscal-catalog</short-name>
   <namespace>http://csrc.nist.gov/ns/oscal/1.0</namespace>
   <remarks>
      <p>The OSCAL Control Catalog format can be used to describe a collection of security controls and related sub-controls, along with a variety of control metadata. The root of the Control Catalog format is <code>catalog</code>.</p>
      <p>An XML Schema is <a href="https://raw.githubusercontent.com/usnistgov/OSCAL/master/schema/xml/oscal-catalog-schema.xsd">provided</a> for the OSCAL Catalog XML model.</p>
   </remarks>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="metadata">
      <formal-name>Publication metadata</formal-name>
      <description>Information describing the publication or availability of this document</description>
      <model>
         <field named="title" required="yes"/>
         <fields named="author"/>
         <field named="publication-date"/>
         <field named="version"/>
         <fields named="doc-id"/>
         <fields named="prop"/>
         <assemblies named="resource"/>
         <assemblies named="role"/>
         <assemblies named="party"/>
         <assembly named="notes"/>
         <assembly named="extra-meta"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="publication-date">
      <formal-name>Publication date</formal-name>
      <description>The official date of publication</description>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="party"
                    group-as="parties">
      <flag datatype="ID" name="id"/>
      <flag datatype="IDREFS" name="role-id"/>
      <formal-name>Party (organization or person)</formal-name>
      <description>A responsible entity, either singular (an organization or person) or collective (multiple persons)</description>
      <remarks>
         <p>As contents one of <code>org</code> or <code>person</code> is required, or both; there may be only one <code>org</code>, but many <code>person</code>s.</p>
         <p>Note that persons can also be indicated with organizational affiliations by using <code>orgname</code> inside <code>person</code>. Contact information in that case belongs to the person, not the organization: use <code>org</code> when an organization as such serves as a documented party.</p>
      </remarks>
      <model>
         <assemblies named="person"/>
         <assembly named="org"/>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="person"
                    group-as="persons">
      <formal-name>Person</formal-name>
      <description>A person, with contact information</description>
      <model>
         <field named="person-name"/>
         <field named="short-name"/>
         <field named="org-name">
            <description>Affiliated organization</description>
         </field>
         <fields named="person-id"/>
         <fields named="org-id"/>
         <assemblies named="address"/>
         <fields named="email"/>
         <fields named="phone"/>
         <fields named="url"/>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="org">
      <formal-name>Organization</formal-name>
      <description>An organization or legal entity (not a person), with contact information</description>
      <model>
         <field named="org-name"/>
         <field named="short-name"/>
         <fields named="org-id"/>
         <assemblies named="address"/>
         <fields named="email"/>
         <fields named="phone"/>
         <fields named="url"/>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="person-id"
                 group-as="person-ids">
      <flag datatype="string" name="type"/>
      <formal-name>Personal Identifier</formal-name>
      <description>An identifier for a person (such as an ORCID) using a designated scheme.</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="org-id"
                 group-as="organization-ids">
      <flag datatype="string" name="type"/>
      <formal-name>Organization Identifier</formal-name>
      <description>An identifier for an organization using a designated scheme.</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="person-name">
      <formal-name>Person Name</formal-name>
      <description>Full (legal) name of an individual</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="org-name">
      <formal-name>Organization Name</formal-name>
      <description>Full (legal) name of an organization</description>
      <remarks>
         <p>Only when this element is used directly within <code>org</code> can it be accepted of the name of the thing to which it is attached. This element may also be used directly on <code>person</code> to name an affiliated organization.</p>
         <p>
            <code>href</code> can be used to provide external links or internal links to other elements. The sibling <code>org-id</code> element (similarly for <em>affiliated</em> organizations) can also be used to link (for example to organizations listed elsewhere as parties.)</p>
      </remarks>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="short-name">
      <formal-name>short-name</formal-name>
      <description>A common name, short name or acronym</description>
      <remarks>
         <p>This element is not expected to be used to identify individual persons, but rather an organization or system.</p>
      </remarks>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="address"
                    group-as="addresses">
      <flag datatype="string" name="type"/>
      <formal-name>Address</formal-name>
      <description>A postal address</description>
      <model>
         <fields named="addr-line"/>
         <field named="city"/>
         <field named="state"/>
         <field named="postal-code"/>
         <field named="country"/>
         <!-- More address stuff -->
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="addr-line"
                 group-as="postal-address">
      <formal-name>Address line</formal-name>
      <description>A single line of an address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="city">
      <formal-name>City</formal-name>
      <description>City, town or geographical region for mailing address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="state">
      <formal-name>State</formal-name>
      <description>State, province or analogous geographical region for mailing address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="postal-code">
      <formal-name>Postal Code</formal-name>
      <description>Postal or ZIP code for mailing address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="country">
      <formal-name>Country</formal-name>
      <description>Country for mailing address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="email"
                 group-as="email-addresses">
      <flag datatype="string" name="type"/>
      <formal-name>Email</formal-name>
      <description>Email address</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="phone"
                 group-as="telephone-numbers">
      <flag datatype="string" name="type"/>
      <formal-name>Telephone</formal-name>
      <description>Contact number by telephone</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="url"
                 group-as="URLs">
      <flag datatype="string" name="type"/>
      <formal-name>URL</formal-name>
      <description>URL for web site or Internet presence</description>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="role"
                    group-as="roles">
      <flag datatype="ID" name="id" required="yes"/>
      <formal-name>Role</formal-name>
      <description>Defining a role to be assigned to a party or agent</description>
      <remarks>
         <p>Permissible values to be determined closer to the application (e.g. by a receiving authority).</p>
      </remarks>
      <model>
         <field named="title"/>
         <field named="short-name"/>
         <field named="desc"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="extra-meta">
      <formal-name>Extra metadata</formal-name>
      <description>Container for (system-defined) metadata</description>
      <model>
         <choice>
            <assemblies named="meta-group"/>
            <fields named="meta"/>
         </choice>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                    name="meta-group"
                    group-as="metadata-groups">
      <flag datatype="string" name="term"/>
      <flag datatype="string" name="type"/>
      <formal-name>Metadata group</formal-name>
      <description>Custom- or application-defined annotated metadata.</description>
      <model>
         <fields named="meta"/>
         <assemblies named="meta-group"/>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="meta"
                 group-as="metadata-fields">
      <flag datatype="string" name="term"/>
      <flag datatype="string" name="type"/>
      <formal-name>Metadata field value</formal-name>
      <description>Any customized or specialized metadata value.</description>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                name="term"
                datatype="string">
      <formal-name>Metadata term</formal-name>
      <description>A classification (according to any schema or taxonomy) of a metadata value or set of values.</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                name="role-id"
                datatype="IDREFS">
      <formal-name>Role identifier</formal-name>
      <description>References a <code>role</code> element defined in metadata.</description>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="resource"
                    group-as="resources">
      <flag datatype="NCName" name="rel"/>
      <flag datatype="string" name="media-type"/>
      <formal-name>Resource</formal-name>
      <description>A resource to inform or authenticate the present document, or to supplement it as an attachment</description>
      <remarks>
         <p>This element is used in two ways. In document metadata, it may describe and point to a mirror or other (authoritative or informative) copy of a document, or of a resouce helpful (necessary) for interpreting it, such as its metaschema or documentation. It may offer a (persistent) link to a <q>best available</q> version, or to an outdated version, as indicated by its <code>rel</code>.</p>
         <p>In back matter or within sections, a resource may be an attachment or any external document.</p>
         <p>The <code>rel</code> flag should be used to indicate the relation of the resource to the document referencing it, such as <q>catalog</q>, <q>baseline</q>, <q>metaschema</q> or <q>attachment</q>.</p>
      </remarks>
      <model>
         <field named="title"/>
         <fields named="author"/>
         <field named="format"/>
         <assembly named="description"/>
         <field named="date"/>
         <field named="version"/>
         <fields named="doc-id"/>
         <fields named="prop"/>
         <choice>
            <assemblies named="hlink"/>
            <field named="base64"/>
         </choice>
         <assembly named="notes"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="author"
                 group-as="authors">
      <formal-name>Author</formal-name>
      <description>A named author</description>
      <remarks>
         <p>Note this information may be duplicative of information given in a <code>party</code> element with appropriate <code>role-id</code> flags, along with more a more complete structured listing. This element provides a value for display as well as an additional point of comparison.</p>
      </remarks>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="doc-id"
                 group-as="document-ids">
      <flag datatype="string" name="type"/>
      <formal-name>Document Identifier</formal-name>
      <description>Any sort of document identifier, name, code, path or other indicator of where and how this document
			may be located, compared or validated. Given appropriate qualification via its <code>type</code> and <code>rel</code>, this value may point to <q>the same</q> or <q>another version</q> of the document.</description>
      <remarks>
         <p>Flags <code>rel</code> and <code>type</code> can qualify the kind and use of document identifier, in particular whether the value is to be attributed to the given instance, or to another instance, source or resource.</p>
         <p>Specific usage rules, nomenclatures and recognized file types e.g. DOIs, CMS locators, etc etc., may be defined at application level. The value of this field may also be a hash or check sum.</p>
      </remarks>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="type"
                datatype="string">
      <formal-name>Type</formal-name>
      <description>Indicating the type of identifier or other data item.</description>
      <remarks>
         <p>Generally, this flag is used to relate to schemes and taxonomies defined outside the OSCAL application in some public form; i.e. they can be looked up.</p>
      </remarks>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="notes">
      <formal-name>Notes</formal-name>
      <description>Any notes with further information</description>
      <model>
         <prose/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="hlink"
                    group-as="hashed-links">
      <flag datatype="anyURI" name="href" required="yes"/>
      <flag datatype="string" name="media-type"/>
      <formal-name>Hashed link</formal-name>
      <description>A pointer to an external document with optional hash for verification</description>
      <remarks>
         <p>This is different from unstructured <code>link</code>, which makes no provision for a hash or formal title. It is also different from the element of the same name once proposed for HTML.</p>
      </remarks>
      <model>
         <field named="title"/>
         <fields named="hash"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="hash"
                 group-as="hashes">
      <flag datatype="string" name="algorithm"/>
      <formal-name>Hash</formal-name>
      <description>A document hash or other value subject to cryptographic authentication</description>
      <remarks>
         <p>When appearing as part of a resource (data object), the hash should apply to the referenced object.</p>
      </remarks>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="algorithm"
                datatype="string">
      <formal-name>Hash algorithm</formal-name>
      <description>Method by which a hash is derived</description>
      <remarks>
         <p>One of the following is recognized: MD5, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512, RIPEMD-160. See <a href="https://www.w3.org/TR/xmlsec-algorithms/#digest-method">XML Security Algorithm Cross-Reference</a> (W3C, April 2013) for more information.</p>
      </remarks>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="href"
                datatype="anyURI">
      <formal-name>Hypertext reference</formal-name>
      <description>A relative or absolute URI indicating a resource available on the Internet.</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="rel"
                datatype="NCName">
      <formal-name>Relation</formal-name>
      <description>Purpose of the link</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="media-type"
                datatype="string">
      <formal-name>Media type</formal-name>
      <description>Describes the media or MIME type of a linked resource</description>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="description">
      <formal-name>Description</formal-name>
      <description>A free-text description of the system.</description>
      <model>
         <prose/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="version">
      <flag datatype="date" name="iso-date"/>
      <formal-name>version</formal-name>
      <description>Version information</description>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="iso-date"
                datatype="date">
      <formal-name>ISO (standard) date</formal-name>
      <description>Please use YYYY-MM-DD syntax.</description>
      <remarks>
         <p>The syntax may be validated in back. The date given should presumably be the same as the (human-readable) <code>date</code> given above it (and such a discrepancy is also be detectable).</p>
      </remarks>
   </define-flag>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="format"
                 as="string">
      <formal-name>Resource or attachment Format</formal-name>
      <description>For use when no mime-type is available or additional information is required.</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="date"
                 as="string">
      <flag datatype="date" name="iso-date"/>
      <formal-name>Date</formal-name>
      <description/>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="base64"
                 as="string">
      <flag datatype="string" name="filename"/>
      <formal-name>Date</formal-name>
      <description/>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="filename"
                datatype="string">
      <formal-name>File Name</formal-name>
      <description>Name of the file before it was converted to Base-64. This is the name that will be assigned to the file when converted back to binary.</description>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="ref-list"
                    group-as="reference-lists">
      <flag datatype="ID" name="id"/>
      <formal-name>Reference</formal-name>
      <description>A list of references to external resources. This object may be nested
			for reference lists composed of reference lists.
		</description>
      <model>
         <field named="title"/>
         <prose/>
         <fields named="link"/>
         <assemblies named="ref"/>
         <assemblies named="ref-list"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="ref"
                    group-as="references">
      <flag datatype="ID" name="id"/>
      <formal-name>Reference</formal-name>
      <description> A reference, with one or more citations to standards, related documents, or
			other resources </description>
      <model>
         <fields named="citation"/>
         <prose/>
         <any/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 group-as="citations"
                 name="citation"
                 as="mixed">
      <flag datatype="ID" name="id"/>
      <flag datatype="anyURI" name="href"/>
      <formal-name>Citation</formal-name>
      <description>Citation of a resource</description>
      <remarks>
         <p>Semantics of any contents within citation are implicit, not encoded. To mitigate problems establishin matches with bibliograpical databases, it is recommended a canonical identifier such as a DOI be provided for any citation.</p>
      </remarks>
      <example>
         <ref xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <citation>Here is a work cited</citation>
            <citation>Some <strong>citation</strong> of some sort</citation>
         </ref>
      </example>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="link"
                 group-as="links"
                 as="mixed">
      <flag datatype="anyURI" name="href"/>
      <flag datatype="NCName" name="rel"/>
      <formal-name>Link</formal-name>
      <description>
			A line or paragraph with a hypertext link
		</description>
      <remarks>
         <p>Works like an HTML anchor (<code>a</code>) except this is a line-oriented (block) element.</p>
      </remarks>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="catalog"
                    group-as="control-catalog">
      <flag datatype="ID" name="id" required="yes"/>
      <flag datatype="NCName" name="model-version" required="yes"/>
      <formal-name>Catalog</formal-name>
      <description>A collection of controls</description>
      <remarks>
         <p>Catalogs may use <code>section</code> to subdivide the textual contents of a catalog.</p>
      </remarks>
      <model>
         <field named="title" required="yes"/>
         <assembly named="metadata"/>
         <!--<field named="declarations"/>-->
         <assemblies named="section"/>
         <choice>
            <assemblies named="group"/>
            <assemblies named="control"/>
         </choice>
         <assembly named="back"/>
      </model>
      <example>
         <description>A small catalog with a single control</description>
         <catalog xmlns="http://csrc.nist.gov/ns/oscal/1.0"
                  id="simple-example"
                  model-version="0.99">
            <title>A Miniature Catalog</title>
            <control id="single">
               <title>A Single Control</title>
            </control>
         </catalog>
      </example>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="back">
      <flag datatype="ID" name="id"/>
      <formal-name>Assets</formal-name>
      <description>References, resources and attachments</description>
      <model>
         <assembly named="ref-list"/>
         <assemblies named="resource"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="section"
                    group-as="sections">
      <flag datatype="ID" name="id"/>
      <flag datatype="NMTOKENS" name="class"/>
      <formal-name>Section</formal-name>
      <description>Allows the inclusion of prose content within a Catalog.</description>
      <model>
         <field named="title" required="yes"/>
         <prose/>
         <assemblies named="section"/>
         <assembly named="ref-list"/>
         <any/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="group"
                    group-as="groups">
      <flag datatype="ID" name="id"/>
      <flag datatype="NMTOKENS" name="class"/>
      <formal-name>Control Group</formal-name>
      <description>A group of controls, or of groups of controls.</description>
      <remarks>
         <p>Catalogs can use groups to provide collections of related controls or Control Groups. A <code>group</code> may have its own properties, statements, parameters, and references, which are inherited by all members of that group. Unlike a <code>section</code>, a <code>group</code> may not contain arbitrary prose directly, only inside its <code>part</code> or <code>control</code> components.</p>
      </remarks>
      <model>
         <field named="title" required="yes"/>
         <assemblies named="param" address="id"/>
         <fields named="prop"/>
         <assemblies named="part"/>
         <choice>
            <assemblies named="group"/>
            <assemblies named="control"/>
         </choice>
         <assembly named="ref-list"/>
         <any/>
      </model>
      <example>
         <group xmlns="http://csrc.nist.gov/ns/oscal/1.0" id="xyz">
            <title>My Group</title>
            <prop class="required">some property</prop>
            <control id="xyz1">
               <title>Control</title>
            </control>
         </group>
      </example>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="control"
                    group-as="controls">
      <flag datatype="ID" name="id" required="yes"/>
      <flag datatype="NMTOKENS" name="class"/>
      <formal-name>Control</formal-name>
      <description>A structured information object representing a security or privacy control. Each security or privacy control within the Catalog is defined by a distinct control instance.</description>
      <remarks>
         <p>Controls may be grouped using <code>group</code>, and controls may be partitioned using <code>part</code> or enhanced using <code>subcontrol</code>.</p>
      </remarks>
      <model>
         <field named="title" required="yes"/>
         <assemblies named="param" address="id"/>
         <fields named="prop"/>
         <fields named="link"/>
         <assemblies named="part"/>
         <assemblies named="subcontrol" address="id"/>
         <assembly named="ref-list"/>
         <any/>
      </model>
      <example>
         <control xmlns="http://csrc.nist.gov/ns/oscal/1.0" id="x">
            <title>Control 1</title>
         </control>
      </example>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="subcontrol"
                    group-as="subcontrols"
                    address="id">
      <flag datatype="ID" name="id" required="yes"/>
      <flag datatype="NMTOKENS" name="class"/>
      <formal-name>Sub-Control</formal-name>
      <description>A control extension or enhancement</description>
      <model>
         <field named="title" required="yes"/>
         <assemblies named="param" address="id"/>
         <fields named="prop"/>
         <fields named="link"/>
         <assemblies named="part"/>
         <assembly named="ref-list"/>
         <any/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="title"
                 as="mixed">
      <formal-name>Title</formal-name>
      <description>A title for display and navigation, exclusive of more specific properties</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="prop"
                 group-as="properties">
      <flag datatype="ID" name="id"/>
      <flag datatype="NMTOKENS" name="class" required="yes"/>
      <formal-name>Property</formal-name>
      <description>A value with a name, attributed to the containing control, subcontrol, part,
          or group.</description>
      <remarks>
         <p>Properties permit the deployment and management of arbitrary controlled values, with and among control objects (controls, parts, and extensions), for any purpose useful to an application or implementation of those controls. Typically, properties will be used to sort, select, order, and arrange controls or relate them to one another or to class hierarchies, taxonomies, or external authorities.</p>
         <p>The value of a property is a simple scalar value or list of values.</p>
         <p>The lexical composition of properties may be constrained by declarations including matching to regular expressions or by declaring a known datatype.</p>
         <p>Because properties are often used as selectors or identifiers for OSCAL operations, their values can be expected frequently to be normalized (e.g., with respect to whitespace) in use; however, this is application defined.</p>
         <p>For singletons (that is, the only element among siblings with its <code>class</code>), properties are especially useful as proxies (unique identifiers) for their controls, such that controls may be returned one for one on queries for properties (name and value). The robustness of such queries can be ensured by appropriate property declarations (as singletons and as identifiers); cf <code>declare-prop</code> in the declarations model (which also supports other constraints over property values).</p>
      </remarks>
      <example>
         <prop xmlns="http://csrc.nist.gov/ns/oscal/1.0" class="name">A1</prop>
      </example>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    group-as="parameters"
                    name="param"
                    address="id">
      <flag datatype="ID" name="id" required="yes"/>
      <flag datatype="NMTOKENS" name="class"/>
      <flag datatype="IDREF" name="depends-on"/>
      <formal-name>Parameter</formal-name>
      <description>Parameters provide a mechanism for the dynamic assignment of value(s) in a control.</description>
      <remarks>
         <p>In a catalog, a parameter is typically used as a placeholder for the future assignment of a parameter value, although the OSCAL model allows for the direct assignment of a value if desired by the control author. The <code>value</code> may be optionally used to specify one or more values. If no value is provided, then it is expected that the value will be provided at the Profile or Implementation layer.</p>
         <p>A parameter can include a variety of metadata options that support the future solicitation of one or more values. A <code>label</code> provides a textual placeholder that can be used in a tool to solicit parameter value input, or to display in catalog documentation. The <code>desc</code> provides a short description of what the parameter is used for, which can be used in tooling to help a user understand how to use the parameter. A <code>constraint</code> can be used to provide criteria for the allowed values. A <code>guideline</code> provides a recommendation for the use of a parameter.</p>
      </remarks>
      <model>
         <field named="label">
            <description>A short name for the parameter.</description>
            <remarks>
               <p>The label value should be suitable for inline display in a rendered catalog.</p>
            </remarks>
         </field>
         <fields named="desc">
            <description>A short summary of the parameter's intended use.</description>
            <remarks>
               <p> A label is optional, but should be provided unless a <code>select</code> (selection) is provided.</p>
            </remarks>
         </fields>
         <fields named="constraint">
            <description>A rule describing the permissible parameter values.</description>
            <remarks>
               <p>Currently, OSCAL does not standardize any formal rules language for value constraints. A <code>test</code> option may be used to specify a formal rule that may be automatically used if recognized by an OSCAL tool. Further development is <a href="https://github.com/usnistgov/OSCAL/issues/206">needed</a> to support the declaration of a rule language and value.</p>
            </remarks>
         </fields>
         <assemblies named="guideline">
            <description>Additional recommendations for the use of the parameter, or around what values should be provided.</description>
         </assemblies>
         <choice>
            <field named="value">
               <description>A recommended parameter value or set of values.</description>
               <remarks>
                  <p>A value provided in a catalog can be redefined at any higher layer of OSCAL (e.g., Profile).</p>
               </remarks>
            </field>
            <assembly named="select">
               <description>A set of parameter value choices, that may be picked from to set the parameter value.</description>
               <remarks>
                  <p>.</p>
               </remarks>
            </assembly>
         </choice>
         <fields named="link">
            <description/>
         </fields>
         <any/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="label"
                 as="mixed">
      <formal-name>Parameter label</formal-name>
      <description>A placeholder for a missing value, in display.</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="desc"
                 group-as="descriptions"
                 as="mixed">
      <flag datatype="ID" name="id"/>
      <formal-name>Parameter description</formal-name>
      <description>Indicates and explains the purpose and use of a parameter</description>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="constraint"
                 group-as="constraints">
      <flag datatype="string" name="test"/>
      <formal-name>Constraint</formal-name>
      <description>A formal or informal expression of a constraint or test</description>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="guideline"
                    group-as="guidance">
      <formal-name>Guideline</formal-name>
      <description>A prose statement that provides a recommendation for the use of a parameter.</description>
      <model>
         <prose/>
         <any/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="value"
                 as="mixed">
      <formal-name>Value constraint</formal-name>
      <description>Indicates a permissible value for a parameter or property</description>
      <remarks>
         <p>In a declaration, <code>value</code> will commonly be given in groups, indicating a set of enumerated permissible values (i.e., for an element to be valid to a value constraint, it must equal one of the given values).</p>
         <p>In a parameter, a value represents a value assignment to the parameter, overriding any value given at the point of insertion. When parameters are provided in OSCAL profiles, their values will override any values assigned <q>lower down the stack</q>.</p>
      </remarks>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="select">
      <flag datatype="string" name="how-many"/>
      <formal-name>Selection</formal-name>
      <description>Presenting a choice among alternatives</description>
      <model>
         <fields named="choice"/>
         <any/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="choice"
                 group-as="alternatives"
                 as="mixed">
      <formal-name>Choice</formal-name>
      <description>A value selection among several such options</description>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="part"
                    group-as="parts">
      <flag datatype="ID" name="id"/>
      <flag datatype="NMTOKENS" name="class"/>
      <formal-name>Part</formal-name>
      <description>A partition or component of a control, subcontrol or part</description>
      <remarks>
         <p>Like properties (<code>prop</code>) and parameters (<code>param</code>), parts can be distinguished from other elements within their controls by their assigned <code>class</code>, such that they may be subjected to <q>declarations logic</q> using these values as bindings (and thereby getting open-ended extensibility).</p>
         <p>An assigned class may frequently provide for a header in display, such that <code>part</code>
            <code>[@class='objectives']</code> is displayed under a header <em>Objectives</em>, etc. Parts may also however have their own titles (<code>title</code> elements).</p>
         <p>Many parts are logical partitions or sections for prose. Other parts may be more formally constructed out of properties (<code>prop</code> elements) and/or their own parts. Such structured objects may, at the extreme, function virtually as control extensions or subcontrol-like objects (<q>enhancements</q>).</p>
      </remarks>
      <model>
         <field named="title"/>
         <fields named="prop"/>
         <prose/>
         <assemblies named="part"/>
         <fields named="link"/>
         <any/>
      </model>
   </define-assembly>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="id"
                datatype="ID">
      <formal-name>ID / identifier</formal-name>
      <description>Unique identifier</description>
      <remarks>
         <p>No mechanism is proposed to ensure that <code>id</code> values do not collide across different catalogs. Use profiling without <q>merge</q> to detect such clashes.</p>
      </remarks>
      <example>
         <citation xmlns="http://csrc.nist.gov/ns/oscal/1.0" id="xyz2">Some <strong>citation</strong> of some sort</citation>
      </example>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="class"
                datatype="NMTOKENS">
      <formal-name>Class</formal-name>
      <description>Identifies the property or object within the control; a semantic hint</description>
      <remarks>
         <p>Overloading this attribute with more than one value is permitted, but not recommended.</p>
      </remarks>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="test"
                datatype="string">
      <formal-name>Constraint test</formal-name>
      <description>A formal (executable) expression of a constraint</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="how-many"
                datatype="string">
      <formal-name>Cardinality</formal-name>
      <description>When selecting, a requirement such as one or more</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="depends-on"
                datatype="IDREF">
      <formal-name>Depends on</formal-name>
      <description>Another parameter invoking this one</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="model-version"
                datatype="NCName">
      <formal-name>Model version</formal-name>
      <description>Declares a major/minor version for this metaschema</description>
   </define-flag>
</METASCHEMA>
