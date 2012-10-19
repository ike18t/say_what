var remote = function(roomName) {
  var remote = remote || {}

  var updateCategories = function(data) {
    $.each(data.categories, function(index, category) {
      var key = category.replace(" ", "_");
      if (!document.getElementById(key)) {
        createButton(key, category);
      }
    });
  };

  createButton = function(key, name) {
    var container = $('<div id=\'' + key + '\' class=\'button_container\'></div>');
    container.append($('<span class=\'button_label\'>' + name + '</span>'));
    container.click(remote.vote);
    $('#categories_container').append(container);
  };

  remote.vote = function() {
    $.ajax('/rooms/incr_category/',
      {
        type: 'PUT',
        data: { room: roomName, name: this.id }
      }
    );
  };

  pullCategories = function() {
    $.getJSON('/rooms/get_categories',
      {
        name: roomName
      }, updateCategories
    );
  };

  remote.initialize = function() {
    $(document).ready(function() {
      pullCategories();
      setInterval(pullCategories, 5000);
    });
  };

  return remote;
};
