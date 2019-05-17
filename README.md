# Open Security Controls Assessment Language (OSCAL)
[![CircleCI](https://circleci.com/gh/usnistgov/OSCAL/tree/master.svg?style=svg)](https://circleci.com/gh/usnistgov/OSCAL/tree/master)[![Gitter](https://img.shields.io/gitter/room/usnistgov-OSCAL/Lobby.svg?style=flat-square)](https://gitter.im/usnistgov-OSCAL/Lobby)

> Current work is happening in the [master](https://github.com/usnistgov/OSCAL/) branch.

NIST is developing the Open Security Controls Assessment Language (OSCAL), a set of hierarchical, formatted, XML- and JSON-based formats that provide a standardized representation for different categories of information pertaining to the publication, implementation, and assessment of security controls. OSCAL is being developed through a [collaborative approach](https://github.com/usnistgov/OSCAL/blob/master/CONTRIBUTING.md) with the public. Public contributions to this project are welcome.

With this effort, we are stressing the agile development of a *minimal* format that is both generic enough to capture the breadth of data in scope (controls specifications), while also capable of ad-hoc tuning and extension to support peculiarities of both (industry or sector) standard and new control types.

The [OSCAL website](https://pages.nist.gov/OSCAL/) provides an overview of the OSCAL project, including an XML and JSON [schema reference](https://pages.nist.gov/OSCAL/docs/schemas/), [examples](https://pages.nist.gov/OSCAL/resources/examples/), and other resources.

This repository consists of the following directories and files pertaining to the OSCAL project:

* [.github](.github): Contains GitHub issue and pull request templates for the OSCAL project.
* [content](content): Provides numerous OSCAL examples in both, XML and JSON formats. Some examples are considered provisional "completed" versions of OSCAL catalogs and profiles; they are not authoritative but are intended as demonstrations of OSCAL. Other examples are works in progress. Each subdirectory within the examples directory clearly indicates the current status of its example files.
* [json](json): Provides OSCAL JavaScript Object Notation (JSON) schemas and utilities that can be used to convert content in other OSCAL formats to OSCAL JSON-based formats.
* [xml](xml): Provides OSCAL Extensible Markup Language (XML) schemas and utilities that can be used to convert content in other OSCAL formats to OSCAL XML-based formats.
* [docs](docs): Stores sources for the [OSCAL website](https://pages.nist.gov/OSCAL).
* [build](build): Contains a collection of scripts, eXtensible Stylesheet Language Transformations (XSLTs), and other artifacts used to support this repository's continuous integration and continuous deployment (CI/CD) processes.
* [src](src): Stores source artifacts used to produce the content, JSON, and XML resources provided in this repository.
* [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): This file contains a code of conduct for OSCAL project contributors.
* [CONTRIBUTING.md](CONTRIBUTING.md): This file is for potential contributors to the OSCAL project. It provides basic information on the OSCAL project, describes the main ways people can make contributions, explains how to report issues with OSCAL, and lists pointers to additional sources of information. It also has instructions on establishing a development environment for contributing to the OSCAL project and using GitHub project cards to track development sprints.
* [LICENSE.md](LICENSE.md): This file contains license and copyright information for the files in the OSCAL GitHub repository.
* [USERS.md](USERS.md): This file explains which types of users are most likely to benefit from consuming available OSCAL tools and content.
