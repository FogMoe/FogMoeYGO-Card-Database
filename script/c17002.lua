--
local m=66917002
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,66917000)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,66917000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)  
    --remove
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,0))
    e6:SetCategory(CATEGORY_REMOVE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,m)
    e6:SetHintTiming(0,0x1e0)
    e6:SetTarget(cm.rmtg)
    e6:SetOperation(cm.rmop)
    c:RegisterEffect(e6) 
    --decrease atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SET_ATTACK_FINAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetValue(cm.val)
    e2:SetCondition(cm.conditions)
    c:RegisterEffect(e2) 
end
function cm.starlight_fusion_check(tp,sg,fc)
    return aux.gffcheck(sg,Card.IsFusionCode,66917000,Card.IsAttribute,ATTRIBUTE_LIGHT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
         tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
         local e1=Effect.CreateEffect(e:GetHandler())
         e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
         e1:SetCode(EVENT_CHAIN_END)
         e1:SetReset(RESET_EVENT+PHASE_END)
         e1:SetLabelObject(tc)
         e1:SetCountLimit(1)
         e1:SetCondition(cm.retcon)
         e1:SetOperation(cm.retop)
         Duel.RegisterEffect(e1,tp)
    end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
    e:Reset()
end
function cm.val(e,c)
    return c:GetBaseAttack()
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66917001)
end
function cm.conditions(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end