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


publicDir = __dirname + '/public'
app.use express.static(publicDir)

app.use require('connect-assets')()

app.listen 8090

io = require('socket.io').listen app

io.sockets.on 'connection', (socket) ->
  socket.emit 'news', {hello: 'world' }
  socket.on 'my other event', (data) ->
    console.log data
