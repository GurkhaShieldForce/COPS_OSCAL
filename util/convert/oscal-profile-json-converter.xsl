<?xml version="1.0" encoding="UTF-8"?>
<METASCHEMA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
            xsi:schemaLocation="http://csrc.nist.gov/ns/oscal/metaschema/1.0 ../../build/metaschema/lib/metaschema.xsd"
            root="profile"
            module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml">
   <schema-name>OSCAL Profile Metaschema</schema-name>
   <short-name>oscal-profile</short-name>
   <namespace>http://csrc.nist.gov/ns/oscal/1.0</namespace>
   <remarks>
      <p>A profile designates a selection and configuration of controls and subcontrols from one or more catalogs, along with a series of operations over the controls and subcontrols. The topmost element in the OSCAL profile XML schema is <code>profile</code>.</p>
   </remarks>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="publication-date">
      <formal-name>Publication date</formal-name>
      <description>The official date of publication</description>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="person-id"
                 group-as="person-ids">
      <flag datatype="string" name="type"/>
      <formal-name>Personal Identifier</formal-name>
      <description>An identifier for a person (such as an ORCID) using a designated scheme.</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="org-id"
                 group-as="organization-ids">
      <flag datatype="string" name="type"/>
      <formal-name>Organization Identifier</formal-name>
      <description>An identifier for an organization using a designated scheme.</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="person-name">
      <formal-name>Person Name</formal-name>
      <description>Full (legal) name of an individual</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="org-name">
      <formal-name>Organization Name</formal-name>
      <description>Full (legal) name of an organization</description>
      <remarks>
         <p>Only when this element is used directly within <code>org</code> can it be accepted of the name of the thing to which it is attached. This element may also be used directly on <code>person</code> to name an affiliated organization.</p>
         <p>
            <code>href</code> can be used to provide external links or internal links to other elements. The sibling <code>org-id</code> element (similarly for <em>affiliated</em> organizations) can also be used to link (for example to organizations listed elsewhere as parties.)</p>
      </remarks>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="short-name">
      <formal-name>short-name</formal-name>
      <description>A common name, short name or acronym</description>
      <remarks>
         <p>This element is not expected to be used to identify individual persons, but rather an organization or system.</p>
      </remarks>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="addr-line"
                 group-as="postal-address">
      <formal-name>Address line</formal-name>
      <description>A single line of an address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="city">
      <formal-name>City</formal-name>
      <description>City, town or geographical region for mailing address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="state">
      <formal-name>State</formal-name>
      <description>State, province or analogous geographical region for mailing address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="postal-code">
      <formal-name>Postal Code</formal-name>
      <description>Postal or ZIP code for mailing address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="country">
      <formal-name>Country</formal-name>
      <description>Country for mailing address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="email"
                 group-as="email-addresses">
      <flag datatype="string" name="type"/>
      <formal-name>Email</formal-name>
      <description>Email address</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="phone"
                 group-as="telephone-numbers">
      <flag datatype="string" name="type"/>
      <formal-name>Telephone</formal-name>
      <description>Contact number by telephone</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="url"
                 group-as="URLs">
      <flag datatype="string" name="type"/>
      <formal-name>URL</formal-name>
      <description>URL for web site or Internet presence</description>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                 name="meta"
                 group-as="metadata-fields">
      <flag datatype="string" name="term"/>
      <flag datatype="string" name="type"/>
      <formal-name>Metadata field value</formal-name>
      <description>Any customized or specialized metadata value.</description>
   </define-field>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                name="term"
                datatype="string">
      <formal-name>Metadata term</formal-name>
      <description>A classification (according to any schema or taxonomy) of a metadata value or set of values.</description>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-metadata-metaschema.xml"
                name="role-id"
                datatype="IDREFS">
      <formal-name>Role identifier</formal-name>
      <description>References a <code>role</code> element defined in metadata.</description>
   </define-flag>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="author"
                 group-as="authors">
      <formal-name>Author</formal-name>
      <description>A named author</description>
      <remarks>
         <p>Note this information may be duplicative of information given in a <code>party</code> element with appropriate <code>role-id</code> flags, along with more a more complete structured listing. This element provides a value for display as well as an additional point of comparison.</p>
      </remarks>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="type"
                datatype="string">
      <formal-name>Type</formal-name>
      <description>Indicating the type of identifier or other data item.</description>
      <remarks>
         <p>Generally, this flag is used to relate to schemes and taxonomies defined outside the OSCAL application in some public form; i.e. they can be looked up.</p>
      </remarks>
   </define-flag>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="notes">
      <formal-name>Notes</formal-name>
      <description>Any notes with further information</description>
      <model>
         <prose/>
      </model>
   </define-assembly>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="hash"
                 group-as="hashes">
      <flag datatype="string" name="algorithm"/>
      <formal-name>Hash</formal-name>
      <description>A document hash or other value subject to cryptographic authentication</description>
      <remarks>
         <p>When appearing as part of a resource (data object), the hash should apply to the referenced object.</p>
      </remarks>
   </define-field>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="algorithm"
                datatype="string">
      <formal-name>Hash algorithm</formal-name>
      <description>Method by which a hash is derived</description>
      <remarks>
         <p>One of the following is recognized: MD5, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512, RIPEMD-160. See <a href="https://www.w3.org/TR/xmlsec-algorithms/#digest-method">XML Security Algorithm Cross-Reference</a> (W3C, April 2013) for more information.</p>
      </remarks>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="href"
                datatype="anyURI">
      <formal-name>Hypertext reference</formal-name>
      <description>A relative or absolute URI indicating a resource available on the Internet.</description>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="rel"
                datatype="NCName">
      <formal-name>Relation</formal-name>
      <description>Purpose of the link</description>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="media-type"
                datatype="string">
      <formal-name>Media type</formal-name>
      <description>Describes the media or MIME type of a linked resource</description>
   </define-flag>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                    name="description">
      <formal-name>Description</formal-name>
      <description>A free-text description of the system.</description>
      <model>
         <prose/>
      </model>
   </define-assembly>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="version">
      <flag datatype="date" name="iso-date"/>
      <formal-name>version</formal-name>
      <description>Version information</description>
   </define-field>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="iso-date"
                datatype="date">
      <formal-name>ISO (standard) date</formal-name>
      <description>Please use YYYY-MM-DD syntax.</description>
      <remarks>
         <p>The syntax may be validated in back. The date given should presumably be the same as the (human-readable) <code>date</code> given above it (and such a discrepancy is also be detectable).</p>
      </remarks>
   </define-flag>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="format"
                 as="string">
      <formal-name>Resource or attachment Format</formal-name>
      <description>For use when no mime-type is available or additional information is required.</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="date"
                 as="string">
      <flag datatype="date" name="iso-date"/>
      <formal-name>Date</formal-name>
      <description/>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                 name="base64"
                 as="string">
      <flag datatype="string" name="filename"/>
      <formal-name>Date</formal-name>
      <description/>
   </define-field>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
                name="filename"
                datatype="string">
      <formal-name>File Name</formal-name>
      <description>Name of the file before it was converted to Base-64. This is the name that will be assigned to the file when converted back to binary.</description>
   </define-flag>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-resources-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="title"
                 as="mixed">
      <formal-name>Title</formal-name>
      <description>A title for display and navigation, exclusive of more specific properties</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
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
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
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
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="label"
                 as="mixed">
      <formal-name>Parameter label</formal-name>
      <description>A placeholder for a missing value, in display.</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="desc"
                 group-as="descriptions"
                 as="mixed">
      <flag datatype="ID" name="id"/>
      <formal-name>Parameter description</formal-name>
      <description>Indicates and explains the purpose and use of a parameter</description>
   </define-field>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="constraint"
                 group-as="constraints">
      <flag datatype="string" name="test"/>
      <formal-name>Constraint</formal-name>
      <description>A formal or informal expression of a constraint or test</description>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="guideline"
                    group-as="guidance">
      <formal-name>Guideline</formal-name>
      <description>A prose statement that provides a recommendation for the use of a parameter.</description>
      <model>
         <prose/>
         <any/>
      </model>
   </define-assembly>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="value"
                 as="mixed">
      <formal-name>Value constraint</formal-name>
      <description>Indicates a permissible value for a parameter or property</description>
      <remarks>
         <p>In a declaration, <code>value</code> will commonly be given in groups, indicating a set of enumerated permissible values (i.e., for an element to be valid to a value constraint, it must equal one of the given values).</p>
         <p>In a parameter, a value represents a value assignment to the parameter, overriding any value given at the point of insertion. When parameters are provided in OSCAL profiles, their values will override any values assigned <q>lower down the stack</q>.</p>
      </remarks>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                    name="select">
      <flag datatype="string" name="how-many"/>
      <formal-name>Selection</formal-name>
      <description>Presenting a choice among alternatives</description>
      <model>
         <fields named="choice"/>
         <any/>
      </model>
   </define-assembly>
   <define-field xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                 module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                 name="choice"
                 group-as="alternatives"
                 as="mixed">
      <formal-name>Choice</formal-name>
      <description>A value selection among several such options</description>
   </define-field>
   <define-assembly xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                    module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
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
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
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
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="class"
                datatype="NMTOKENS">
      <formal-name>Class</formal-name>
      <description>Identifies the property or object within the control; a semantic hint</description>
      <remarks>
         <p>Overloading this attribute with more than one value is permitted, but not recommended.</p>
      </remarks>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="test"
                datatype="string">
      <formal-name>Constraint test</formal-name>
      <description>A formal (executable) expression of a constraint</description>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="how-many"
                datatype="string">
      <formal-name>Cardinality</formal-name>
      <description>When selecting, a requirement such as one or more</description>
   </define-flag>
   <define-flag xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-catalog-metaschema.xml"
                name="depends-on"
                datatype="IDREF">
      <formal-name>Depends on</formal-name>
      <description>Another parameter invoking this one</description>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="profile"
                    group-as="profiles">
      <flag datatype="ID" name="id" required="yes"/>
      <formal-name>Profile</formal-name>
      <description>Each OSCAL profile is defined by a Profile element</description>
      <remarks>
         <p>An OSCAL document that describes a selection with possible modification of multiple controls from multiple catalogs. It provides mechanisms by which controls may be selected (<code>import</code>), merged or (re)structured (<code>merge</code>), and emended (<code>modify</code>). OSCAL profiles may select subsets of control sets, set parameter values for them in application, and even qualify the representation of controls and subcontrols as given in and by a catalog. They may also serve as sources for further modification in and by other profiles, that import them.</p>
      </remarks>
      <model>
         <field named="title" required="yes"/>
         <assembly named="metadata"/>
         <assemblies named="import"/>
         <assembly named="merge"/>
         <assembly named="modify"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="import"
                    group-as="imports">
      <flag datatype="anyURI" name="href" required="yes"/>
      <formal-name>Import resource</formal-name>
      <description>An Import element designates a catalog, profile, or other resource to be
         included (referenced and potentially modified) by this profile.</description>
      <remarks>
         <p>An <code>import</code> indicates a source whose controls are to be included (referenced and modified) in a profile. This source will either be a catalog whose controls are given (<q>by value</q>), or a profile with its own control imports (with possible settings.</p>
         <p>The contents of the <code>import</code> element indicate which controls and subcontrols from the source, will be included. Controls and subcontrols may be either selected (using an <code>include</code> element) or de-selected (using an <code>exclude</code> element) from the source catalog or profile.</p>
         <p>When no <code>include</code> is given (whether an <code>exclude</code> is given or not), an <code>include</code>/<code>all</code> is assumed (that is, all controls will be included by default).</p>
      </remarks>
      <model>
         <assembly named="include"/>
         <assembly named="exclude"/>
      </model>
      <example>
         <import xmlns="http://csrc.nist.gov/ns/oscal/1.0" href="catalog.xml">
            <include>
               <call control-id="ac-1"/>
            </include>
         </import>
      </example>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="merge">
      <formal-name>Merge controls</formal-name>
      <description>A Merge element merges controls in resolution.</description>
      <remarks>
         <p>The contents of the <code>merge</code> element may be used to <q>reorder</q> or <q>restructure</q> controls by indicating an order and/or structure in resolution.</p>
         <p>Implicitly, a <code>merge</code> element is also a filter: controls that are included in a profile, but not included (implicitly or explicitly) in the scope of a <code>merge</code> element, will not be merged into (will be dropped) in the resulting resolution.</p>
      </remarks>
      <model>
         <field named="combine"/>
         <choice>
            <field named="as-is"/>
            <assembly named="custom"/>
         </choice>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 name="combine"
                 as="empty">
      <flag datatype="string" name="method">
         <value>use-first</value>
         <value>merge</value>
         <value>keep</value>
      </flag>
      <formal-name>Combination rule</formal-name>
      <description>A Combine element defines whether and how to combine multiple (competing)
        versions of the same control</description>
      <remarks>
         <p>Whenever combining controls from multiple (import) pathways, an issue arises of what to do with clashing invocations (multiple competing versions of a control or a subcontrol). </p>
         <p>This setting permits a profile designer to apply a rule for the resolution of such cases. In a well-designed profile, such collisions would ordinarily be avoided, but this setting can be useful for defining what to do when it occurs.</p>
      </remarks>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 name="as-is"
                 as="boolean">
      <formal-name>As is</formal-name>
      <description>An As-is element indicates that the controls should be structured in resolution as they are
        structured in their source catalogs. It does not contain any elements or attributes.</description>
   </define-field>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                name="method"
                datatype="string">
      <formal-name>Combination method</formal-name>
      <description>How clashing controls and subcontrols should be handled</description>
   </define-flag>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="custom"
                    group-as="customs">
      <formal-name>Custom grouping</formal-name>
      <description>A Custom element frames a structure for embedding represented controls in resolution.</description>
      <remarks>
         <p>The <code>custom</code> element represents a custom arrangement or organization of controls in the resolution of a catalog. </p>
         <p>While the <code>as-is</code> element provides for a restitution of a control set's organization (in one or more source catalogs), this element permits the definition of an entirely different structure.</p>
      </remarks>
      <model>
         <choice>
            <assemblies named="group"/>
            <fields named="call"/>
            <fields named="match"/>
         </choice>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="group"
                    group-as="groups">
      <formal-name>Control group</formal-name>
      <description>As in catalogs, a group of (selected) controls or of groups of controls</description>
      <model>
         <choice>
            <assemblies named="group"/>
            <fields named="call"/>
            <fields named="match"/>
         </choice>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="modify"
                    group-as="modifys">
      <formal-name>Modify controls</formal-name>
      <description>Set parameters or amend controls in resolution</description>
      <model>
         <assemblies named="set-param"/>
         <assemblies named="alter"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="include"
                    group-as="includes">
      <formal-name>Include controls</formal-name>
      <description>Specifies which controls and subcontrols to include from the resource (source catalog) being
          imported</description>
      <remarks>
         <p>To be schema-valid, this element must contain either (but not both) a single <code>all</code> element, or a sequence of <code>call</code> elements.</p>
         <p>If this element is not given, it is assumed to be present with contents <code>all</code> (qv); i.e., all controls are included by default, unless the <code>include</code> instruction calls controls specifically.</p>
      </remarks>
      <model>
         <choice>
            <field named="all"/>
            <fields named="call"/>
            <fields named="match"/>
         </choice>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 name="all"
                 as="empty">
      <flag datatype="NCName" name="with-subcontrols">
         <value>yes</value>
      </flag>
      <formal-name>Include all</formal-name>
      <description>Include all controls from the imported resource (catalog)</description>
      <remarks>
         <p>This element provides an alternative to calling controls and subcontrols individually from a catalog. But this is also the default behavior when no <code>include</code> element is given in an <code>import</code>; so ordinarily one might not see this element unless it is for purposes of including its <code>@with-subcontrols='yes'</code>
         </p>
      </remarks>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 name="call"
                 group-as="id-selectors"
                 as="empty">
      <flag datatype="NCName" name="control-id"/>
      <flag datatype="NCName" name="subcontrol-id"/>
      <flag datatype="NCName" name="with-control">
         <value>no</value>
         <value>yes</value>
      </flag>
      <flag datatype="NCName" name="with-subcontrols">
         <value>no</value>
         <value>yes</value>
      </flag>
      <formal-name>Call (control or subcontrol)</formal-name>
      <description>Call a control or subcontrol by its ID</description>
      <remarks>
         <p>Inside <code>include</code>, If <code>@control-id</code> is used (to indicate the control being referenced), <code>@subcontrol-id</code> cannot be used, and vice versa. (A single <code>call</code> element is used for each control.) This constraint is enforced by the schema. Likewise, <code>@with-subcontrols</code> can be used only along with <code>@control-id</code> not with <code>@subcontrol-id</code>.</p>
         <p>If <code>@with-subcontrols</code> is <q>yes</q> on the call to a control, no sibling <code>call</code>elements need to be used to call its subcontrols. Accordingly it may be more common to call subcontrols (enhancements) by ID only to exclude them, not to include them.</p>
      </remarks>
   </define-field>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 name="match"
                 group-as="pattern-selectors"
                 as="empty">
      <flag datatype="string" name="pattern"/>
      <flag datatype="NCName" name="order">
         <value>keep</value>
         <value>ascending</value>
         <value>descending</value>
      </flag>
      <flag datatype="NCName" name="with-control">
         <value>no</value>
         <value>yes</value>
      </flag>
      <flag datatype="NCName" name="with-subcontrols">
         <value>no</value>
         <value>yes</value>
      </flag>
      <formal-name>Match controls and subcontrols by identifier</formal-name>
      <description>Select controls by (regular expression) match on ID</description>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="exclude"
                    group-as="excludes">
      <formal-name>Exclude controls</formal-name>
      <description>Which controls and subcontrols to exclude from the resource (source catalog) being
          imported</description>
      <remarks>
         <p>Within <code>exclude</code>, <code>all</code> is not an option since it makes no sense. However, it also makes no sense to use exclude/call except with include/all; you would not want to include and exclude something by ID simultaneously. If this happens, an error condition will be reported.</p>
      </remarks>
      <model>
         <choice>
            <fields named="call"/>
            <fields named="match"/>
         </choice>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    group-as="param-settings"
                    name="set-param"
                    address="id">
      <flag datatype="ID" name="id" required="yes"/>
      <flag datatype="NMTOKENS" name="class"/>
      <flag datatype="IDREF" name="depends-on"/>
      <formal-name>Parameter Setting</formal-name>
      <description> A parameter setting, to be propagated to points of insertion
      </description>
      <model><!-- declarations tbf in the imported schema and to be aligned with it -->
         <field named="label"/>
         <fields named="desc"/>
         <fields named="constraint"/>
         <choice>
            <field named="value"/>
            <assembly named="select"/>
         </choice>
         <fields named="link"/>
         <assemblies named="part"/>
      </model>
   </define-assembly>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="alter"
                    group-as="alterations">
      <flag datatype="NCName" name="control-id"/>
      <flag datatype="NCName" name="subcontrol-id"/>
      <formal-name>Alteration</formal-name>
      <description>An Alter element specifies changes to be made to an included control or subcontrol when a profile is resolved.</description>
      <remarks>
         <p>Use <code>@control-id</code> or <code>@subcontrol-id</code> to indicate the scope of alteration.</p>
         <p>It is an error for two <code>alter</code> elements to apply to the same control or subcontrol. In practice, multiple alterations can be applied (together), but it creates confusion.</p>
         <p>At present, no provision is made for altering many controls at once (for example, to systematically remove properties or add global properties); extending this element to match multiple control IDs could provide for this.</p>
      </remarks>
      <model>
         <fields named="remove"/>
         <assemblies named="add"/>
      </model>
   </define-assembly>
   <define-field module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                 as="empty"
                 name="remove"
                 group-as="removals">
      <flag datatype="NMTOKENS" name="class-ref"/>
      <flag datatype="NCName" name="id-ref"/>
      <flag datatype="NMTOKENS" name="item-name"/>
      <formal-name>Removal</formal-name>
      <description>Specifies elements to be removed from a control or subcontrol, in resolution</description>
      <remarks>
         <p>Use <code>@class-ref</code>, <code>@id-ref</code> or <code>@item-name</code> to indicate class tokens or ID reference, or the formal name, of the component to be removed or erased from a control or subcontrol, when a catalog is resolved. The control or subcontrol affected is indicated by the pointer on the removal's parent (containing) <code>alter</code> element.</p>
         <p>To change an element, use <code>remove</code> to remove the element, then <code>add</code> to add it back again with changes.</p>
      </remarks>
   </define-field>
   <define-assembly module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                    name="add"
                    group-as="additions">
      <flag datatype="NCName" name="position">
         <value>before</value>
         <value>after</value>
         <value>starting</value>
         <value>ending</value>
      </flag>
      <formal-name>Addition</formal-name>
      <description>Specifies contents to be added into controls or subcontrols, in resolution</description>
      <model>
         <field named="title"/>
         <assemblies named="param" address="id"/>
         <fields named="prop"/>
         <fields named="link"/>
         <assemblies named="part"/>
         <assembly named="ref-list"/>
      </model>
   </define-assembly>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="control-id">
      <formal-name>Control ID</formal-name>
      <description>Value of the 'id' flag on a target control</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="with-control">
      <formal-name>Include control with subcontrol</formal-name>
      <description>Whether a control should be implicitly included, if not called.</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="with-subcontrols">
      <formal-name>Include subcontrols with control</formal-name>
      <description>Whether subcontrols should be implicitly included, if not called.</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="subcontrol-id">
      <formal-name>Control ID</formal-name>
      <description>Value of the 'id' flag on a target subcontrol</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="string"
                name="pattern">
      <formal-name>Pattern</formal-name>
      <description>A regular expression matching the IDs of one or more controls or subcontrols to be selected</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="order">
      <formal-name>Pattern</formal-name>
      <description>A regular expression matching the IDs of one or more controls or subcontrols to be selected</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="position">
      <formal-name>Position</formal-name>
      <description>Where to add the new content with respect to the targeted element (beside it or inside it)</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NMTOKENS"
                name="class-ref">
      <formal-name>References by class</formal-name>
      <description>Items to remove, by class</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NCName"
                name="id-ref">
      <formal-name>References by ID</formal-name>
      <description>Items to remove, by ID</description>
   </define-flag>
   <define-flag module="file:/mnt/c/Users/wap1/Documents/OSCAL/schema/metaschema/oscal-profile-metaschema.xml"
                datatype="NMTOKENS"
                name="item-name">
      <formal-name>References by name</formal-name>
      <description>Items to remove, by item type (name), e.g. title or prop</description>
   </define-flag>
</METASCHEMA>
