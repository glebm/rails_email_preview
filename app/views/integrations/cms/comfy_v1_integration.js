if (window.parent && window.parent.rep && (new RegExp(document.querySelector('meta[name="rep-root-path"]').content)).test(parent.location.href)) {
  jQuery(function($) {
    // Hide nav:
    $('.left-column,.right-column').hide();
    $('.center-column').css('margin', 0);
    $('#comfy').css('backgroundColor', 'white');

    // Replace header:
    const repData = document.querySelector('#rep-cms-integration-data').dataset;
    let showUrl = repData.showUrl;
    if (showUrl) {
      const parentParams = parent.location.search;
      if (!/\?/.test(showUrl)) showUrl += '?';
      showUrl = showUrl.replace(/\?.*$/, parentParams);
      document.querySelector('.page-header h2').innerHTML =
          `${repData.editEmailLabel} <a class='btn btn-link' href='${showUrl}'>${repData.viewLinkLabel}</a>`;
      document.querySelector('.form-actions a').href = showUrl;
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
