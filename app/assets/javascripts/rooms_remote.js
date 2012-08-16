var process_json = function(data) {
  var data = data.categories;
  for (var key in data) {
    category = data[key];
    key = category.replace(" ", "_");
    var button = $('#' + key);
    if (button.length === 0) {
      create_button(key, category);
    }
  }
};

var create_button = function(key, name) {
  var container = $('<div id=\'' + key + '\' class=\'button_container\'></div>');
  container.append($('<span class=\'button_label\'>' + name + '</span>'));
  $('#categories_container').append(container);
  container.click(function() { vote(key); });
};

var vote = function(category) {
  $.ajax('/rooms/incr_category/',
    {
      type: 'PUT',
      data: { room: room_name, name: category }
    }
  );
};

var refresh = function() {
  $.getJSON('/rooms/get_categories',
    {
      name: room_name
    }, process_json
  );
};

$(document).ready(function() {
  refresh();
  setInterval(refresh, 5000);
});
