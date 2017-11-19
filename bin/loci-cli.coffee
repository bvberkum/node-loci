#!/usr/bin/env coffee
path = require 'path'
neodoc = require 'neodoc'
lib = require '../src/loci'
require '../src/strutil'


proc =
  noderoot: path.dirname __dirname
  scriptname: path.basename process.argv[1]

ctxp = {
  proc: {}
  config:
    engines: [
      'pug'
    ]
    views: './src/loci/view'
    verbose: false
    "show-stack-trace": true
    port: 7030
  cdn: require path.join proc.noderoot, 'cdn.json'
  deps: require path.join proc.noderoot, 'cdn-deps.json'
  package: require path.join proc.noderoot, 'package.json'
  packages:
    express: require path.join(
      proc.noderoot, 'node_modules', 'express', 'package.json' )
}

ctxp.proc[process.pid] = proc
base = lib.init ctxp


loci_cli = module.exports =
  base: base
  main: ( ctx ) ->
    opts = neodoc.run """

    Usage: loci [--version] [--help] [options]

    options:
      --quiet                  Be quiet.
      --verbose                .
      --host NAME              .
      --port NUM               .

    """, { optionsFirst: false, laxPlacement: true, smartOptions: true }
    lib.run_main ctx, opts

if proc.scriptname.startsWith 'loci'
  loci_cli.main base
else if proc.scriptname.startsWith 'grunt'
else
  lib.log "Invalid argument:", process.argv[2]
  process.exit(1)
