function TopNotification( msg ) {
  AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
  AddNotification(msg, $('#BottomNotifications'));
}

function TopRemoveNotification(msg){
  RemoveNotification(msg, $('#TopNotifications'));
}

function BottomRemoveNotification(msg){
  RemoveNotification(msg, $('#BottomNotifications'));
}


function RemoveNotification(msg, panel){
  var count = msg.count;
  if (count > 0 && panel.GetChildCount() > 0){
    var start = panel.GetChildCount() - count;
    if (start < 0)
      start = 0;

    for (i=start;i<panel.GetChildCount(); i++){
      var lastPanel = panel.GetChild(i);
      //lastPanel.SetAttributeInt("deleted", 1);
      lastPanel.deleted = true;
      lastPanel.DeleteAsync(0);
    }
  }
}

function AddNotification(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  //$.Msg(msg)

  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLine')
    lastNotification.hittest = false;
  }

  var notification = null;
  
  if (msg.hero != null)
    notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');
  else if (msg.image != null)
    notification = $.CreatePanel('Image', lastNotification, '');
  else if (msg.ability != null)
    notification = $.CreatePanel('DOTAAbilityImage', lastNotification, '');
  else if (msg.item != null)
    notification = $.CreatePanel('DOTAItemImage', lastNotification, '');
  else
    notification = $.CreatePanel('Label', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    //$.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      //$.Msg('callback')
      if (lastNotification.deleted)
        return;
      
      lastNotification.DeleteAsync(0);
    });
  }

  if (msg.hero != null){
    notification.heroimagestyle = msg.imagestyle || "icon";
    notification.heroname = msg.hero
    notification.hittest = false;
  } else if (msg.image != null){
    notification.SetImage(msg.image);
    notification.hittest = false;
  } else if (msg.ability != null){
    notification.abilityname = msg.ability
    notification.hittest = false;
  } else if (msg.item != null){
    notification.itemname = msg.item
    notification.hittest = false;
  } else{
    notification.html = true;
    var text = msg.text || "No Text provided";
    notification.text = $.Localize(text)
    notification.hittest = false;
    notification.AddClass('TitleText');
  }
  
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('NotificationMessage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}

function createPlayerPanel(event){
    var killsContainer = $("#player_kills_container");

    if($("#top_row")===null) {
    var top_row = $.CreatePanel( "Panel", killsContainer, "top_row");

    var name_label = $.CreatePanel( "Label", top_row, "top_name");
    name_label.text = $.Localize( "#player_name" );
    name_label.AddClass("player_names");

    var kills_label = $.CreatePanel( "Label", top_row, "top_creep_kills");
    kills_label.text = $.Localize( "#creep_kills" );
    kills_label.AddClass("player_kills");

    var wavekills_label = $.CreatePanel( "Label", top_row, "top_wave_kills" );
    wavekills_label.text = $.Localize( "#wave_kills" );
    wavekills_label.AddClass("player_wavekills");

    for (var key in Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS )){
      if ($("#player_id_"+key) === null){
        var parentPanel = $.CreatePanel( "Panel", killsContainer, "player_id_"+key);
        parentPanel.AddClass("player_row");

        var player_name_label = $.CreatePanel( "Label", parentPanel, "player_name_"+key );
        player_name_label.AddClass("player_names");

        var player_kills_label = $.CreatePanel( "Label", parentPanel, "creep_kills"+key );
        player_kills_label.AddClass("player_kills");

        var player_wavekills_label = $.CreatePanel( "Label", parentPanel, "wave_kills"+key );
        player_wavekills_label.AddClass("player_wavekills");

        player_name_label.text = Players.GetPlayerName(+key);
        var event = new Object();
        event.player_id = +key;
        GameEvents.SendCustomGameEventToServer("update_player_kills",event) ;
      }
    }
  }
  else{
      killsContainer.RemoveAndDeleteChildren();

  }
}

function updatePlayerPanel(event){
    if (event.creep_kills && $("#creep_kills"+event.player_id )!=null){
      var player_kills_label = $("#creep_kills"+event.player_id );
      player_kills_label.text = event.creep_kills;
    }
    else if (event.wave_kills && $("#wave_kills"+event.player_id )!= null){
      var player_kills_label = $("#wave_kills"+event.player_id );
      player_kills_label.text = event.wave_kills;
    }
  
}
function UpdateTimers(event){
    if (event.wave_time){
      var label = $("#WaveLabelBot");
      label.text = event.wave_time;
    }
    if (event.roshan_time){
      var label = $("#SpecialEventLabelBot");
      label.text = event.roshan_time;
    }
}
//=============================================================================
//==========================================================================
(function () {
  
  GameEvents.Subscribe( "create_player_panel", createPlayerPanel );
  GameEvents.Subscribe( "update_player_panel", updatePlayerPanel );
  GameEvents.Subscribe( "top_notification", TopNotification );
  GameEvents.Subscribe( "bottom_notification", BottomNotification );
  GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
  GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
  GameEvents.Subscribe( "update_timers", UpdateTimers );


})();


