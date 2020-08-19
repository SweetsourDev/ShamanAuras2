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
LiquidMagmaTotemBar.elapsed = 0
LiquidMagmaTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(4,3,1)
	
	return selected
end

LiquidMagmaTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

LiquidMagmaTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)