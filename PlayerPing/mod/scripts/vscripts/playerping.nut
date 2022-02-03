global function playerPingPreCache

//CHANGE SETTINGS HERE
struct{
	// Settings below to change the appearance of the display
	float size = 20 // UI element Size, basically it's bounding box kinda I think
	vector color = Vector(1.0, 1.0, 1.0) //color of on-screen display, standard rgb values. Supported Range 0.00 to 1.00. For easy conversion of standard rgb values that look like 255,255,255 (white) lookup a rgb value to percentage converter. 1.00 would be considered 100% 0.50 for 50%, etc..
	float alpha = 0.6 // this is the opacity of the on-screen display, 1.00 is solid, 0.00 would be completely see through and such will be invisible.
	float textSize = 19 // value for font size, 19 is default
	float boldVal = 0.0 // How thick or bold the text appears, default: 0.0
  bool addBackground = true // toggle for adding background, it's a little scuffed atm but improves readability
} settings


//No touchy tho feel free to use anything you find useful
struct{
  bool show = false
  bool adjusted = false
}script

var playerPing = null
var playerName = null
var playerKD = null
var background = null

var friendlyHeader = null
var friendlyTeamMates = null
var friendlyKD = null
var friendlyPing = null

var enemyHeader = null
var enemyTeam = null
var enemyKD = null
var enemyPing = null
float shifter = 0
float horzShifter = 0

void function playerPingPreCache(){
	thread menusTread()
}

void function menusTread(){
	WaitFrame()
	int noConsoleSpam = 0
  	while(IsLobby() && IsMenuLevel()){
  		if(noConsoleSpam <= 0 ){
  		    print("<##############>Ping Display is waiting for a game<##############>")
  		    noConsoleSpam = 2
  	     }
  		else
  		WaitForever()
  	}
	thread displayPings()
}

void function displayPings(){
  RegisterButtonPressedCallback(KEY_F1, displayOn)
}

void function displayOn(var button){
  entity player = GetLocalClientPlayer()
  script.show = !script.show
  if(!script.show){
    RuiDestroyIfAlive(friendlyHeader)
    RuiDestroyIfAlive(friendlyTeamMates)
    RuiDestroyIfAlive(friendlyKD)
    RuiDestroyIfAlive(friendlyPing)
    RuiDestroyIfAlive(enemyHeader)
    RuiDestroyIfAlive(enemyTeam)
    RuiDestroyIfAlive(enemyKD)
    RuiDestroyIfAlive(enemyPing)
    if(settings.addBackground){
      if(background != null){
        RuiDestroyIfAlive(background)
      }
    }
  }
  if(script.show){
    thread friendlyTeamDisplay()
    thread enemyTeamDisplay()
    if(settings.addBackground){
      thread backgroundCreate()
    }
    EmitSoundOnEntity(player, "menu_click")
    thread playerPingBrain()
  }
}

void function backgroundCreate(){
  background = RuiCreate($"ui/scoreboard_background.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 10)
}
struct{
float vertPos = 0.50
}overlay
void function friendlyTeamDisplay(){
  friendlyHeader = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 15)
		RuiSetInt(friendlyHeader, "lineNum", 1)
		RuiSetFloat2(friendlyHeader, "msgPos", <0.68, 0.0, 0.0>)
		RuiSetString(friendlyHeader, "msgText", "Your Team \n---------------------------------------------------" )
		RuiSetFloat(friendlyHeader, "msgFontSize", 21)
    RuiSetFloat(friendlyHeader, "msgAlpha", settings.alpha)
		RuiSetFloat(friendlyHeader, "thicken", settings.boldVal)
		RuiSetFloat3(friendlyHeader, "msgColor", settings.color)

  friendlyTeamMates = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 15)
		RuiSetInt(friendlyTeamMates, "lineNum", 1)
		RuiSetFloat2(friendlyTeamMates, "msgPos", <0.68, 0.04, 0.0>)
		RuiSetString(friendlyTeamMates, "msgText", "Name Display" )
		RuiSetFloat(friendlyTeamMates, "msgFontSize", settings.textSize)
    RuiSetFloat(friendlyTeamMates, "msgAlpha", settings.alpha)
		RuiSetFloat(friendlyTeamMates, "thicken", settings.boldVal)
		RuiSetFloat3(friendlyTeamMates, "msgColor", settings.color)

  friendlyKD = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 15)
		RuiSetInt(friendlyKD, "lineNum", 1)
		RuiSetFloat2(friendlyKD, "msgPos", <0.83, 0.04, 0.0>)
		RuiSetString(friendlyKD, "msgText", "fKD Display" )
		RuiSetFloat(friendlyKD, "msgFontSize", settings.textSize)
    RuiSetFloat(friendlyKD, "msgAlpha", settings.alpha)
		RuiSetFloat(friendlyKD, "thicken", settings.boldVal)
		RuiSetFloat3(friendlyKD, "msgColor", settings.color)

  friendlyPing = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 15)
		RuiSetInt(friendlyPing, "lineNum", 1)
		RuiSetFloat2(friendlyPing, "msgPos", <0.93, 0.04, 0.0>)
		RuiSetString(friendlyPing, "msgText", "fPing Display" )
		RuiSetFloat(friendlyPing, "msgFontSize", settings.textSize)
    RuiSetFloat(friendlyPing, "msgAlpha", settings.alpha)
		RuiSetFloat(friendlyPing, "thicken", settings.boldVal)
		RuiSetFloat3(friendlyPing, "msgColor", settings.color)
}
void function enemyTeamDisplay(){
  shifter = 0
  enemyHeader = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 15)
		RuiSetInt(enemyHeader, "lineNum", 1)
		RuiSetFloat2(enemyHeader, "msgPos", <0.68, overlay.vertPos, 0.0>)
		RuiSetString(enemyHeader, "msgText", "Enemy Team \n--------------------------------------------------------" )
		RuiSetFloat(enemyHeader, "msgFontSize", settings.textSize)
    RuiSetFloat(enemyHeader, "msgAlpha", settings.alpha)
		RuiSetFloat(enemyHeader, "thicken", settings.boldVal)
		RuiSetFloat3(enemyHeader, "msgColor", settings.color)
    
    shifter = overlay.vertPos + 0.04
 
  enemyTeam = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 20)
		RuiSetInt(enemyTeam, "lineNum", 1)
		RuiSetFloat2(enemyTeam, "msgPos", <0.68, shifter, 0.0>)
		RuiSetString(enemyTeam, "msgText", "eName Display" )
		RuiSetFloat(enemyTeam, "msgFontSize", settings.textSize)
    RuiSetFloat(enemyTeam, "msgAlpha", settings.alpha)
		RuiSetFloat(enemyTeam, "thicken", settings.boldVal)
		RuiSetFloat3(enemyTeam, "msgColor", settings.color)
  
  enemyKD = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 20)
		RuiSetInt(enemyKD, "lineNum", 1)
		RuiSetFloat2(enemyKD, "msgPos", <0.83, shifter, 0.0>)
		RuiSetString(enemyKD, "msgText", "Name Display" )
		RuiSetFloat(enemyKD, "msgFontSize", settings.textSize)
    RuiSetFloat(enemyKD, "msgAlpha", settings.alpha)
		RuiSetFloat(enemyKD, "thicken", settings.boldVal)
		RuiSetFloat3(enemyKD, "msgColor", settings.color)
  
  enemyPing = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 20)
		RuiSetInt(enemyPing, "lineNum", 1)
		RuiSetFloat2(enemyPing, "msgPos", <0.93, shifter, 0.0>)
		RuiSetString(enemyPing, "msgText", "Name Display" )
		RuiSetFloat(enemyPing, "msgFontSize", settings.textSize)
    RuiSetFloat(enemyPing, "msgAlpha", settings.alpha)
		RuiSetFloat(enemyPing, "thicken", settings.boldVal)
		RuiSetFloat3(enemyPing, "msgColor", settings.color)
  
}

// Updates the leaderboard overlay
void function playerPingBrain(){
  var clientTeam = GetLocalClientPlayer().GetTeam()
  string friendlyNameString = ""
  string friendlyKdString = ""
  string friendlyPingString = ""

  string enemyNameString = ""
  string enemyKdString = ""
  string enemyPingString = ""
  overlay.vertPos = 0.50

  // For setting (You) to the correct player
	entity localplayer = GetLocalClientPlayer()
	string localname = localplayer.GetPlayerName()
  string sep = "--------------------------------------------------------\n"
    //Avoids script attempting to set Ruis if destroyed.
  	while(script.show){
       if(!IsLobby() && !IsMenuLevel()){
          WaitFrame()
          //Gathering player's game info
          int counter = 0
          foreach(entity player in GetPlayerArray()){
            string fUserName = ""
            if(player.GetTeam() == clientTeam ){
              if(player.GetPlayerName() == localname){
                fUserName = "(You)" + player.GetPlayerName()
              }
              else{
                fUserName = player.GetPlayerName()
              }
              int fPing = player.GetPlayerGameStat( PGS_PING )
              int fKills = player.GetPlayerGameStat ( PGS_KILLS )
              int fDeaths = player.GetPlayerGameStat ( PGS_DEATHS )

              counter ++
              if(counter < 2){
                overlay.vertPos = 0.15
              }
              if(counter > 2){
                overlay.vertPos = 0.50
              }
              if(counter > 15){
                overlay.vertPos = 0.70
              }
              

              friendlyNameString = friendlyNameString + "|" + fUserName + "\n\n" //+ sep
              friendlyKdString = friendlyKdString + "K/D: " + fKills + "/" + fDeaths + "\n\n"
              friendlyPingString = friendlyPingString + fPing + "ms\n\n"
            }
            string eUserName = ""
            if(player.GetTeam() != clientTeam){
              int ePing = player.GetPlayerGameStat( PGS_PING )
              int eKills = player.GetPlayerGameStat( PGS_KILLS )
              int eDeaths = player.GetPlayerGameStat( PGS_DEATHS )
              eUserName = player.GetPlayerName()
              

              enemyNameString = enemyNameString + "|" + eUserName + "\n\n" //+ sep
              enemyKdString = enemyKdString + "K/D: " + eKills + "/" + eDeaths + "\n\n"
              enemyPingString = enemyPingString + ePing + "ms\n\n"
            }

          }
          if(script.show){
            RuiSetString(friendlyTeamMates, "msgText", friendlyNameString)
            RuiSetString(friendlyKD, "msgText", friendlyKdString)
            RuiSetString(friendlyPing, "msgText", friendlyPingString)

            RuiSetString(enemyTeam, "msgText", enemyNameString)
            RuiSetString(enemyKD, "msgText", enemyKdString)
            RuiSetString(enemyPing, "msgText", enemyPingString)
            
          }
          friendlyNameString = ""
          friendlyKdString = ""
          friendlyPingString = ""
          counter = 0
          enemyNameString = ""
          enemyKdString = ""
          enemyPingString = ""
       }
    }
}


