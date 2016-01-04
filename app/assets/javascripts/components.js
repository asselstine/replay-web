$(document).ready(function () {

  $("[data-server-date]").each(function () {
    var _this = this;
    $(this).closest('form').on('submit',function (e) {
      // $(_this).val( ServerDate()
    });
  });

});
