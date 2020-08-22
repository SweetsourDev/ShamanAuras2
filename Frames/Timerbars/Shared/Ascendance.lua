local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetSpecialization = GetSpecialization

-- Cache Global Addon Variables
local AscendanceBar = SSA.AscendanceBar

local spec = GetSpecialization()

--Initialize Data Variables
AscendanceBar.spellID = (spec == 1 and 114050) or (spec == 2 and 114051) or (spec == 3 and 114052)
AscendanceBar.start = 0
AscendanceBar.duration = 15
AscendanceBar.elapsed = 0
AscendanceBar.condition = function()
	local _,_,_,selected = GetTalentInfo(7,3,1)
	
	return selected
end

AscendanceBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			--print("PREVIEW: "..tostring(Auras:IsPreviewingTimerbar(self)))
			if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

AscendanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)