// Switch background color for navbar
(function ($) {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

  $(".popover-dismiss").popover({
    trigger: "focus"
  });

  var navbarCollapse = function () {
    if ($(".navbar.fixed-top").length === 0) {
      return;
    }
    if ($(".navbar.fixed-top").offset().top > 0) {
      $(".navbar").addClass("navbar-scrolled");
    } else {
      $(".navbar").removeClass("navbar-scrolled");
    }
  };
  navbarCollapse();
  $(window).scroll(navbarCollapse);

})(jQuery);

// Smooth scrolling when clicking an anchor link
$('a[href^="#"]').click(function () {
  $('html, body').animate({
    scrollTop: $($(this).attr('href')).offset().top
  }, 500);
  return false;
});
