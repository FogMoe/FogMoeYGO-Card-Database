local m=6007
local cm=_G["c"..m]
cm.name="眩惑"
function cm.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c~=c
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,1-tp,REASON_COST)
	Duel.ShuffleHand(tp)
end
function cm.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsOnField()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsOnField() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
