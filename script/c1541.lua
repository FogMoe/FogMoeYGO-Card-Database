local m=1541
local cm=_G["c"..m]
cm.name="时天械末法咏劫"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.desfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x5f30)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.desfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.desfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabel()
	if x~=PLAYER_ALL then
		Duel.RegisterFlagEffect(x,1541,RESET_PHASE+PHASE_END,0,1)
	end
	if x==PLAYER_ALL then
		Duel.RegisterFlagEffect(0,1541,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,1541,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1541)~=0 and Duel.GetCurrentPhase()==PHASE_END
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x5f30) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,99,nil)
	if g:GetCount()~=0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
		local ag=Duel.GetOperatedGroup()
		if ag:GetCount()~=0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.BreakEffect()
			local bg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,ag:GetCount(),nil)
			if bg:GetCount()~=0 then
				Duel.SendtoHand(bg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,bg)
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(cm.getsummoncount(tp))
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetLabel(cm.getsummoncount(tp))
	e6:SetValue(cm.countval)
	e6:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e6,tp)
end
function cm.getsummoncount(tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return cm.getsummoncount(sump)>e:GetLabel()
end
function cm.countval(e,re,tp)
	if cm.getsummoncount(tp)>e:GetLabel() then return 0 else return 1 end
end