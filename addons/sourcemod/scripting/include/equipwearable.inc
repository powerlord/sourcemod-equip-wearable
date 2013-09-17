#include <sourcemod>

native EquipPlayerWearable(client, wearable);

native RemovePlayerWearable(client, wearable);

native IsWearable(entity);

//native GetPlayerWearableSlot(client, entity);

public SharedPlugin:__pl_equipwearable =
{
	name = "equipwearable",
	file = "equipwearable.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

public __pl_equipwearable_SetNTVOptional()
{
	MarkNativeAsOptional("EquipPlayerWearable");
	//MarkNativeAsOptional("GetPlayerWearableSlot");
}