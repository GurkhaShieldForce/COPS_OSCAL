// oscalkit - OSCAL conversion utility
// Written in 2017 by Andrew Weiss <andrew.weiss@docker.com>

// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.

// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

package core

import (
	"encoding/json"
	"encoding/xml"
	"fmt"

	yaml "gopkg.in/yaml.v2"
)

// Framework ...
type Framework struct {
	XMLName       xml.Name               `xml:"http://csrc.nist.gov/ns/oscal/1.0 framework" json:"-" yaml:"-"`
	OptionalClass string                 `xml:"class,attr,omitempty" json:"class,omitempty" yaml:"class,omitempty"`
	ID            string                 `xml:"id,attr,omitempty" json:"id,omitempty" yaml:"id,omitempty"`
	Title         string                 `xml:"title" json:"title" yaml:"title"`
	Declarations  *FrameworkDeclarations `xml:"declarations,omitempty" json:"declarations,omitempty" yaml:"declarations,omitempty"`
	Sections      []Section              `xml:"section,omitempty" json:"sections,omitempty" yaml:"sections,omitempty"`
	Categories    []Category             `xml:"group,omitempty" json:"groups,omitempty" yaml:"groups,omitempty"`
	Items         []Item                 `xml:"component,omitempty" json:"components,omitempty" yaml:"components,omitempty"`
	References    *References            `xml:"references,omitempty" json:"references,omitempty" yaml:"references,omitempty"`
}

// FrameworkDeclarations ...
type FrameworkDeclarations struct {
	Href         string
	Declarations *Declarations
}

// MarshalJSON ...
func (f *FrameworkDeclarations) MarshalJSON() ([]byte, error) {
	if f.Href != "" {
		return json.Marshal(f.Href)
	}

	return json.Marshal(f)
}

// MarshalYAML ...
func (f *FrameworkDeclarations) MarshalYAML() (interface{}, error) {
	if f.Href != "" {
		return f.Href, nil
	}

	return *f, nil
}

// Component ...
func (f *Framework) Component() string {
	return "framework"
}

// Raw ...
func (f *Framework) Raw(format string, prettify bool) ([]byte, error) {
	switch format {
	case "json":
		if prettify {
			return json.MarshalIndent(f, "", "  ")
		}
		return json.Marshal(f)

	case "yaml", "yml":
		return yaml.Marshal(f)

	case "xml":
		return nil, nil
	}

	return nil, fmt.Errorf("Unknown format: %s", format)
}

// Type ...
func (f *Framework) Type() interface{} {
	return f
}
