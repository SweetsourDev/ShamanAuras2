local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local HeroismBar = SSA.HeroismBar

-- Initialize Data Variables
HeroismBar.spellID = 32182
HeroismBar.start = 0
HeroismBar.duration = 40
HeroismBar.condition = function() return true end

HeroismBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0)) then
		Auras:RunTimerBarCode(self)
	end
end)

HeroismBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
end)