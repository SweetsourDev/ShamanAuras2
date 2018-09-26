local SSA, Auras, L, LSM = unpack(select(2,...))

-- Cache Global Lua Functions
local format = string.format
local tonumber = tonumber

function Auras:Spacer(order,width)
	local spacer = {
		order = order,
		type = "description",
		name = ' ',
		width = width or "normal",
	}
	
	return spacer
end

function Auras:Execute_MoveAuras(db,order,spec,name)
	local execute = {
		order = order,
		type = "execute",
		name = name,
		func = function()
			db.isMoving = true
			SSA["Move"..spec].Info:Show()
			self:InitMoveAuraGroups(spec)
		end,
	}
	
	return execute
end

function Auras:Execute_ResetAuras(order,auraGroup,name)
	local execute = {
		order = order,
		type = "execute",
		name = name,
		func = function()
			self:ResetAuraGroupPosition(auraGroup)
		end,
	}
	
	return execute
end

--[[function Auras:Toggle_Basic(db,order,spec,name,desc,disabled,dbKey,isUpdateTalents)
	local toggle = {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		disabled = disabled,
		get = function()
			if (dbKey == "ElementalBlastBar") then
				dbKey = "ElementalBlastBarCrit"
			end
			
			return db[spec][dbKey].isEnabled
		end,
		set = function(this,value)
			if (dbKey == "ElementalBlastBar") then
				db[spec]["ElementalBlastBarCrit"].isEnabled = value
				db[spec]["ElementalBlastBarHaste"].isEnabled = value
				db[spec]["ElementalBlastBarMastery"].isEnabled = value
			else
				db[spec][dbKey].isEnabled = value
			end

			if (dbKey == "healingStreamTotemOne") then
				db.healingStreamTotemTwo = value
			end
			
			if (isUpdateTalents) then
				self:UpdateTalents()
			end
		end,
	}
	
	return toggle
end]]
function Auras:Toggle_Basic(db,order,name,desc,disabled,dbKey,isUpdateTalents)
	local toggle = {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		disabled = disabled,
		get = function()
			return db[dbKey]
		end,
		set = function(this,value)
			db[dbKey] = value
			
			if (dbKey == "healingStreamTotemOne") then
				db.healingStreamTotemTwo = value
			end
			
			if (isUpdateTalents) then
				self:UpdateTalents()
			end
		end,
	}
	
	return toggle
end

function Auras:Toggle_Cooldowns(db,order,spec,name,desc,disabled,dbKey,auraGroup,optionsGroup,optionsSubgroup)
	local toggle = {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		disabled = disabled,
		get = function()
			return db[dbKey]
		end,
		set = function(this,value)
			db[dbKey] = value
			Auras:InitializeCooldowns(auraGroup,spec)
			
			if (optionsGroup) then
				self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
			end
		end,
	}
	
	return toggle
end

function Auras:Toggle_VerifyDefaults(db,order,spec,name,desc,width,disabled,dbKey,optionsGroup,optionsSubgroup)
	local toggle = {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		disabled = disabled,
		get = function()
			return db[dbKey]
		end,
		set = function(this,value)
			db[dbKey] = value
			self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
		end,
		width = width,
	}
	
	return toggle
end

function Auras:Toggle_Statusbar(db,order,name,desc,dbKey,barName)
	if (not db) then
		print("Bad Bar: "..tostring(barName))
	end
	
	local toggle = {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
		get = function()
			return db[dbKey]
		end,
		set = function(this,value)
			if (barName) then
				if (value) then
					this.options.args.bars.args[barName].disabled = false
				else
					this.options.args.bars.args[barName].disabled = true
				end
			end

			db[dbKey] = value
		end,
	}
	
	return toggle
end

function Auras:Slider_VerifyDefaults(db,order,spec,name,desc,min,max,width,disabled,dbKey,optionsGroup,optionsSubgroup,isUpdateTalents)
	local slider = {
		order = order,
		type = "range",
		name = name,
		desc = desc,
		min = min,
		max = max,
		step = 0.1,
		bigStep = 0.1,
		disabled = disabled,
		get = function() return db[dbKey] end,
		set = function(this,value)
			db[dbKey] = value
			self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
			
			if (isUpdateTalents) then
				self:UpdateTalents()
			end
		end,
		width = width or "normal",
	}
	
	return slider
end

function Auras:Color_VerifyDefaults(db,order,spec,name,desc,hasAlpha,width,disabled,dbKey,optionsGroup,optionsSubgroup,isUpdateTalents)
	local color = {
		type = "color",
		order = order,
		name = name,
		desc = desc,
		disabled = disabled,
		hasAlpha = hasAlpha,
		get = function(info)
			local color = db[dbKey]
			return color.r, color.g, color.b, color.a
		end,
		set = function(this, r, g, b, a)
			local color = db[dbKey]
			
			color.r = tonumber(format("%.2f",r))
			color.g = tonumber(format("%.2f",g))
			color.b = tonumber(format("%.2f",b))
			color.a = tonumber(format("%.2f",a))
			self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
			
			if (isUpdateTalents) then
				self:UpdateTalents()
			end
		end,
		width = width or "normal",
	}
	
	return color
end

function Auras:Select_CooldownCopy(order,spec,name,desc,copyMethod,cdGroup,values,optionsGroup,optionsSubgroup)
	local selection = {
		order = order,
		type = "select",
		dialogControl = dialogControl,
		name = name,
		desc = desc,
		values = values,
		get = function()
			return ''
		end,
		set = function(this,value)
			if (copyMethod == "formatting") then
				self:CopyCooldownFormatting(value,spec,cdGroup)
			elseif (copyMethod == "options") then
				self:CopyCooldownOptions(value,spec,cdGroup)
			end
			
			self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
		end,
	}
	
	return selection
end

function Auras:Select_VerifyDefaults(db,order,spec,name,desc,dialogControl,values,width,disabled,dbKey,optionsGroup,optionsSubgroup,isUpdateTalents,isUpdateCooldown)
	local selection = {
		order = order,
		type = "select",
		dialogControl = dialogControl,
		name = name,
		desc = desc,
		disabled = disabled,
		values = values,
		get = function()
			return db[dbKey]
		end,
		set = function(this,value)
			db[dbKey] = value
			self:VerifyDefaultValues(spec,this.options,optionsGroup,optionsSubgroup)
			
			if (isUpdateTalents) then
				self:UpdateTalents()
			end
			
			if (isUpdateCooldown) then
				for i=1,Auras.db.char.layout[spec].auras.groupCount do
					if (db.selected == i) then
						db.groups[i].isPreview = true
					else
						db.groups[i].isPreview = false
					end
				end
				self:RefreshCooldownList(this.options,spec,db)
			end
		end,
		width = width or "normal",
	}
	
	return selection
end
