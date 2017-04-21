App.messages = App.cable.subscriptions.create("MessagesChannel", {
  received: function(data) {
    $("#room").append(JST["views/message"](data));
    $("[data-textfield='message']").val(null);
  }
});
