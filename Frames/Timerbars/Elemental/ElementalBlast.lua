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
ElementalBlastBarCrit.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

ElementalBlastBarCrit:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarCrit:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)

-- Initialize Data Variables
ElementalBlastBarHaste.spellID = 173183
ElementalBlastBarHaste.start = 0
ElementalBlastBarHaste.duration = 10
ElementalBlastBarHaste.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

ElementalBlastBarHaste:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarHaste:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)

-- Initialize Data Variables
ElementalBlastBarMastery.spellID = 173184
ElementalBlastBarMastery.start = 0
ElementalBlastBarMastery.duration = 10
ElementalBlastBarMastery.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

ElementalBlastBarMastery:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

ElementalBlastBarMastery:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)


