#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = 
{
	name = "[TF2] EquipWearable",
	author = "Powerlord",
	description = "Quick API for EquipWearable so I don't have to have this in every plugin involving wearables.",
	version = "1.0",
	url = "<- URL ->"
}

new Handle:hGameConf;
new Handle:hEquipWearable;
new Handle:hRemoveWearable;
new Handle:hIsWearable;

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	new EngineVersion:version = GetEngineVersion();
	
	if (version != Engine_TF2)
	{
		strcopy(error, err_max, "Only supported on TF2");
		return APLRes_Failure;
	}
	
	RegPluginLibrary("equipwearable");
	
	CreateNative("EquipPlayerWearable", Native_EquipWearable);
	CreateNative("RemovePlayerWearable", Native_RemoveWearable);
	CreateNative("IsWearable", Native_IsWearable);
	
	return APLRes_Success;
}

public OnPluginStart()
{
	hGameConf = LoadGameConfigFile("equipwearable");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameConf, SDKConf_Virtual, "EquipWearable");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	hEquipWearable = EndPrepSDKCall();
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameConf, SDKConf_Virtual, "RemoveWearable");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	hRemoveWearable = EndPrepSDKCall();
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hGameConf, SDKConf_Virtual, "IsWearable");
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
	hIsWearable = EndPrepSDKCall();
}

public Native_EquipWearable(Handle:plugin, numparams)
{
	new client = GetNativeCell(1);
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "Client %d is invalid", client);
		return;
	}
	
	new wearable = GetNativeCell(2);
	
	if (!Internal_IsWearable(wearable))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "%d is not a wearable", wearable);
	}
	
	SDKCall(hEquipWearable, client, wearable);
}

public Native_RemoveWearable(Handle:plugin, numparams)
{
	new client = GetNativeCell(1);
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "Client %d is invalid", client);
		return;
	}
	
	new wearable = GetNativeCell(2);

	if (!Internal_IsWearable(wearable))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "%d is not a wearable", wearable);
	}
	
	SDKCall(hRemoveWearable, client, wearable);
}

public Native_IsWearable(Handle:plugin, numparams)
{
	new entity = GetNativeCell(1);
	
	return Internal_IsWearable(entity);
}

bool:Internal_IsWearable(entity)
{
	if (entity <= MaxClients || !IsValidEntity(entity))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "%d is an invalid entity", entity);
	}
	
	return SDKCall(hIsWearable, entity);
}