local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ManaTideTotemBar = SSA.ManaTideTotemBar

-- Initialize Data Variables
ManaTideTotemBar.spellID = 16191
ManaTideTotemBar.icon = 538569
ManaTideTotemBar.start = 0
ManaTideTotemBar.duration = 8
ManaTideTotemBar.elapsed = 0
ManaTideTotemBar.condition = function()
	return IsSpellKnown(16191)
end

ManaTideTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

ManaTideTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)