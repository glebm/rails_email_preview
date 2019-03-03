(function (doc) {
  var rep = window['rep'] || (window['rep'] = { resizeAttached: false });
  rep.loaded = false;

  function findIframe() {
    return doc.getElementById('rep-src-iframe');
  }

  function resizeIframe() {
    var el = findIframe();
    if (!el) {
      rep.loaded = false;
      return;
    }
    var iframeBody = el.contentWindow.document.body;
    if (iframeBody) {
      el.style.height = (getBodyHeight(iframeBody)) + "px";
    }
  }

  function getBodyHeight(body) {
    var boundingRect = body.getBoundingClientRect();
    var style = body.ownerDocument.defaultView.getComputedStyle(body);
    var marginY = parseInt(style['margin-bottom'], 10) +
        parseInt(style['margin-top'], 10);
    // There may be a horizontal scrollbar adding to the height.
    var scrollbarHeight = 17;
    return scrollbarHeight + marginY + Math.max(
        body.scrollHeight, body.offsetHeight, body.clientHeight,
        boundingRect.height + boundingRect.top) +
        // no idea why these 4px are needed:
        4;
  }

  function fetchHeaders() {
    var headersView = doc.getElementById('email-headers'),
        xhr = new XMLHttpRequest();
    xhr.open('GET', headersView.getAttribute('data-url'), true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.send(null);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        headersView.innerHTML = xhr.responseText;
      }
    }
  }

  // Called from the iframe via window.parent
  rep.iframeOnDOMContentLoaded = function () {
    rep.loaded = true;
    resizeIframe();
    // CMS refresh headers hook
    if (rep.fetchHeadersOnNextLoad) {
      rep.fetchHeadersOnNextLoad = false;
      fetchHeaders();
    }
  };

  // This is only called back once the iframe has finished loading everything, including images
  rep.iframeOnLoad = resizeIframe;

  // Resize on window resize
  if (!rep.resizeAttached) {
    window.addEventListener('resize', function () {
      if (rep.loaded) resizeIframe();
    }, true);
    rep.resizeAttached = true
  }

  // Only show progress bar after some time to avoid flashing
  setTimeout(function () {
    doc.getElementById('email-progress-bar').style.display = 'block';
  }, 350);

  findIframe().addEventListener('load', resizeIframe);
  resizeIframe();
})(document);
