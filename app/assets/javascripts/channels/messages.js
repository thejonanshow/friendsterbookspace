App.messages = App.cable.subscriptions.create("MessagesChannel", {
  received: function(data) {
    var room = $("#room");

    if (data.user_name == "Alexa") {
      room.append(JST["views/alexa_message"](data));
    } else {
      room.append(JST["views/message"](data));
    }

    $("[data-textfield='message']").val(null);
    room[0].scrollTop = room[0].scrollHeight;
  }
});
