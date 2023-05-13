ESX = exports.es_extended:getSharedObject()


-- NPC BIGLIETTARIO
Citizen.CreateThread(function()
    if not HasModelLoaded('a_m_y_business_02') then
       RequestModel('a_m_y_business_02')
       while not HasModelLoaded('a_m_y_business_02') do
          Citizen.Wait(5)
       end
    end

local npc = CreatePed(4, 'a_m_y_business_02', -273.5423, -321.8805, 17.2882, 90.3152, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)


local options = {
    {
        name = 'ox:train',
        event = 'WqlTrain:acquista',
        icon = 'fa-solid fa-money-bill',
        label = '💵 Acquista Ticket',
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end,
    }
}

exports.ox_target:addLocalEntity(npc,options)

end)

RegisterNetEvent('WqlTrain:acquista') 
AddEventHandler('WqlTrain:acquista', function()
    local Ped = PlayerPedId()
    local input = lib.inputDialog('BIGLIETTARIO', {
        {type = 'select', label = 'Vendita Ticket', options = {
            {label = "🎫 Ticket", value = "ticket"}
        }},
    })
    
    if input and #input > 0 then
        if lib.progressBar({
            duration = 1000,
            label = 'Pagamento in corso...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'mp_common',
                clip = 'givetake1_a'
            }
        }) then
            TriggerServerEvent('WqlTrain:acquista', input[1])
            ESX.ShowNotification('Hai acquistato un ticket. Dirigiti sotto per visionare le fermate disponibili...')
        end
    end
end)


-- NPC CONTROLLORE
Citizen.CreateThread(function()
    if not HasModelLoaded('ig_stevehains') then
       RequestModel('ig_stevehains')
       while not HasModelLoaded('ig_stevehains') do
          Citizen.Wait(5)
       end
    end

    local npc2 = CreatePed(4, 'ig_stevehains', -296.9654, -332.2035, 9.0631, 83.7511, false, true)
    FreezeEntityPosition(npc2, true)
    SetEntityInvincible(npc2, true)
    SetBlockingOfNonTemporaryEvents(npc2, true)

    local controllore = {
        {
            name = 'ox:controllore',
                onSelect = function()
                    local input = lib.inputDialog('CONTROLLORE', {
                        {type = 'select', label = '👷🏽 FERMATE DISPONIBILI 👷🏽', options = {
                            {label = "🚇 FERMATA 1 (CENTRO CITTA')", value = "1"},
                            {label = "🚇 FERMATA 2", value = "2"},
                            {label = "🚇 FERMATA 3", value = "3"},
                            {label = "🚇 FERMATA 4", value = "4"},
                            {label = "🚇 FERMATA 5", value = "5"},
                            {label = "🚇 FERMATA 6", value = "6"},
                            {label = "🚇 FERMATA 7", value = "7"},
                            {label = "🚇 FERMATA 8 (SOUTH SIDE)", value = "8"},
                            {label = "🚇 FERMATA 9 (AEROPORTO)", value = "9"},
                            {label = "🚇 FERMATA 10 (FUORI CITTA')", value = "10"},
                            {label = "🚇 FERMATA 11 (FUORI CITTA')", value = "11"},
                        }},
                    })
                    if exports.ox_inventory:Search("count", "ticket") <= 1 then ESX.ShowNotification('Non possiedi un ticket per poter prendere un treno!') return end
                    if input then
                        ESX.ShowNotification('Stai per dirigerti alla fermata '..input[1])
                        if lib.progressBar({
                            duration = 3000,
                            label = 'Stai per salire sul treno...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                            },
                        }) then
                            DoScreenFadeOut(800)
                            Wait(3000)
                            SetEntityCoords(PlayerPedId(), WQL.StazioneUno[tonumber(input[1])])
                            print(WQL.StazioneUno[tonumber(input[1])])
                            DoScreenFadeIn(800)
                            ESX.ShowNotification('Sei giunto alla prima fermata!')
                        end
                    end
                end,
            icon = 'fa-solid fa-train-subway',
            label = 'Seleziona Fermata',
            canInteract = function(entity, distance, coords, name, bone)
                return not IsEntityDead(entity)
            end
            
        }
    }

    exports.ox_target:addLocalEntity(npc2, controllore)

end)

-- BLIP BIGLIETTERIA
CreateThread(function()

    local WqualBiglietteria = AddBlipForCoord(-273.5423, -321.8807, 18.2882)
    SetBlipSprite(WqualBiglietteria, 525)
    SetBlipScale(WqualBiglietteria, 0.7)
    SetBlipColour(WqualBiglietteria, 13)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Biglietteria")
    EndTextCommandSetBlipName(WqualBiglietteria)
end)



-- BLIP FERMATE -- 
for i=1, #WQL.FermataBlip, 1 do

    local cfg = WQL.FermataBlip [i]

    local WqualFermata = AddBlipForCoord(cfg.coordinate)
    SetBlipSprite(WqualFermata, 36)
    SetBlipScale(WqualFermata, 0.8)
    SetBlipColour(WqualFermata, 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(cfg.nome)
    EndTextCommandSetBlipName(WqualFermata)

end