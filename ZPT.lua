_addon.name = 'ZNM Pop Tracker'
_addon.author = 'Radec'
_addon.commands = { 'zpt' }
_addon.version = '1'

require("tables")
config = require('config')

znm_mobs = T{
	["Vulpangue"] = 				{display_name="Vulpan",pop=2580,drop=2616,KI=998},
	["Chamrosh"] = 					{display_name="Chamro",pop=2581,drop=2617,KI=998},
	["Cheese Hoarder Gigiroon"] =	{display_name="Cheese",pop=2582,drop=2618,KI=998},
	["Brass Borer"] = 				{display_name=" Borer",pop=2590,drop=2626,KI=1004},
	["Claret"] = 					{display_name="Claret",pop=2591,drop=2627,KI=1004},
	["Ob"] =						{display_name="    Ob",pop=2592,drop=2628,KI=1004},
	["Velionis"] = 					{display_name=" Skele",pop=2600,drop=2636,KI=1010},
	["Lil' Apkallu"] = 				{display_name="Apkall",pop=2601,drop=2637,KI=1010},
	["Chigre"] =					{display_name="Chigre",pop=2602,drop=2638,KI=1010},

	["Iriz Ima"] = 					{display_name="  Iriz",pop=2577,drop=2613,KI=999},
	["Lividroot Amooshah"] =		{display_name="Morbol",pop=2578,drop=2614,KI=999},
	["Iriri Samariri"] = 			{display_name=" Iriri",pop=2579,drop=2615,KI=999},
	["Anantaboga"] = 				{display_name="Ananta",pop=2587,drop=2623,KI=1005},
	["Reacton"] = 					{display_name="Reacto",pop=2588,drop=2624,KI=1005},
	["Dextrose"] =					{display_name="Dextro",pop=2589,drop=2625,KI=1005},
	["Wulgaru"] =					{display_name="Wulgar",pop=2597,drop=2633,KI=1011},
	["Zareehkl the Jubilant"] = 	{display_name="Qutrub",pop=2598,drop=2634,KI=1011},
	["Verdelet"] = 					{display_name="Verdel",pop=2599,drop=2635,KI=1011},

	["Armed Gears"] = 				{display_name=" Gears",pop=2574,drop=2610,KI=1000},
	["Gotah Zha the Redolent"] =	{display_name="Mamool",pop=2575,drop=2611,KI=1001},
	["Dea"] = 						{display_name="   Dea",pop=2576,drop=2612,KI=1002},
	["Nosferatu"] = 				{display_name="  Vamp",pop=2584,drop=2620,KI=1006},
	["Khromasoul Bhurborlor"] = 	{display_name=" Troll",pop=2585,drop=2621,KI=1007},
	["Achamoth"] =					{display_name="  Moth",pop=2586,drop=2622,KI=1008},
	["Mahjlaef the Paintorn"] =		{display_name="Flayer",pop=2594,drop=2630,KI=1012},
	["Experimental Lamia"] = 		{display_name=" Lamia",pop=2595,drop=2631,KI=1013},
	["Nuhn"] = 						{display_name="  Nuhn",pop=2596,drop=2632,KI=1014},

	["Tinnin"] =					{display_name="Tinnin",pop=2573,drop=2609,KI=1003},
	["Sarameya"] = 					{display_name="Sarameya",pop=2583,drop=2619,KI=1009},
	["Tyger"] = 					{display_name="Tyger",pop=2593,drop=2629,KI=1015},

	--Doesn't really have a seal or a drop. Just do a find for the key
	--["Pandemonium Warden"] = 		{display_name="Pandemonium Warden",pop=2572,drop=-1,KI=-1},
}

salt_areas = T{
	["Tinnin"] =	{KI=1016},
	["Sarameya"] =	{KI=1017},
	["Tyger"] =		{KI=1018},
}

show_tinnin = true
show_sarameya = true
show_tyger = true

local ZeniPopTracker = {}

local defaults = {}
defaults.text = {}
defaults.text.pos = {}
defaults.text.pos.x = 0
defaults.text.pos.y = 0
defaults.text.bg = {}
defaults.text.bg.alpha = 150
defaults.text.bg.blue = 0
defaults.text.bg.green = 0
defaults.text.bg.red = 0
defaults.text.bg.visible = true
defaults.text.padding = 8
defaults.text.text = {}
defaults.text.text.font = 'Consolas'
defaults.text.text.size = 10
defaults.visible = true
defaults.show_tinnin = true
defaults.show_sarameya = true
defaults.show_tyger = true

player = windower.ffxi.get_player()
ZeniPopTracker.settings = config.load('data/'..player['name']..'.xml', defaults)
ZeniPopTracker.text = require('texts').new(ZeniPopTracker.settings.text, ZeniPopTracker.settings)

function znm_status(items, key_items, name)
	pop = "_"
	drop = "_"
	seal = "_"
	if have_item(items, znm_mobs[name]["pop"]) then
		pop = "\\cs(255,0,0)".."P".."\\cr"
	end
	if have_item(items, znm_mobs[name]["drop"]) then
		drop = "\\cs(255,255,0)".."D".."\\cr"
	end
	if have_key_item(key_items, znm_mobs[name]["KI"]) then
		seal = "\\cs(100,255,100)".."S".."\\cr"
	end
	
	return znm_mobs[name]['display_name']..":"..pop..drop..seal.." "
end

function salt_status(key_items, name)
	if have_key_item(key_items, salt_areas[name]["KI"]) then
		salt = "\\cs(100,255,100)".."  Salt".."\\cr"
	else
		salt = "\\cs(64,64,64)".."  Salt".."\\cr"
	end
	
	return salt
end

function have_key_item(key_items, id)
	for _, item_id in pairs(key_items) do
		if item_id == id then
			return true
		end
	end

	return false
end

function have_item(items, id)
	for _, bag in pairs(items) do
		if type(bag) == 'table' then
			for _, item in ipairs(bag) do
				if item.id == id then
					return true
				end
			end
		end
	end

	return false
end

function maketext()

	local items = windower.ffxi.get_items()
	local key_items = windower.ffxi.get_key_items()

	line1 = ""
	line2 = ""
	line3 = ""
	line4 = ""

	--Tinnin Path
	if ZeniPopTracker.settings.show_tinnin then
		line1 = line1..znm_status(items, key_items, 'Vulpangue')..znm_status(items, key_items, 'Chamrosh')..znm_status(items, key_items, 'Cheese Hoarder Gigiroon')
		line2 = line2..znm_status(items, key_items, 'Iriz Ima')..znm_status(items, key_items, 'Iriri Samariri')..znm_status(items, key_items, 'Lividroot Amooshah')
		line3 = line3..znm_status(items, key_items, 'Armed Gears')..znm_status(items, key_items, 'Gotah Zha the Redolent')..znm_status(items, key_items, 'Dea')
		line4 = line4..salt_status(key_items, 'Tinnin').."     "..znm_status(items, key_items, 'Tinnin').."           "
	end

	--Sarameya Path
	if ZeniPopTracker.settings.show_sarameya then
		--Spacing if tinnin is active
		if line1 ~= "" then
			line1 = line1.."   "
			line2 = line2.."   "
			line3 = line3.."   "
			line4 = line4.."   "
		end
		line1 = line1..znm_status(items, key_items, 'Brass Borer')..znm_status(items, key_items, 'Claret')..znm_status(items, key_items, 'Ob')
		line2 = line2..znm_status(items, key_items, 'Anantaboga')..znm_status(items, key_items, 'Reacton')..znm_status(items, key_items, 'Dextrose')
		line3 = line3..znm_status(items, key_items, 'Nosferatu')..znm_status(items, key_items, 'Khromasoul Bhurborlor')..znm_status(items, key_items, 'Achamoth')
		line4 = line4..salt_status(key_items, 'Sarameya').."    "..znm_status(items, key_items, 'Sarameya').."          "
	end

	--Tyger Path
	if ZeniPopTracker.settings.show_tyger then
		--Spacing if tinnin or sarameya is active
		if line1 ~= "" then
			line1 = line1.."   "
			line2 = line2.."   "
			line3 = line3.."   "
			line4 = line4.."   "
		end
		line1 = line1..znm_status(items, key_items, 'Velionis')..znm_status(items, key_items, "Lil' Apkallu")..znm_status(items, key_items, 'Chigre')
		line2 = line2..znm_status(items, key_items, 'Wulgaru')..znm_status(items, key_items, 'Zareehkl the Jubilant')..znm_status(items, key_items, 'Verdelet')
		line3 = line3..znm_status(items, key_items, 'Mahjlaef the Paintorn')..znm_status(items, key_items, 'Experimental Lamia')..znm_status(items, key_items, 'Nuhn')
		line4 = line4..salt_status(key_items, 'Tyger').."      "..znm_status(items, key_items, 'Tyger')
	end

	text = line1.."\n"..line2.."\n"..line3.."\n"..line4

	return text
end

windower.register_event('load', function()
	ZeniPopTracker.text:text(maketext())
	ZeniPopTracker.text:visible(true)
    if windower.ffxi.get_info().logged_in and ZeniPopTracker.settings.visible then
        active = true
        ZeniPopTracker.update()
    end
end)

windower.register_event('zone change', function(old, new)
	active = false
	coroutine.sleep(10)
	active = true
end)

windower.register_event("addon command", function (...)
	local params = {...}
	--Any path name toggles visibility of that path
	--"All" shows all paths
	for _,param in pairs(params) do
		if param:lower() == "tinnin" then
			ZeniPopTracker.settings.show_tinnin = not ZeniPopTracker.settings.show_tinnin
    		ZeniPopTracker.settings:save()
		end
		if param:lower() == "sarameya" then
			ZeniPopTracker.settings.show_sarameya = not ZeniPopTracker.settings.show_sarameya
    		ZeniPopTracker.settings:save()
		end
		if param:lower() == "tyger" then
			ZeniPopTracker.settings.show_tyger = not ZeniPopTracker.settings.show_tyger
    		ZeniPopTracker.settings:save()
		end
		if param:lower() == "all" then
			ZeniPopTracker.settings.show_tinnin = true
			ZeniPopTracker.settings.show_sarameya = true
			ZeniPopTracker.settings.show_tyger = true
    		ZeniPopTracker.settings:save()
		end
	end
	ZeniPopTracker.update()
end)

ZeniPopTracker.update = function()
    local text = maketext()
    ZeniPopTracker.text:text(text)
    if ZeniPopTracker.settings.visible then
        ZeniPopTracker.text:visible(true)
    end
end

windower.register_event('add item', 'remove item', function()
    if active then
        ZeniPopTracker.update()
    end
end)

windower.register_event('incoming chunk', function(id)
    --0x055: KI update
    --0x0D2: Treasure pool addition
    --0x0D3: Treasure pool lot/drop
    if active and id == 0x055 or id == 0x0D2 or id == 0x0D3 then
        ZeniPopTracker.update()
    end
end)