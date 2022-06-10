--时钟试炼官·默
local m=82225
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(cm.condition1)
	e1:SetValue(cm.indval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.condition2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local lp=Duel.GetLP(tp)
	local clp=Duel.GetLP(1-tp)
	return lp>clp
end
function cm.indval(e,c)  
	return c:IsSummonType(SUMMON_TYPE_NORMAL)  
end  
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local lp=Duel.GetLP(tp)
	local clp=Duel.GetLP(1-tp)
	return lp<clp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.filter(c,e,tp)
	return not c:IsCode(m) and c:IsSetCard(0x3294) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e0=Effect.CreateEffect(c)  
		e0:SetType(EFFECT_TYPE_SINGLE)  
		e0:SetCode(EFFECT_DISABLE_EFFECT)  
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e0) 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		Duel.SpecialSummonComplete()
	end
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	e2:SetTargetRange(1,0)  
	e2:SetLabelObject(e)  
	e2:SetTarget(cm.splimit)  
	Duel.RegisterEffect(e2,tp)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return not c:IsRace(RACE_MACHINE)  
end  