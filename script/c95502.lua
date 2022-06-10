local m=95502
local cm=_G["c"..m]
cm.name="机械化 维纳斯"
function cm.initial_effect(c)
			--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
		--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.gravecon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m-100)
	e4:SetCondition(cm.ctcon)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0x9901)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function cm.gravecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end

function cm.e3filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9901) and 
	c:IsControlerCanBeChanged()
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(cm.e3filter,tp,0,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil)) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
		local g1=Duel.GetMatchingGroup(cm.e3filter,tp,0,LOCATION_MZONE,nil)
		local g2=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if g1:GetCount()>0 or g2:GetCount()>0 then
			local op=0
			if g1:GetCount()>0 and g2:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			elseif g1:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(m,1))
			else
				op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
			end
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local g=g1:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.GetControl(tc,tp)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=g2:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.HintSelection(g)
					 Duel.Destroy(g,REASON_EFFECT)

				end
			end
		end
		
	
end