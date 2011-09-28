require.paths.unshift('./node_modules')

express = require 'express'
app = express.createServer()
fs = require 'fs'
parser = require 'libxml-to-js'

filter = (title) ->
  regex = /:(sources|tests|javadoc)/
  not regex.exec(title)

class FeedItem
  constructor: (@id, @title, @date) ->

  addComment: (@comment) ->

results = []
xml = fs.readFileSync('data/recentlyDeployedReleaseArtifacts.xml').toString()
id = 0
parser xml, '//item', (err, result) ->
  for item in result when filter(item.title)
    results.push new FeedItem(id, item.title, item['dc:date'])
    id += 1


publicDir = __dirname + '/public'
app.use express.static(publicDir)

app.use require('connect-assets')()

app.listen 8090

io = require('socket.io').listen app

io.sockets.on 'connection', (socket) ->
  socket.emit 'init', results
  socket.on 'comment', (data) ->
    for item in results when item.id == data.id
      item.addComment data.comment
    socket.emit 'init', results
