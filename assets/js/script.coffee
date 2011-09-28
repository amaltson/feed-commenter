socket = io.connect 'http://localhost'
socket.on 'init', (data) ->
  console.log data
  for result in data
    # console.log title, time
    {title, date} = result
    $('#main').append("<div>Title: #{title} and Time: #{date}</div>")
# socket.emit 'my other event', { my: 'data' }
