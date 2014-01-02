#include <sourcemod>

native EquipPlayerWearable(client, wearable);

native RemovePlayerWearable(client, wearable);

native IsWearable(entity);

//native GetPlayerWearableSlot(client, entity);

/**
 * Removes all weapons from a client's weapon slot
 *
 * @param client		Player's index.
 * @param slot			Slot index (0-5)
 * @noreturn
 * @error				Invalid client, invalid slot or lack of mod support
 */
stock TF2_RemoveWeaponSlotFix(client, slot)
{
	new weaponIndex;
	while ((weaponIndex = GetPlayerWeaponSlot(client, slot)) != -1)
	{
		new wearable = GetEntPropEnt(weaponIndex, Prop_Send, "m_hExtraWearable");
		if (wearable > MaxClients)
		{
			RemovePlayerWearable(client, wearable);
		}
		
		RemovePlayerItem(client, weaponIndex);
		AcceptEntityInput(weaponIndex, "Kill");
	}
}

/**
 * Removes all weapons from a client
 *
 * @param client		Player's index.
 * @noreturn
 */
stock TF2_RemoveAllWeaponsFix(client)
{
	for (new i = 0; i <= 5; i++)
	{
		TF2_RemoveWeaponSlotFix(client, i);
	}
}

/**
 * Removes all non-weapon Wearables from a client
 *
 * @param client		Player's index.
 * @noreturn
 */
stock TF2_RemoveAllWearables(client)
{
	new wearable = -1;
	while ((wearable = FindEntityByClassname(wearable, "tf_wearable*")) != -1)
	{
		if (IsValidEntity(wearable))
		{
			new player = GetEntPropEnt(wearable, Prop_Send, "m_hOwnerEntity");
			if (client == player)
			{
				RemovePlayerWearable(client, wearable);
				AcceptEntityInput(wearable, "Kill");
			}
		}
	}
}

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
	MarkNativeAsOptional("RemovePlayerWearable");
	MarkNativeAsOptional("IsWearable");
	//MarkNativeAsOptional("GetPlayerWearableSlot");
}