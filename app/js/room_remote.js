var remote = function(roomName) {
  var updateCategories = function(data) {
    $.each(data.categories, function(index, category) {
      var key = category.replace(' ', '_');
      if (!document.getElementById(key)) {
        createButton(key, category);
      }
    });
  };

  var createButton = function(key, name) {
    var container = $('<div id=\'' + key + '\' class=\'button_container\'></div>');
    container.append($('<span class=\'button_label\'>' + name + '</span>'));
    container.click(vote);
    this.container.append(container);
  };

  var pullCategories = function() {
    $.getJSON('/room/' + roomName + '/get_categories', {}, updateCategories);
  };

  var vote = function() {
    $.ajax('/room/' + roomName + '/incr_category/' + this.id,
      {
        type: 'PUT',
      }
    );
  };

  var intervalHandle = null;
  this.container = null;

  this.initialize = function(container) {
    this.container = container;
    pullCategories();
    //intervalHandle = setInterval(pullCategories, 5000);
  };

  this.stop = function() {
    if (intervalHandle != null) {
      clearInterval(intervalHandle);
    }
  };

  return this;
};
