App.messages = App.cable.subscriptions.create("MessagesChannel", {
  received: function(data) {
    var room = $("#room");
    room.append(JST["views/message"](data));
    $("[data-textfield='message']").val(null);
    room[0].scrollTop = room[0].scrollHeight;
  }
});
