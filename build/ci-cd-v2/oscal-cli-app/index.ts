#!/usr/bin/env node
'use strict'

import { join } from 'path'
import yargs from 'yargs'

yargs
    .commandDir(join(__dirname, 'lib', 'commands'))
    .help()
    .argv;