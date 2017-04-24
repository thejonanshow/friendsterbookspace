$(document).ready(function() {
  var messageForm = $("#message_content");
  var room = $("#room");
  var nav = $("#nav");
  var footer = $("#footer");

  messageForm.focus();

  messageForm.keydown(function(event) {
    if (event.keyCode == 13) {
      $("[data-send='message']").click();
    };
  });

  $("[data-send='message']").click(function(event) {
    resetRoomScroll();
  })

  var resetRoomHeight = function() {
    room.css("max-height", $(window).height() - nav.outerHeight() * 3 - footer.outerHeight());
  }

  resetRoomHeight();
  $(window).on('resize', function() {
    resetRoomScroll();
    resetRoomHeight();
  });

  var resetRoomScroll = function() {
    room[0].scrollTop = room[0].scrollHeight;
  };

  resetRoomScroll();
  messageForm.keyup(function(event) {
    if (event.keyCode == 13) {
      resetRoomScroll();
    };
  });
});
