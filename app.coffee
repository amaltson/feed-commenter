require.paths.unshift('./node_modules')

express = require 'express'
app = express.createServer()
fs = require 'fs'
parser = require 'libxml-to-js'

filter = (title) ->
  regex = /:(sources|tests|javadoc)/
  not regex.exec(title)

class FeedItem
  constructor: (@title, @date) ->

  addComment: (@comment) ->

results = []
xml = fs.readFileSync('data/recentlyDeployedReleaseArtifacts.xml').toString()
parser xml, '//item', (err, result) ->
  results.push new FeedItem(item.title, item['dc:date']) for item in result when filter(item.title)

app.get '/', (req, res) ->
  res.send results

app.listen 8090
