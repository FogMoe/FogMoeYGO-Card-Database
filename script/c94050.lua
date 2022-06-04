local m=94050
local cm=_G["c"..m]
cm.name="守护世界法则的战士"
function cm.initial_effect(c)
		--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.rmcon)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.rmcost)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSetCard(0x9401)
end
function cm.alllimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9401)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.alllimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function cm.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		local reset=0
		if tc:IsControler(tp) then
			reset=RESET_OPPO_TURN
		else
			reset=RESET_SELF_TURN
		end
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+reset,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
			e1:SetValue(0)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+reset,0,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end