$(function () {
  $('.custom-file-input').on('change', function () {
    var name = '';
    try {
      name = $(this)[0].files[0].name;
    } catch (e) {
    }
    $(this).next('.custom-file-label').text(name);
  })
});
