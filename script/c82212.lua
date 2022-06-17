local m=82212
local cm=_G["c"..m]
cm.name="川尻早人"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)   
	--return to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BATTLE_START)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.target)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)  
end
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) end  
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	local c=Duel.GetAttacker()  
	if c:IsRelateToBattle() then g:AddCard(c) end  
	c=Duel.GetAttackTarget()  
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g, nil, REASON_EFFECT)  
	end  
end  