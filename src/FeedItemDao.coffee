mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

class FeedItemDao

  constructor: ->
    mongoose.connect 'mongodb://localhost/feedcommenter'
  
    FeedItem = new Schema
      id : ObjectId
      title : String
      date: Date
      comment: String

    FeedItemDao.Item = mongoose.model 'FeedItem', FeedItem

  save: (feeditem) ->
    feeditem.save (err) ->
      console.log "Error: " + err if err
      console.log 'Saved'

instance = new FeedItemDao.Item()
instance.title = 'hello'
instance.date = new Date 2011,00,01
instance.comment = 'This is an awesome comment'
instance.save (err) ->
  console.log "Error: " + err if err
  console.log 'Saved'

Item.find {}, (err, docs) ->
  console.log item for item in docs
