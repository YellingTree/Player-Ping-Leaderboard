global function playerPingPreCache

//CHANGE SETTINGS HERE
struct{
	// Settings below to change the appearance of the display
	float size = 20 // UI element Size, basically it's bounding box kinda I think
	float verticalPos = 0.00 // Vertical Postion on-screen. 0.00 is max up, 1.00 is max down, default 0.00
	float horizPos = 0.68 // Horizontal position on-screen. 0.00 is max left, 1.00 is max right, default 0.68
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
    RuiDestroyIfAlive(playerPing)
    RuiDestroyIfAlive(playerName)
    RuiDestroyIfAlive(playerKD)
    if(settings.addBackground){
      if(background != null){
        RuiDestroyIfAlive(background)
      }
    }
  }
  if(script.show){
    thread playerNameDisplay()
    if(settings.addBackground){
      thread backgroundCreate()
    }
    EmitSoundOnEntity(player, "menu_click")
  }
}

void function backgroundCreate(){
  background = RuiCreate($"ui/scoreboard_background.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 10)
}

void function playerNameDisplay(){
  playerName = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 15)
		RuiSetInt(playerName, "lineNum", 1)
		RuiSetFloat2(playerName, "msgPos", <settings.horizPos, settings.verticalPos, 0.0>)
		RuiSetString(playerName, "msgText", "Name Display" )
		RuiSetFloat(playerName, "msgFontSize", settings.textSize)
    RuiSetFloat(playerName, "msgAlpha", settings.alpha)
		RuiSetFloat(playerName, "thicken", settings.boldVal)
		RuiSetFloat3(playerName, "msgColor", settings.color)
  
  thread playerKDs()
}

void function playerKDs(){
  playerKD = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 15)
		RuiSetInt(playerKD, "lineNum", 1)
		RuiSetFloat2(playerKD, "msgPos", <settings.horizPos, settings.verticalPos, 0.0>)
		RuiSetString(playerKD, "msgText", "KD Display" )
		RuiSetFloat(playerKD, "msgFontSize", settings.textSize)
    RuiSetFloat(playerKD, "msgAlpha", settings.alpha)
		RuiSetFloat(playerKD, "thicken", settings.boldVal)
		RuiSetFloat3(playerKD, "msgColor", settings.color)
    
    thread playerPingDisplay()
}
void function playerPingDisplay(){
  playerPing = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 15)
		RuiSetInt(playerPing, "lineNum", 1)
		RuiSetFloat2(playerPing, "msgPos", <settings.horizPos, settings.verticalPos, 0.0>)
		RuiSetString(playerPing, "msgText", "Ping Display" )
		RuiSetFloat(playerPing, "msgFontSize", settings.textSize)
    RuiSetFloat(playerPing, "msgAlpha", settings.alpha)
		RuiSetFloat(playerPing, "thicken", settings.boldVal)
		RuiSetFloat3(playerPing, "msgColor", settings.color)
    thread playerPingBrain()
}

void function playerPingBrain(){
  string nameString = ""
  string kdString = ""
  string pingString = ""
	entity localplayer = GetLocalClientPlayer()
	string localname = localplayer.GetPlayerName()
  int nameLength = 0

  float kdPos = 0
  float pingPos = 0

  	while(script.show){
       if(!IsLobby() && !IsMenuLevel()){
          WaitFrame()
           foreach(entity player in GetPlayerArray()){
						 string userName = ""
						 if(player.GetPlayerName() == localname){
							 userName = "(You)" + player.GetPlayerName()
						 }
						 else{
							 userName = player.GetPlayerName()
						 }
             int playerPing = player.GetPlayerGameStat( PGS_PING )
						 int playerKills = player.GetPlayerGameStat( PGS_KILLS )
						 int playerDeaths = player.GetPlayerGameStat( PGS_DEATHS )
						 string sep = "-----------------------------------------------------------------\n"
            
            string converter = "0." + nameLength.tostring()
            float converter2 = converter.tofloat()
            
            kdPos = settings.horizPos + 0.15
            //settings.horizPos + (converter2 - 15)
            pingPos = kdPos + 0.10
            //kdPos + 0.08
          
             nameString = nameString + "| " + userName + "\n" + sep
             kdString = kdString + "K/D: " + playerKills + "/" + playerDeaths + "\n\n"
             pingString = pingString + "Ping: " + playerPing + "ms\n\n"
             
            }
          if(script.show){
            RuiSetString(playerName, "msgText", nameString)
            RuiSetString(playerKD, "msgText", kdString)
            RuiSetString(playerPing, "msgText", pingString)
            
            

            RuiSetFloat2(playerKD, "msgPos", <kdPos, settings.verticalPos, 0.0>)
            RuiSetFloat2(playerPing, "msgPos", <pingPos, settings.verticalPos, 0.0>)
            
            nameString = ""
            kdString = ""
            pingString = ""

            


            }

  	   }
    }
}
