--狼喵嗷和羊喵嗷
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.tg2)
	e2:SetValue(cm.val2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and c:IsControler(tp) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.val2,1,nil)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.val2(e,c)
	if not c then c=e end
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x3fa1)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end
