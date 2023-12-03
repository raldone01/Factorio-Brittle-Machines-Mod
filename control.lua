local fake_player = nil
local set_damage_cycle_threshold = 10 -- trigger damage n products_finished
local set_damage_amount = 1 -- do n damage to the machine

-- Function to damage a building
function damage_building(entity)
    if entity and entity.valid then
        local damage_amount = settings.global["brittle-machines-damage-amount-setting"].value
        --entity.damage(damage_amount, "neutral", nil)
        entity.damage(damage_amount, "neutral", "physical")
    end
end

-- TODO: check refinery, chemical plant, etc. for finished_products
-- TODO: check lab for finished_research
-- TODO: handle all CraftingMachine
-- TODO: remove dead entities from previous_finished_products
-- TODO: check if unit_number is unique across surfaces
-- TODO: check locale keys
-- TODO: Fix mod settings description

-- Function to check and update production cycles
function check_production_cycles(event)
    if previous_finished_products == nil then
        previous_finished_products = {}
    end
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered({type = {"assembling-machine", "lab"}})) do
            local unit_number = entity.unit_number
            local current_finished_products = entity.products_finished
            local previous_finished_products_unit = previous_finished_products[unit_number]
            if previous_finished_products_unit == nil then
                previous_finished_products_unit = 0
            end
            if current_finished_products ~= previous_finished_products_unit then
                log("unit_number: " .. unit_number .. " current_finished_products: " .. current_finished_products .. " previous_finished_products: " .. previous_finished_products_unit)
                previous_finished_products[unit_number] = current_finished_products
                if current_finished_products % set_damage_cycle_threshold == 0 then
                    damage_building(entity)
                end
            end
        end
    end
end

-- Event handler for production
script.on_event(defines.events.on_tick, check_production_cycles)

-- Load settings
script.on_init(function()
    log("on_init")
    previous_finished_products = {}
    fake_player = game.players["brittle-machines-fake-player"]
    set_damage_cycle_threshold = settings.global["brittle-machines-cycle-threshold-setting"].value
    set_damage_amount = settings.global["brittle-machines-damage-amount-setting"].value
end)
