"use strict"

load_grunt_tasks = require("load-grunt-tasks")

module.exports = ( grunt ) ->

  # auto load grunt contrib tasks from package.json
  load_grunt_tasks(grunt)

  grunt.initConfig
    clean: {
      build: {
        src: [
          'public/style/pkg-*.css',
          'public/script/pkg-*.js',
          'public/script/dotmpe/'
        ]
      }
    },

    watch:
      coffee:
        files: "src/node/*.coffee"
        tasks: [
          "coffee:lib"
          "exec:es2015_test"
          "mochaTest:test"
        ]

    coffee:
      lib:
        expand: true
        cwd: "#{__dirname}/src/"
        src: [
           "loci/*.coffee"
           "*.coffee"
        ],
        dest: "build/js/loci/src"
        ext: ".js"

      dev:
        expand: true
        cwd: "#{__dirname}/"
        src: [
           "bin/*.coffee"
           "src/**/*.coffee"
           "*.coffee"
           "test/mocha/*.coffee"
        ],
        dest: "build/js/loci-dev"
        ext: ".js"

      test:
        expand: true
        cwd: "#{__dirname}/"
        src: [
           "test/mocha/*.coffee"
        ],
        dest: "build/js/loci-test"
        ext: ".js"

    coffeelint:
      options:
        configFile: ".coffeelint.json"
      gruntfile: [ "Gruntfile.coffee" ]
      app: [
        "bin/*.coffee"
        "src/**/*.coffee"
        "test/**/*.coffee"
      ]

    yamllint:
      all: [
        "Sitefile.yaml"
        "package.yaml"
        "**/*.meta"
        'config/*.yaml'
        'src/**/*.meta'
        'src/**/*.metadata'
      ]

    mochaTest:
      test:
        options:
          reporter: "spec"
          require: "coffee-script/register"
          captureFile: "mocha.out"
          quiet: false
          clearRequireCache: false # do explicitly as needed
        src: ["test/mocha/*.coffee"]

    exec:
      services_json:
        cmd: "make services.json"

      check_version:
        cmd: "git-versioning check"

      spec_update:
        cmd: "sh ./tools/update-spec.sh"

      tasks_update:
        cmd: "sh ./tools/tasks.sh"

      deps_g:
        cmd: "make dep-g"

    pkg: grunt.file.readJSON "package.json"


  # Static analysis of source files
  grunt.registerTask "lint", [ "coffeelint", "yamllint" ]

  # Test both source and compiled JS lib
  grunt.registerTask "test", [ "mochaTest", "coffee:lib" ]

  # Project pre-commit
  grunt.registerTask "check", [ "exec:check_version", "lint" ]
  grunt.registerTask "default", [ "lint", "test" ]

  # Documentation artefacts, some intial publishing
  grunt.registerTask "build", [
    "coffee:lib"
    "exec:services_json"
    "exec:deps_g"
  ]

  # Looking for better build and module config
  grunt.registerTask "x-build", [
    "build"
    "exec:spec_update"
  ]

