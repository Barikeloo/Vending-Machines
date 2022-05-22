ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local ShopOpened = false

CreateThread(function()
    while true do
        Wait(0)
        if not ShopOpened then 
            local ped = PlayerPedId()
            local Ppos = GetEntityCoords(ped)
            for k, v in pairs(CFG['PROP']) do 
                local prop = GetClosestObjectOfType(Ppos.x, Ppos.y, Ppos.z, 1.0, v, false, false, false)
                local propPos = GetEntityCoords(prop)
                local dist = GetDistanceBetweenCoords(Ppos.x, Ppos.y, Ppos.z, propPos.x, propPos.y, propPos.z, true)

                if dist <= 1.5 then 
                    ESX.ShowHelpNotification(CFG['TEXT'])
                    if IsControlJustPressed(0, 38) then 
                        OpenMachine()
                        ShopOpened = true
                    end
                else 
                    Wait(500)
                end
            end
        end
        Wait(1)
    end
end)

function OpenMachine() 
    local elements = {}
    for k, v in pairs(CFG['PRICES']) do 
        table.insert(elements,{label = v.emoji..v.label .. ' <font color=green>-</font> <font color=yellowgreen>'..'€'..v.price..'</font>', value = v.value, price = v.price})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "menu",
	{
		title    = "Máquina Expendedora",
		align    = 'center',
		elements = elements
	},
	function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialog', {
            title = '¿Cuántos deseas comprar?'
        }, function(data2, menu2)
            TriggerServerEvent('bk-vending:buy', data.current.value, data.current.price, tonumber(data2.value))
            menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)
    end,
    function(data, menu)
        menu.close()
        ShopOpened = false
	end, function(data, menu)
	end)
end