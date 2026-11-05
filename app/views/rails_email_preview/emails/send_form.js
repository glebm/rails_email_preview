(function (doc) {
  var form = doc.querySelector('.rep--send-to-form');
  form.addEventListener('submit', function (event) {
    if (!window.confirm(form.getAttribute('data-confirm-message'))) event.preventDefault();
  });
})(document);
