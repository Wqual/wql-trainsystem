RegisterServerEvent('WqlTrain:acquista')
AddEventHandler('WqlTrain:acquista', function(value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local prezzoTicket = 50 -- Prezzo ticket

    if value == 'ticket' then
        if xPlayer.getMoney() >= prezzoTicket then
            xPlayer.removeMoney(prezzoTicket)
            xPlayer.addInventoryItem('ticket', 1)
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'success', description = 'Hai comprato un ticket per: ' .. prezzoTicket .. '$'})
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'error', description = 'Non hai abbastanza soldi!'})
        end
    end
end)