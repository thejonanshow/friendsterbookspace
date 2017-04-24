App.users = App.cable.subscriptions.create("UsersChannel", {
  received: function(data) {
    if(data.type == "audio"){
      $("body").prepend(JST["views/audio"](data));
      $("#" + data.id)[0].play();
    }
  }
});
