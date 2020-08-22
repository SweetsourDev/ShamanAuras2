local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthgrabTotemBar = SSA.EarthgrabTotemBar

-- Initialize Data Variables
EarthgrabTotemBar.spellID = 51485
EarthgrabTotemBar.icon = 136100
EarthgrabTotemBar.start = 0
EarthgrabTotemBar.duration = 20
EarthgrabTotemBar.elapsed = 0
EarthgrabTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(3,2,1)
	
	return selected
end

EarthgrabTotemBar:SetScript('OnUpdate',function(self,elapsed)
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

EarthgrabTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)