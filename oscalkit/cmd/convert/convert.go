// oscalkit - OSCAL conversion utility
// Written in 2017 by Andrew Weiss <andrew.weiss@docker.com>

// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.

// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

package convert

import (
	"github.com/urfave/cli"
)

var yaml bool

// Convert ...
var Convert = cli.Command{
	Name:  "convert",
	Usage: "convert between one or more OSCAL file formats and from OpenControl format",
	Subcommands: []cli.Command{
		ConvertOSCAL,
		ConvertOpenControl,
	},
}
