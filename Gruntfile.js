'use strict';

module.exports = function(grunt) {

  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      client: {
        src: 'src/loci/client/**/*.js'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      }
    },

    coffeelint: {
      options: {
        configFile: '.coffeelint.json'
      },
      client: {
        src: 'src/loci/client/**/*.coffee'
      },
      src: [
        '*.coffee',
        'src/**/*.coffee',
        'public/client.coffee',
        'test/**/*.coffee'
      ]
    },

    yamllint: {
      all: {
        src: [
          'config/*.yaml',
          'src/**/*.meta',
          'src/**/*.metadata'
        ]
      }
    },

    clean: {
      build: {
        src: [
          'public/style/pkg-*.css',
          'public/script/pkg-*.js',
          'public/script/dotmpe/'
        ]
      }
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script/register',
          captureFile: 'mocha.out',
          quiet: false,
          clearRequireCache: false
        },
        src: ['test/mocha/*.coffee']
      }
    },

  });

  // auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt);

  grunt.registerTask('init', [
    'make:init-config'
  ]);

  grunt.registerTask('lint', [
    'coffeelint',
    'jshint',
    'yamllint'
  ]);

  grunt.registerTask('test', [
    'mochaTest'
  ]);

  grunt.registerTask('build-client', [
    //'make:build-client',
  ]);
  grunt.registerTask('client', [
    //'jshint:client',
    'coffeelint:client',
    'build-client'
  ]);
  grunt.registerTask('build', [
    'client'
  ]);

  // Default task.
  grunt.registerTask('default', [
    'lint',
    'test'
  ]);

};
