local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local BloodlustBar = SSA.BloodlustBar

-- Initialize Data Variables
BloodlustBar.spellID = 2825
BloodlustBar.start = 0
BloodlustBar.duration = 40
BloodlustBar.condition = function() return true end

BloodlustBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0)) then
		Auras:RunTimerBarCode(self)
	end
end)

BloodlustBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
end)