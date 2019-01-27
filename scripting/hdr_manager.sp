#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "HDR Manager",
	author = "KiD Fearless",
	description = "Adds convars to control env_tonemap_controller",
	version = "1.0",
	url = "http://steamcommunity.com/id/kidfearless"
}

#define MAXCONVARS 11
ConVar CreateTonemap;

ConVar EntityConVars[MAXCONVARS]

int env_tonemap_controller = -1;

public void OnPluginStart()
{
	HookEvent("round_start", OnRoundStartPost);
	CreateTonemap = CreateConVar("hdr_create_tonemap", "1", "Should an env_tonemap_controller be created if one isn't found", _, false, 0.0, true, 1.0);
	EntityConVars[0] = CreateConVar("SetTonemapScale", "1", "Sets the tonemap scale, it should be a value between 0 and 2, where 0 is the eyes fully closed, 1 is use the unchanged autoexposure (default), and 2 is the eye fully wide open. ", _, false, 0.0, false, 2.0);
	EntityConVars[1] = CreateConVar("BlendTonemapScale", "1", "lends from the player's current tonemap scale to a new one.", _, false, 0.0, false, 2.0);
	EntityConVars[2] = CreateConVar("SetAutoExposureMin", "1", "Sets a custom tonemap auto exposure minimum.", _, false, 0.0, false, 2.0);
	EntityConVars[3] = CreateConVar("SetAutoExposureMax", "1", "Sets a custom tonemap auto exposure maximum.", _, false, 0.0, false, 2.0);
	EntityConVars[4] = CreateConVar("SetBloomScale", "1", "Sets a custom bloom scale.", _, false, 0.0, false, 2.0);
	EntityConVars[5] = CreateConVar("SetTonemapRate", "1", "Sets the rate for autoexposure adjustment", _, false, 0.0, false, 2.0);
	EntityConVars[6] = CreateConVar("SetBloomExponent", "1", "Sets a custom bloom exponent.", _, false, 0.0, false, 2.0);
	EntityConVars[7] = CreateConVar("SetBloomSaturation", "1", "Sets a custom bloom saturation.", _, false, 0.0, false, 2.0);
	EntityConVars[8] = CreateConVar("SetTonemapPercentBrightPixels", "2", "Sets a target percentage of pixels to maintain above a certain brightness.", _, false, 0.0, false, 2.0);
	EntityConVars[9] = CreateConVar("SetTonemapPercentTarget", "45", "Sets the brightness that the percentage of pixels defined by SetTonemapPercentBrightPixels should be kept above.", _, false, 0.0, false, 2.0);
	EntityConVars[10] = CreateConVar("SetTonemapMinAvgLum", "3", "Sets custom tonemapping param", _, false, 0.0, false, 2.0);
	AutoExecConfig();

	EntityConVars[0].AddChangeHook(OnConVarChanged);
	EntityConVars[1].AddChangeHook(OnConVarChanged);
	EntityConVars[2].AddChangeHook(OnConVarChanged);
	EntityConVars[3].AddChangeHook(OnConVarChanged);
	EntityConVars[4].AddChangeHook(OnConVarChanged);
	EntityConVars[5].AddChangeHook(OnConVarChanged);
	EntityConVars[6].AddChangeHook(OnConVarChanged);
	EntityConVars[7].AddChangeHook(OnConVarChanged);
	EntityConVars[8].AddChangeHook(OnConVarChanged);
	EntityConVars[9].AddChangeHook(OnConVarChanged);
	EntityConVars[10].AddChangeHook(OnConVarChanged);
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if(env_tonemap_controller != -1)
	{
		if(convar.IntValue != -2)
		{
			char name[32];
			GetConVarName(convar, name, sizeof(name));
			SetVariantFloat(convar.FloatValue);
			AcceptEntityInput(env_tonemap_controller, name);
		}
	}
}

public void OnMapStart()
{
	env_tonemap_controller = FindEntityByClassname(MAXPLAYERS, "env_tonemap_controller");
	if(env_tonemap_controller == -1 && CreateTonemap.BoolValue)
	{
		env_tonemap_controller = CreateEntityByName("env_tonemap_controller");
	}
}

public void OnRoundStartPost(Event event, const char[] name, bool dontBroadcast)
{
	CreateTimer(1.0, Timer_OnRoundStartPost);
}

public Action Timer_OnRoundStartPost(Handle timer)
{
	if(env_tonemap_controller != -1)
	{
		for(int i = 0; i < MAXCONVARS; ++i)
		{
			if(EntityConVars[i].IntValue != -2)
			{
				char name[32];
				GetConVarName(EntityConVars[i], name, sizeof(name));
				SetVariantFloat(EntityConVars[i].FloatValue);
				AcceptEntityInput(env_tonemap_controller, name);
			}
		}
	}
	return Plugin_Handled;
}

