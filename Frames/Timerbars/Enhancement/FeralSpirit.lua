local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FeralSpiritBar = SSA.FeralSpiritBar

FeralSpiritBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,51533)) then
		Auras:RunTimerBarCode(self)
	end
end)

--[[FeralSpiritBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)]]

FeralSpiritBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)