local SSA, _, L, LSM = unpack(select(2,...))

local Auras = LibStub("AceAddon-3.0"):GetAddon("ShamanAurasDev")

-- Cache Global Lua Functions
local upper = string.upper
local twipe = table.wipe

--[[----------------------------------------------------------------
	Constants
------------------------------------------------------------------]]
local FRAME_ANCHOR_OPTIONS = {
	["TOPLEFT"] = L["OPTION_TOP_LEFT"],
	["TOP"] = L["OPTION_TOP"],
	["TOPRIGHT"] = L["OPTION_TOP_RIGHT"],
	["LEFT"] = L["OPTION_LEFT"],
	["CENTER"] = L["OPTION_CENTER"],
	["RIGHT"] = L["OPTION_RIGHT"],
	["BOTTOMLEFT"] = L["OPTION_BOTTOM_LEFT"],
	["BOTTOM"] = L["OPTION_BOTTOM"],
	["BOTTOMRIGHT"] = L["OPTION_BOTTOM_RIGHT"],
}

local FONT_OUTLINES = {
	[""] = NONE,
	["OUTLINE"] = L["OPTION_OUTLINE"],
	["THICKOUTLINE"] = L["OPTION_OUTLINE_THICK"],
	["MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME"],
	["OUTLINE, MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME_OUTLINE"],
	["THICKOUTLINE, MONOCHROME"] = L["OPTION_OUTLINE_MONOCHROME_THICK"],
}

local TIME_FORMATS = {
	["full"] = "2:25",
	["short"] = "2m",
}


--[[----------------------------------------------------------------
	Copy font options from other cooldown groups.
------------------------------------------------------------------]]
function Auras:CopyCooldownOptions(spec,srcGrp,destGrp)
	local src = self.db.char.auras[spec].cooldowns.groups[srcGrp].text
	local dest = self.db.char.auras[spec].cooldowns.groups[destGrp].text
	
	dest.justify = src.justify
	dest.x = src.x
	dest.y = src.y
	dest.font.name = src.font.name
	dest.font.size = src.font.size
	dest.font.flag = src.font.flag
	dest.font.color.r = src.font.color.r
	dest.font.color.g = src.font.color.g
	dest.font.color.b = src.font.color.b
	dest.font.color.a = src.font.color.a
	dest.font.shadow.isEnabled = src.font.shadow.isEnabled
	dest.font.shadow.offset.x = src.font.shadow.offset.x
	dest.font.shadow.offset.y = src.font.shadow.offset.y
	dest.font.shadow.color.r = src.font.shadow.color.r
	dest.font.shadow.color.g = src.font.shadow.color.g
	dest.font.shadow.color.b = src.font.shadow.color.b
	dest.font.shadow.color.a = src.font.shadow.color.a
end

--[[----------------------------------------------------------------
	Copy formatting options from other cooldown groups.
------------------------------------------------------------------]]
function Auras:CopyCooldownFormatting(spec,srcGrp,destGrp)
	local src = self.db.char.auras[spec].cooldowns.groups[srcGrp].text
	local dest = self.db.char.auras[spec].cooldowns.groups[destGrp].text
	
	dest.formatting.length = src.formatting.length
	dest.formatting.decimals = src.formatting.decimals
	dest.formatting.alert.isEnabled = src.formatting.alert.isEnabled
	dest.formatting.alert.threshold = src.formatting.alert.threshold
	dest.formatting.alert.animate = src.formatting.alert.animate
	dest.formatting.alert.color.r = src.formatting.alert.color.r
	dest.formatting.alert.color.g = src.formatting.alert.color.g
	dest.formatting.alert.color.b = src.formatting.alert.color.b
	dest.formatting.alert.color.a = src.formatting.alert.color.a
end

--[[----------------------------------------------------------------
	Setup progress bar formatting.
------------------------------------------------------------------]]
function Auras:SetBarOptions(db,option,text1,text2,spark,timer)
	if (db.adjust.isEnabled) then
	
		if (spark) then
			option.iconSpark.disabled = false
		end
		
		if (db[text1].isDisplayText) then
			option[text1].disabled = false
		else
			option[text1].disabled = true
		end

		if (db[text1].font.shadow.isEnabled and db[text1].isDisplayText) then
			option[text1].args.shadow.args.shadowColor.disabled = false
			option[text1].args.shadow.args.shadowX.disabled = false
			option[text1].args.shadow.args.shadowY.disabled = false
		else
			option[text1].args.shadow.args.shadowColor.disabled = true
			option[text1].args.shadow.args.shadowX.disabled = true
			option[text1].args.shadow.args.shadowY.disabled = true
		end
		
		if (text2) then
			if (db[text2].isDisplayText) then
				option[text2].disabled = false
			else
				option[text2].disabled = true
			end
			
			if (db[text2].font.shadow.isEnabled and db[text2].isDisplayText) then
				option[text2].args.shadow.args.shadowColor.disabled = false
				option[text2].args.shadow.args.shadowX.disabled = false
				option[text2].args.shadow.args.shadowY.disabled = false
			else
				option[text2].args.shadow.args.shadowColor.disabled = true
				option[text2].args.shadow.args.shadowX.disabled = true
				option[text2].args.shadow.args.shadowY.disabled = true
			end
		end
	
		if (option.layout.args.timerColor) then
			if (db.adjust.showTimer) then
				option.layout.args.timerColor.disabled = false
				option.layout.args.timerTexture.disabled = false
			else
				option.layout.args.timerColor.disabled = true
				option.layout.args.timerTexture.disabled = true
			end
		end

		if (db.adjust.showBG) then
			option.layout.args.backgroundColor.disabled = false
			option.layout.args.backgroundTexture.disabled = false
		else
			option.layout.args.backgroundColor.disabled = true
			option.layout.args.backgroundTexture.disabled = true
		end
		
		option.layout.disabled = false
	else
		if (spark) then
			option.iconSpark.disabled = true
		end
		
		option[text1].disabled = true
		option[text1].args.shadow.args.shadowColor.disabled = true
		option[text1].args.shadow.args.shadowX.disabled = true
		option[text1].args.shadow.args.shadowY.disabled = true
		
		if (text2) then
			option[text2].disabled = true
			option[text2].args.shadow.args.shadowColor.disabled = true
			option[text2].args.shadow.args.shadowX.disabled = true
			option[text2].args.shadow.args.shadowY.disabled = true
		end
		
		if (timer) then
			option.layout.args.timerColor.disabled = true
			option.layout.args.timerTexture.disabled = true
		end
		option.layout.args.backgroundColor.disabled = true
		option.layout.args.backgroundTexture.disabled = true
		option.layout.disabled = true
	end	
		
	if (spark) then
		if (db.icon.isEnabled and db.adjust.isEnabled) then
			option.iconSpark.args.iconJustify.disabled = false
		else
			option.iconSpark.args.iconJustify.disabled = true
		end
	end
end

--[[----------------------------------------------------------------
	Compare current values with default values to determine if 
	reset buttons should be enabled or disabled.
------------------------------------------------------------------]]
function Auras:GetResetButtonState(db,default,text1,text2,bg,fg,layout,timer)
	local isTextOne,isTextTwo
	local isBG,isFG
	local isLayout,isTimer
	
	if (text1) then
		if(not db[text1].isDisplayText or
		db[text1].x ~= default[text1].x or
		db[text1].y ~= default[text1].y or
		db[text1].font.name ~= default[text1].font.name or
		db[text1].font.size ~= default[text1].font.size or
		db[text1].font.flag ~= default[text1].font.flag or
		db[text1].font.color.r ~= default[text1].font.color.r or
		db[text1].font.color.g ~= default[text1].font.color.g or
		db[text1].font.color.b ~= default[text1].font.color.b or
		db[text1].font.color.a ~= default[text1].font.color.a or
		db[text1].font.shadow.isEnabled or
		db[text1].font.shadow.offset.x ~= default[text1].font.shadow.offset.x or
		db[text1].font.shadow.offset.y ~= default[text1].font.shadow.offset.y or
		db[text1].font.shadow.color.r ~= default[text1].font.shadow.color.r or
		db[text1].font.shadow.color.g ~= default[text1].font.shadow.color.g or
		db[text1].font.shadow.color.b ~= default[text1].font.shadow.color.b or
		db[text1].font.shadow.color.a ~= default[text1].font.shadow.color.a or
		db[text1].justify ~= default[text1].justify) then
			isTextOne = false
		else
			isTextOne = true
		end
	end
	
	if (text2) then
		if(not db[text2].isDisplayText or
		db[text2].x ~= default[text2].x or
		db[text2].y ~= default[text2].y or
		db[text2].font.name ~= default[text2].font.name or
		db[text2].font.size ~= default[text2].font.size or
		db[text2].font.flag ~= default[text2].font.flag or
		db[text2].font.color.r ~= default[text2].font.color.r or
		db[text2].font.color.g ~= default[text2].font.color.g or
		db[text2].font.color.b ~= default[text2].font.color.b or
		db[text2].font.color.a ~= default[text2].font.color.a or
		db[text2].font.shadow.isEnabled or
		db[text2].font.shadow.offset.x ~= default[text2].font.shadow.offset.x or
		db[text2].font.shadow.offset.y ~= default[text2].font.shadow.offset.y or
		db[text2].font.shadow.color.r ~= default[text2].font.shadow.color.r or
		db[text2].font.shadow.color.g ~= default[text2].font.shadow.color.g or
		db[text2].font.shadow.color.b ~= default[text2].font.shadow.color.b or
		db[text2].font.shadow.color.a ~= default[text2].font.shadow.color.a or
		db[text2].justify ~= default[text2].justify) then
			isTextTwo = false
		else
			isTextTwo = true
		end
	end
	
	if (bg) then
		if (db.background.texture ~= default.background.texture or
		db.background.color.r ~= default.background.color.r or
		db.background.color.g ~= default.background.color.g or
		db.background.color.b ~= default.background.color.b or
		db.background.color.a ~= default.background.color.a) then
			isBG = false
		else
			isBG = true
		end
	end
	
	if (fg) then
		if (db.foreground.color.r ~= default.foreground.color.r or
		db.foreground.color.g ~= default.foreground.color.g or
		db.foreground.color.b ~= default.foreground.color.b or
		db.foreground.texture ~= default.foreground.texture) then
			isFG = false
		else
			isFG = true
		end
	end
	
	if (timer) then
		if (db.timerBar.color.r ~= default.timerBar.color.r or
		db.timerBar.color.g ~= default.timerBar.color.g or
		db.timerBar.color.b ~= default.timerBar.color.b or
		db.timerBar.color.a ~= default.timerBar.color.a or
		db.timerBar.texture ~= default.timerBar.texture) then
			isTimer = false
		else
			isTimer = false
		end
	end
	
	if (layout) then
		if (db.layout.width ~= default.layout.width or
		db.layout.height ~= default.layout.height or
		db.layout.strata ~= default.layout.strata) then
			isLayout = false
		else
			isLayout = true
		end
	end
	
	if ((not isTextOne and text1) or
		(not isTextTwo and text2) or
		(not isBG and bg) or
		(not isFG and fg) or
		(not isLayout and layout) or
		(not isTimer and timer)) then
		return false
	else
		return true
	end
end

function Auras:GetCooldownResetButtonState(cdGroup,default)
	if (cdGroup.isEnabled ~= default.isEnabled or
		cdGroup.sweep ~= default.sweep or
		cdGroup.inverse ~= default.inverse or
		cdGroup.bling ~= default.bling or
		cdGroup.GCD.isEnabled ~= default.GCD.isEnabled or
		cdGroup.text.x ~= default.text.x or
		cdGroup.text.y ~= default.text.y or
		cdGroup.text.isDisplayText ~= default.text.isDisplayText or
		cdGroup.text.justify ~= default.text.justify or
		cdGroup.text.font.size ~= default.text.font.size or
		cdGroup.text.font.flag ~= default.text.font.flag or
		cdGroup.text.font.name ~= default.text.font.name or
		cdGroup.text.font.color.a ~= default.text.font.color.a or
		cdGroup.text.font.color.r ~= default.text.font.color.r or
		cdGroup.text.font.color.g ~= default.text.font.color.g or
		cdGroup.text.font.color.b ~= default.text.font.color.b or
		cdGroup.text.font.shadow.isEnabled ~= default.text.font.shadow.isEnabled or
		cdGroup.text.font.shadow.color.a ~= default.text.font.shadow.color.a or
		cdGroup.text.font.shadow.color.r ~= default.text.font.shadow.color.r or
		cdGroup.text.font.shadow.color.g ~= default.text.font.shadow.color.g or
		cdGroup.text.font.shadow.color.b ~= default.text.font.shadow.color.b or
		cdGroup.text.font.shadow.offset.x ~= default.text.font.shadow.offset.x or
		cdGroup.text.font.shadow.offset.y ~= default.text.font.shadow.offset.y or
		cdGroup.text.formatting.decimals ~= default.text.formatting.decimals or
		cdGroup.text.formatting.length ~= default.text.formatting.length or
		cdGroup.text.formatting.alert.animate ~= default.text.formatting.alert.animate or
		cdGroup.text.formatting.alert.isEnabled ~= default.text.formatting.alert.isEnabled or
		cdGroup.text.formatting.alert.threshold ~= default.text.formatting.alert.threshold or
		cdGroup.text.formatting.alert.color.a ~= default.text.formatting.alert.color.a or
		cdGroup.text.formatting.alert.color.r ~= default.text.formatting.alert.color.r or
		cdGroup.text.formatting.alert.color.g ~= default.text.formatting.alert.color.g or
		cdGroup.text.formatting.alert.color.b ~= default.text.formatting.alert.color.b) then
		return true
	else
		return false
	end
end

function Auras:ResetText(db,text,default)
	db[text].isDisplayText = true
	db[text].x = default[text].x
	db[text].y = default[text].y
	db[text].font.name = default[text].font.name
	db[text].font.size = default[text].font.size
	db[text].font.flag = default[text].font.flag
	db[text].font.color.r = default[text].font.color.r
	db[text].font.color.g = default[text].font.color.g
	db[text].font.color.b = default[text].font.color.b
	db[text].font.color.a = default[text].font.color.a
	db[text].font.shadow.isEnabled = false
	db[text].font.shadow.offset.x = default[text].font.shadow.offset.x
	db[text].font.shadow.offset.y = default[text].font.shadow.offset.y
	db[text].font.shadow.color.r = default[text].font.shadow.color.r
	db[text].font.shadow.color.g = default[text].font.shadow.color.g
	db[text].font.shadow.color.b = default[text].font.shadow.color.b
	db[text].font.shadow.color.a = default[text].font.shadow.color.a
	db[text].justify = default[text].justify
end

function Auras:ResetBackground(db,default)
	db.background.texture = default.background.texture
	db.background.color.r = default.background.color.r
	db.background.color.g = default.background.color.g
	db.background.color.b = default.background.color.b
	db.background.color.a = default.background.color.a
end

function Auras:ResetColor(db,color,default)
	db.color.r = default.color.r
	db.color.g = default.color.g
	db.color.b = default.color.b
	
	if (db.color.a) then
		db.color.a = default.color.a
	end
end

-- FIX THIS
function Auras:ResetForeground(db,default)
	db.foreground.color.r = default.foreground.color.r
	db.foreground.color.g = default.foreground.color.g
	db.foreground.color.b = default.foreground.color.b
	db.foreground.texture = default.foreground.texture
end

-- FIX THIS
function Auras:ResetLayout(db,default)
	db.layout.width = default.layout.width
	db.layout.height = default.layout.height
	db.layout.strata = default.layout.strata
end

-- FIX THIS
function Auras:ResetTimerBar(db,default)
	db.timerBar.color.r = default.timerBar.color.r
	db.timerBar.color.g = default.timerBar.color.g
	db.timerBar.color.b = default.timerBar.color.b
	db.timerBar.color.a = default.timerBar.color.a
	db.timerBar.texture = default.timerBar.texture
end

--[[----------------------------------------------------------------
	Configure cooldown customization interface by enabling and 
	disabling specific controls based on existing settings.
------------------------------------------------------------------]]
function Auras:SetCooldownOptions(spec,options)
	local db = Auras.db.char
	local cooldown = self.db.char.auras[spec].cooldowns
	local defaults = SSA.defaults.auras[spec].cooldowns
	local option = options.args.cooldowns.args
	
	
	
	--local grp,subGrp = split(";",cd.selected or 'primary;1')
	--local selected = ''
	
	for i=1,#Auras.db.char.auras[spec].groups do
		if (i == cooldown.selected) then
			--cd.groups[i].isPreview = true
		else
			--cd.groups[i].isPreview = false
		end
		
		if (not cooldown.adjust) then
			if (not option.group.disabled) then
				option.group.disabled = true
			end

			--[[option.cdGroups.args["cd"..i.."_animation"].disabled = true
			option.cdGroups.args["cd"..i.."_formatting"].disabled = true
			option.cdGroups.args["cd"..i.."_adjustGroup"].disabled = true]]
		else
			if (option.group.disabled) then
				option.group.disabled = false
			end

			--[[option.cdGroups.args["cd"..i.."_animation"].disabled = false
			option.cdGroups.args["cd"..i.."_formatting"].disabled = false
			option.cdGroups.args["cd"..i.."_adjustGroup"].disabled = false]]
		end

		if (cooldown.groups[i].isEnabled) then
			
			--option.cdGroups.args["cd"..i.."_animation"].args.text.disabled = false
			--option.cdGroups.args["cd"..i.."_animation"].args.sweep.disabled = false
			
			
		else
			--[[if (cooldown.adjust) then
				cooldown.adjust = false
			end]]
			--option.cdGroups.args["cd"..i.."_animation"].args.text.disabled = true
			--option.cdGroups.args["cd"..i.."_animation"].args.sweep.disabled = true
			
			--[[if (not option.group.disabled) then
				option.group.disabled = true
			end
			
			if (not option.adjustToggle.disabled) then
				option.adjustToggle.disabled = true
			end]]
		end

		if (cooldown.adjust and cooldown.groups[i].sweep and cooldown.groups[i].isEnabled) then
			option.cdGroups.args["cd"..i.."_animation"].args.GCD.disabled = false
			option.cdGroups.args["cd"..i.."_animation"].args.inverse.disabled = false
			option.cdGroups.args["cd"..i.."_animation"].args.bling.disabled = false
		else
			option.cdGroups.args["cd"..i.."_animation"].args.GCD.disabled = true
			option.cdGroups.args["cd"..i.."_animation"].args.inverse.disabled = true
			option.cdGroups.args["cd"..i.."_animation"].args.bling.disabled = true
		end

		if (cooldown.adjust and cooldown.groups[i].text.formatting.alert.isEnabled) then
			option.cdGroups.args["cd"..i.."_formatting"].args.alertFlash.disabled = false
			option.cdGroups.args["cd"..i.."_formatting"].args.alertColor.disabled = false
			option.cdGroups.args["cd"..i.."_formatting"].args.alertThreshold.disabled = false
		else
			option.cdGroups.args["cd"..i.."_formatting"].args.alertFlash.disabled = true
			option.cdGroups.args["cd"..i.."_formatting"].args.alertColor.disabled = true
			option.cdGroups.args["cd"..i.."_formatting"].args.alertThreshold.disabled = true
		end
		
		if (cooldown.adjust and cooldown.groups[i].isEnabled) then
			option.cdGroups.args["cd"..i.."_animation"].disabled = false
			option.cdGroups.args["cd"..i.."_formatting"].disabled = false
			option.cdGroups.args["cd"..i.."_adjustGroup"].disabled = false
		else
			cooldown.groups[i].isPreview = false
			option.cdGroups.args["cd"..i.."_animation"].disabled = true
			option.cdGroups.args["cd"..i.."_formatting"].disabled = true
			option.cdGroups.args["cd"..i.."_adjustGroup"].disabled = true
		end
		--[[if (cooldown.groups[i].text.font.shadow.isEnabled and cooldown.adjust) then
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowColor.disabled = false
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowX.disabled = false
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowY.disabled = false
		else
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowColor.disabled = true
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowX.disabled = true
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.shadow.args.shadowY.disabled = true
		end]]
		
		

		if (Auras:GetCooldownResetButtonState(cooldown.groups[i],defaults.groups[i])) then
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.disabled = false
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.name = "|cFFFFCC00Reset to Default|r"
		else
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.disabled = true
			option.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.name = "|cFF666666Reset to Default|r"
		end
	end
	
	if (option.group.disabled) then
		
	end
	
	
	--[[if (cooldown.groups[i].isEnabled) then
		option.cdGroups.args["cd"..i.."_animation"].text.disabled = false
		option.cdGroups.args["cd"..i.."_animation"].sweep.disabled = false
		option.group.disabled = false
		option.adjustToggle.disabled = false
	else
		if (cooldown.adjust) then
			cooldown.adjust = false
		end
		option.cdGroups.args["cd"..i.."_animation"].text.disabled = true
		option.cdGroups.args["cd"..i.."_animation"].sweep.disabled = true
		option.group.disabled = true
		option.adjustToggle.disabled = true
	end]]
end

function Auras:VerifyDefaultValues(spec,options,group,subgroup)
	if (group == "Cooldowns") then
		Auras:RefreshCooldownList(options,spec,Auras.db.char.auras[spec].cooldowns)
		Auras:SetCooldownOptions(spec,options)
	elseif (group == "Cast" or group == "Channel") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars[group.."Bar"]
		local default = SSA.defaults.statusbars.defaults[group.."Bar"]
		
		local option = options.args.bars.args[group.."Bar"].args
		
		Auras:SetBarOptions(bar,option,'nametext','timetext',true)
		
		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			
			not bar.icon.isEnabled or
			bar.icon.justify ~= default.icon.justify or
			not bar.spark or
			
			not Auras:GetResetButtonState(bar,default,'nametext','timetext',true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_"..upper(group)].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_"..upper(group)].."|r"
		end
	elseif (group == "Fulmination") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.FulminationBar
		local default = SSA.defaults.statusbars[spec].defaults.FulminationBar
		local option = options.args.bars.args.FulminationBar.args
		
		Auras:SetBarOptions(bar,option,'counttext','timetext',false,true)

		if (bar.isEnabled) then
			options.args.bars.args.FulminationBar.disabled = false
		else
			options.args.bars.args.FulminationBar.disabled = true
		end

		--option.general.args.threshold.max = UnitPowerMax('player',POWER_MAELSTROM_ID)
		
		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			bar.alphaTar ~= default.alphaTar or
			bar.threshold ~= default.threshold or
			not bar.animate or
			
			not Auras:GetResetButtonState(bar,default,'counttext','timetext',true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_FULMINATION"].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_FULMINATION"].."|r"
		end
	elseif (group == "MaelstromWeapon") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.MaelstromWeaponBar
		local default = SSA.defaults.statusbars[spec].defaults.MaelstromWeaponBar
		local option = options.args.bars.args.MaelstromWeaponBar.args
		
		Auras:SetBarOptions(bar,option,'counttext','timetext',false,true)

		if (bar.isEnabled) then
			options.args.bars.args.MaelstromWeaponBar.disabled = false
		else
			options.args.bars.args.MaelstromWeaponBar.disabled = true
		end

		--option.general.args.threshold.max = UnitPowerMax('player',POWER_MAELSTROM_ID)
		
		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			bar.alphaTar ~= default.alphaTar or
			bar.threshold ~= default.threshold or
			not bar.animate or
			not Auras:GetResetButtonState(bar,default,'counttext','timetext',true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_MAELSTROM_WEAPON"].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MAELSTROM_WEAPON"].."|r"
		end
	elseif (group == 'Settings') then
		local db = Auras.db.char
		local settings = db.settings[spec]
		local defaults = SSA.defaults.settings[spec]
		local option = options.args.general.args.settings.args
		
		if (settings.OoCAlpha ~= defaults.OoCAlpha or 
			--(settings.totemMastery and settings.totemMastery ~= defaults[spec].totemMastery) or 
			settings.OoRColor.r ~= defaults.OoRColor.r or 
			settings.OoRColor.g ~= defaults.OoRColor.g or 
			settings.OoRColor.b ~= defaults.OoRColor.b or 
			settings.OoRColor.a ~= defaults.OoRColor.a) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_SETTINGS"].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_SETTINGS"].."|r"
		end
	elseif (group == "Timerbar") then
		local db = Auras.db.char
		local layout = db.timerbars[spec].groups[subgroup]
		local defaults = SSA.defaults.timerbars.templates.groups

		--print("SUBGROUP: "..tostring(subgroup))
		if (layout.alphaOoC ~= defaults.alphaOoC or
			layout.alphaCombat ~= defaults.alphaCombat or
			
			not Auras:GetResetButtonState(layout,defaults,'nametext','timetext',false,false,true)) then
			--option.reset.disabled = false
			--option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_"..upper(group)].."|r"
		else
			--option.reset.disabled = true
			--option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_"..upper(group)].."|r"
		end
	elseif (group == "Icefury") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.IcefuryBar
		local default = SSA.defaults.statusbars[spec].defaults.IcefuryBar

		local option = options.args.bars.args.IcefuryBar.args
		
		Auras:SetBarOptions(bar,option,'counttext','timetext',false,true)

		if (bar.isEnabled) then
			options.args.bars.args.IcefuryBar.disabled = false
		else
			options.args.bars.args.IcefuryBar.disabled = true
		end
		
		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			bar.alphaTar ~= default.alphaTar or
			
			not Auras:GetResetButtonState(bar,default,'counttext','timetext',true,true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_ICEFURY"].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_ICEFURY"].."|r"
		end
	elseif (group == "Earthen Wall") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.EarthenWallTotemBar
		local default = SSA.defaults.statusbars[spec].defaults.EarthenWallTotemBar
		
		local option = options.args.bars.args.EarthenWallTotemBar.args
		
		Auras:SetBarOptions(bar,option,'healthtext','timetext',false,true)
		
		if (bar.isEnabled) then
			options.args.bars.args.EarthenWallTotemBar.disabled = false
		else
			options.args.bars.args.EarthenWallTotemBar.disabled = true
		end
		
		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			bar.alphaTar ~= default.alphaTar or
			
			not Auras:GetResetButtonState(bar,default,'healthtext','timetext',true,true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_EARTHEN_WALL"].."|r"
		else
			option.reset.disabled = true
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_EARTHEN_WALL"].."|r"
		end
	elseif (group == "Mana") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.ManaBar
		local default = SSA.defaults.statusbars[spec].defaults.ManaBar
		local option = options.args.bars.args.ManaBar.args
		
		Auras:SetBarOptions(bar,option,'text')

		if (bar.isEnabled) then
			options.args.bars.args.ManaBar.disabled = false
		else
			options.args.bars.args.ManaBar.disabled = true
		end

		if (bar.alphaCombat ~= default.alphaCombat or
			bar.alphaOoC ~= default.alphaOoC or
			bar.alphaTar ~= default.alphaTar or
			
			not bar.grouping or 
			bar.precision ~= default.precision or
			
			not Auras:GetResetButtonState(bar,default,'text',nil,true,true,true)) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_MANA"].."|r"
		else
			option.reset.disabled = false
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_MANA"].."|r"
		end
	elseif (group == "Tidal Waves") then
		local db = Auras.db.char
		local bar = db.statusbars[spec].bars.TidalWavesBar
		local default = SSA.defaults.statusbars[spec].defaults.TidalWavesBar
		local option = options.args.bars.args.TidalWavesBar.args

		if (bar.adjust.isEnabled) then
			if (bar.adjust.showBG) then
				option.layout.args.backgroundColor.disabled = false
				option.layout.args.backgroundTexture.disabled = false
			else
				option.layout.args.backgroundColor.disabled = true
				option.layout.args.backgroundTexture.disabled = true
			end
			
			option.layout.disabled = false
		else
			option.layout.args.backgroundColor.disabled = true
			option.layout.args.backgroundTexture.disabled = true
			option.layout.disabled = true
		end

		if (bar.isEnabled) then
			options.args.bars.args.TidalWavesBar.disabled = false
		else
			options.args.bars.args.TidalWavesBar.disabled = true
		end

		if (not bar.animate or
			bar.combatDisplay ~= default.combatDisplay or
			bar.OoCDisplay ~= default.OoCDisplay or
			bar.OoCTime ~= default.OoCTime or
		
			bar.background.texture ~= default.background.texture or
			bar.background.color.r ~= default.background.color.r or
			bar.background.color.g ~= default.background.color.g or
			bar.background.color.b ~= default.background.color.b or
			bar.background.color.a ~= default.background.color.a or
			
			bar.emptyColor.r ~= default.emptyColor.r or
			bar.emptyColor.g ~= default.emptyColor.g or
			bar.emptyColor.b ~= default.emptyColor.b or
			
			bar.foreground.color.r ~= default.foreground.color.r or
			bar.foreground.color.g ~= default.foreground.color.g or
			bar.foreground.color.b ~= default.foreground.color.b or
			bar.foreground.texture ~= default.foreground.texture or
			
			bar.layout.width ~= default.layout.width or
			bar.layout.height ~= default.layout.height or
			bar.layout.strata ~= default.layout.strata) then
			option.reset.disabled = false
			option.reset.name = "|cFFFFCC00"..L["BUTTON_RESET_STATUSBAR_TIDAL_WAVES"].."|r"
		else
			option.reset.disabled = false
			option.reset.name = "|cFF666666"..L["BUTTON_RESET_STATUSBAR_TIDAL_WAVES"].."|r"
		end
	end
end

function Auras:RefreshCooldownList(options,spec)
	local args = {}
	local orderCtr = 9
	local COOLDOWN_VALUES = {}
	local auras = self.db.char.auras[spec]
	
	
	for i=1,#auras.groups do
		local cdGroup = auras.cooldowns.groups[i]

		for i=1,#auras.groups do
			if (auras.cooldowns.selected ~= i) then
				tinsert(COOLDOWN_VALUES,"Group #"..i.." Cooldowns")
			end
		end

		args["cd"..i.."toggle"] = self:Toggle_VerifyDefaults(cdGroup,1,spec,ENABLE,L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],"full",false,auras.cooldowns.selected ~= i,'isEnabled','Cooldowns')

		orderCtr = orderCtr + 1

		args["cd"..i.."_animation"] = {
			name = "Cooldown Animation",
			type = "group",
			order = orderCtr,
			guiInline = true,
			hidden = auras.cooldowns.selected ~= i,
			disabled = not auras.cooldowns.adjust,
			args = {
				text = self:Toggle_Cooldowns(cdGroup.text,1,spec,L["LABEL_COOLDOWN_TEXT"],L["TOOLTIP_TOGGLE_COOLDOWN_TEXT"],nil,'isDisplayText','AuraBase','Cooldowns'),
				sweep = self:Toggle_Cooldowns(cdGroup,2,spec,L["LABEL_COOLDOWN_SWEEP"],L["TOOLTIP_TOGGLE_COOLDOWN_SWEEP"],nil,'sweep','AuraBase','Cooldowns'),
				GCD = self:Toggle_Cooldowns(cdGroup.GCD,3,spec,L["LABEL_COOLDOWN_GCD"],L["TOOLTIP_TOGGLE_COOLDOWN_GCD"],nil,'isEnabled','AuraBase','Cooldowns'),
				inverse = self:Toggle_Cooldowns(cdGroup,4,spec,L["LABEL_COOLDOWN_REVERSE_SWEEP"],L["TOOLTIP_COOLDOWN_REVERSE_SWEEP"],nil,'inverse','AuraBase','Cooldowns'),
				bling = self:Toggle_Cooldowns(cdGroup,5,spec,L["LABEL_COOLDOWN_BLING"],L["TOOLTIP_TOGGLE_COOLDOWN_BLING"],nil,'bling','AuraBase','Cooldowns'),
			},
		}

		orderCtr = orderCtr + 1

		args["cd"..i.."_formatting"] = {
			name = FORMATTING,
			type = "group",
			order = orderCtr,
			guiInline = true,
			hidden = auras.cooldowns.selected ~= i,
			disabled = not auras.cooldowns.adjust,
			args = {
				alertToggle = self:Toggle_VerifyDefaults(cdGroup.text.formatting.alert,1,spec,L["LABEL_ALERT"],L["TOOLTIP_ALERT"],'double',nil,nil,'isEnabled','Cooldowns'),
				copy = self:Select_CooldownCopy(2,spec,L["LABEL_COOLDOWN_COPY_FROM"],L["TOOLTIP_COOLDOWN_COPY_FROM"],'formatting',i,COOLDOWN_VALUES,'Cooldowns'),
				alertFlash = self:Toggle_VerifyDefaults(cdGroup.text.formatting.alert,3,spec,L["LABEL_ALERT_ANIMATE"],L["TOOLTIP_ALERT_ANIMATE"],nil,not cdGroup.text.formatting.alert.isEnabled,nil,'animate','Cooldowns'),
				alertColor = self:Color_VerifyDefaults(cdGroup.text.formatting.alert,4,spec,L["LABEL_ALERT_COLOR"],L["TOOLTIP_ALERT_COLOR"],true,nil,not cdGroup.text.formatting.alert.isEnabled,'color','Cooldowns'),
				alertThreshold = self:Slider_VerifyDefaults(cdGroup.text.formatting.alert,5,spec,L["LABEL_ALERT_THRESHOLD"],L["TOOLTIP_ALERT_THRESHOLD"],3,10,1,nil,not cdGroup.text.formatting.alert.isEnabled,'threshold','Cooldowns'),
				decimals = self:Toggle_VerifyDefaults(cdGroup.text.formatting,6,spec,L["LABEL_DECIMALS"],L["TOOLTIP_DECIMALS"],nil,nil,nil,'decimals','Cooldowns'),
				format = self:Select_VerifyDefaults(cdGroup.text.formatting,7,spec,L["LABEL_MINUTE_FORMAT"],L["TOOLTIP_MINUTE_FORMAT"],nil,TIME_FORMATS,nil,nil,'length','Cooldowns'),
			},
		}
		
		orderCtr = orderCtr + 1
		
		args["cd"..i.."_adjustGroup"] = {
			name = L["LABEL_COOLDOWN_SETTINGS"],
			type = "group",
			order = orderCtr,
			guiInline = true,
			hidden = auras.cooldowns.selected ~= i,
			disabled = not auras.cooldowns.adjust,
			args = {
				color = self:Color_VerifyDefaults(cdGroup.text.font,1,spec,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,'double',nil,'color','Cooldowns'),
				copy = self:Select_CooldownCopy(2,spec,L["LABEL_COOLDOWN_COPY_FROM"],L["TOOLTIP_COOLDOWN_COPY_FROM"],'options',i,COOLDOWN_VALUES,'Cooldowns'),
				fontName = self:Select_VerifyDefaults(cdGroup.text.font,3,spec,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,nil,'name','Cooldowns'),
				fontSize = self:Slider_VerifyDefaults(cdGroup.text.font,4,spec,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,nil,'size','Cooldowns'),
				fontOutline = self:Select_VerifyDefaults(cdGroup.text.font,5,spec,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,nil,'flag','Cooldowns'),
				textAnchor = self:Select_VerifyDefaults(cdGroup.text,6,spec,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,nil,'justify','Cooldowns'),
				textX = self:Slider_VerifyDefaults(cdGroup.text,7,spec,"X",L["TOOLTIP_FONT_X_OFFSET"],-100,100,1,nil,nil,'x','Cooldowns'),
				textY = self:Slider_VerifyDefaults(cdGroup.text,8,spec,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,1,nil,nil,'y','Cooldowns'),
				shadow = {
					name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
					type = "group",
					order = 9,
					hidden = false,
					guiInline = true,
					args = {
						shadowToggle = self:Toggle_VerifyDefaults(cdGroup.text.font.shadow,1,spec,L["TOGGLE"],nil,nil,nil,nil,'isEnabled','Cooldowns'),
						shadowColor = self:Color_VerifyDefaults(cdGroup.text.font.shadow,2,spec,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,nil,'color','Cooldowns'),
						--filler_0 = self:Spacer(3,nil),
						shadowX = self:Slider_VerifyDefaults(cdGroup.text.font.shadow.offset,4,spec,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,nil,'x','Cooldowns'),
						shadowY = self:Slider_VerifyDefaults(cdGroup.text.font.shadow.offset,5,spec,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,nil,'y','Cooldowns'),
					},
				},
				reset = {
					order = 10,
					type = "execute",
					--[[name = function(this)
						if (self:GetCooldownResetButtonState(cdGroup,self.db.char.auras.templates.cooldowns)) then
							--this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.disabled = false
							this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.name = "|cFFFFCC00"..RESET_TO_DEFAULT.."|r"
						else
							--this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.disabled = true
							this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.name = "|cFF666666"..RESET_TO_DEFAULT.."|r"
						end
					end,]]
					name = RESET_TO_DEFAULT,
					disabled = false,
					--disabled = not self:GetCooldownResetButtonState(cdGroup,self.db.char.auras.templates.cooldowns),
					func = function(this)
						local cd = cdGroup
						local default = self.db.char.auras.templates.cooldowns
						
						--self:ResetText(cd,'text',default)

						cdGroup.isEnabled = true
						cdGroup.sweep = true
						cdGroup.inverse = false
						cdGroup.bling = false
						cdGroup.GCD.isEnabled = false

						cdGroup.text.isDisplayText = true
						cdGroup.text.x = default.text.x
						cdGroup.text.y = default.text.y
						cdGroup.text.justify = default.text.justify

						cdGroup.text.font.size = default.text.font.size
						cdGroup.text.font.flag = default.text.font.flag
						cdGroup.text.font.name = default.text.font.name

						cdGroup.text.font.color.a = default.text.font.color.a
						cdGroup.text.font.color.r = default.text.font.color.r
						cdGroup.text.font.color.g = default.text.font.color.g
						cdGroup.text.font.color.b = default.text.font.color.b

						cdGroup.text.font.shadow.isEnabled = false

						cdGroup.text.font.shadow.color.a = default.text.font.shadow.color.a
						cdGroup.text.font.shadow.color.r = default.text.font.shadow.color.r
						cdGroup.text.font.shadow.color.g = default.text.font.shadow.color.g
						cdGroup.text.font.shadow.color.b = default.text.font.shadow.color.b

						cdGroup.text.font.shadow.offset.x = default.text.font.shadow.offset.x
						cdGroup.text.font.shadow.offset.y = default.text.font.shadow.offset.y

						cdGroup.text.formatting.decimals = default.text.formatting.decimals
						cdGroup.text.formatting.length = default.text.formatting.length

						cdGroup.text.formatting.alert.animate = default.text.formatting.alert.animate
						cdGroup.text.formatting.alert.isEnabled = default.text.formatting.alert.isEnabled
						cdGroup.text.formatting.alert.threshold = default.text.formatting.alert.threshold

						cdGroup.text.formatting.alert.color.a = default.text.formatting.alert.color.a
						cdGroup.text.formatting.alert.color.r = default.text.formatting.alert.color.r
						cdGroup.text.formatting.alert.color.g = default.text.formatting.alert.color.g
						cdGroup.text.formatting.alert.color.b = default.text.formatting.alert.color.b

						--[[for k,v in pairs(this) do
							if (type(v) == "table") then
								print(">"..k)
								for key,val in pairs(v) do
									if (type(val) == "table") then
										print("--->"..key)
										for keys,value in pairs(val) do
											if (type(value) == "table") then
												print("------>"..keys)
												for keyz,values in pairs(value) do
													print("---------"..tostring(keyz).." - "..tostring(values))	
												end
											else
												print("------"..tostring(keys).." - "..tostring(value))
											end
										end
									else
										print("---"..tostring(key).." - "..tostring(val))
									end
								end
							else
								print(tostring(k).." - "..tostring(v))
							end
						end]]
						
						this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.disabled = true
						this.options.args.cooldowns.args.cdGroups.args["cd"..i.."_adjustGroup"].args.reset.name = "|cFF666666"..RESET_TO_DEFAULT.."|r"
						self:InitializeCooldowns(spec)
						self:VerifyDefaultValues(spec,this.options,'Cooldowns')
					end,
				},
			},
		}

		COOLDOWN_VALUES = nil
		COOLDOWN_VALUES = {}
	end

	options.args.cooldowns.args.cdGroups.args = args
	options.args.cooldowns.args.cdGroups.name = "Group "..self.db.char.auras[spec].cooldowns.selected.." Cooldown Settings"
end

local function UpdateSpellAuraInfo(spec,group)
	for k,v in pairs(Auras.db.char.auras[spec].auras) do
		if (v.group == group) then
			v.group = 0
			v.order = 0
			v.isInUse = false
			SSA[k]:SetParent(nil)
		elseif (v.group > group) then
			v.group = v.group - 1
		end
	end
end

local function UpdateSpellTimerBarInfo(spec,group)
	for k,v in pairs(Auras.db.char.timerbars[spec].bars) do
		if (v.layout.group == group) then
			v.layout.group = 0
			v.isInUse = false
			SSA[k]:SetParent(nil)
		elseif (v.layout.group > group) then
			v.layout.group = v.layout.group - 1
		end
	end
end

local function ReorderAuraList(spec,grp,oldOrder,newOrder,method)
	local auras = Auras.db.char.auras[spec].auras
	
	if (method == "swap") then
		for k,v in pairs(auras) do
			if (v.group == grp and v.order == oldOrder) then
				auras[k].order = newOrder
			end
		end
	elseif (method == "remove") then
		for k,v in pairs(auras) do
			if (v.group == grp and v.order > oldOrder) then
				auras[k].order = auras[k].order - 1
			end
		end
	elseif (method == "add") then
		for k,v in pairs(auras) do
			if (v.group == grp and v.order >= oldOrder and k ~= newOrder) then
				auras[k].order = auras[k].order + 1
			end
		end
	end
end

local function ReorderAuraGroups(spec,oldPos,method)
	if (method == "delete") then
		local groupCount = #Auras.db.char.auras[spec].groups
		
		-- Copy the frame in the global from the index that was deleted to a temporary
		-- variable, then wipe the global.
		local tempGroup = SSA["AuraGroup"..oldPos]
		SSA["AuraGroup"..oldPos] = nil
		_G["SSA_AuraGroup"..oldPos] = nil
		
		for i=oldPos,groupCount do
			SSA["AuraGroup"..i] = SSA["AuraGroup"..(i+1)]
			_G["SSA_AuraGroup"..i] = _G["SSA_AuraGroup"..(i+1)]
			SSA["AuraGroup"..(i+1)] = nil
			_G["SSA_AuraGroup"..(i+1)] = nil
		end

		SSA["AuraGroup"..(groupCount + 1)] = tempGroup
		_G["SSA_AuraGroup"..(groupCount + 1)] = tempGroup
	end
end

local function ReorderTimerBarGroups(spec,oldPos,method)
	if (method == "delete") then
		local groupCount = #Auras.db.char.timerbars[spec].groups
		
		-- Copy the frame in the global from the index that was deleted to a temporary
		-- variable, then wipe the global.
		local tempGroup = SSA["BarGroup"..oldPos]
		SSA["BarGroup"..oldPos] = nil
		_G["SSA_BarGroup"..oldPos] = nil
		
		for i=oldPos,groupCount do
			SSA["BarGroup"..i] = SSA["BarGroup"..(i+1)]
			_G["SSA_BarGroup"..i] = _G["SSA_BarGroup"..(i+1)]
			SSA["BarGroup"..(i+1)] = nil
			_G["SSA_BarGroup"..(i+1)] = nil
		end

		SSA["BarGroup"..(groupCount + 1)] = tempGroup
		_G["SSA_BarGroup"..(groupCount + 1)] = tempGroup
	end
end

local function ReorderAuraGlow(obj,triggers,oldPos,newPos)
	local tempTable = {}
		
	for k,v in pairs(triggers[newPos]) do
		tempTable[k] = v
	end

	triggers[newPos] = nil
	triggers[newPos] = {}
	
	for k,v in pairs(triggers[oldPos])  do
		triggers[newPos][k] = v
	end

	triggers[oldPos] = nil
	triggers[oldPos] = {}
	
	for k,v in pairs(tempTable) do
		triggers[oldPos][k] = v
	end
end

local function AddGlowTools(auraTbl,grp)
	local auras = Auras.db.char.auras[SSA.spec]
	local orderCtr = 6
	
	local GLOW_OPTIONS = {
		["combat"] = {
			["off"] = "Out Of Combat",
			["on"] = "In Combat",
			["all"] = "Always",
		},
		["cooldown"] = {
			["off"] = "Not On Cooldown",
			["on"] = "On Cooldown",
			["all"] = "Always",
		},
		["debuff"] = {
			["off"] = "Debuff Missing",
			["on"] = "Debuff Active",
			["all"] = "Always",
		},
		["buff"] = {
			["off"] = "Buff Missing",
			["on"] = "Buff Active",
			["all"] = "Always",
		},
		["charges"] = {},
		["interrupt"] = {},
	}
	
	for k,v in pairs(auras.auras) do
		local aura = SSA[k]
		
		if (v.glow) then
			for i=1,#v.glow.triggers do
				local trigger = v.glow.triggers[i]
				
				if (GLOW_OPTIONS[trigger.type] and v.group == grp) then
					
					auraTbl["aura"..v.order].args["glow_"..i] = {
						order = orderCtr + i,
						type = "group",
						name = trigger.name or "No Table "..i,
						hidden = not v.isCustomize,
						args = {
							toggle = {
								order = 1,
								type = "toggle",
								name = "Enable",
								get = function()
									return trigger.isEnabled
								end,
								set = function(this,value)
									trigger.isEnabled = value
								end,
								width = 0.47,
							},
							--[[filler_moveUp = {
								order = 2,
								type = "description",
								name = '',
								hidden = function()
									return ((i ~= 1 and #v.glow.triggers ~= 1) and true) or false
								end,
								width = 0.17,
							},]]
							moveUp = {
								order = 2,
								type = "execute",
								name = ' ',
								desc = "Increase Glow Priority",
								image = [[Interface\AddOns\ShamanAuras2\media\icons\config\move-up-glow]],
								imageWidth = 25,
								imageHeight = 25,
								disabled = function()
									return ((i == 1 or #v.glow.triggers == 1)and true) or false
								end,
								func = function(this)
									ReorderAuraGlow(k,v.glow.triggers,i,i-1)
									Auras:RefreshAuraGroupList(this.options,SSA.spec)
									--val.priority = val.priority - 1
									
									--Auras:RefreshAuraGroupList(this.options,spec)
									--[[ReorderAuraList(spec,grp,v.order - 1,v.order,"swap")
									v.order = v.order - 1
									
									Auras:RefreshAuraGroupList(this.options,spec)
									Auras:UpdateTalents()]]
								end,
								width = 0.17,
							},
							--[[filler_moveDown = {
								order = 3,
								type = "description",
								name = '',
								hidden = function()
									return (i ~= #v.glow.triggers and true) or false
								end,
								width = 0.17,
							},]]
							moveDown = {
								order = 3,
								type = "execute",
								name = ' ',
								desc = "Decrease Glow Priority",
								image = [[Interface\AddOns\ShamanAuras2\media\icons\config\move-down-glow]],
								imageWidth = 25,
								imageHeight = 25,
								disabled = function()
									return (i == #v.glow.triggers and true) or false
								end,
								--disabled = function()
									--return auras.groups[grp].auraCount <= 1
								--end,
								func = function(this)
									ReorderAuraGlow(k,v.glow.triggers,i,i+1)
									Auras:RefreshAuraGroupList(this.options,SSA.spec)
									--val.priority = val.priority + 1
									
									--[[ReorderAuraList(spec,grp,v.order + 1,v.order,"swap")
									v.order = v.order + 1
									
									Auras:RefreshAuraGroupList(this.options,spec)
									Auras:UpdateTalents()]]
								end,
								width = 0.17,
							},
							requiredTarget = {
								order = 4,
								type = "execute",
								name = ' ',
								desc = function()
									if (trigger.target.reaction ~= "off") then
										if (trigger.target.reaction == "enemy") then
											return "|cFFFF0000Enemy|r target currently required.\n-------------------------------------\n|cFFFFe961Click to require any target.|r\n\n|cFF00FF00Shift+Click to require a friendly target.|r\n\n|cFF888888Alt+Click to disable target requirement.|r\n-------------------------------------\nRecommended: "..trigger.target.recommend
										elseif (trigger.target.reaction == "friend") then
											return "|cFF00FF00Friendly|r target currently required.\n-------------------------------------\n|cFFFFe961Click to require any target.|r\n\n|cFFFF0000Ctrl+Click to require an enemy target.|r\n\n|cFF888888Alt+Click to disable target requirement.|r\n-------------------------------------\nRecommended: "..trigger.target.recommend
										elseif (trigger.target.reaction == "all") then
											return "Any target currently required.\n-------------------------------------\n|cFF00FF00Shift+Click to require a friendly target.|r\n\n|cFFFF0000Ctrl+Click to require an enemy target.|r\n\n|cFF888888Alt+Click to disable target requirement.|r\n-------------------------------------\nRecommended: "..trigger.target.recommend
										end
									else
										return "Target currently not required.\n-------------------------------------\n|cFFFFe961Click to require any target.|r\n\n|cFF00FF00Shift+Click to require a friendly target.|r\n\n|cFFFF0000Ctrl+Click to require an enemy target.|r\n\n|cFF888888Alt+Click to disable target requirement.|r\n-------------------------------------\nRecommended: "..trigger.target.recommend
									end
								end,
								disabled = function()
									if (trigger.target.locked) then
										return true
									else
										return false
									end
								end,
								image = function()
									if (trigger.target.reaction ~= "off") then
										return [[Interface\AddOns\ShamanAuras2\media\icons\config\target-]]..trigger.target.reaction
									else
										return [[Interface\AddOns\ShamanAuras2\media\icons\config\target-disabled]]
									end
								end,
								imageWidth = 25,
								imageHeight = 25,
								func = function(this)
									if (IsShiftKeyDown()) then
										trigger.target.reaction = "friend"
									elseif (IsControlKeyDown()) then
										trigger.target.reaction = "enemy"
									elseif (IsAltKeyDown()) then
										trigger.target.isRequired = "off"
									else
										trigger.target.reaction = "all"
									end
									
									--trigger.isTargetRequired = not trigger.isTargetRequired
									--ReorderAuraGlow(k,v.glow.triggers,i,i+1)
									Auras:RefreshAuraGroupList(this.options,SSA.spec)
									--val.priority = val.priority + 1
									
									--[[ReorderAuraList(spec,grp,v.order + 1,v.order,"swap")
									v.order = v.order + 1
									
									Auras:RefreshAuraGroupList(this.options,spec)
									Auras:UpdateTalents()]]
								end,
								width = 0.3,
							},
							filler = {
								order = 5,
								type = "description",
								name = '',
								width = 0.05,
							},
							--[[filler_skull = {
								order = 5,
								type = "description",
								name = '',
								width = 0.3,
							},]]
							filler_show = {
								order = 6,
								hidden = function()
									if (not trigger.show) then
										return false
									else
										return true
									end
								end,
								type = "description",
								name = '',
								width = 0.8,
							},
							show = {
								order = 6,
								type = "select",
								name = "Show",
								hidden = function()
									if (not trigger.show) then
										return true
									else
										return false
									end
								end,
								get = function()
									return trigger.show
								end,
								set = function(this,value)
									trigger.show = value
								end,
								values = GLOW_OPTIONS[trigger.type],
								width = 0.8,
							},
							combat = {
								order = 7,
								type = "select",
								name = "Combat",
								get = function()
									return trigger.combat
								end,
								set = function(this,value)
									trigger.combat = value
								end,
								values = GLOW_OPTIONS["combat"],
								width = 0.7,
							},
							filler_displayTime = {
								order = 8,
								type = "description",
								name = "",
								--[[hidden = function()
									if (trigger.show == "all" or trigger.show == "off" or not trigger.show) then
										return true
									elseif (trigger.show == "on") then
										return false
									end
								end,]]
								hidden = function()
									if (not trigger.displayTime) then
										return false
									else
										return true
									end
								end,
								width = 0.9,
							},
							displayTime = {
								order = 8,
								type = "range",
								name = "Glow Duration",
								desc = function()
									if (trigger.type == "cooldown") then
										return "The number of seconds that the glow will display after this spell's cooldown concludes.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r"
									elseif (trigger.type == "buff" or trigger.type == "debuff") then
										return "The number of seconds that the glow will display after the "..((trigger.type == "buff" and "buff") or "debuff").." is no longer active.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r"
									else
										return "The number of seconds that the glow will display after being triggered.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r"
									end
								end,
								hidden = function()
									if (not trigger.displayTime) then
										return true
									else
										return false
									end
								end,
								disabled = function()
									if (trigger.show == "on") then
										return true
									elseif (trigger.show == "all" or trigger.show == "off") then
										return false
									end
								end,
								min = 0,
								max = 10,
								step = 1,
								bigStep = 1,
								get = function()
									return trigger.displayTime
								end,
								set = function(this,value)
									trigger.displayTime = value
								end,
								width = 0.9,
							},
							filler_threshold = {
								order = 9,
								type = "description",
								name = "",
								hidden = function()
									if (not trigger.threshold) then
										return false
									else
										return true
									end
								end,
								width = 0.9,
							},
							pulseRate = {
								order = 10,
								type = "range",
								name = "Pulse Rate",
								desc = "Causes the glow animation to \"pulse\". This value sets the amount of seconds that will elapse between each pulse.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r",
								min = 0,
								max = 10,
								step = 0.5,
								bigStep = 0.5,
								get = function()
									return trigger.pulseRate
								end,
								set = function(this,value)
									-- Prevent the user from manually entering a value below 0.5 seconds
									if (value < 0.5 and value > 0 ) then
										value = 0.5
									end
									
									trigger.pulseRate = value
								end,
								width = 0.9,
							},
							threshold = {
								order = 11,
								type = "range",
								name = "Trigger Threshold",
								desc = "Select the threshold at which the glow will trigger.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r",
								hidden = function()
									if (not trigger.threshold) then
										return true
									else
										return false
									end
								end,
								min = trigger.min or 0,
								max = trigger.charges or trigger.duration or 0,
								step = 1,
								bigStep = 1,
								get = function()
									return trigger.threshold
								end,
								set = function(this,value)
									trigger.threshold = value
									
									if ((aura.charges or 1000) <= trigger.threshold) then
										trigger.start = GetTime()
									end
								end,
								width = 0.9,
							},
						},
					}
				end
			end
		end
		
		--[[if (v.group == grp and v.glow) then
			for key,val in pairs(v.glow.triggers) do
				if (v.glow.triggers[key] and GLOW_OPTIONS[key]) then
					local _,valType = next(val)
					
					if (type(valType) == "table") then
						print("TABLE: "..k.." ("..key..", "..type(val)..", "..type(valType)..")")
						for keys,vals in pairs(val) do
							auraTbl["aura"..v.order].args["glow_"..key.."_"..keys] = {
								order = orderCtr + (vals.priority or 0),
								type = "group",
								name = vals.groupName or "No Tables "..keys,
								hidden = not v.isCustomize,
								args = {
									toggle = {
										order = 1,
										type = "toggle",
										name = "Enable",
										get = function()
											return vals.isEnabled
										end,
										set = function(this,value)
											vals.isEnabled = value
										end,
										width = 0.5,
									},
									filler_moveUp = {
										order = 2,
										type = "description",
										name = '',
										hidden = function()
											return ((vals.priority ~= 1 and v.glow.triggers.numTriggers ~= 1) and true) or false
										end,
										width = 0.25,
									},
									moveUp = {
										order = 2,
										type = "execute",
										name = '',
										desc = "Increase Glow Priority",
										image = "Interface\\AddOns\\ShamanAuras2\\media\\icons\\config\\move-up-glow",
										imageWidth = 25,
										imageHeight = 25,
										hidden = function()
											return ((vals.priority == 1 or v.glow.triggers.numTriggers == 1)and true) or false
										end,
										disabled = function()
											--return auras.groups[grp].auraCount <= 1
										end,
										func = function(this)
											--ReorderAuraList(spec,grp,v.order - 1,v.order,"swap")
											--v.order = v.order - 1
											
											--Auras:RefreshAuraGroupList(this.options,spec)
											--Auras:UpdateTalents()
										end,
										width = 0.25,
									},
									filler_moveDown = {
										order = 3,
										type = "description",
										name = '',
										hidden = function()
											return (vals.priority ~= v.glow.triggers.numTriggers and true) or false
										end,
										width = 0.25,
									},
									moveDown = {
										order = 3,
										type = "execute",
										name = '',
										desc = "Decrease Glow Priority",
										image = "Interface\\AddOns\\ShamanAuras2\\media\\icons\\config\\move-down-glow",
										imageWidth = 25,
										imageHeight = 25,
										hidden = function()
											return (vals.priority == v.glow.triggers.numTriggers and true) or false
										end,
										disabled = function()
											--return auras.groups[grp].auraCount <= 1
										end,
										func = function(this)
											--ReorderAuraList(spec,grp,v.order + 1,v.order,"swap")
											--v.order = v.order + 1
											
											--Auras:RefreshAuraGroupList(this.options,spec)
											--Auras:UpdateTalents()
										end,
										width = 0.25,
									},
									filler_show = {
										order = 4,
										hidden = not vals.disableShow,
										type = "description",
										name = '',
										width = 0.8,
									},
									show = {
										order = 4,
										type = "select",
										name = "Show",
										hidden = vals.disableShow,
										get = function()
											return vals.show
										end,
										set = function(this,value)
											vals.show = value
										end,
										values = GLOW_OPTIONS[key],
										width = 0.8,
									},
									combat = {
										order = 5,
										type = "select",
										name = "Combat",
										get = function()
											return vals.combat
										end,
										set = function(this,value)
											vals.combat = value
										end,
										values = GLOW_OPTIONS["combat"],
										width = 0.8,
									},
									filler = {
										order = 6,
										type = "description",
										name = "",
										width = 0.8,
									},
									displayTime = {
										order = 7,
										type = "range",
										name = "Glow Duration",
										hidden = function()
											if (vals.show == "on") then
												return true
											elseif (vals.show == "all" or vals.show == "off") then
												return false
											end
										end,
										min = 0,
										max = 10,
										step = 1,
										bigStep = 1,
										get = function()
											return vals.displayTime
										end,
										set = function(this,value)
											vals.displayTime = value
										end,
										width = 0.8,
									},
									threshold = {
										order = 8,
										type = "range",
										name = "Trigger Time",
										min = vals.min,
										max = vals.max,
										hidden = function()
											if (not vals.threshold) then
												return true
											else
												return false
											end
										end,
										step = 1,
										bigStep = 1,
										get = function()
											return vals.threshold
										end,
										set = function(this,value)
											vals.threshold = value
										end,
										width = 0.8,
									},
								},
							}
							--orderCtr = orderCtr + 1
						end
					else
						print("SOLO: "..k.." ("..key..", "..type(val)..", "..type(valType)..")")
						auraTbl["aura"..v.order].args["glow_"..key] = {
							order = orderCtr + (val.priority or 0),
							type = "group",
							name = val.groupName or "No Table "..key,
							hidden = not v.isCustomize,
							args = {
								toggle = {
									order = 1,
									type = "toggle",
									name = "Enable",
									get = function()
										return val.isEnabled
									end,
									set = function(this,value)
										val.isEnabled = value
									end,
									width = 0.56,
								},
								filler_moveUp = {
									order = 2,
									type = "description",
									name = '',
									hidden = function()
										return ((val.priority ~= 1 and v.glow.triggers.numTriggers ~= 1) and true) or false
									end,
									width = 0.17,
								},
								moveUp = {
									order = 2,
									type = "execute",
									name = ' ',
									desc = "Increase Glow Priority",
									image = "Interface\\AddOns\\ShamanAuras2\\media\\icons\\config\\move-up-glow",
									imageWidth = 25,
									imageHeight = 25,
									hidden = function()
										return ((val.priority == 1 or v.glow.triggers.numTriggers == 1)and true) or false
									end,
									disabled = function()
										--return auras.groups[grp].auraCount <= 1
									end,
									func = function(this)
										val.priority = val.priority - 1
										--Auras:RefreshAuraGroupList(this.options,spec)
										--ReorderAuraList(spec,grp,v.order - 1,v.order,"swap")
										--v.order = v.order - 1
										
										--Auras:RefreshAuraGroupList(this.options,spec)
										--Auras:UpdateTalents()
									end,
									width = 0.17,
								},
								filler_moveDown = {
									order = 3,
									type = "description",
									name = '',
									hidden = function()
										return (val.priority ~= v.glow.triggers.numTriggers and true) or false
									end,
									width = 0.17,
								},
								moveDown = {
									order = 3,
									type = "execute",
									name = ' ',
									desc = "Decrease Glow Priority",
									image = "Interface\\AddOns\\ShamanAuras2\\media\\icons\\config\\move-down-glow",
									imageWidth = 25,
									imageHeight = 25,
									hidden = function()
										--print("PRIORITY: "..tostring(val.priority)..", TRIGGERS: "..tostring(v.glow.triggers.numTriggers))
										return (val.priority == v.glow.triggers.numTriggers and true) or false
									end,
									disabled = function()
										--return auras.groups[grp].auraCount <= 1
									end,
									func = function(this)
										val.priority = val.priority + 1
										--ReorderAuraList(spec,grp,v.order + 1,v.order,"swap")
										--v.order = v.order + 1
										
										--Auras:RefreshAuraGroupList(this.options,spec)
										--Auras:UpdateTalents()
									end,
									width = 0.17,
								},
								filler_show = {
									order = 4,
									hidden = not val.disableShow,
									type = "description",
									name = '',
									width = 0.9,
								},
								show = {
									order = 4,
									type = "select",
									name = "Show",
									hidden = val.disableShow,
									get = function()
										return val.show
									end,
									set = function(this,value)
										val.show = value
									end,
									values = GLOW_OPTIONS[key],
									width = 0.9,
								},
								combat = {
									order = 5,
									type = "select",
									name = "Combat",
									get = function()
										return val.combat
									end,
									set = function(this,value)
										val.combat = value
									end,
									values = GLOW_OPTIONS["combat"],
									width = 0.9,
								},
								filler_displayTime = {
									order = 6,
									type = "description",
									name = "",
									hidden = function()
										if (val.show == "all" or val.show == "off" or not val.show) then
											return true
										elseif (val.show == "on") then
											return false
										end
									end,
									width = 0.9,
								},
								displayTime = {
									order = 7,
									type = "range",
									name = "Glow Duration",
									desc = "The number of seconds that the glow will display after being triggered.\n\n|cFFFF0000Setting this value to 0 disables this functionality.|r",
									hidden = function()
										if (val.show == "on") then
											return true
										elseif (val.show == "all" or val.show == "off") then
											return false
										end
									end,
									min = 0,
									max = 10,
									step = 1,
									bigStep = 1,
									get = function()
										return val.displayTime
									end,
									set = function(this,value)
										val.displayTime = value
									end,
									width = 0.9,
								},
								pulseRate = {
									order = 8,
									type = "range",
									name = "Pulse Rate",
									min = 0.5,
									max = 10,
									step = 1,
									bigStep = 1,
									get = function()
										return val.pulseRate
									end,
									set = function(this,value)
										val.pulseRate = value
									end,
									width = 0.9,
								},
								threshold = {
									order = 9,
									type = "range",
									name = "Trigger Threshold",
									min = val.min,
									max = val.max,
									step = 1,
									bigStep = 1,
									get = function()
										return val.threshold
									end,
									set = function(this,value)
										val.threshold = value
									end,
									width = 0.9,
								},
							},
						}
						--orderCtr = orderCtr + 1
					end
				elseif (key == "interrupt") then
					auraTbl["aura"..v.order].args["glow_"..key] = {
						order = orderCtr,
						type = "group",
						name = val.groupName,
						hidden = not v.isCustomize,
						args = {
							toggle = {
								order = 1,
								type = "toggle",
								name = "Enable",
								get = function()
									return val.isEnabled
								end,
								set = function(this,value)
									val.isEnabled = value
								end,
								width = 2,
							},
							combat = {
								order = 2,
								type = "select",
								name = "Combat",
								get = function()
									return val.combat
								end,
								set = function(this,value)
									val.combat = value
								end,
								values = GLOW_OPTIONS["combat"],
								width = 1,
							},
						},
					}
					
					orderCtr = orderCtr + 1
				end
			end
		end]]
	end
	_G["SSA_AURA_TABLE"] = auraTbl
end

local function BuildCurrentAuraList(db,spec,grp)
	-- Build List of currently used auras for each group
	local auraTbl = {}
	local auras = Auras.db.char.auras[spec]

	for k,v in pairs(auras.auras) do
		local aura = SSA[k]
		
		if (v.group == grp) then
			auraTbl["aura"..v.order] = {
				order = v.order,
				type = "group",
				guiInline = true,
				name = " ",
				args = {
					auraName = {
						order = 1,
						type = "description",
						name = function()
							local name,_,icon = GetSpellInfo(aura.spellID)
							
							if (name) then
								return "|T"..icon..":20|t "..tostring(name)
							end
						end,
						width = "normal",
					},
					--[[moveUp_Filler = {
						order = 2,
						type = "description",
						name = "",
						hidden = function()
							return not (v.order == 1 and true) or false
						end,
						width = 0.25,
					},]]
					moveUp = {
						order = 2,
						type = "execute",
						--[[name = function()
							if (auras.groups[grp].auraCount <= 1) then
								return "|cFF777777Move Up|r"
							else
								return "Move Up"
							end
						end,]]
						name = '',
						image = [[Interface\AddOns\ShamanAuras2\media\icons\config\move-up]],
						imageWidth = 25,
						imageHeight = 25,
						disabled = function()
							return (v.order == 1 and true) or false
						end,
						--[[disabled = function()
							return auras.groups[grp].auraCount <= 1
						end,]]
						func = function(this)
							ReorderAuraList(spec,grp,v.order - 1,v.order,"swap")
							v.order = v.order - 1
							
							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = 0.25,
					},
					--[[moveDown_Filler = {
						order = 3,
						type = "description",
						name = "",
						hidden = function()
							return not (v.order == #auras.groups and true) or false
						end,
						width = 0.25,
					},]]
					moveDown = {
						order = 3,
						type = "execute",
						--[[name = function()
							if (auras.groups[grp].auraCount <= 1) then
								return "|cFF777777Move Down|r"
							else
								return "Move Down"
							end
						end,]]
						name = '',
						image = [[Interface\AddOns\ShamanAuras2\media\icons\config\move-down]],
						imageWidth = 25,
						imageHeight = 25,
						disabled = function()
							return (v.order == auras.groups[grp].auraCount and true) or false
						end,
						--[[disabled = function()
							return auras.groups[grp].auraCount <= 1
						end,]]
						func = function(this)
							ReorderAuraList(spec,grp,v.order + 1,v.order,"swap")
							v.order = v.order + 1
							
							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = 0.25,
					},
					removeAura = {
						order = 4,
						type = "execute",
						--name = "Remove",
						name = '',
						image = [[Interface\AddOns\ShamanAuras2\media\icons\config\remove]],
						imageWidth = 25,
						imageHeight = 25,
						func = function(this)
							ReorderAuraList(spec,grp,v.order,nil,"remove")
							v.group = 0
							v.order = 0
							v.isInUse = false
							auras.groups[grp].auraCount = auras.groups[grp].auraCount - 1

							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = 0.25,
					},
					customize = {
						order = 5,
						type = "toggle",
						name = "Configure Glow",
						get = function()
							return v.isCustomize
						end,
						set = function(this,value)
							v.isCustomize = value
							
							--[[print(barTitle.." ("..grp..")")
							for k,v in pairs(auras.auras) do
								if (v.group == grp and k ~= barTitle) then
									--print(k)
									v.isCustomize = false
								end
							end]]
							
							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
							
							--[[if (value) then
								SSA[barTitle]:Show()
							end]]
						end,
						width = 0.75,
					},
					--[[customizeAura = {
						order = 6,
						type = "group",
						name = "Glow Customization",
						hidden = not v.isCustomize,
						args = {
							toggle = {
								order = 1,
								type = "toggle",
								name = "Toggle",
								--description = "TEST",
								get = function()
									return v.glow.isEnabled
								end,
								set = function(this,value)
									v.glow.isEnabled = value
								end,
								width = 0.5,
							},
							trigger = {
								order = 2,
								type = "select",
								name = "Glow Trigger",
								--description = "TEST",
								disabled = function()
									local triggerCtr = 0
									
									for key,val in pairs(v.glow.triggers) do
										if (type(val) == "table") then
											triggerCtr = triggerCtr + 1
										end
									end
									
									return triggerCtr == 1 or not v.glow.isEnabled
								end,
								get = function()
									return v.glow.triggers.selected
								end,
								set = function(this,value)
									v.glow.triggers.selected = value
								end,
								values = function()
									local items = {}
									
									for key,val in pairs(v.glow.triggers) do
										if (type(val) == "table") then
											items[key] = gsub(key, "^%a", string.upper)
										end
									end
									
									return items
								end,
								width = 1,
							},
							combat_state = {
								order = 3,
								type = "select",
								name = "Combat Settings",
								--description = "TEST",
								disabled = function()
									return not v.glow.isEnabled
								end,
								get = function()
									return v.glow.states.combat
								end,
								set = function(this,value)
									v.glow.states.combat = value
								end,
								values = {
									["yes"] = "In Combat",
									["not"] = "Not In Combat",
									["both"] = "Always",
								},
								width = 0.75,
							},
							usable_state = {
								order = 4,
								type = "select",
								name = "Show",
								disabled = function()
									return not v.glow.isEnabled
								end,
								get = function()
									return v.glow.states.usable
								end,
								set = function(this,value)
									v.glow.states.usable = value
								end,
								values = {
									["off"] = "Off Cooldown",
									["no"] = "On Cooldown",
									["always"] = "Always",
								},
								width = 0.75,
							},
							time_slider = {
								order = 5,
								type = "range",
								name = "Trigger Time",
								hidden = function()
									if (not v.glow.triggers.time) then
										return true
									else
										return false
									end
								end,
								min = (v.glow.triggers.time and v.glow.triggers.time.min) or 0,
								max = (v.glow.triggers.time and v.glow.triggers.time.max) or 0,
								step = 1,
								bigStep = 1,
								get = function()
									return v.glow.triggers.time.setTime
								end,
								set = function(this,value)
									v.glow.triggers.time.setTime = value
								end,
							},
							--textureColor = Auras:Color_VerifyDefaults(timerbars.bars[barTitle].layout,2,spec,L["LABEL_STATUSBAR_COLOR"],nil,false,"normal",false,'color','Timerbar',grp,true),
							--texture = Auras:Select_VerifyDefaults(timerbars.bars[barTitle].layout,3,spec,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),"normal",false,'texture','Timerbar',grp,true),
						},
						width = "full",
					},]]
				},
				width = "full",
			}
		end
	end
	
	AddGlowTools(auraTbl,grp)
	
	return auraTbl
end

function Auras:RefreshAuraGroupList(options,spec)
	local args = {}
	local orderCtr = 2
	local db = Auras.db.char
	local auras = Auras.db.char.auras[spec]
	local templates = Auras.db.char.auras.templates
	local groupName,groupOrientation = '','Horizontal'
	local listPos = 0
	local selectedAura = 1
	local isLayoutToggle = false
	local AURA_LIST, AURA_NAME,sortTable = {},{},{}
	
	args["addGroup"] = {
		order = 1,
		type = "execute",
		name = "Add Group",
		disabled = function() return not db.settings[spec].display.isShowAuras end,
		func = function(this)
			local numGroups = #auras.groups
			
			auras.groups[numGroups + 1] = {}
			auras.cooldowns.groups[numGroups + 1] = {}
			auras.frames[numGroups + 1] = {}
			--db.auras[spec].groups[numGroups + 1] = {}
			
			Auras:CopyTableValues(auras.groups[numGroups + 1],templates.groups)
			Auras:CopyTableValues(auras.cooldowns.groups[numGroups + 1],templates.cooldowns)
			Auras:CopyTableValues(auras.frames[numGroups + 1],templates.frames)

			if (groupName == '') then
				auras.groups[numGroups + 1].name = "Group #"..(numGroups + 1)
			else
				auras.groups[numGroups + 1].name = groupName
			end
			
			auras.groups[numGroups + 1].orientation = groupOrientation
			--db.layout[spec].auras.groupCount = db.layout[spec].auras.groupCount + 1
			
			--[[if (not SSA["AuraGroup"..#auras.groups]) then
				local AuraGroup = Auras:CreateGroup("AuraGroup",SSA.AuraBase,#auras.groups)
				
				AuraGroup:SetWidth(50)
				AuraGroup:SetHeight(50)
				AuraGroup:SetPoint("CENTER",0,0)
			end]]
			Auras:BuildAuraGroups()
			Auras:RefreshAuraGroupList(this.options,spec)
		end,
	}
	
	-- Build the list of auras
	for k,_ in pairs(auras.auras) do
		tinsert(sortTable,k)
	end
	
	table.sort(sortTable)
	
	for i=1,#sortTable do
		--local name,_,icon = GetSpellInfo(auras.auras[sortTable[i]].spellID)
		local name,_,icon = GetSpellInfo(SSA[sortTable[i]].spellID)
	
		if (not auras.auras[sortTable[i]].isInUse) then
			--tinsert(AURA_LIST,"|T"..tostring(icon)..":0|t "..tostring(name)..";"..sortTable[i])
			tinsert(AURA_LIST,"|T"..tostring(icon)..":0|t "..tostring(name))
			tinsert(AURA_NAME,sortTable[i])
		end
	end
	
	if (#AURA_LIST == 0) then
		selectedAura = 1
		AURA_LIST = {
			[1] = "All auras in use",
		}
	end

	args["groupName"] = {
		order = 2,
		type = "input",
		name = "Group Name (Optional)",
		disabled = function() return not db.settings[spec].display.isShowAuras end,
		get = function()
			return groupName
		end,
		set = function(this,value)
			groupName = value
		end,
		width = "normal",
	}
	
	args["groupOrientation"] = {
		order = 3,
		type = "select",
		name = "Orientation",
		get = function()
			return groupOrientation
		end,
		set = function(this,value)
			groupOrientation = value
		end,
		values = {
			["Horizontal"] = "Horizontal",
			["Vertical"] = "Vertical",
		},
		width = 0.75,
	}
	
	args["toggle"] = {
		order = 4,
		type = "toggle",
		name = "Enabled",
		desc = "Enable or disable the aura builder.\n\n|cFFFF0000Disabling this will hide all the auras for this specialization.|r",
		get = function()
			return db.settings[spec].display.isShowAuras
		end,
		set = function(this,value)
			db.settings[spec].display.isShowAuras = value
			self:UpdateTalents()
		end,
		width = 0.4,
	}
	
	args["groupList"] = {
		order = 5,
		type = "group",
		name = "Group List",
		inline = false,
		disabled = function() return not db.settings[spec].display.isShowAuras end,
		args = {
		
		}
	}
	
	for i=1,#auras.groups do
		args["groupTab"..i] = {
			order = i+5,
			type = "group",
			childGroups = "tab",
			name = function()
				local name = auras.groups[i].name
				if (name == '') then
					return "Group #"..i
				else
					return auras.groups[i].name
				end
			end,
			inline = false,
			disabled = function() return not db.settings[spec].display.isShowAuras end,
			args = {
				addAuras = {
					order = 1,
					type = "execute",
					name = "Add Aura",
					func = function(this)
						--local splitStr = {strsplit(" ",AURA_LIST[selectedAura],2)}
						--local auraName = gsub(splitStr[2]," ","")
						--local auraName = { strsplit(";",AURA_LIST[selectedAura]) }
						--auras.auras[auraName[2]].group = i
						--auras.auras[auraName[2]].isInUse = true
						--auras.spellIDs[tostring(SSA[AURA_NAME[selectedAura]].spellID)].group = i
						auras.auras[AURA_NAME[selectedAura]].group = i
						auras.auras[AURA_NAME[selectedAura]].isInUse = true
						
						if (listPos <= auras.groups[i].auraCount) then
							ReorderAuraList(spec,i,listPos,auraName,"add")	
						end
						
						--auras.auras[auraName[2]].order = listPos
						auras.auras[AURA_NAME[selectedAura]].order = listPos
						auras.groups[i].auraCount = auras.groups[i].auraCount + 1
						Auras:RefreshAuraGroupList(this.options,spec)
						Auras:UpdateTalents()
					end,
					width = "half",
				},
				auraList = {
					order = 2,
					type = "select",
					name = "Aura List",
					get = function()
						return selectedAura
					end,
					set = function(this,value)
						selectedAura = value
					end,
					values = AURA_LIST,
				},
				listPosition = {
					order = 3,
					type = "select",
					name = "Position (Optional)",
					get = function()
						if (listPos == 0) then
							listPos = auras.groups[i].auraCount + 1
							return listPos
						else
							return listPos
						end
					end,
					set = function(this,value)
						listPos = value
					end,
					values = function()
						local list = {}
						
						for i=1,(auras.groups[i].auraCount + 1) do
							tinsert(list,i)
						end
						
						return list
						
					end,
					width = "half",
				},
				--[[filler = {
					order = 5,
					type = "description",
					name = " ",
					width = "half",
				},]]
				toggleGlobalPulse = {
					order = 5,
					type = "toggle",
					name = "Pulse",
					desc = "Toggle the glow pulse for all auras within this group",
					get = function()
						if (auras.groups[i].isPulse == nil) then
							auras.groups[i].isPulse = true
						end
						return auras.groups[i].isPulse
					end,
					set = function(this,value)
						auras.groups[i].isPulse = value
						Auras:UpdateTalents()
						Auras:RefreshAuraGroupList(this.options,spec)
					end,
					width = "half",
				},
				toggleLayout = {
					order = 6,
					type = "toggle",
					name = "Layout",
					desc = "Toggle to access controls to customize the group's layout",
					get = function()
						return auras.groups[i].isAdjust
					end,
					set = function(this,value)
						auras.groups[i].isAdjust = value
						Auras:UpdateTalents()
						Auras:RefreshAuraGroupList(this.options,spec)
					end,
					width = "half",
				},
				iconSize = {
					order = 7,
					type = "range",
					name = "Icon Size",
					hidden = not auras.groups[i].isAdjust,
					min = 16,
					max = 256,
					step = 1,
					bigStep = 1,
					get = function()
						return auras.groups[i].icon
					end,
					set = function(_,value)
						auras.groups[i].icon = value
						Auras:UpdateTalents()
					end,
				},
				iconSpacing = {
					order = 8,
					type = "range",
					name = "Icon Spacing",
					hidden = not auras.groups[i].isAdjust,
					min = 32,
					max = 300,
					step = 1,
					bigStep = 1,
					get = function()
						return auras.groups[i].spacing
					end,
					set = function(_,value)
						auras.groups[i].spacing = value
						Auras:UpdateTalents()
					end,
				},
				chargeSize = {
					order = 9,
					type = "range",
					name = "Count Font Size",
					hidden = not auras.groups[i].isAdjust,
					min = 10,
					max = 60,
					step = 0.5,
					bigStep = 0.5,
					get = function()
						return auras.groups[i].charges
					end,
					set = function(_,value)
						auras.groups[i].charges = value
						Auras:UpdateTalents()
					end,
				},
				--[[renameAura = {
					order = 5,
					type = "input",
					name = "Group Name",
					validate = function(_,value)
						if (#value <= 12) then
							return true
						else
							return "Use less than 12 characters"
						end
					end,
					get = function()
						return db.layout[spec].groups[i].name
					end,
					set = function(this,value)
						db.layout[spec].groups[i].name = value
						
						Auras:RefreshAuraGroupList(this.options,spec)
					end,
				},]]
				currentAuras = {
					order = 10,
					type = "group",
					name = "Current Auras",
					inline = true,
					args = BuildCurrentAuraList(Auras.db.char,spec,i),
				},
			}
		}
		
		
		args.groupList.args["AuraGroup"..i] = {
			order = i,
			name = ' ',
			type = "group",
			guiInline = true,
			--disabled = function() return not db.settings[spec].display.isShowAuras end,
			args = {
				groupTitle = {
					order = 1,
					type = "input",
					--[[name = function()
						local name = db.layout[spec].groups[i].name
						if (name == '') then
							return "Group #"..i
						else
							return i..". "..db.layout[spec].groups[i].name
						end
					end,]]
					name = '',
					validate = function(_,value)
						if (#value <= 12) then
							return true
						else
							return "Use less than 12 characters"
						end
					end,
					get = function()
						return auras.groups[i].name
					end,
					set = function(this,value)
						auras.groups[i].name = value
						
						Auras:RefreshAuraGroupList(this.options,spec)
					end,
					width = "normal",
				},
				numAuras = {
					order = 2,
					type = "description",
					name = "        "..auras.groups[i].auraCount.." Auras",
					width = "half",
				},
				groupOrientation = {
					order = 3,
					type = "execute",
					name = auras.groups[i].orientation,
					func = function(this)
						if (auras.groups[i].orientation == "Horizontal") then
							auras.groups[i].orientation = "Vertical"
						else
							auras.groups[i].orientation = "Horizontal"
						end
						
						Auras:RefreshAuraGroupList(this.options,spec)
						Auras:UpdateTalents()
					end,
					width = "half",
				},
				deleteGroup = {
					order = 4,
					type = "execute",
					name = DELETE,
					--confirm = true,
					func = function(this)
						tremove(auras.cooldowns.groups,i)
						--db.elements[spec].cooldowns.groups[i] = nil
						tremove(auras.groups,i)
						--db.layout[spec].groups[i] = nil
						tremove(auras.frames,i)
						UpdateSpellAuraInfo(spec,i)
						--db.elements[spec].frames.groups[i] = nil
						--db.auras[spec].groups[i] = nil
						--db.layout[spec].auras.groupCount = db.layout[spec].auras.groupCount - 1
						ReorderAuraGroups(spec,i,"delete")
						Auras:RefreshAuraGroupList(this.options,spec)
						Auras:UpdateTalents()
					end,
					width = "half",
				},
				--[[renameAura = {
					order = 5,
					type = "input",
					name = "Group Name",
					validate = function(_,value)
						if (#value <= 12) then
							return true
						else
							return "Use less than 12 characters"
						end
					end,
					get = function()
						return db.layout[spec].groups[i].name
					end,
					set = function(this,value)
						db.layout[spec].groups[i].name = value
						
						Auras:RefreshAuraGroupList(this.options,spec)
					end,
				},]]
			}
		}
	end
	
	options.args.auraGroups.args = args
end

local function BuildCurrentBarList(db,spec,grp)
	-- Build List of currently used auras for each group
	local barTbl,sortTable = {},{}
	local timerbars = db.timerbars[spec]

	for k,v in pairs(timerbars.bars) do
		if (v.layout.group == grp) then
			tinsert(sortTable,k)
		end
	end
	if (spec == 3) then
		--print("GROUP: "..tostring(grp))
	end

	table.sort(sortTable)
	
	for i=1,#sortTable do
		local barTitle = sortTable[i]
		local bar = SSA[barTitle]
		
		if ((bar.spellID == 2825 and UnitFactionGroup("player") ~= "Horde") or (bar.spellID == 32182 and UnitFactionGroup("player") ~= "Alliance")) then
			-- Bloodlust is for Horde only
			-- Heroism is for Alliance only
		else
			barTbl["bar"..i] = {
				order = i,
				type = "group",
				guiInline = true,
				name = " ",
				args = {
					barName = {
						order = 1,
						type = "description",
						name = function()
							local _,_,icon = GetSpellInfo(bar.spellID)
							
							--if (name) then
								return "|T"..icon..":20|t "..timerbars.bars[barTitle].layout.text
							--end
						end,
						width = "normal",
					},
					customize = {
						order = 2,
						type = "toggle",
						name = "Customize",
						get = function()
							return timerbars.bars[barTitle].isCustomize
						end,
						set = function(this,value)
							timerbars.bars[barTitle].isCustomize = value
							
							for k,v in pairs(timerbars.bars) do
								if (v.layout.group == grp and k ~= barTitle) then
									--print(k)
									v.isCustomize = false
								end
							end
							
							Auras:RefreshTimerBarGroupList(this.options,spec)
							Auras:UpdateTalents()
							
							if (value) then
								SSA[barTitle]:Show()
							end
						end,
						width = "normal",
					},
					--[[filler_1 = { data
						order = 3,
						type = "description",
						name = " ",
						width = "half",
					},]]
					--[[moveUp = {
						order = 2,
						type = "execute",
						name = function()
							if (db.layout[spec].timerbars.groups[grp].barCount <= 1) then
								return "|cFF777777Move Up|r"
							else
								return "Move Up"
							end
						end,
						disabled = function()
							return db.layout[spec].timerbars.groups[grp].barCount <= 1
						end,
						func = function(this)
							ReorderAuraList(spec,grp,i - 1,i,"swap")
							db.auras[spec].spells[k].aura.order = v.aura.order - 1
							
							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},
					moveDown = {
						order = 3,
						type = "execute",
						name = function()
							if (db.layout[spec].auras.groups[grp].auraCount <= 1) then
								return "|cFF777777Move Down|r"
							else
								return "Move Down"
							end
						end,
						disabled = function()
							return db.layout[spec].auras.groups[grp].auraCount <= 1
						end,
						func = function(this)
							ReorderAuraList(spec,grp,v.aura.order + 1,v.aura.order,"swap")
							db.auras[spec].spells[k].aura.order = v.aura.order + 1
							
							Auras:RefreshAuraGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},]]
					--[[filler = {
						order = 2,
						type = "description",
						name = " ",
						width = "normal",
					},]]
					removeBar = {
						order = 4,
						type = "execute",
						name = "Remove",
						func = function(this)
							--RefreshBarList(spec,grp,i,nil,"remove")
							timerbars.bars[barTitle].layout.group = 0
							timerbars.bars[barTitle].isInUse = false
							timerbars.bars[barTitle].isAdjust = false
							timerbars.bars[barTitle].isCustomize = false
							timerbars.groups[grp].barCount = timerbars.groups[grp].barCount - 1

							Auras:RefreshTimerBarGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},
					customizeGroup = {
						order = 5,
						type = "group",
						name = "Customization Tools",
						hidden = not timerbars.bars[barTitle].isCustomize,
						args = {
							textureColor = Auras:Color_VerifyDefaults(timerbars.bars[barTitle].layout,2,spec,L["LABEL_STATUSBAR_COLOR"],nil,false,"normal",false,'color','Timerbar',grp,true),
							texture = Auras:Select_VerifyDefaults(timerbars.bars[barTitle].layout,3,spec,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),"normal",false,'texture','Timerbar',grp,true),
						},
						width = "full",
					},
				},
				width = "full",
			}
		end
	end
	
	return barTbl
end

function Auras:RefreshTimerBarGroupList(options,spec)
	local args = {}
	local orderCtr = 2
	local db = Auras.db.char
	local groupName,groupOrientation = '','Vertical'
	--local listPos = 0
	local selectedBar = 1
	local isLayoutToggle = false
	local timerbars = Auras.db.char.timerbars[spec]
	local BAR_LIST, sortTable = {},{}
	
	args["addGroup"] = {
		order = 1,
		type = "execute",
		name = "Add Group",
		disabled = function() return not db.settings[spec].display.isShowTimerbars end,
		func = function(this)
			local numGroups = #timerbars.groups
			
			timerbars.groups[numGroups + 1] = {}
			timerbars.frames[numGroups + 1] = {}
			
			Auras:CopyTableValues(timerbars.groups[numGroups + 1],Auras.db.char.timerbars.templates.groups)
			Auras:CopyTableValues(timerbars.frames[numGroups + 1],Auras.db.char.timerbars.templates.frames)

			if (groupName == '') then
				timerbars.groups[numGroups + 1].name = "Group #"..(numGroups + 1)
			else
				timerbars.groups[numGroups + 1].name = groupName
			end
			
			timerbars.groups[numGroups + 1].layout.orientation = groupOrientation
			--db.layout[spec].timerbars.groupCount = db.layout[spec].timerbars.groupCount + 1
			
			if (not SSA["BarGroup"..#timerbars.groups]) then
				local BarGroup = Auras:CreateGroup("BarGroup",SSA.AuraBase,#timerbars.groups)
				
				BarGroup:SetWidth(50)
				BarGroup:SetHeight(50)
				BarGroup:SetPoint("CENTER",0,0)
			end
			Auras:RefreshTimerBarGroupList(this.options,spec)
		end,
	}
	
	-- Build the list of timer bars
	for k,_ in pairs(timerbars.bars) do
		tinsert(sortTable,k)
	end
	
	table.sort(sortTable)
	
	for i=1,#sortTable do
		local barTitle = sortTable[i]
		local bar = SSA[barTitle]
		local _,_,icon = GetSpellInfo(bar.spellID)
	
		-- If the bar is enabled, but not currently in use, show it in the "Available Bars" list
		if (timerbars.bars[barTitle].isEnabled and not timerbars.bars[barTitle].isInUse) then
			tinsert(BAR_LIST,"|T"..icon..":0|t "..timerbars.bars[barTitle].layout.text..";"..barTitle)
		end
	end
	
	if (#BAR_LIST == 0) then
		selectedBar = 1
		BAR_LIST = {
			[1] = "All timer bars in use",
		}
	end

	args["groupName"] = {
		order = 2,
		type = "input",
		name = "Group Name (Optional)",
		disabled = function() return not db.settings[spec].display.isShowTimerbars end,
		get = function()
			return groupName
		end,
		set = function(this,value)
			groupName = value
		end,
		width = "normal",
	}
	
	args["groupOrientation"] = {
		order = 3,
		type = "select",
		name = "Orientation",
		disabled = function() return not db.settings[spec].display.isShowTimerbars end,
		get = function()
			return groupOrientation
		end,
		set = function(this,value)
			groupOrientation = value
		end,
		values = {
			["HORIZONTAL"] = "Horizontal",
			["VERTICAL"] = "Vertical",
		},
		width = 0.75,
	}
	
	args["toggle"] = {
		order = 4,
		type = "toggle",
		name = "Enabled",
		desc = "Enable or disable the timer bar builder.\n\n|cFFFF0000Disabling this will hide all the timer bars for this specialization.|r",
		get = function()
			return db.settings[spec].display.isShowTimerbars
		end,
		set = function(this,value)
			db.settings[spec].display.isShowTimerbars = value
			self:UpdateTalents()
		end,
		width = 0.4,
	}
	
	args["groupList"] = {
		order = 5,
		type = "group",
		name = "Group List",
		inline = false,
		disabled = function() return not db.settings[spec].display.isShowTimerbars end,
		args = {
		
		}
	}
	
	for i=1,#timerbars.groups do
		--if (#timerbars.groups[i] > 0) then
			args["groupTab"..i] = {
				order = i+5,
				type = "group",
				childGroups = "tab",
				name = function()
					local name = timerbars.groups[i].name
					if (name == '') then
						return "Group #"..i
					else
						return timerbars.groups[i].name
					end
				end,
				inline = false,
				disabled = function() return not db.settings[spec].display.isShowTimerbars end,
				args = {
					addBar = {
						order = 1,
						type = "execute",
						name = "Add Bar",
						disabled = timerbars.groups[i].isAdjust,
						func = function(this)
							--local splitStr = {strsplit(" ",BAR_LIST[selectedBar],2)}
							--local barName = gsub(splitStr[2]," ","")
							local barName = { strsplit(";",BAR_LIST[selectedBar]) }
							timerbars.bars[barName[2]].layout.group = i
							timerbars.bars[barName[2]].isEnabled = true
							timerbars.bars[barName[2]].isInUse = true
							
							--[[if (listPos <= db.layout[spec].timerbars.groups[i].auraCount) then
								ReorderAuraList(spec,i,listPos,barName,"add")	
							end]]

							timerbars.groups[i].barCount = timerbars.groups[i].barCount + 1
							Auras:RefreshTimerBarGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},
					barList = {
						order = 2,
						type = "select",
						name = "Timer Bar List",
						disabled = timerbars.groups[i].isAdjust,
						get = function()
							return selectedBar
						end,
						set = function(this,value)
							selectedBar = value
						end,
						values = function()
							local items = {}
							for i=1,#BAR_LIST do
								local barInfo = { strsplit(";",BAR_LIST[i]) }
								tinsert(items,barInfo[1])
							end

							return items
						end,
					},
					--[[listPosition = {
						order = 3,
						type = "select",
						name = "Position (Optional)",
						get = function()
							if (listPos == 0) then
								listPos = db.layout[spec].timerbars.groups[i].auraCount + 1
								return listPos
							else
								return listPos
							end
						end,
						set = function(this,value)
							listPos = value
						end,
						values = function()
							local list = {}
							
							for i=1,(db.layout[spec].timerbars.groups[i].auraCount + 1) do
								tinsert(list,i)
							end
							
							return list
							
						end,
						width = "half",
					},]]
					filler = {
						order = 5,
						type = "description",
						name = " ",
						width = "normal",
					},
					toggleLayout = {
						order = 6,
						type = "toggle",
						name = "Layout",
						desc = "Toggle to access controls to customize the group's layout",
						get = function()
							return timerbars.groups[i].isAdjust
						end,
						set = function(this,value)
							timerbars.groups[i].isAdjust = value
							
							Auras:UpdateTalents()
							
							for k,v in pairs(timerbars.bars) do
								if (v.layout.group == i and value) then
									v.isAdjust = true
									SSA[k]:Show()
								else
									if (timerbars.groups[v.layout.group] and timerbars.groups[v.layout.group].isAdjust) then
										timerbars.groups[v.layout.group].isAdjust = false
									end
									v.isAdjust = false
								end
							end
							
							
							Auras:RefreshTimerBarGroupList(this.options,spec)
							
							
						end,
						width = "half",
					},
					--[[barWidth = {
						order = 7,
						type = "range",
						name = "Bar Length",
						hidden = not db.layout[spec].timerbars.groups[i].isAdjust,
						min = 16,
						max = 256,
						step = 1,
						bigStep = 1,
						get = function()
							return db.layout[spec].timerbars.groups[i].layout.width
						end,
						set = function(_,value)
							db.layout[spec].timerbars.groups[i].layout.width = value
							Auras:InitializeTimerBars(spec)
							--Auras:UpdateTalents()
						end,
					},
					barHeight = {
						order = 8,
						type = "range",
						name = "Bar Width",
						hidden = not db.layout[spec].timerbars.groups[i].isAdjust,
						min = 5,
						max = 100,
						step = 1,
						bigStep = 1,
						get = function()
							return db.layout[spec].timerbars.groups[i].layout.height
						end,
						set = function(_,value)
							db.layout[spec].timerbars.groups[i].layout.height = value
							Auras:InitializeTimerBars(spec)
							--Auras:UpdateTalents()
						end,
					},
					barSpacing = {
						order = 9,
						type = "range",
						name = "Bar Spacing",
						hidden = not db.layout[spec].timerbars.groups[i].isAdjust,
						min = 5,
						max = 100,
						step = 1,
						bigStep = 1,
						get = function()
							return db.layout[spec].timerbars.groups[i].layout.spacing
						end,
						set = function(_,value)
							db.layout[spec].timerbars.groups[i].layout.spacing = value
							Auras:InitializeTimerBars(spec)
							--Auras:UpdateTalents()
						end,
					},]]
					general = {
						name = "|cFFFFFFFF"..SETTINGS.."|r",
						order = 7,
						type = "group",
						guiInline = true,
						hidden = not timerbars.groups[i].isAdjust,
						args = {
							alphaCombat = Auras:Slider_VerifyDefaults(timerbars.groups[i],1,spec,L["LABEL_ALPHA_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_COMBAT"],0,1,0.1,nil,false,'alphaCombat','Timerbar',i),
							alphaOoC = Auras:Slider_VerifyDefaults(timerbars.groups[i],2,spec,L["LABEL_ALPHA_NO_TARGET_NO_COMBAT"],L["TOOLTIP_STATUSBAR_ALPHA_NO_COMBAT"],0,1,0.1,nil,false,'alphaOoC','Timerbar',i),
						},
					},
					layout = {
						name = L["LABEL_LAYOUT_DESIGN"],
						type = "group",
						order = 8,
						hidden = not timerbars.groups[i].isAdjust,
						guiInline = true,
						args = {
							--[[texture = Auras:Select_VerifyDefaults(db.layout[spec].timerbars.groups[i].foreground,1,1,L["LABEL_STATUSBAR_TEXTURE"],L["TOOLTIP_STATUSBAR_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,'texture','Timerbar',i),
							textureColor = Auras:Color_VerifyDefaults(db.layout[spec].timerbars.groups[i].foreground,2,1,L["LABEL_STATUSBAR_COLOR"],nil,false,"double",false,'color','Timerbar',i),
							backgroundTexture = Auras:Select_VerifyDefaults(db.layout[spec].timerbars.groups[i].background,3,1,L["LABEL_STATUSBAR_BG_TEXTURE"],L["TOOLTIP_STATUSBAR_BG_TEXTURE"],"LSM30_Statusbar",LSM:HashTable(LSM.MediaType.STATUSBAR),false,'texture','Timerbar',i),
							backgroundColor = Auras:Color_VerifyDefaults(db.layout[spec].timerbars.groups[i].background,4,1,L["LABEL_STATUSBAR_BG_COLOR"],L["TOOLTIP_STATUSBAR_BG_COLOR"],true,nil,false,'color','Timerbar',i),
							backgroundToggle = Auras:Toggle_VerifyDefaults(db.layout[spec].timerbars.groups[i].adjust,5,1,L["LABEL_STATUSBAR_MODIFY_BACKGROUND"],L["TOOLTIP_TOGGLE_STATUSBAR_BG_CUSTOMIZATON"],nil,false,'showBG','Timerbar',i),]]
							width = Auras:Slider_VerifyDefaults(timerbars.groups[i].layout,6,spec,L["LABEL_WIDTH"],nil,10,250,1,nil,false,'width','Timerbar',i,true),
							height = Auras:Slider_VerifyDefaults(timerbars.groups[i].layout,7,spec,L["LABEL_HEIGHT"],nil,5,100,1,nil,false,'height','Timerbar',i,true),
							spacing = Auras:Slider_VerifyDefaults(timerbars.groups[i].layout,8,spec,L["LABEL_SPACING"],nil,5,100,1,nil,false,'spacing','Timerbar',i,true),
							growth = {
								order = 9,
								type = "select",
								name = "Bar Growth",
								get = function()
									return timerbars.groups[i].layout.growth
								end,
								set = function(this,value)
									timerbars.groups[i].layout.growth = value
									
									Auras:UpdateTalents()
									Auras:RefreshTimerBarGroupList(this.options,spec)
								end,
								values = function()
									local args = {}
									local orientation = timerbars.groups[i].layout.orientation
									
									if (orientation == "VERTICAL") then
										args["LEFT"] = "Left"
										args["RIGHT"] = "Right"
									else
										args["UP"] = "Up"
										args["DOWN"] = "Down"
									end
									
									return args
								end,
							},
							--[[anchor = {
								order = 10,
								type = "select",
								name = "Group Anchor",
								get = function()
									return db.layout[spec].timerbars.groups[i].layout.anchor
								end,
								set = function(this,value)
									db.layout[spec].timerbars.groups[i].layout.anchor = value
									
									Auras:UpdateTalents()
									Auras:RefreshTimerBarGroupList(this.options,spec)
								end,
								values = function()
									local args = {}
									local orientation = db.layout[spec].timerbars.groups[i].layout.orientation
									
									if (orientation == "VERTICAL") then
										args["LEFT"] = "Left"
										args["RIGHT"] = "Right"
									else
										args["TOP"] = "Top"
										args["Bottom"] = "Bottom"
									end
									
									return args
								end,
							},]]
						},
					},
					nametext = {
						name = L["LABEL_TEXT_SPELL"],
						type = "group",
						order = 9,
						hidden = not timerbars.groups[i].isAdjust,
						guiInline = true,
						args = {
							color = Auras:Color_VerifyDefaults(timerbars.groups[i].nametext.font,1,spec,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Timerbar',i,true),
							fontName = Auras:Select_VerifyDefaults(timerbars.groups[i].nametext.font,2,spec,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Timerbar',i,true),
							fontSize = Auras:Slider_VerifyDefaults(timerbars.groups[i].nametext.font,3,spec,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,false,'size','Timerbar',i,true),
							fontOutline = Auras:Select_VerifyDefaults(timerbars.groups[i].nametext.font,4,spec,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Timerbar',i,true),
							--nametextAnchor = Auras:Select_VerifyDefaults(db.layout[spec].timerbars.groups[i].nametext,5,spec,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Timerbar',i,true),
							--nametextX = Auras:Slider_VerifyDefaults(db.layout[spec].timerbars.groups[i].nametext,6,spec,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Timerbar',i,true),
							--nametextY = Auras:Slider_VerifyDefaults(db.layout[spec].timerbars.groups[i].nametext,7,spec,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Timerbar',i,true),
							shadow = {
								name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
								type = "group",
								order = 8,
								hidden = false,
								guiInline = true,
								args = {
									shadowToggle = Auras:Toggle_VerifyDefaults(timerbars.groups[i].nametext.font.shadow,1,spec,L["TOGGLE"],nil,nil,false,nil,'isEnabled','Timerbar',i,true),
									shadowColor = Auras:Color_VerifyDefaults(timerbars.groups[i].nametext.font.shadow,2,spec,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Timerbar',i,true),
									shadowX = Auras:Slider_VerifyDefaults(timerbars.groups[i].nametext.font.shadow.offset,3,spec,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,false,'x','Timerbar',i,true),
									shadowY = Auras:Slider_VerifyDefaults(timerbars.groups[i].nametext.font.shadow.offset,4,spec,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,false,'y','Timerbar',i,true),
								},
							},
						},
					},
					timetext = {
						name = '|cFFFFFFFF'..L["LABEL_TIME_TEXT"]..'|r',
						type = "group",
						order = 10,
						hidden = not timerbars.groups[i].isAdjust,
						guiInline = true,
						args = {
							color = Auras:Color_VerifyDefaults(timerbars.groups[i].timetext.font,1,spec,L["LABEL_FONT_COLOR"],L["TOOLTIP_FONT_COLOR"],true,"full",false,'color','Timerbar',i,true),
							fontName = Auras:Select_VerifyDefaults(timerbars.groups[i].timetext.font,2,spec,L["LABEL_FONT"],L["TOOLTIP_FONT_NAME"],"LSM30_Font",LSM:HashTable("font"),nil,false,'name','Timerbar',i,true),
							fontSize = Auras:Slider_VerifyDefaults(timerbars.groups[i].timetext.font,3,spec,FONT_SIZE,L["TOOLTIP_COOLDOWN_FONT_SIZE"],5,40,1,nil,false,'size','Timerbar',i,true),
							fontOutline = Auras:Select_VerifyDefaults(timerbars.groups[i].timetext.font,4,spec,L["LABEL_FONT_OUTLINE"],L["TOOLTIP_FONT_OUTLINE"],nil,FONT_OUTLINES,nil,false,'flag','Timerbar',i,true),
							--timetextAnchor = Auras:Select_VerifyDefaults(db.layout[spec].timerbars.groups[i].timetext,5,spec,L["LABEL_FONT_ANCHOR"],L["TOOLTIP_FONT_ANCHOR_POINT"],nil,FRAME_ANCHOR_OPTIONS,nil,false,'justify','Timerbar',i,true),
							--timetextX = Auras:Slider_VerifyDefaults(db.layout[spec].timerbars.groups[i].timetext,6,spec,"X",L["TOOLTIP_FONT_X_OFFSET"],-500,500,nil,false,'x','Timerbar',i,true),
							--timetextY = Auras:Slider_VerifyDefaults(db.layout[spec].timerbars.groups[i].timetext,7,spec,"Y",L["TOOLTIP_FONT_Y_OFFSET"],-100,100,nil,false,'y','Timerbar',i,true),
							shadow = {
								name = '|cFFFFFFFF'..L["LABEL_FONT_SHADOW"]..'|r',
								type = "group",
								order = 8,
								hidden = false,
								guiInline = true,
								args = {
									shadowToggle = Auras:Toggle_VerifyDefaults(timerbars.groups[i].timetext.font.shadow,1,spec,L["TOGGLE"],nil,nil,false,nil,'isEnabled','Timerbar',i,true),
									shadowColor = Auras:Color_VerifyDefaults(timerbars.groups[i].timetext.font.shadow,2,spec,L["LABEL_FONT_SHADOW_COLOR"],L["TOOLTIP_FONT_SHADOW_COLOR"],true,nil,false,'color','Timerbar',i,true),
									shadowX = Auras:Slider_VerifyDefaults(timerbars.groups[i].timetext.font.shadow.offset,3,spec,"X",L["TOOLTIP_FONT_SHADOW_X_OFFSET"],-10,10,0.5,nil,false,'x','Timerbar',i,true),
									shadowY = Auras:Slider_VerifyDefaults(timerbars.groups[i].timetext.font.shadow.offset,4,spec,"Y",L["TOOLTIP_FONT_SHADOW_Y_OFFSET"],-10,10,0.5,nil,false,'y','Timerbar',i,true),
								},
							},
						},
					},
					currentBars = {
						order = 11,
						type = "group",
						name = "Current Bars",
						inline = true,
						hidden = timerbars.groups[i].isAdjust,
						args = BuildCurrentBarList(Auras.db.char,spec,i),
					},
				}
			}
			
			
			args.groupList.args["BarGroup"..i] = {
				order = i,
				name = ' ',
				type = "group",
				guiInline = true,
				args = {
					groupTitle = {
						order = 1,
						type = "input",
						name = '',
						validate = function(_,value)
							if (#value <= 12) then
								return true
							else
								return "Use less than 12 characters"
							end
						end,
						get = function()
							return timerbars.groups[i].name
						end,
						set = function(this,value)
							timerbars.groups[i].name = value
							
							Auras:RefreshTimerBarGroupList(this.options,spec)
						end,
						width = "normal",
					},
					numBars = {
						order = 2,
						type = "description",
						name = "        "..timerbars.groups[i].barCount.." Bars",
						width = "half",
					},
					groupOrientation = {
						order = 3,
						type = "execute",
						name = timerbars.groups[i].layout.orientation,
						func = function(this)
							if (timerbars.groups[i].layout.orientation == "HORIZONTAL") then
								timerbars.groups[i].layout.orientation = "VERTICAL"
								timerbars.groups[i].layout.growth = "RIGHT"
							else
								timerbars.groups[i].layout.orientation = "HORIZONTAL"
								timerbars.groups[i].layout.growth = "DOWN"
							end
							
							
							Auras:RefreshTimerBarGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},
					deleteGroup = {
						order = 4,
						type = "execute",
						name = DELETE,
						--confirm = true,
						func = function(this)
							tremove(timerbars.groups,i)
							tremove(timerbars.frames,i)
							UpdateSpellTimerBarInfo(spec,i)

							--db.layout[spec].timerbars.groupCount = db.layout[spec].timerbars.groupCount - 1
							ReorderTimerBarGroups(spec,i,"delete")
							Auras:RefreshTimerBarGroupList(this.options,spec)
							Auras:UpdateTalents()
						end,
						width = "half",
					},
					--[[renameAura = {
						order = 5,
						type = "input",
						name = "Group Name",
						validate = function(_,value)
							if (#value <= 12) then
								return true
							else
								return "Use less than 12 characters"
							end
						end,
						get = function()
							return db.layout[spec].groups[i].name
						end,
						set = function(this,value)
							db.layout[spec].groups[i].name = value
							
							Auras:RefreshTimerBarGroupList(this.options,spec)
						end,
					},]]
				}
			}
		--end
	end
	
	options.args.timerbarGroups.args = args
end