local m=82248
local cm=_G["c"..m]
--孑影之魔女
function c82248.initial_effect(c)
	--attack limit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CANNOT_ATTACK)  
	c:RegisterEffect(e1)  
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)  
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x3299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and not c:IsCode(m)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER)  
		if g:GetCount()>0 then  
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)  
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local e2=Effect.CreateEffect(e:GetHandler())  
				e2:SetType(EFFECT_TYPE_FIELD)  
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
				e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
				e2:SetTargetRange(0,1)  
				e2:SetValue(cm.aclimit)  
				e2:SetLabel(tc:GetCode())  
				e2:SetReset(RESET_PHASE+PHASE_END)  
				Duel.RegisterEffect(e2,tp) 
			end
		end   
	end  
end  
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsCode(e:GetLabel())  
end  