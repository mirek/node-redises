module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        files:
          'lib/redises.js': 'src/redises.coffee'
          'lib/pool.js': 'src/pool.coffee'

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: [
            'coffee-script'
          ]
        src: ['spec/**/*.coffee']

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask "compile", ["coffee"]
  grunt.registerTask "default", ["compile"]
