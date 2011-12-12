express = require 'express'
app = express.createServer()
fs = require 'fs'
xml2js = require 'xml2js'

parser = new xml2js.Parser()

filter = (title) ->
  regex = /:(sources|tests|javadoc)/
  not regex.exec(title)

class FeedItem
  constructor: (@id, @title, @date) ->

  addComment: (@comment) ->

parsed = []
xml = fs.readFileSync('data/recentlyDeployedReleaseArtifacts.xml').toString()
id = 0
parser.parseString xml, (err, result) ->
  for item in result.channel.item when filter(item.title)
    parsed.push new FeedItem(id, item.title, item['dc:date'])
    id += 1


publicDir = __dirname + '/public'
app.use express.static(publicDir)

app.use require('connect-assets')()

js('script')

app.listen 8090

io = require('socket.io').listen app

io.sockets.on 'connection', (socket) ->
  socket.emit 'init', parsed
  socket.on 'comment', (data) ->
    for item in parsed when item.id == data.id
      item.addComment data.comment
    socket.emit 'init', parsed

