'use strict'

fs = require 'fs'
path = require 'path'
{exec, spawn} = require 'child_process'

lrUtils = require 'grunt-contrib-livereload/lib/utils'


lrSnippet = lrUtils.livereloadSnippet

folderMount = (connect, point) ->
  return connect.static path.resolve(point)


module.exports = (grunt) ->

  conf =
    pkg: grunt.file.readJSON 'package.json'

    path:
      source: path.join 'app'
      intermediate: path.join '.intermediate'
      publish: path.join 'gh-pages'
      test: path.join 'test'

    ###*
    # Delete specified filess & directories
    # @property grunt-contrib-clean
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-clean#readme
    ###
    clean:
      options:
        force: true
      intermediate:
        src: '<%= path.intermediate %>'
      publish:
        src: '<%= path.publish %>'

    ###*
    # CoffeeScript
    # @property grunt-contrib-coffee
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-coffee#readme
    ###
    coffee:
      options:
        bare: true
      source:
        expand: true
        cwd: '<%= path.source %>/js'
        src: '**/*.coffee'
        dest: '<%= path.intermediate %>/js'
        ext: '.js'

    ###*
    # CoffeeScript Lint
    # @property grunt-coffeelint
    # @type Object
    # @url https://github.com/vojtajina/grunt-coffeelint#readme
    ###
    coffeelint:
       options:
        indentation: 2
        max_line_length: 80
        camel_case_classes: true
        no_trailing_semicolons:  true
        no_implicit_braces: true
        no_implicit_parens: false
        no_empty_param_list: true
        no_tabs: true
        no_trailing_whitespace: true
        no_plusplus: false
        no_throwing_strings: true
        no_backticks: true
        line_endings: true
        no_stand_alone_at: false
      source:
        src: [
          '<%= path.source %>/js/**/*.coffee'
          'Gruntfile.coffee'
        ]

    ###*
    # Connect & LiveReload static web server
    # @property grunt-contrib-connect
    # @property grunt-contrib-livereload
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-connect#readme
    # @url https://github.com/gruntjs/grunt-contrib-livereload#readme
    ###
    connect:
      intermediate:
        options:
          port: 50000
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, '.intermediate')]
      publish:
        options:
          port: 50001
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, 'gh-pages')]

    ###*
    # File copy
    # @property grunt-contrib-copy
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-copy#readme
    ###
    copy:
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*'
          '!**/*.coffee'
          '!**/*.jade'
          '!**/*.styl'
        ]
        dest: '<%= path.intermediate %>'
      intermediate:
        expand: true
        cwd: '<%= path.intermediate %>'
        src: [
          '**/*.html'
          'img/**/*'
        ]
        dest: '<%= path.publish %>'

    ###*
    # CSS Lint
    # @property grunt-css
    # @type Object
    # @url https://github.com/jzaefferer/grunt-css#readme
    ###
    csslint:
      intermediate:
        src: '<%= path.intermediate %>/css/**/*.css'

    ###*
    # CSSO
    # @property grunt-csso
    # @type Object
    # @url https://github.com/t32k/grunt-csso#readme
    ###
    csso:
      options:
        restructure: true
      publish:
        src: '<%= path.publish %>/css/app.css'
        dest: '<%= path.publish %>/css/app.min.css'

    ###*
    # HTML Lint
    # @property grunt-html
    # @type Object
    # @url https://github.com/jzaefferer/grunt-html#readme
    ###
    htmllint:
      intermediate:
        src: '<%= path.intermediate %>/**/*.html'

    ###*
    # Jade
    # @property grunt-contrib-jade
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-jade#readme
    ###
    jade:
      options:
        pretty: true
        data: grunt.file.readJSON 'package.json'
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: '**/!(_)*.jade'
        dest: '<%= path.intermediate %>'
        ext: '.html'

    ###*
    # JSHint
    # @property grunt-contrib-jshint
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-jshint#readme
    ###
    jshint:
      options:
        jshintrc: '.jshintrc'
      source:
        src: '<%= path.source %>/js/!(vendor)/*.js'

    ###*
    # JSON Lint
    # @property grunt-jsonlint
    # @type Object
    # @url https://github.com/brandonramirez/grunt-jsonlint#readme
    ###
    jsonlint:
      source:
        src: [
          '<%= path.source %>/**/*.json'
          'package.json'
        ]

    ###*
    # AssetGraph
    # @property grunt-reduce
    # @type Object
    # @url https://github.com/Munter/grunt-reduce#readme
    # @url https://github.com/One-com/assetgraph#readme
    # @url https://github.com/One-com/assetgraph-builder#readme
    # @url https://github.com/One-com/assetgraph-sprite#readme
    ###
    reduce:
      root: '<%= path.intermediate %>'
      outRoot: '<%= path.publish %>'
      less: false
      manifest: false
      pretty: true

    ###*
    # File change observer
    # @property grunt-regarde
    # @type Object
    # @url https://github.com/yeoman/grunt-regarde#readme
    ###
    regarde:
      source:
        files: '<%= path.source %>/**/*'
        tasks: [
          'default'
          #'build'
          'livereload'
        ]

    ###*
    # RequireJS
    # @property grunt-contrib-requirejs
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-requirejs#readme
    # @url https://github.com/jrburke/r.js/blob/master/build/example.build.js
    # @url https://github.com/jrburke/almond#readme
    ###
    requirejs:
      css:
        options:
          optimizeCss: 'standard.keepComments.keepLines'
          cssIn: '<%= path.intermediate %>/css/config.css'
          out: '<%= path.publish %>/css/app.css'
      js:
        options:
          mainConfigFile: '<%= path.intermediate %>/js/config.js'
          optimize: 'none'
          name: '../../vendor/js/almond-0.2.5'
          include: ['main']
          insertRequire: ['main']
          out: '<%= path.publish %>/js/app.js'
          wrap: true

    ###*
    # Mocha CLI test driver
    # @property grunt-simple-mocha
    # @type Object
    # @url https://github.com/yaymukund/grunt-simple-mocha#readme
    ###
    simplemocha:
      options:
        compilers: 'coffee:coffee-script'
        globals: []
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      test:
        src: '<%= path.test %>/**/*.coffee'

    ###*
    # Stylus
    # @property grunt-contrib-stylus
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-stylus#readme
    ###
    stylus:
      options:
        compress: false
      source:
        expand: true
        cwd: '<%= path.source %>/css'
        src: '**/!(_)*.styl'
        dest: '<%= path.intermediate %>/css'
        ext: '.css'

    ###*
    # UglifyJS
    # @property grunt-contrib-uglify
    # @type Object
    # @url https://github.com/gruntjs/grunt-contrib-uglify#readme
    ###
    uglify:
      options:
        preserveComments: false
      publish:
        src: '<%= path.publish %>/js/app.js'
        dest: '<%= path.publish %>/js/app.min.js'


  tasks =
    css: [
      'stylus'
      #'csslint'
      #'requirejs:css'
      #'csso'
    ]
    html: [
      'jade'
      #'htmllint'
    ]
    js: [
      'coffeelint'
      'jshint'
      #'simplemocha'
      'coffee'
      #'requirejs:js'
      #'uglify'
    ]
    json: [
      'jsonlint'
    ]
    watch: [
      'livereload-start'
      'connect'
      'regarde'
    ]
    build: [
      'clean:publish'
      'reduce'
    ]
    default: [
      'copy:source'
      'css'
      'html'
      'js'
      'json'
      'copy:intermediate'
    ]


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-css'
  grunt.loadNpmTasks 'grunt-csso'
  grunt.loadNpmTasks 'grunt-html'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-reduce'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.initConfig conf

  grunt.registerTask 'css', tasks.css
  grunt.registerTask 'html', tasks.html
  grunt.registerTask 'js', tasks.js
  grunt.registerTask 'json', tasks.json
  grunt.registerTask 'watch', tasks.watch
  grunt.registerTask 'build', tasks.build
  grunt.registerTask 'default', tasks.default
