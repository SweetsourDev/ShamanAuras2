local SSA, Auras, L, LSM = unpack(select(2,...))


-- Cache Global Variables
-- Lua Function
local getn = table.getn
local floor, fmod = math.floor, math.fmod
local format, tonumber, tostring = format, tonumber, tostring
local split = string.split
-- WoW API / Variables
local GetTime = GetTime

-- Convert time, in seconds, to a timer string
function Auras:parseTime(timer,precision,isFormatted,group,msg)
	if (timer and timer > 0) then
		local m,s,ms,fs = floor(timer / 60),floor(fmod(timer,60)),(('%%.%df'):format(1)):format(fmod(timer,60),1),timer

		if (isFormatted) then
			local cd = self.db.char.auras[SSA.spec].cooldowns.groups[group]
			
			if (cd.text.formatting.length == "full") then
				if (m >= 1 and s == 0) then
					return m..":00",fs
				else
					if (m > 0) then
						m = m..":"
						if (s < 10) then
							s = "0"..s
						end
					else
						m = ''
						if (s < 0) then
							s = ''
						end
					end
				end
			elseif (cd.text.formatting.length == "short") then
				if (m >= 1) then
					return m.."m",fs
				else
					m = ''
					if (s < 0) then
						s = ''
					end
				end
			end
		else
			if (m >= 1 and s == 0) then
				return m..":00",fs
			else
				if (m > 0) then
					m = m..":"
					if (s < 10) then
						s = "0"..s
					end
				else
					m = ''
					if (s < 0) then
						s = ''
					end
				end
			end
		end
		
		if (precision) then
			return m..ms,fs
		else
			return m..s,fs
		end
	else
		return 0,0
	end
end

function Auras:InitializeCooldowns(spec)
	local spec = spec or SSA.spec or GetSpecialization()
	local cd = self.db.char.auras[spec].cooldowns
	--local frames = { SSA[self]:GetChildren() }
	
	--[[local ignoreFrames = {
		["StormkeeperChargeGrp"] = true,
		["StormstrikeChargeGrp"] = true,
		["Cloudburst"] = true,
	}]]
	
	for k,_ in pairs(self.db.char.auras[spec].auras) do
		--SSA.DataFrame.text:SetText("AURA: "..tostring(k))
		local aura = SSA[k]
		
		if (aura) then
			-- We don't need to initialize the cooldown of an aura if it's not part of an aura group
			if (self.db.char.auras[spec].auras[k].group > 0) then
				-- Set Cooldown's Text Visibility
				aura.CD:SetHideCountdownNumbers(true)
				aura.PCD:SetHideCountdownNumbers(true)
				
				-- Set Cooldown's Spiral Direction
				SSA.DataFrame.text:SetText("Group: "..tostring(self.db.char.auras[spec].auras[k].group).."\n")
				SSA.DataFrame.text:SetText(self:CurText('DataFrame').."K: "..tostring(k).."\n")
				aura.CD:SetReverse(cd.groups[self.db.char.auras[spec].auras[k].group].inverse)
				aura.PCD:SetReverse(cd.groups[self.db.char.auras[spec].auras[k].group].inverse)
				
				if (aura.GCD) then
					aura.GCD:SetReverse(cd.groups[self.db.char.auras[spec].auras[k].group].inverse)
				end
				
				if (aura.ChargeCD) then
					aura.ChargeCD:SetHideCountdownNumbers(true)
				end
				
				if (cd.groups[self.db.char.auras[spec].auras[k].group].sweep) then
					aura.PCD:SetDrawSwipe(true)
					aura.PCD:SetDrawEdge(true)
				else
					aura.PCD:SetDrawSwipe(false)
					aura.PCD:SetDrawEdge(false)
				end
			end
		else
			self.db.char.auras[spec].auras[k] = nil
		end
	end
	--for i=1,getn(frames) do
		--if (frames[i]:GetObjectType() == "Frame" and not ignoreFrames[frames[i]:GetName()]) then
	--[[for i=1,Auras.db.char.layout[spec].auras.groupCount do
			local auras = { frames[i]:GetChildren() }
			--local auras = { frames[
			for j=1,getn(auras) do
				if (auras[j]:GetObjectType() == "Frame") then
					local aura = auras[j]
					
					-- Set Cooldown's Text Visibility
					if (not aura.CD) then
						print("NO CHILD: "..tostring(j))
					end
					aura.CD:SetHideCountdownNumbers(true)
					aura.PCD:SetHideCountdownNumbers(true)
					
					-- Set Cooldown's Spiral Direction
					aura.CD:SetReverse(cd.inverse)
					aura.PCD:SetReverse(cd.inverse)
					
					if (aura.GCD) then
						aura.GCD:SetReverse(cd.inverse)
					end
					
					if (aura.ChargeCD) then
						aura.ChargeCD:SetHideCountdownNumbers(true)
					end
					
					if (cd.sweep) then
						aura.PCD:SetDrawSwipe(true)
						aura.PCD:SetDrawEdge(true)
					else
						aura.PCD:SetDrawSwipe(false)
						aura.PCD:SetDrawEdge(false)
					end
				end
			end
		--end
	end]]
end

-- Complete Cooldown Handler
function Auras:CooldownHandler(obj,group,start,duration,bypass)
	local spec = SSA.spec
	local cd = self.db.char.auras[spec].cooldowns

	if (cd.adjust and not UnitAffectingCombat('player')) then
		if (obj.CD:IsShown()) then
			obj.CD:Hide()
		end
		
		
		
		if (group == cd.selected) then
			if (obj.Charges) then
				obj.Charges:Hide()
			end

			cd.groups[cd.selected].isPreview = true

			self:PreviewCooldown(obj,group,spec)
		else
			if (obj.PCD:IsShown()) then
				obj.PCD:Hide()
			end

			for i=1,#cd.groups do
				if (i ~= cd.selected) then
					cd.groups[i].isPreview = false
				end
			end
			--self:NoCombatDisplay(obj,group)
			--obj:SetAlpha(0.5)
		end
	else
		if (obj.PCD:IsShown()) then
			obj.PCD:Hide()
		end
		
		--cd.groups[cd.selected].isPreview = false
		for i=1,#cd.groups do
			cd.groups[i].isPreview = false
		end
		
		if (obj.Charges and not obj.Charges:IsShown()) then
			obj.Charges:Show()
		end
		
		self:ExecuteGCD(obj,(start or 0),spec,group)
		self:UpdateCooldown(obj,cd,group)
		
		if (not bypass and (duration or 0) > 1.5) then
			if (not obj.CD:IsShown()) then
				obj.CD:Show()
			end

			self:ExecuteCooldown(obj,start,duration,group,spec)
		else
			if (obj.CD:IsShown()) then
				obj.CD:Hide()
			end
		end
	end
end

function Auras:UpdateCooldown(obj,cd,group)
	-- Gather CD Information
	local swipe,bling = obj.CD:GetDrawSwipe(),obj.CD:GetDrawBling()
	local start,duration = obj.CD:GetCooldownTimes()
					
	-- Configure CD
	if (start == 0 or duration == 0) then
		if (swipe) then
			obj.CD:SetDrawSwipe(false)
			obj.CD:SetDrawEdge(false)
		end
		
		if (bling) then
			obj.CD:SetDrawBling(false)
		end
	elseif (cd.groups[group].sweep and cd.groups[group].bling) then
		if (not swipe) then
			obj.CD:SetDrawSwipe(true)
			obj.CD:SetDrawEdge(true)
		end
		
		if (not bling) then
			obj.CD:SetDrawBling(true)
		end
	elseif (cd.groups[group].sweep and not cd.groups[group].bling) then
		if (not swipe) then
			obj.CD:SetDrawSwipe(true)
			obj.CD:SetDrawEdge(true)
		end
		
		if (bling) then
			obj.CD:SetDrawBling(false)
		end
	else
		if (swipe) then
			obj.CD:SetDrawSwipe(false)
			obj.CD:SetDrawEdge(false)
		end
		
		if (bling) then
			obj.CD:SetDrawBling(false)
		end
	end

	if (obj.GCD) then
		-- Gather GCD Information
		local gSwipe,gBling = obj.GCD:GetDrawSwipe(),obj.GCD:GetDrawBling()
		local gStart,gDuration = obj.GCD:GetCooldownTimes()
	
		if (cd.groups[group].GCD.isEnabled and cd.groups[group].sweep and cd.groups[group].bling) then
			if (not gSwipe) then
				obj.GCD:SetDrawSwipe(true)
				obj.GCD:SetDrawEdge(true)
			end
			
			if (not gBling) then
				obj.GCD:SetDrawBling(true)
			end
		elseif (cd.groups[group].GCD.isEnabled and cd.groups[group].sweep and not cd.groups[group].bling) then
			if (not gSwipe) then
				obj.GCD:SetDrawSwipe(true)
				obj.GCD:SetDrawEdge(true)
			end
			
			if (gBling) then
				obj.GCD:SetDrawBling(false)
			end
		else
			if (gSwipe) then
				obj.GCD:SetDrawSwipe(false)
				obj.GCD:SetDrawEdge(false)
			end
			
			if (gBling) then
				obj.GCD:SetDrawBling(false)
			end
		end
	end
end

function Auras:SetCooldownFont(obj,cdGrp,remaining)
	obj.text:SetFont(LSM.MediaTable.font[cdGrp.text.font.name] or LSM.DefaultMedia.font,cdGrp.text.font.size,cdGrp.text.font.flag)
	
	if (cdGrp.text.formatting.alert.isEnabled and remaining) then
		if (remaining <= ((cdGrp.text.formatting.decimals and cdGrp.text.formatting.alert.threshold + 0.1) or (not cdGrp.text.formatting.decimals and cdGrp.text.formatting.alert.threshold + 1))) then
			if (cdGrp.text.formatting.alert.animate) then
				if (not obj.Flash:IsPlaying()) then
					obj.Flash:Play()
				end
			else
				if (obj.Flash:IsPlaying()) then
					obj.Flash:Stop()
				end
			end
			obj.text:SetTextColor(cdGrp.text.formatting.alert.color.r,cdGrp.text.formatting.alert.color.g,cdGrp.text.formatting.alert.color.b,cdGrp.text.formatting.alert.color.a)
		else
			if (obj.Flash:IsPlaying()) then
				obj.Flash:Stop()
			end
			
			obj.text:SetTextColor(cdGrp.text.font.color.r,cdGrp.text.font.color.g,cdGrp.text.font.color.b,cdGrp.text.font.color.a)
		end
	else
		obj.text:SetTextColor(cdGrp.text.font.color.r,cdGrp.text.font.color.g,cdGrp.text.font.color.b,cdGrp.text.font.color.a)
	end

	obj.text:ClearAllPoints()
	obj.text:SetPoint(cdGrp.text.justify,obj,cdGrp.text.justify,cdGrp.text.x,cdGrp.text.y)
	
	if (cdGrp.text.font.shadow.isEnabled) then
		obj.text:SetShadowColor(cdGrp.text.font.shadow.color.r,cdGrp.text.font.shadow.color.g,cdGrp.text.font.shadow.color.b,cdGrp.text.font.shadow.color.a)
		obj.text:SetShadowOffset(cdGrp.text.font.shadow.offset.x,cdGrp.text.font.shadow.offset.y)
	else
		obj.text:SetShadowColor(0,0,0,0)
	end
end

function Auras:PreviewCooldown(obj,group)
	local spec = SSA.spec
	local cd = self.db.char.auras[spec].cooldowns
	local cdGrp = cd.groups[group]
	
	if (not obj.PCD:IsShown()) then
		obj.PCD:Show()
	end
	
	--obj:SetAlpha(1)
	
	local start,duration = obj.PCD:GetCooldownTimes()
	local remains = ((start + duration) / 1e3) - GetTime()

	self:SetCooldownFont(obj.PCD,cdGrp,remains)
		
	if (remains <= 3) then
		obj.PCD:SetCooldown(GetTime(),10)	
	else
		if (cdGrp.text.isDisplayText) then
			if (remains < 10 and cdGrp.text.formatting.decimals) then
				obj.PCD.text:SetText(self:parseTime(remains,true,true,group))
			else
				obj.PCD.text:SetText(self:parseTime(remains,false,true,group))
			end
		else
			obj.PCD.text:SetText('')
		end	
	end
end

function Auras:ExecuteGCD(obj,start,group)
	if (not obj.GCD) then
		return
	end
	
	local cd = self.db.char.auras[SSA.spec].cooldowns
	local strt,duration = obj.CD:GetCooldownTimes()
	local gDur = obj.GCD:GetCooldownDuration()
	SSA.DataFrame.text:SetText("GCD Check: "..tostring(obj:GetName()))
	if (cd.groups[group].isEnabled and cd.groups[group].GCD.isEnabled and cd.groups[group].GCD.length > 0 and (strt or 0) == 0 and GetTime() < cd.groups[group].GCD.endTime) then
		if (not obj.GCD:IsShown()) then
			obj.GCD:Show()
		end
		obj.GCD:SetReverse(cd.groups[group].inverse)
		obj.GCD:SetCooldown(start,cd.groups[group].GCD.length)
	else
		
		if (not cd.groups[group].isEnabled or not cd.groups[group].GCD.isEnabled or cd.interrupted or GetTime() > (cd.groups[group].GCD.endTime + 1) or strt > 0) then
			if (obj.GCD:IsShown()) then
				obj.GCD:Hide()
			end
		end
	end
end

--function Auras:ExecuteCooldown(self,start,duration,isSmallAura,isHideText,spec)
function Auras:ExecuteCooldown(obj,start,duration,group)
	-- Initialize Database Vars
	local cd = self.db.char.auras[SSA.spec].cooldowns
	local cdGrp = cd.groups[group]
	
	-- Initialize Time-based Vars
	local expires = start + duration
	local remains = expires - GetTime()
	--local remaining,seconds = self:parseTime(timer,false,spec,group,subgroup)

	if (not cdGrp.isEnabled) then
		obj.CD:Hide()
		return
	else
		if (not obj.CD:IsShown()) then
			obj.CD:Show()
		end
	end
	
	self:SetCooldownFont(obj.CD,cdGrp,remains)
	obj.CD:SetCooldown(start,duration)
	
	if (cdGrp.text.isDisplayText) then
		if (remains < 10 and cdGrp.text.formatting.decimals) then
			obj.CD.text:SetText(self:parseTime(remains,true,true,group))
		else
			obj.CD.text:SetText(self:parseTime(remains,false,true,group))
		end
	else
		obj.CD.text:SetText('')
	end
end
