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
    $.getJSON('/rooms/get_categories_with_counts',
      {
        name: roomName
      }, updateCounts
    );
  };

  var intervalHandle = null;
  this.container = null;

  this.initialize = function(container) {
    this.container = container;
    pullCounts();
    intervalHandle = setInterval(pullCounts, 1000);
  };

  this.stop = function() {
    if (intervalHandle != null) {
      clearInterval(intervalHandle);
    }
  };

  return this;
};
