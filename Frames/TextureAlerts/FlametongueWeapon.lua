local SSA, Auras = unpack(select(2,...))

-- Totem Mastery Notification
local FlametongueWeapon = CreateFrame('Frame','FlametongueWeapon',SSA.AuraBase,BackdropTemplateMixin and "BackdropTemplate")
FlametongueWeapon:SetPoint('CENTER',0,-210)
FlametongueWeapon:SetWidth(300)
FlametongueWeapon:SetHeight(135)
FlametongueWeapon:SetFrameStrata('BACKGROUND')
FlametongueWeapon:RegisterForDrag('LeftButton')
FlametongueWeapon:SetAlpha(0)
FlametongueWeapon:Show()

FlametongueWeapon.header = FlametongueWeapon:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
FlametongueWeapon.header:SetFont([[Interface\AddOns\ShamanAuras2\Media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
FlametongueWeapon.header:SetPoint('TOPLEFT',FlametongueWeapon,"TOPLEFT",5,5)
FlametongueWeapon.header:SetTextColor(1,1,1,1)
FlametongueWeapon.header:SetText(GetSpellInfo(210643))
FlametongueWeapon.header:Hide()
				
FlametongueWeapon.texture = FlametongueWeapon:CreateTexture(nil,'LOW')
--FlametongueWeapon.texture:SetTexture([[Textures\SpellActivationOverlays\Echo_of_the_Elements]])
FlametongueWeapon.texture:SetTexture(457658)
FlametongueWeapon.texture:SetPoint('CENTER',FlametongueWeapon,'CENTER',0,10)
FlametongueWeapon.texture:SetWidth(FlametongueWeapon:GetHeight() * 2)
FlametongueWeapon.texture:SetHeight(FlametongueWeapon:GetWidth() * 0.6)
--FlametongueWeapon.texture:SetRotation(rad(-90))
FlametongueWeapon.texture:SetAlpha(0.7)

-- Animation for Totem Mastery Notification Texture
FlametongueWeapon.Flash = FlametongueWeapon.texture:CreateAnimationGroup()
FlametongueWeapon.Flash:SetLooping('BOUNCE')

FlametongueWeapon.Flash.fadeIn = FlametongueWeapon.Flash:CreateAnimation('Alpha')
FlametongueWeapon.Flash.fadeIn:SetFromAlpha(1)
FlametongueWeapon.Flash.fadeIn:SetToAlpha(0.4)
FlametongueWeapon.Flash.fadeIn:SetDuration(0.4)

FlametongueWeapon.Flash.fadeOut = FlametongueWeapon.Flash:CreateAnimation('Alpha')
FlametongueWeapon.Flash.fadeOut:SetFromAlpha(0.4)
FlametongueWeapon.Flash.fadeOut:SetToAlpha(1)
FlametongueWeapon.Flash.fadeOut:SetDuration(0.4)
FlametongueWeapon.Flash.fadeOut:SetEndDelay(0)

FlametongueWeapon:SetScript('OnUpdate',function(self)
	if (not Auras.db.char.isFirstEverLoad) then
		local spec = GetSpecialization()

		local remaining = 0
		local isRefresh = false
		--local buff = UnitBuff('player',Auras:GetSpellName(202192))
		--local buff = Auras:RetrieveAuraInfo("player", 202192)
		local _,mainExpires,_,mainEnchantID,_,offExpires,_,offEnchantID = GetWeaponEnchantInfo()

		local db = Auras.db.char
	
		self:SetPoint(db.elements[spec].frames[self:GetName()].point,SSA[db.elements[spec].frames[self:GetName()].relativeTo],db.elements[spec].frames[self:GetName()].relativePoint,db.elements[spec].frames[self:GetName()].x,db.elements[spec].frames[self:GetName()].y)
		Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving)
		Auras:ToggleAuraVisibility(self,true,'showhide')

		if (mainEnchantID == 5400) then
			remaining = (mainExpires or 0) - GetTime()
		elseif (offEnchantID == 5400) then
			remaining = (offExpires or 0) - GetTime()
		end

		if ((remaining or 0) <= db.settings[spec].flametongueWeapon) then
			isRefresh = true
		end

		if (((isRefresh or ((mainEnchantID or 0) ~= 5400 and (offEnchantID or 0) ~= 5400)) and db.elements[spec].frames.FlametongueWeapon.isEnabled) or db.settings.move.isMoving) then
			SSA.isFlametongue = false

			self:SetAlpha(1)
			
			if (not self.Flash:IsPlaying()) then
				self.Flash:Play()
			end
			if (UnitAffectingCombat('player')) then
				self.Flash.fadeOut:SetToAlpha(0.6)
				self.Flash.fadeIn:SetFromAlpha(1)
			else
				self.Flash.fadeOut:SetToAlpha(0.3)
				self.Flash.fadeIn:SetFromAlpha(0.6)
			end
		else
			SSA.isFlametongue = true
			
			self:SetAlpha(0)
			
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
		end
		
		--Auras:ToggleFrameMove(self,db.elements[1].isMoving)
	--else
		--Auras:ToggleAuraVisibility(self,false,'showhide')
	--end
	end
end)

FlametongueWeapon:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

FlametongueWeapon:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		local spec = GetSpecialization()

		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[spec].frames[self:GetName()])
	end
end)

_G["SSA_FlametongueWeapon"] = FlametongueWeapon