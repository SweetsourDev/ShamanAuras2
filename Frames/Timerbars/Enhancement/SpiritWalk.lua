local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritWalkBar = SSA.SpiritWalkBar

-- Initialize Data Variables
SpiritWalkBar.spellID = 58875
SpiritWalkBar.start = 0
SpiritWalkBar.duration = 8
SpiritWalkBar.condition = function() return IsSpellKnown(58875) end

SpiritWalkBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,58875)) then
		Auras:RunTimerBarCode(self)
	end
end)

SpiritWalkBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)