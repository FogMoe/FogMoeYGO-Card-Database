--引星魔女
local m=17013
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,17000) 
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,17000),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit() 
	--SkipPhase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)   
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)  
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_BATTLE_END)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)>=15 end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
end