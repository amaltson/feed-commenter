require.paths.unshift('./node_modules')

express = require 'express'
app = express.createServer()
fs = require 'fs'
parser = require 'libxml-to-js'

filter = (title) ->
  regex = /:(sources|tests|javadoc)/
  not regex.exec(title)

results = []
xml = fs.readFileSync('data/recentlyDeployedReleaseArtifacts.xml').toString()
parser xml, '//item', (err, result) ->
  results.push item.title for item in result when filter(item.title)

app.get '/', (req, res) ->
  res.send results

app.listen 8090
