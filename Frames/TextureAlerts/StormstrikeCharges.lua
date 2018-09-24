local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local StormstrikeCharges = SSA.StormstrikeChargeGrp

StormstrikeCharges:SetScript('OnUpdate',function(self,elaps)
	if (Auras:CharacterCheck(2)) then
		local buff,_,count = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(201846))
		local _,_,_,selected = GetTalentInfo(5,1,1)
		local db = Auras.db.char
		local frm = db.elements[2].frames.StormstrikeChargeGrp
		local isMoving = db.elements[2].isMoving
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:ToggleFrameMove(self,isMoving)
		
		if (isMoving) then
			self.Charge1:SetAlpha(1)
			--self.Charge1.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
			self.Charge2:SetAlpha(1)
			--self.Charge2.Lightning:SetModel('spells/Monk_chiblast_precast.m2')
		end
		
		if (frm.isEnabled and not isMoving) then
			if (buff) then
				
			end
			
			if (count == 2) then
				self.Charge1:SetAlpha(1)
				self.Charge2:SetAlpha(1)
			elseif (count == 1 and selected) then
				self.Charge2:SetAlpha(0)
			elseif (count == 0 or not buff) then
				self.Charge1:SetAlpha(0)
				self.Charge2:SetAlpha(0)
			end
		elseif (not frm.isEnabled and not isMoving) then
			self:SetAlpha(0)
		end

	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

StormstrikeCharges:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements[2].isMoving) then
		Auras:MoveOnMouseDown(self,'AuraGroup2',button)
	end
end)

StormstrikeCharges:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements[2].isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[2].frames[self:GetName()])
	end
end);