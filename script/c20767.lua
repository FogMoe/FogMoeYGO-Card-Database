--合击星
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.filter(c,cod)
	if not (c:IsType(TYPE_MONSTER) and c:IsFaceup()) then return false end
	if cod then return c:IsCode(cod) end
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tc:GetCode())
		if #g>0 then
			tc=g:GetFirst()
			while tc do
				local e2=e1:Clone()
				e2:SetValue(tc:GetAttack()*2)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	end
end
