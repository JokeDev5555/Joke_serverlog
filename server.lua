function sanitize(string)
    return string:gsub('%@', '')
end

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    sendToDiscord(sanitize(GetPlayerName(source)).." ได้ทำการเชื่อมต่อ server ", Config['senddc']['connecting'].color, source, Config['senddc']['connecting'].webhook)
end)

AddEventHandler('playerDropped', function(reason)
    sendToDiscord(sanitize(GetPlayerName(source)).." ได้ออกจาก server ".. reason .."", Config['senddc']['player_drop'].color, source, Config['senddc']['player_drop'].webhook)
end)

RegisterServerEvent('Joke_serverlog:senddiscord')
AddEventHandler('Joke_serverlog:senddiscord', function(text, color, src, discord_webhook)
    sendToDiscord(text, color, src, discord_webhook)
end)

function sendToDiscord(name, color, src, discord_webhook)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    local ids = ExtractIdentifiers(src)
    local connect = {
        {   
            ["username"] = "",
            ["avatar_url"] = "",
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = "Identifier:** ".. identifiers.steam .."**\nLink Steam: **https://steamcommunity.com/profiles/".. tonumber(ids.steam:gsub("steam:", ""),16) .."**\n Rockstar: **".. identifiers.license .."**\n Discord: <@".. ids.discord:gsub("discord:", "") .."> |  Discord ID: **".. identifiers.discord .."** \n IP Address: **".. GetPlayerEndpoint(src) .."**",
            ["footer"] = {
                ["text"] = "เวลา: ".. os.date ("%X") .." - ".. os.date ("%x") .." Backend Joke Sohandsome",
                ['icon_url'] = 'https://cdn.discordapp.com/attachments/952855787628269588/1065172474012106772/image.png',
            },
        }
    }
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end