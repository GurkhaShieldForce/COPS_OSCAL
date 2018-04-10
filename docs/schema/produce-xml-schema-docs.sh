# Invokes produce-schema-set.xpl to produce all three schema modules with injected docs

CALABASH=/home/wendell/xmlcalabash-1.1.20-98/xmlcalabash-1.1.20-98.jar

# Calls to Calabash for each of 'catalog', 'profile' and 'declarations'
CATALOG_DOCS="java -jar $CALABASH -i schema-docs=oscal-oscal.xml -o html-docs=__catalogXML.html -o markdown-docs=__catalogXML.md lib/produce-schema-module-docs.xpl module=catalog"
PROFILE_DOCS="java -jar $CALABASH -i schema-docs=oscal-oscal.xml -o html-docs=__profileXML.html -o markdown-docs=__profileXML.md lib/produce-schema-module-docs.xpl module=profile"
DECLARATIONS_DOCS="java -jar $CALABASH -i schema-docs=oscal-oscal.xml -o html-docs=__declarations-docs.html -o markdown-docs=__declarationsXML.md lib/produce-schema-module-docs.xpl module=declarations"

# Alternatively, a single call to a pipeline that writes all three, while producing only the Markdown results not the HTML
ALL_MD_DOCS="java -jar $CALABASH -i source=oscal-oscal.xml lib/produce-schema-docs-md.xpl"

# Now ...
echo
echo Processing schema documentation ...

# Go for it --
echo $ALL_MD_DOCS
$ALL_MD_DOCS
echo PRODUCED .md files

# echo $CATALOG_DOCS
# $CATALOG_DOCS
# echo PRODUCED catalog XML documentation

# echo $PROFILE_DOCS
# $PROFILE_DOCS
# echo PRODUCED profile XML documentation

# echo $DECLARATIONS_DOCS
# $DECLARATIONS_DOCS
# echo PRODUCED declarations XML documentation

