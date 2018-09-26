local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthbindTotemBar = SSA.EarthbindTotemBar

-- Initialize Data Variables
EarthbindTotemBar.spellID = 2484
EarthbindTotemBar.icon = 136102
EarthbindTotemBar.start = 0
EarthbindTotemBar.duration = 20
EarthbindTotemBar.condition = function() return IsSpellKnown(2484) end

EarthbindTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,2484)) then
		Auras:RunTimerBarCode(self)
	end
end)

EarthbindTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)