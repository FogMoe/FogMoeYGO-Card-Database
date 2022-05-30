--NCCAG新月·月之圣杯
local m=71110
local cm=_G["c"..m]
function cm.initial_effect(c)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.indtg1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.indtg2)
	c:RegisterEffect(e3)
	--attack all
	local e4=e2:Clone()
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetTarget(cm.eftg)
	c:RegisterEffect(e4)
	--no battle damage
	local e5=e2:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_HAND)
	e7:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e7:SetCountLimit(1,m)
	e7:SetCondition(cm.con)
	e7:SetTarget(cm.tdtg)
	e7:SetOperation(cm.tdop)
	c:RegisterEffect(e7)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic() and e:GetHandler():GetFlagEffect(m-1)>0
end
function cm.eftg(e,c)
	return c:IsCode(m-4)
end
function cm.indtg1(e,c)
	return c:IsCode(m-4) and c==Duel.GetAttacker()
end
function cm.indtg2(e,c)
	local ac=Duel.GetAttacker()
	return ac:IsCode(m-4) and c==Duel.GetAttackTarget()
end
function cm.atfilter(c)
	local g=c:GetBattledGroup()
	if c:GetAttackedCount()~=0 and c:IsCode(m-4) then
		g:AddCard(c)
	end
	return g:IsExists(Card.IsCode,1,nil,m-4)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_MZONE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.atfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if not g:GetFirst() then return end
	local tc=g:GetFirst() 
	local tg=Group.CreateGroup()
	local sg=Group.CreateGroup()
	while tc do
		sg=tc:GetEquipGroup()
		if sg:GetFirst() then
			tg:Merge(sg)
		end
		tc=g:GetNext()
	end
	if tg:GetFirst() then
		g:Merge(tg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end









