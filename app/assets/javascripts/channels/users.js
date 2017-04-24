App.users = App.cable.subscriptions.create("UsersChannel", {
  received: function(data) {
    alert(data);
  }
});
