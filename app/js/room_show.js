var room = function(roomName) {
  var updateCounts = function(data) {
    $.each(data.categories, function(category, value) {
      var key = category.replace(' ', '_');
      var category = container.find('#' + key);
      if (category.length === 0) {
        category = createMeter(key);
      }
      value = (value > 5 ? 5 : value) * 20;
      category.progressbar('option', 'value', value);
    });
  };

  var createMeter = function(key) {
    var container = $('<div class=\'category_container\'></div>');
    category = $('<div id=\'' + key + '\'></div>');
    container.append($('<span class=\'meter_label\'>' + key + '</span>')).append(category);
    this.container.append(container);
    category.progressbar({});
    return category;
  };

  var pullCounts = function() {
    $.getJSON('/room/' + roomName + '/get_counts', {}, updateCounts);
  };

  this.container = null;

  this.initialize = function(container) {
    this.container = container;
    initializeWS();
  };

  var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
  var ws = new Socket("ws://localhost:8080");

  var initializeWS = function() {
    ws.onmessage = function(evt) {
      console.debug("Received: " + evt.data);
      updateCounts(JSON.parse(evt.data));
    };

    ws.onclose = function(event) {
      console.debug("Closed - code: " + event.code + ", reason: " + event.reason + ", wasClean: " + event.wasClean);
    };

    ws.onopen = function() {
      console.debug("connected...");
      ws.send("hello again");
    };
  }
  return this;
};
