# setup_tracking
Setup a vrtracking pipeline

[![Build Status](https://travis-ci.org/sanger-pathogens/setup_tracking.svg?branch=master)](https://travis-ci.org/sanger-pathogens/setup_tracking)   
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-brightgreen.svg)](https://github.com/sanger-pathogens/setup_tracking/blob/master/GPL-LICENSE)   

## Contents
  * [Introduction](#introduction)
  * [Installation](#installation)
    * [Required dependencies](#required-dependencies)
    * [Running the tests](#running-the-tests)
  * [Usage](#usage)
  * [License](#license)
  * [Feedback/Issues](#feedbackissues)


## Introduction
setup_tracking is used to set up a new vrtrack pipeline. It creates a database and initally seeds it. It creates directories and config files and outputs a line to add to the crontab.

## Installation
setup_tracking has the following dependencies:

### Required dependencies
* [vr-codebase](https://github.com/sanger-pathogens/vr-codebase)

### Running the tests
The test can be run with dzil from the top level directory:

`dzil test`

## Usage
```
setup_tracking.pl -h

Usage: ./bin/setup_tracking.pl [options] short_name
  -d|pipeline_base_directory  <Base directory for pipeline defaults to /lustre/scratch118/infgen/pathogen/pathpipe>
  -c|config_base_directory    <Config file directory, defaults to /nfs/pathnfs01/conf>
  -l|log_base_directory       <Log file directory, defaults to /nfs/pathnfs01/log>
  -p|prefix                   <prefix of database name, defaults to pathogen>
  -s|suffix                   <suffix of database name, defaults to external>
  -e|environment              <production or test, defaults to production>
  -n|no_populate_assembly     <do not populate assembly table>
  -h|help                     <print this message>

Defaults should be find for pathogens, so typical usage is:
./bin/setup_tracking.pl abc
which creates a database called pathogen_abc_external,
config files in /nfs/pathnfs01/conf/pathogen_abc_external
and pipeline files in /lustre/scratch118/infgen/pathogen/pathpipe/pathogen_abc_external/seq-pipelines

Setup a new vrtrack pipeline. It creates a database, initally seeds it, creates directories, creates config files and outputs the line to add to the crontab.
```
## License
setup_tracking is free software, licensed under [GPLv3](https://github.com/sanger-pathogens/setup_tracking/blob/master/GPL-LICENSE).

## Feedback/Issues
Please report any issues to the [issues page](https://github.com/sanger-pathogens/setup_tracking/issues) or email path-help@sanger.ac.uk.
