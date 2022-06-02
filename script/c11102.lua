--水彩童话·清爽夏夜
function c11102.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c11102.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11102,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c11102.con2)
	e2:SetTarget(c11102.tg2)
	e2:SetOperation(c11102.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11102,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c11102.tg3)
	e3:SetOperation(c11102.op3)
	c:RegisterEffect(e3)
--
end
--
function c11102.con1(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
--
function c11102.con2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD+LOCATION_HAND)==0
		and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c11102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11102.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetTargetRange(1,1)
		e2_1:SetTarget(c11102.limit2_1)
		e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e2_1,tp)
	end
end
function c11102.limit2_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c~=se:GetHandler()
end
--
function c11102.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>=100 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
end
function c11102.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.SetLP(p,Duel.GetLP(p)-100)
	Duel.Recover(p,d,REASON_EFFECT)
end
--
