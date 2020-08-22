local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local ElementalBlastBarCrit = SSA.ElementalBlastBarCrit
local ElementalBlastBarHaste = SSA.ElementalBlastBarHaste
local ElementalBlastBarMastery = SSA.ElementalBlastBarMastery

-- Initialize Data Variables
ElementalBlastBarCrit.spellID = 118522
ElementalBlastBarCrit.start = 0
ElementalBlastBarCrit.duration = 10
ElementalBlastBarCrit.elapsed = 0
ElementalBlastBarCrit.condition = function()
	local spec = GetSpecialization()
	local selected = false

	if (spec == 1) then
		_,_,_,selected = GetTalentInfo(2,3,1)
	elseif (spec == 2) then
		_,_,_,selected = GetTalentInfo(1,3,1)
	end
	
	return selected
end

ElementalBlastBarCrit:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

ElementalBlastBarCrit:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)

-- Initialize Data Variables
ElementalBlastBarHaste.spellID = 173183
ElementalBlastBarHaste.start = 0
ElementalBlastBarHaste.duration = 10
ElementalBlastBarHaste.elapsed = 0
ElementalBlastBarHaste.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

ElementalBlastBarHaste:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

ElementalBlastBarHaste:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)

-- Initialize Data Variables
ElementalBlastBarMastery.spellID = 173184
ElementalBlastBarMastery.start = 0
ElementalBlastBarMastery.duration = 10
ElementalBlastBarMastery.elapsed = 0
ElementalBlastBarMastery.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

ElementalBlastBarMastery:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

ElementalBlastBarMastery:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)


