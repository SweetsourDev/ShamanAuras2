local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local TimeWarpBar = SSA.TimeWarpBar

-- Initialize Data Variables
TimeWarpBar.spellID = 80353
TimeWarpBar.start = 0
TimeWarpBar.duration = 40
TimeWarpBar.elapsed = 0
TimeWarpBar.condition = function()
	return true
end

TimeWarpBar:SetScript('OnUpdate',function(self,elapsed)
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

TimeWarpBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
	end
end)