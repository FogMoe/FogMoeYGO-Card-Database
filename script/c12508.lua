--大千世界·不可触及的过去
local m=12508
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
   return ((ex1 and (dv1&LOCATION_GRAVE==LOCATION_GRAVE or g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or (ex2 and (dv2&LOCATION_GRAVE==LOCATION_GRAVE or g2 and g2:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or (ex3 and (dv3&LOCATION_GRAVE==LOCATION_GRAVE or g3 and g3:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))or ex4 or ex5) and Duel.IsChainDisablable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end