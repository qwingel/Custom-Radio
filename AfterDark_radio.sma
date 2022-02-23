#include <amxmodx>
#include <amxmisc>
#include <reapi>

#define PLUGIN "Custom Radio"
#define VERSION "1.3"
#define AUTHOR "Antarktida"
#define gPrefix "^4[Radio]"
#define NumberOfSounds 7 // Type how many sounds do you want here 

new Float:g_flNextTime[33];
new bool:g_RadioEnabled[33] = { true };
new const RADIO_SOUND[NumberOfSounds][] ={
    //Type your sounds directory here
    //For example:
    //"radio/bhop01.wav",
}
public radioonoff(id){
    g_RadioEnabled[id] = !g_RadioEnabled[id];	
    client_print_color(id, print_team_blue, "%s ^1Radio is %s", gPrefix, g_RadioEnabled[id]?"on":"off");
}
public plugin_init(){
    register_plugin(PLUGIN, VERSION, AUTHOR);
    register_clcmd("radio1", "SoundMenu");
}
public client_connect(id){
    g_RadioEnabled[id] = true;
    g_flNextTime[id] = 0.0;
}
public plugin_precache()
{
	for (new i = 0; i < NumberOfSounds; ++i)
		precache_sound(RADIO_SOUND[i]);
}
public SoundMenu(id){
    if(is_user_alive(id)){
        new iMenu = menu_create("\wSounds", "Sounds_handler");
        menu_additem(iMenu, "Phrase1", "1", 0); // Type your phrases instead of "Phrase1"
        //For example:
        //menu_additem(iMenu, "Bunnyhop", "6", 0);
        /*
        This phrases will be displayed in the menu
        Add up to 10 lines
        */
        menu_setprop(iMenu, MPROP_EXIT, MEXIT_ALL);
        menu_display(id, iMenu, 0);
    }
    return PLUGIN_HANDLED;
}
public Sounds_handler(id, menu, item){
    if (item == MENU_EXIT)
    {
        menu_destroy(menu)
        return PLUGIN_HANDLED;
    }
    new s_Data[6], s_Name[64], i_Access, i_Callback;
    menu_item_getinfo(menu, item, i_Access, s_Data, charsmax(s_Data), s_Name, charsmax(s_Name), i_Callback);
    new i_Key = str_to_num(s_Data);
    if(g_flNextTime[id] > get_gametime()){
		client_print_color(id, print_team_blue,"%s ^1Между использованием фраз должно пройти 15 секунд", gPrefix);
		return PLUGIN_HANDLED;
    }
    else{
        switch(i_Key){
            case 1:{
                client_print_color(0, print_chat, "%s In chat ", gPrefix); 
                // Istead of "In chat" type your message.
                // This will be displayed in the chat 
            }
            //Example :
            case 2:{
                client_print_color(0, print_chat, "%s ^1We did it in 2012 ", gPrefix);
            } 
            case .../*to 9*/:{
            }
            case 0:{
                menu_destroy(menu)
            }
        }
    }
    if(i_Key >= 0 && i_Key <= 8){
		for(new i = 0; i < MaxClients; i++){
			if(is_user_connected(i) && g_RadioEnabled[i]){
					rh_emit_sound2(id, i, CHAN_VOICE, RADIO_SOUND[i_Key - 1], VOL_NORM, ATTN_NORM , 0, PITCH_NORM);
			}
		}
	}
    g_flNextTime[id] = get_gametime() + 15.0;
    menu_destroy(menu);
    return PLUGIN_HANDLED;
}
