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
function Auras:parseTime(timer,precision,spec,group,msg)
	if (timer and timer > 0) then
		local m,s,ms,fs = floor(timer / 60),floor(fmod(timer,60)),(('%%.%df'):format(1)):format(fmod(timer,60),1),timer

		if (spec) then
			local cd = Auras.db.char.auras[spec].cooldowns.groups[group]
			
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
	local cd = Auras.db.char.auras[spec].cooldowns
	--local frames = { SSA[self]:GetChildren() }
	
	--[[local ignoreFrames = {
		["StormkeeperChargeGrp"] = true,
		["StormstrikeChargeGrp"] = true,
		["Cloudburst"] = true,
	}]]
	
	for k,_ in pairs(Auras.db.char.auras[spec].auras) do
		--SSA.DataFrame.text:SetText("AURA: "..tostring(k))
		local aura = SSA[k]
		
		--SSA.DataFrame.text:SetText("Error: "..k)
		-- Set Cooldown's Text Visibility
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
function Auras:CooldownHandler(self,spec,group,start,duration,bypass)
	local cd = Auras.db.char.auras[spec].cooldowns
	
	if (cd.adjust and not UnitAffectingCombat('player')) then
		if (self.CD:IsShown()) then
			self.CD:Hide()
		end
		
		cd.groups[cd.selected].isPreview = true
		
		if (group == cd.selected) then
			if (self.Charges) then
				self.Charges:Hide()
			end

			Auras:PreviewCooldown(self,group,spec)
		else
			if (self.PCD:IsShown()) then
				self.PCD:Hide()
			end
		end
	else
		if (self.PCD:IsShown()) then
			self.PCD:Hide()
		end
		
		cd.groups[cd.selected].isPreview = false
		
		if (self.Charges and not self.Charges:IsShown()) then
			self.Charges:Show()
		end
		
		Auras:ExecuteGCD(self,(start or 0),spec)
		Auras:UpdateCooldown(self,spec,cd)
		
		if (not bypass and (duration or 0) > 1.5) then
			if (not self.CD:IsShown()) then
				self.CD:Show()
			end

			Auras:ExecuteCooldown(self,start,duration,group,spec)
		else
			if (self.CD:IsShown()) then
				self.CD:Hide()
			end
		end
	end
end

function Auras:UpdateCooldown(self,spec,cd)
	-- Gather CD Information
	local swipe,bling = self.CD:GetDrawSwipe(),self.CD:GetDrawBling()
	local start,duration = self.CD:GetCooldownTimes()
					
	-- Configure CD
	if (start == 0 or duration == 0) then
		if (swipe) then
			self.CD:SetDrawSwipe(false)
			self.CD:SetDrawEdge(false)
		end
		
		if (bling) then
			self.CD:SetDrawBling(false)
		end
	elseif (cd.sweep and cd.bling) then
		if (not swipe) then
			self.CD:SetDrawSwipe(true)
			self.CD:SetDrawEdge(true)
		end
		
		if (not bling) then
			self.CD:SetDrawBling(true)
		end
	elseif (cd.sweep and not cd.bling) then
		if (not swipe) then
			self.CD:SetDrawSwipe(true)
			self.CD:SetDrawEdge(true)
		end
		
		if (bling) then
			self.CD:SetDrawBling(false)
		end
	else
		if (swipe) then
			self.CD:SetDrawSwipe(false)
			self.CD:SetDrawEdge(false)
		end
		
		if (bling) then
			self.CD:SetDrawBling(false)
		end
	end

	if (self.GCD) then
		-- Gather GCD Information
		local gSwipe,gBling = self.GCD:GetDrawSwipe(),self.GCD:GetDrawBling()
		local gStart,gDuration = self.GCD:GetCooldownTimes()
	
		if (cd.GCD.isEnabled and cd.sweep and cd.bling) then
			if (not gSwipe) then
				self.GCD:SetDrawSwipe(true)
				self.GCD:SetDrawEdge(true)
			end
			
			if (not gBling) then
				self.GCD:SetDrawBling(true)
			end
		elseif (cd.GCD.isEnabled and cd.sweep and not cd.bling) then
			if (not gSwipe) then
				self.GCD:SetDrawSwipe(true)
				self.GCD:SetDrawEdge(true)
			end
			
			if (gBling) then
				self.GCD:SetDrawBling(false)
			end
		else
			if (gSwipe) then
				self.GCD:SetDrawSwipe(false)
				self.GCD:SetDrawEdge(false)
			end
			
			if (gBling) then
				self.GCD:SetDrawBling(false)
			end
		end
	end
end

function Auras:SetCooldownFont(self,cdGrp,remaining)
	self.text:SetFont(LSM.MediaTable.font[cdGrp.text.font.name] or LSM.DefaultMedia.font,cdGrp.text.font.size,cdGrp.text.font.flag)
	
	if (cdGrp.text.formatting.alert.isEnabled and remaining) then
		if (remaining <= ((cdGrp.text.formatting.decimals and cdGrp.text.formatting.alert.threshold + 0.1) or (not cdGrp.text.formatting.decimals and cdGrp.text.formatting.alert.threshold + 1))) then
			if (cdGrp.text.formatting.alert.animate) then
				if (not self.Flash:IsPlaying()) then
					self.Flash:Play()
				end
			else
				if (self.Flash:IsPlaying()) then
					self.Flash:Stop()
				end
			end
			self.text:SetTextColor(cdGrp.text.formatting.alert.color.r,cdGrp.text.formatting.alert.color.g,cdGrp.text.formatting.alert.color.b,cdGrp.text.formatting.alert.color.a)
		else
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
			
			self.text:SetTextColor(cdGrp.text.font.color.r,cdGrp.text.font.color.g,cdGrp.text.font.color.b,cdGrp.text.font.color.a)
		end
	else
		self.text:SetTextColor(cdGrp.text.font.color.r,cdGrp.text.font.color.g,cdGrp.text.font.color.b,cdGrp.text.font.color.a)
	end

	self.text:ClearAllPoints()
	self.text:SetPoint(cdGrp.text.justify,self,cdGrp.text.justify,cdGrp.text.x,cdGrp.text.y)
	
	if (cdGrp.text.font.shadow.isEnabled) then
		self.text:SetShadowColor(cdGrp.text.font.shadow.color.r,cdGrp.text.font.shadow.color.g,cdGrp.text.font.shadow.color.b,cdGrp.text.font.shadow.color.a)
		self.text:SetShadowOffset(cdGrp.text.font.shadow.offset.x,cdGrp.text.font.shadow.offset.y)
	else
		self.text:SetShadowColor(0,0,0,0)
	end
end

function Auras:PreviewCooldown(self,group,spec)
	local db = Auras.db.char
	local cd = db.auras[spec].cooldowns
	local cdGrp = cd.groups[group]
	
	if (not self.PCD:IsShown()) then
		self.PCD:Show()
	end
	
	self:SetAlpha(1)
	
	local start,duration = self.PCD:GetCooldownTimes()
	local remains = ((start + duration) / 1e3) - GetTime()

	Auras:SetCooldownFont(self.PCD,cdGrp,remains)
		
	if (remains <= 3) then
		self.PCD:SetCooldown(GetTime(),10)	
	else
		if (cd.text) then
			if (remains < 10 and cdGrp.text.formatting.decimals) then
				self.PCD.text:SetText(Auras:parseTime(remains,true,spec,group))
			else
				self.PCD.text:SetText(Auras:parseTime(remains,false,spec,group))
			end
		else
			self.PCD.text:SetText('')
		end	
	end
end

function Auras:ExecuteGCD(self,start,spec)
	if (not self.GCD) then
		return
	end
	
	local cd = Auras.db.char.auras[spec].cooldowns
	local strt,duration = self.CD:GetCooldownTimes()
	local gDur = self.GCD:GetCooldownDuration()
	
	if (cd.isEnabled and cd.GCD.isEnabled and cd.GCD.length > 0 and strt == 0 and GetTime() < cd.GCD.endTime) then
		if (not self.GCD:IsShown()) then
			self.GCD:Show()
		end
		self.GCD:SetReverse(cd.inverse)
		self.GCD:SetCooldown(start,cd.GCD.length)
	else
		
		if (not cd.isEnabled or not cd.GCD.isEnabled or cd.interrupted or GetTime() > (cd.GCD.endTime + 1) or strt > 0) then
			if (self.GCD:IsShown()) then
				self.GCD:Hide()
			end
		end
	end
end

--function Auras:ExecuteCooldown(self,start,duration,isSmallAura,isHideText,spec)
function Auras:ExecuteCooldown(self,start,duration,group,spec)
	-- Initialize Database Vars
	local cd = Auras.db.char.auras[spec].cooldowns
	local cdGrp = cd.groups[group]
	
	-- Initialize Time-based Vars
	local expires = start + duration
	local remains = expires - GetTime()
	--local remaining,seconds = Auras:parseTime(timer,false,spec,group,subgroup)

	if (not cd.isEnabled) then
		self.CD:Hide()
		return
	else
		if (not self.CD:IsShown()) then
			self.CD:Show()
		end
	end
	
	Auras:SetCooldownFont(self.CD,cdGrp,remains)
	self.CD:SetCooldown(start,duration)
	
	if (cd.text) then
		if (remains < 10 and cdGrp.text.formatting.decimals) then
			self.CD.text:SetText(Auras:parseTime(remains,true,spec,group,subgroup))
		else
			self.CD.text:SetText(Auras:parseTime(remains,false,spec,group,subgroup,self:GetName()))
		end
	else
		self.CD.text:SetText('')
	end
end
