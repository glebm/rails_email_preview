if (window.parent && window.parent.rep && (new RegExp(document.querySelector('meta[name="rep-root-path"]').content)).test(parent.location.href)) {
  jQuery(function($) {
    // Hide nav:
    $('.left-column,.right-column').hide();
    $('.center-column').css('margin', 0);
    $('#comfy').css('backgroundColor', 'white');

    var showUrl = '<%= show_url %>';

    if (showUrl) {
      var parentParams = parent.location.search;
      if (!/\?/.test(showUrl)) showUrl += '?';
      showUrl = showUrl.replace(/\?.*$/, parentParams);
      $('.page-header h2').html(
          "<%= t '.edit_email' %>" + " <a class='<%= RailsEmailPreview.style[:btn_default_class] %>' href='" + showUrl + "'><%= t '.view_link' %></a>");
    }

    // Snippet form:
    var control = function(name) {
      return $('[name^="snippet[' + name + ']"]').closest('.form-group,.control-group');
    };

    // retext labels
    control('label').find('.control-label').text("Subject");
    control('content').find('.control-label').text("Body");

    // hide identifier and categories
    control('identifier').hide();
    control('category_ids').hide();

    // Do not mess with identifier
    $('[data-slug]').removeAttr('data-slug');
  });

  // Schedule headers view refresh on next load
  jQuery(window).on('load', function() {
    setTimeout(function() {
      window.parent.rep.fetchHeadersOnNextLoad = true;
    })
  });
}
