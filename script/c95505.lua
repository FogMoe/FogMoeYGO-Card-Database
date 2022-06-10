local m=95505
local cm=_G["c"..m]
cm.name="机械化 风漂龙"
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
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m-100)
	e4:SetCondition(cm.ctcon)
	e4:SetOperation(cm.drop)
	e4:SetTarget(cm.drtg)
	c:RegisterEffect(e4)
	if cm.counter==nil then
		cm.counter=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if (tc:IsPreviousLocation(LOCATION_MZONE) or tc:IsPreviousLocation(LOCATION_HAND)) and tc:IsSetCard(0x9901) and tc:IsType(TYPE_MONSTER) then
				cm.counter=cm.counter+1
					Duel.RegisterFlagEffect(0,m-100,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	cm.counter=0
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,cm.counter) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cm.counter)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,cm.counter,REASON_EFFECT)
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

