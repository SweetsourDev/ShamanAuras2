local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FrostbrandBar = SSA.FrostbrandBar

-- Initialize Data Variables
FrostbrandBar.spellID = 196834
FrostbrandBar.start = 0
FrostbrandBar.duration = 16
FrostbrandBar.condition = function() return IsSpellKnown(196834) end

FrostbrandBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,196834)) then
		Auras:RunTimerBarCode(self)
	end
end)

FrostbrandBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)