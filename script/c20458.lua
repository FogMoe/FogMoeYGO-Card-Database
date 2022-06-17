--命运超越
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function cm.tgf1(c,g,e)
	return g:IsContains(c) and c:IsAttack(0) and c:GetBaseAttack()~=0 and c:IsCanBeEffectTarget(e)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget() or Duel.GetAttackTarget())
	if chkc then return cm.tgf1(chkc,g,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g,e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(tc:GetBaseAttack()*2)
		tc:RegisterEffect(e1)
	end
end