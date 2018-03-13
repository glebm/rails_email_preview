(() => {
  if (!(window.parent && window.parent.rep &&
          (new RegExp(document.querySelector('meta[name="rep-root-path"]').content)).test(parent.location.href))) return;
  document.querySelector('#cms-left').style.display = 'none';
  document.addEventListener('DOMContentLoaded', () => {
    // Hide nav
    document.querySelector('#cms-right').style.display = 'none';
    const main = document.querySelector('#cms-main');
    main.classList.remove('col-lg-8');
    main.classList.add('col-lg-12');

    // Replace header:
    const repData = document.querySelector('#rep-cms-integration-data').dataset;
    let showUrl = repData.showUrl;
    if (showUrl) {
      const parentParams = parent.location.search;
      if (!/\?/.test(showUrl)) showUrl += '?';
      showUrl = showUrl.replace(/\?.*$/, parentParams);
      main.querySelector('.page-header h2').innerHTML =
          `${repData.editEmailLabel} <a class='btn btn-link' href='${showUrl}'>${repData.viewLinkLabel}</a>`;
      main.querySelector('.form-actions a').href = showUrl;
    }

    const control = (name) => {
      const input = main.querySelector(`[name^="snippet[${name}]"]:not([type="hidden"])`);
      let parent = input.parentElement;
      while (!parent.classList.contains('form-group')) parent = parent.parentElement;
      return parent;
    };

    // Retext labels:
    control('label').querySelector('label').innerText = 'Subject';
    control('content').querySelector('label').innerText = 'Body';

    // Hide identifiers and categories:
    control('identifier').style.display = 'none';
    control('category_ids').style.display = 'none';

    // Do not mess with the identifier
    document.querySelector('[data-slug]').removeAttribute('data-slug');
  });
  window.parent.rep.fetchHeadersOnNextLoad = true;
  window.parent.rep.iframeOnDOMContentLoaded();
})();
