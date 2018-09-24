local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

-- Cache Global Addon Variables
local LiquidMagmaTotemBar = SSA.LiquidMagmaTotemBar

LiquidMagmaTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,4,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

--LiquidMagmaTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
LiquidMagmaTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)