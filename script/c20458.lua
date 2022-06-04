--命运超越
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tgf1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttack(0)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tgf1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
		local _,val=g:GetMaxGroup(Card.GetAttack)
		val = val+100
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	end
end