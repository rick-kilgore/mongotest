exec = require('child_process').exec

config =
    src: 'src/'
    output: 'build/lib/'

task 'build', "compile *.coffee into #{config.output}/*.js", ->
    console.log "running coffee..."
    exec "coffee -c -o #{config.output} #{config.src}", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
