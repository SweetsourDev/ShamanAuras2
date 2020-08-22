local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local select = select

-- Cache Global WoW API Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

-- Cache Global Addon Variables
local FireElementalBar = SSA.FireElementalBar
local EmberElementalBar = SSA.EmberElementalBar
local PrimalFireElementalBar = SSA.PrimalFireElementalBar

-- Initialize Data Variables
FireElementalBar.spellID = 188592
FireElementalBar.icon = 135790
FireElementalBar.start = 0
FireElementalBar.duration = 30
FireElementalBar.baseDuration = 30
FireElementalBar.newDuration = 0
FireElementalBar.GUID = ''
FireElementalBar.elapsed = 0
FireElementalBar.hasEssence = true
FireElementalBar.totemIcon = 135790
FireElementalBar.condition = function()
	return not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067)
end

FireElementalBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1,198067) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				--if (bar.hasEssence) then

					--local numVars = { GetTotemInfo(1) }
					--SSA.DataFrame.text:SetText('')
					--print("Num Vars: "..tostring(#numVars)).
					if (self.start > 0) then
						for i=1,MAX_TOTEMS do
							local _,_,_,duration,icon = GetTotemInfo(i)


							if (icon == self.totemIcon) then
								
								if (self.newDuration == 0 and duration < self.baseDuration) then
									self.newDuration = duration
									self.duration = duration
									self:SetValue(duration)
									self:SetMinMaxValues(1,duration)
								elseif ((self.newDuration == 0 and self.duration ~= duration) or (self.newDuration > 0 and self.newDuration ~= duration)) then
									self.newDuration = duration
									self.duration = self.duration + (duration - self:GetValue())
									self:SetValue(duration)
									self:SetMinMaxValues(1,self.duration)
								end
							end
							
							
						end
					end
				--end

				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

FireElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,1,198067) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then	
		Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
	end
end)

-- Initialize Data Variables
EmberElementalBar.spellID = 275385
EmberElementalBar.icon = 135790
EmberElementalBar.start = 0
EmberElementalBar.duration = 30
EmberElementalBar.GUID = ''
EmberElementalBar.elapsed = 0
EmberElementalBar.condition = function() return not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067) end

EmberElementalBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

EmberElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
	end
end)

-- Initialize Data Variables
PrimalFireElementalBar.spellID = 118291
PrimalFireElementalBar.start = 0
PrimalFireElementalBar.duration = 30
PrimalFireElementalBar.GUID = ''
PrimalFireElementalBar.isPrimal = true
PrimalFireElementalBar.elapsed = 0
PrimalFireElementalBar.condition = function() return select(4,GetTalentInfo(6,2,1)) and not select(4,GetTalentInfo(4,2,1)) end

PrimalFireElementalBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1,6,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

PrimalFireElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	--[[local spec = 1
	local timerbar = Auras.db.char.timerbars[spec][self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,_,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (srcGUID == UnitGUID("player") and subevent == "SPELL_SUMMON") then
		-- If the player casts Primal Earth Elemental while the Primal Fire Elemental is already active,
		-- hide the timer bar for Primal Fire Elemental
		if (spellID == 118323 and timerbar.startTime > 0) then
			timerbar.startTime = 0
		elseif (spellID == timerbar.spellID) then
			timerbar.startTime = GetTime()
			timerbar.event.elementalGUID = destGUID
			self:Show()
		end
	elseif (subevent == "UNIT_DIED" and destGUID == timerbar.event.elementalGUID) then
		timerbar.startTime = 0
	end]]
	
	if ((Auras:CharacterCheck(self,1,6,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Elemental(self,118323,CombatLogGetCurrentEventInfo())
	end
end)
--[[
	NO TALENT
	---------
	Event: SPELL_SUMMON
	GUID: Player (Arg 4), Pet (Arg 8)
	
	Event: UNIT_DIED
	GUID: Pet (Arg 8)

	Event: SPELL_CAST_SUCCESS
	GUID: Player (Arg 4)
	Spell ID: 198067
	
	Event: SPELL_AURA_APPLIED 
	GUID: Player (Arg 4)
	Spell ID: 188592
	
	Event: SPELL_AURA_REMOVED
	GUID: Player (Arg 4)
	Spell ID: 188592
	
	
	TALENTED
	--------
	Event: PET_DISMISS_START
]]