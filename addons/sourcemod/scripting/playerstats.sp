#include <sourcemod>
#include <vip_core>
#include <store>
#include <geoip>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "Player Stats",
    author      = "kraier",
    description = "!stats <player-name>",
    version     = "1.0.0",
    url         = ""
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_stats", Command_Stats);
}

public Action Command_Stats(int client, int args)
{
    if (args != 1)
    {
        ReplyToCommand(client, "SYNTAX: /stats <playername>");
        return Plugin_Handled;
    }

    int Target = 0;

    if(Target == -1)
        return Plugin_Handled;
    
    char TargetName[32], iTarget[64], authid[64], ip[64], Country[64];

    GetCmdArg(1, iTarget, sizeof(iTarget));

    Target = FindTarget(client, iTarget, false, false);

    GetClientName(Target, TargetName, sizeof(TargetName));

    GetClientAuthId(Target, AuthId_Steam2, authid, sizeof(authid));

    GetClientIP(Target, ip, sizeof(ip), true);

    GeoipCountry(ip, Country, sizeof(Country));

    int pCredits = Store_GetClientCredits(Target);

    if(IsClientValid(Target))
    {
        if(GetUserAdmin(client) != INVALID_ADMIN_ID)
        {
            PrintToChat(client, " \x08——————————\x04« \x05Player-Stats \x04»\x08——————————");
            PrintToChat(client, " \x04[›]\x08 Name:\x04 %s", TargetName);
            PrintToChat(client, " \x04[›]\x08 STEAMID:\x04 %s", authid);
            PrintToChat(client, " \x04[›]\x08 Credits:\x04 %d", pCredits);
            PrintToChat(client, " \x04[›]\x08 IP:\x04 %s", ip);
            PrintToChat(client, " \x04[›]\x08 Country:\x04 %s", Country);
            if(VIP_IsClientVIP(Target))
            {
                PrintToChat(client, " \x04[›]\x08 VIP Status:\x04 Yes");
            } else {
                PrintToChat(client, " \x04[›]\x08 VIP Status:\x07 No");
            }

            if(GetUserAdmin(Target) != INVALID_ADMIN_ID)
            {
                PrintToChat(client, " \x04[›]\x08 Admin Status:\x04 Yes");
            }
            else
            {
                PrintToChat(client, " \x04[›]\x08 Admin Status:\x07 No");
            } 
            PrintToChat(client, " \x08———————————————————————————————");
        }
        else
        {
            PrintToChat(client, " \x07You do not have access to this command!");
        }
    }

    return Plugin_Handled;
}

bool IsClientValid(int client)
{
    return (0 < client <= MaxClients) && IsClientInGame(client) && !IsFakeClient(client);
}