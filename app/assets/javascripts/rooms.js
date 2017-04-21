$(document).ready(function() {
  $("#message_content").keydown(function(event) {
    if (event.keyCode == 13) {
      $("[data-send='message']").click();
    };
  });
});
