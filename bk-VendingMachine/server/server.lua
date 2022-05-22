ESX = nil

Discord = {}
Discord.Webhook = ""
Discord.Avatar = ""
Discord.Colour = 345001

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('bk-vending:buy', function(item, price, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = price
    local item = item
    local xItem = xPlayer.getInventoryItem(item)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, amount)
        SendLog('Nueva compra detectada', 'Identificador : '.. xPlayer.identifier .. '\n Nombre del jugador : ' ..xPlayer.name.. '\n Alerta : ha comprado ' .. amount .. ' de ' .. xItem.name .. ' por ' .. price .. '$')
    else
        print('No tienes dinero suficiente')
    end
end)

function SendLog(title, message) 
    local embedMsg = {}
    embedMsg = {
        {
            ["color"] = Discord.Colour,
            ["title"] = title,
            ["description"] =  ""..message.."",
            ["footer"] ={
                ["text"] = os.date("%c"),
            },
        }
    }
    PerformHttpRequest(Discord.Webhook, function(err, text, headers)end, 'POST', json.encode({username = "Machine Log", avatar_url= Discord.Avatar ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end