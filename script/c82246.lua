local m=82246
local cm=_G["c"..m]
cm.name="孑影之骁骑"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,2,99)
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetTargetRange(1,1)  
	e5:SetValue(cm.damval)  
	c:RegisterEffect(e5)  
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x3299)
end  
function cm.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsPosition(POS_DEFENSE) then  
		return dam*3 
	else return dam end  
end  