socket = io.connect 'http://localhost'
socket.on 'init', (data) ->
  console.log data
  $('#main').children().remove()
  for artifact in data
    {id, title, date} = artifact
    $('#main').append("<div id=#{id}>Title: #{title} and Time: #{date}. Comment: <input id='comment#{id}' type='text' /></div>")
