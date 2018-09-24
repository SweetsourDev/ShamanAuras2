local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local BloodlustBar = SSA.BloodlustBar

BloodlustBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0)) then
		Auras:RunTimerBarCode(self)
	end
end)

--BloodlustBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
BloodlustBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
end)