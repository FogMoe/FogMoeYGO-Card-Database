--守城要塞
local m=95716
local cm=_G["c"..m]
function c95716.initial_effect(c)
	--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e8)
		--Decrease Atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
			--increase def
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DEFCHANGE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9905))
	e0:SetValue(cm.defval)
	c:RegisterEffect(e0)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.poscon)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(cm.damcon)
	e5:SetTarget(cm.damtg)
	e5:SetOperation(cm.damop)
	c:RegisterEffect(e5)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 and ep==tp
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local damval=ev/2
	Duel.SetTargetParam(damval)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,damval)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition() and c:IsDefensePos()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,1)
		tc:RegisterEffect(e1)
	end
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.cfilter(c)
	return c:IsDefensePos() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9905) and c:IsFaceup()
end
function cm.cfilter2(c)
	return c:IsAttackPos() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.atkval(e)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-50
end
function cm.defval(e)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)*50
end