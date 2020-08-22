local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthbindTotemBar = SSA.EarthbindTotemBar

-- Initialize Data Variables
EarthbindTotemBar.spellID = 2484
EarthbindTotemBar.icon = 136102
EarthbindTotemBar.start = 0
EarthbindTotemBar.duration = 20
EarthbindTotemBar.elapsed = 0
EarthbindTotemBar.condition = function()
	return IsSpellKnown(2484)
end

EarthbindTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

EarthbindTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)