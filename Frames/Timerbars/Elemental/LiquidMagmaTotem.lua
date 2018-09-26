local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

-- Cache Global Addon Variables
local LiquidMagmaTotemBar = SSA.LiquidMagmaTotemBar

-- Initialize Data Variables
LiquidMagmaTotemBar.spellID = 192222
LiquidMagmaTotemBar.icon = 971079
LiquidMagmaTotemBar.start = 0
LiquidMagmaTotemBar.duration = 15
LiquidMagmaTotemBar.condition = function() return select(4,GetTalentInfo(4,3,1)) end

LiquidMagmaTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,4,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

LiquidMagmaTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)