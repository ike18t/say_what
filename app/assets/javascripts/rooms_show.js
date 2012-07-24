var process_json = function(data) {
  var data = data.categories;
  for (var key in data) {
    key = key.replace(" ", "_");
    var category = $('#' + key);
    if (category.length === 0) {
      category = create_meter(key);
    }
    var value = data[key];
    value = (value > 5 ? 5 : value) * 20;
    category.progressbar('option', 'value', value);
  }
};

var create_meter = function(key) {
  var container = $('<div class=\'category_container\'></div>');
  category = $('<div id=\'' + key + '\'></div>');
  container.append($('<span class=\'meter_label\'>' + key + '</span>')).append(category);
  $('#categories_container').append(container);
  category.progressbar({});
  return category;
};

var refresh = function() {
  $.getJSON('get_categories_with_counts',
    {
      name: room_name
    }, process_json
  );
};

$(document).ready(function() {
  refresh();
  setInterval(refresh, 1000);
});
