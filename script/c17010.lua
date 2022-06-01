--黯星魔女
local m=66917010
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,66917000) 
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,66917000),aux.NonTuner(nil),1,1)
    c:EnableReviveLimit()    
    --can not attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(cm.atkcon)
    e1:SetOperation(cm.atkop)
    c:RegisterEffect(e1)
    --Activate
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_ATKCHANGE)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCountLimit(1)
    e11:SetTarget(cm.target)
    e11:SetOperation(cm.activate)
    c:RegisterEffect(e11)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --cannot attack announce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(cm.antarget)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e4)
end
function cm.antarget(e,c,sump,sumtype,sumpos,targetp)
    return c:GetAttack()~=c:GetBaseAttack() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(100)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end