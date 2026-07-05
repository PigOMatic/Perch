// ════════════════════════════════════════════════════════════════════════
// PERCH INTELLIGENCE ENGINE v1
// ════════════════════════════════════════════════════════════════════════
//
// One brain making all decisions for Today.
// No UI. No HTML. No side effects. Pure decision logic.
//
// buildMorningBrief() → structured object consumed by all render functions.
// Run once per load. Every section reads from the result.
//
// ════════════════════════════════════════════════════════════════════════

(function(global){
'use strict';

// ── CONSTANTS ─────────────────────────────────────────────────────────
const PRIORITY_RANK = {'Life Goal':4, High:3, Medium:2, Low:1};
const COACHING_RANK = {Aggressive:4, Active:3, Balanced:2, Quiet:1};
const SKIP          = new Set(['completed','resolved','dismissed','archived','snoozed']);
const DAYS_FULL     = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

// ── HELPERS ───────────────────────────────────────────────────────────
function fmtTime(t){
  if(!t) return '';
  const[h,m]=t.split(':').map(Number);
  return(h>12?h-12:h||12)+':'+(m<10?'0'+m:m)+(h>=12?'\u202fPM':'\u202fAM');
}

function sortGoals(goals){
  return [...goals].sort((a,b)=>{
    const pd=(PRIORITY_RANK[b.life_priority||'Medium']||2)-(PRIORITY_RANK[a.life_priority||'Medium']||2);
    if(pd!==0) return pd;
    return (COACHING_RANK[b.coaching_level||'Balanced']||2)-(COACHING_RANK[a.coaching_level||'Balanced']||2);
  });
}

function whyNowScore(rec, context){
  // Higher = stronger "why now". Engine uses this to rank and suppress recs.
  let score = rec.baseScore || 50;
  if(rec.timedToToday)    score += 40; // directly tied to today's date
  if(rec.timedToPayday)   score += 35; // tied to upcoming payday
  if(rec.goalConnected)   score += 20; // connected to a named life goal
  if(rec.urgency==='high')score += 25;
  if(rec.urgency==='low') score -= 20;
  if(context.shiftToday && rec.type==='shift_prep') score += 30;
  if(context.shortMoney && rec.type==='bill')        score += 30;
  // Suppress recs that have no "why now" — they could appear any day
  if(!rec.timedToToday && !rec.timedToPayday && !rec.goalConnected && !context.urgentToday)
    score -= 25;
  return Math.max(0, Math.min(100, score));
}

// ── TONE DETERMINATION ────────────────────────────────────────────────
// Single place where emotional register is decided.
function determineTone(context){
  const { shortMoney, shiftToday, shiftTomorrow, hasUrgent,
          daysToPayday, shiftCount, activeCapsCount,
          goalReachedRecently, payArrived, holidayNear } = context;

  if(goalReachedRecently)              return 'Celebrate';
  if(payArrived)                       return 'Opportunity';  // payday = chance to act
  if(holidayNear && !shiftToday)       return 'Opportunity';
  if(shortMoney)                       return 'Focused';
  if(shiftToday && hasUrgent)          return 'Focused';
  if(shiftToday)                       return 'Busy';
  if(hasUrgent)                        return 'Focused';
  if(shiftCount >= 4)                  return 'Recover';     // dense week, today is a rest day
  if(shiftTomorrow && activeCapsCount === 0) return 'Calm';  // tomorrow is the busy day
  if(daysToPayday !== null && daysToPayday <= 1) return 'Opportunity';
  if(activeCapsCount === 0 && !hasUrgent)        return 'Calm';
  return 'Focused';
}

// ── OPENING SENTENCE ──────────────────────────────────────────────────
// The single sentence Perch says first. One truth. No filler.
function buildOpening(context, tone, topGoal){
  const { shiftToday, shiftTomorrow, shortMoney, tightMoney,
          daysToPayday, payArrived, nextFreeDay, shiftCount,
          activeCapsCount, goalReachedRecently } = context;

  const shiftTime = shiftToday ? fmtTime(shiftToday.time) : '';
  const tomTime   = shiftTomorrow ? fmtTime(shiftTomorrow.time) : '';

  // Goal-connected openings — most differentiated thing Perch can say
  if(topGoal && tone === 'Opportunity' && payArrived){
    const pct = topGoal.target_amount > 0
      ? Math.round(topGoal.saved_amount / topGoal.target_amount * 100)
      : null;
    // State the fact (percentage) — don't claim it's their "focus".
    const goalLine = pct ? topGoal.name+' is at '+pct+'%.' : topGoal.name+'.';
    return 'Payday. '+goalLine;
  }
  // (Holiday projection opening removed — it assumed the user would pick up
  //  holiday shifts, which Perch has no evidence for. Fall through to facts.)
  if(goalReachedRecently && topGoal)
    return topGoal.name+' is fully funded. That\u2019s worth stopping for.';

  // Situation-first openings — scoped to what Perch can actually see
  if(shortMoney)    return 'Money\u2019s thin till payday.';
  if(shiftToday){
    // Only name the shift type from real evidence in the shift record.
    const sName = (shiftToday.name||'').toLowerCase();
    const isICU   = /\bicu\b/.test(sName);
    const isNight = (shiftToday.time && parseInt(shiftToday.time) >= 17) || /night/.test(sName);
    // "another" requires provable repetition: 2+ same-type shifts in the weekly schedule
    const sameTypeCount = context.sameTypeShiftCount || 0;
    const canSayAnother = sameTypeCount >= 2;
    if(isICU)   return (canSayAnother?'Another ICU ':'An ICU ')+(isNight?'night.':'shift today.');
    if(isNight) return canSayAnother?'Another night shift.':'Night shift tonight.';
    return 'Working today.';
  }
  if(tightMoney)                 return 'Covered, just barely.';
  if(shiftTomorrow)              return 'No shift today.';
  if(payArrived)                 return 'Payday landed.';
  if(daysToPayday !== null && daysToPayday <= 3)
    return 'Payday\u2019s close.';
  if(shiftCount >= 4 && nextFreeDay)
    return 'Long stretch this week. '+nextFreeDay+' is your next day off.';
  if(tone === 'Calm' && activeCapsCount === 0)
    return 'Nothing on Perch\u2019s list today.';
  if(tone === 'Calm')
    return 'Nothing on Perch\u2019s list today.';
  return 'Nothing on Perch\u2019s list today.';
}

// ── RECOMMENDATION CANDIDATES ─────────────────────────────────────────
// Build all possible recs as structured objects, score them, return sorted.
function buildRecCandidates(context, topGoal){
  const { fin, activeCaps, shiftToday, shiftTomorrow, shortMoney } = context;
  const candidates = [];

  // Bill recs
  fin.beforeBills.filter(b=>!b.autopay).forEach(b=>{
    candidates.push({
      type: 'bill',
      key:  'rec_bill_due',
      text: b.name+' is due before payday. Worth getting it off the list.',
      whyNow: 'Before next payday',
      goalConnected: false,
      timedToToday: false,
      timedToPayday: true,
      urgency: shortMoney ? 'high' : 'medium',
      baseScore: 65,
      actionVal: 'done',
      data: b,
    });
  });

  // Tight money rec
  if(shortMoney){
    const names = fin.beforeBills.filter(b=>!b.autopay).map(b=>b.name);
    candidates.push({
      type: 'finance',
      key:  'rec_tight_money',
      text: names.length === 1
        ? names[0]+' is due before payday. Worth handling now.'
        : names.length > 1
        ? names.slice(0,-1).join(', ')+' and '+names.slice(-1)+' are due before payday.'
        : 'Mark any bills already handled \u2014 keeps your balance accurate.',
      whyNow: 'Balance goes negative before payday',
      goalConnected: false,
      timedToPayday: true,
      timedToToday: false,
      urgency: 'high',
      baseScore: 80,
    });
  }

  // Shift prep recs
  if(shiftToday){
    candidates.push({
      type: 'shift_prep',
      key:  'rec_shift_today',
      text: shiftToday.time
        ? 'Shift tonight at '+fmtTime(shiftToday.time)+'. Give yourself time to get ready.'
        : 'Working today. Give yourself time to get ready.',
      whyNow: 'Shift is today',
      goalConnected: false,
      timedToToday: true,
      timedToPayday: false,
      urgency: 'medium',
      baseScore: 60,
    });
  } else if(shiftTomorrow){
    candidates.push({
      type: 'shift_prep',
      key:  'rec_shift_tomorrow',
      text: shiftTomorrow.time
        ? 'Shift tomorrow at '+fmtTime(shiftTomorrow.time)+'. Today is yours.'
        : 'Shift tomorrow. Today is yours.',
      whyNow: 'Shift is tomorrow',
      goalConnected: false,
      timedToToday: true,
      timedToPayday: false,
      urgency: 'low',
      baseScore: 40,
    });
  }

  // Brain cap recs
  if(activeCaps.length > 0){
    const oldest = activeCaps[activeCaps.length-1];
    const label  = oldest.clean_label || oldest.label || 'something in your Brain';
    candidates.push({
      type: 'brain_clear',
      key:  'rec_brain',
      text: activeCaps.length === 1
        ? '\u201C'+label+'\u201D is still open.'
        : activeCaps.length+' things in Brain. \u201C'+label+'\u201D has been there longest.',
      whyNow: activeCaps.length > 3 ? 'Brain is getting full' : null,
      goalConnected: false,
      timedToToday: false,
      timedToPayday: false,
      urgency: activeCaps.length > 3 ? 'medium' : 'low',
      baseScore: activeCaps.length > 3 ? 45 : 30,
      suppressable: true, // can be hidden if something more important exists
    });
  }

  // Goal-connected rec — always surfaces if goal + payday approaching
  if(topGoal && fin.paydayAmount > 0 && fin.daysToPayday != null && fin.daysToPayday <= 7){
    const remaining = (topGoal.target_amount||0) - (topGoal.saved_amount||0);
    const perPayday = remaining > 0 ? Math.ceil(remaining/24) : 0;
    if(perPayday >= 5){
      candidates.push({
        type: 'goal_transfer',
        key:  'rec_goal_payday',
        text: 'Payday is in '+fin.daysToPayday+(fin.daysToPayday===1?' day':' days')+'. Move $'+perPayday+' toward '+topGoal.name+'.',
        whyNow: 'Payday in '+fin.daysToPayday+(fin.daysToPayday===1?' day':' days'),
        goalConnected: true,
        goalName: topGoal.name,
        timedToToday: false,
        timedToPayday: true,
        urgency: 'medium',
        baseScore: 55,
      });
    }
  }

  // Payday landed rec
  if(context.payArrived){
    candidates.push({
      type: 'finance',
      key:  'rec_payday_landed',
      text: 'Payday landed. Update your balance when it hits.',
      whyNow: 'Payday is today',
      goalConnected: !!topGoal,
      timedToToday: true,
      timedToPayday: false,
      urgency: 'medium',
      baseScore: 70,
    });
  }

  // Clear day rec
  if(candidates.length === 0 || candidates.every(c=>c.urgency==='low')){
    candidates.push({
      type: 'clear',
      key:  'rec_clear',
      text: 'Nothing urgent today. Enjoy the breathing room.',
      whyNow: null,
      goalConnected: false,
      timedToToday: false,
      timedToPayday: false,
      urgency: 'none',
      baseScore: 10,
      suppressable: true,
    });
  }

  // Score all candidates
  candidates.forEach(r => { r.score = whyNowScore(r, context); });
  candidates.sort((a,b) => b.score - a.score);
  return candidates;
}

// ── TOP PRIORITY ───────────────────────────────────────────────────────
function buildTopPriority(context, tone){
  const { hasUrgent, shortMoney, shiftToday, activeCaps, fin } = context;

  if(shortMoney && fin.beforeBills.filter(b=>!b.autopay).length > 0){
    const b = fin.beforeBills.filter(b=>!b.autopay)[0];
    return {
      type: 'financial',
      label: b.name+' before payday',
      urgent: true,
      whyNow: 'Balance goes negative if unpaid',
    };
  }
  if(hasUrgent && !shiftToday){
    return {
      type: 'overdue',
      label: 'Something is overdue',
      urgent: true,
      whyNow: 'Past due date',
    };
  }
  if(shiftToday){
    return {
      type: 'shift',
      label: 'Shift today',
      urgent: false,
      whyNow: 'Working today',
    };
  }
  if(activeCaps.length > 0){
    const oldest = activeCaps[activeCaps.length-1];
    return {
      type: 'brain',
      label: oldest.clean_label || oldest.label || 'Open Brain item',
      urgent: false,
      whyNow: activeCaps.length > 2 ? activeCaps.length+' things open' : null,
    };
  }
  return { type: 'none', label: null, urgent: false, whyNow: null };
}

// ── SUPPORTING FACTS ──────────────────────────────────────────────────
function buildFacts(context){
  const { fin, shiftToday, shiftTomorrow, activeCaps, shifts } = context;
  const facts = [];

  if(fin.payday){
    if(context.shortMoney){
      facts.push('\uD83D\uDCB8 Projected \u2212$'+Math.abs(fin.projected).toLocaleString()+' after '
        +fin.beforeBills.length+' bill'+(fin.beforeBills.length!==1?'s':'')+' before payday');
    } else if(fin.beforeBills.length > 0){
      const names = fin.beforeBills.slice(0,2).map(b=>b.name).join(', ')+(fin.beforeBills.length>2?' +more':'');
      facts.push(names+' due before payday \u2014 $'+fin.projected.toLocaleString()+' clear after.');
    } else {
      facts.push('No bills before payday \u2014 $'+fin.balance.toLocaleString()+' clear.');
    }
    if(fin.daysToPayday != null && fin.daysToPayday <= 5 && facts.length < 3)
      facts.push('Payday in '+fin.daysToPayday+' day'+(fin.daysToPayday===1?'':'s')+'.');
  }

  if(facts.length < 3){
    const _t = shiftToday ? shiftToday.time||'' : '';
    const _t2 = shiftTomorrow ? shiftTomorrow.time||'' : '';
    if(shiftToday)
      facts.push('Shift today'+(_t?' at '+fmtTime(_t):'')+'.') ;
    else if(shiftTomorrow)
      facts.push('Shift tomorrow'+(_t2?' at '+fmtTime(_t2):'')+'.') ;
    else if(!shifts.length)
      facts.push('No shifts scheduled this week.');
  }

  if(facts.length < 3 && activeCaps.length > 0){
    const oldest = activeCaps[activeCaps.length-1];
    const label  = oldest.clean_label || oldest.label || 'item';
    facts.push((activeCaps.length===1?'One thing':activeCaps.length+' things')
      +' open in Brain \u2014 \u201C'+label+'\u201D oldest.');
  }

  return facts;
}

// ── MAIN ENGINE FUNCTION ───────────────────────────────────────────────
function buildMorningBrief(){
  const fin         = PerchMemory.financeSnapshot();
  const okR         = PerchMemory.evaluateOK();
  const todayDow    = new Date().getDay();
  const shifts      = (PerchMemory.get('work.schedule')||[]);
  const activeCaps  = (PerchMemory.get('captures')||[]).filter(c=>!SKIP.has(c.status||''));
  const priorities  = (PerchMemory.get('priorities')||[]).filter(p=>p.active!==false);
  const userGoals   = (PerchMemory.get('future_horizon')||[])
    .filter(g=>g.user_created&&!g.seed&&g.is_life_goal&&g.name);
  const people      = PerchMemory.get('people')||[];

  const shiftToday    = shifts.find(s=>s.day_of_week===todayDow);
  const shiftTomorrow = shifts.find(s=>s.day_of_week===(todayDow+1)%7);
  // Provable repetition: how many shifts in the weekly schedule share today's type?
  // Used to gate "another" — only claimed when the pattern is real, not assumed.
  const sameTypeShiftCount = (()=>{
    if(!shiftToday) return 0;
    const tName=(shiftToday.name||'').toLowerCase();
    const tICU=/\bicu\b/.test(tName);
    const tNight=(shiftToday.time&&parseInt(shiftToday.time)>=17)||/night/.test(tName);
    return shifts.filter(s=>{
      const n=(s.name||'').toLowerCase();
      const nICU=/\bicu\b/.test(n);
      const nNight=(s.time&&parseInt(s.time)>=17)||/night/.test(n);
      return (tICU&&nICU)||(tNight&&nNight)||(!tICU&&!tNight&&n===tName);
    }).length;
  })();
  const shortMoney    = fin.payday && fin.projected<0;
  const tightMoney    = fin.payday && fin.projected>=0 && fin.totalBefore>0 && fin.projected<(fin.balance*0.15);
  const hasUrgent     = !!(PerchEvents.getOverdue&&PerchEvents.getOverdue().length>0)
                      ||(PerchEvents.getToday&&PerchEvents.getToday().filter(e=>e.type!=='shift').length>0);
  const payArrived    = fin.payday && fin.daysToPayday===0;
  const daysToPayday  = fin.daysToPayday;

  // Next free day (for busy week openings)
  const nextFreeDay=(()=>{
    if(!shifts.length) return null;
    for(let i=2;i<8;i++){
      const d=new Date(); d.setDate(d.getDate()+i);
      if(!shifts.some(s=>s.day_of_week===d.getDay()))
        return DAYS_FULL[d.getDay()];
    }
    return null;
  })();

  // Goal reached recently (cross-page flag)
  let goalReachedRecently=false;
  try{
    const flag=localStorage.getItem('perch_goal_updated');
    if(flag){const f=JSON.parse(flag);goalReachedRecently=!!(f&&f.reached);}
  }catch(e){}

  // Holiday near (for Opportunity tone)
  const holidayNear=(()=>{
    try{
      if(typeof _nextHoliday==='function'){
        const h=_nextHoliday();
        return h&&h.days<=14?h:null;
      }
    }catch(e){}
    return null;
  })();

  // Holiday shift pay estimate
  const holidayShiftPay=holidayNear&&shifts.length>0
    ? Math.round((fin.paydayAmount||0)/Math.max(shifts.length*2,1)*1.5)
    : 0;

  // Top life goal
  const topGoal = userGoals.length ? sortGoals(userGoals)[0] : null;

  // Build shared context object — all decisions read from this
  const context = {
    fin, okR, shifts, activeCaps, priorities, userGoals, people,
    shiftToday, shiftTomorrow, shortMoney, tightMoney,
    hasUrgent, payArrived, daysToPayday,
    shiftCount: shifts.length,
    sameTypeShiftCount,
    activeCapsCount: activeCaps.length,
    nextFreeDay, goalReachedRecently,
    holidayNear, holidayShiftPay,
    urgentToday: hasUrgent || shortMoney,
  };

  // ── DECISIONS ──────────────────────────────────────────────────────
  const tone         = determineTone(context);
  const opening      = buildOpening(context, tone, topGoal);
  const topPriority  = buildTopPriority(context, tone);
  const recCandidates= buildRecCandidates(context, topGoal);
  const facts        = buildFacts(context);

  // Primary rec = highest scored
  const recommendation = recCandidates[0] || null;

  // Suppressed recs = scored < 30 OR suppressable with something better above them
  const suppressedRecs = recCandidates.filter((r,i)=>
    i>0 && (r.score<30 || (r.suppressable && recCandidates[0].score>50))
  );

  // Reasons (transparency for debugging and future "Why Perch?" view)
  const reasons=[];
  if(tone) reasons.push('Tone is '+tone+' because: '
    +(shortMoney?'finances tight':shiftToday?'shift today':payArrived?'payday':hasUrgent?'something urgent':'quiet day'));
  if(recommendation) reasons.push('Top rec: '+recommendation.key+' (score '+recommendation.score+') — '+recommendation.whyNow);
  if(suppressedRecs.length) reasons.push('Suppressed: '+suppressedRecs.map(r=>r.key).join(', '));
  if(topGoal) reasons.push('Top goal: '+topGoal.name+' ('+topGoal.life_priority+', '+topGoal.coaching_level+')');

  return {
    // Core
    tone,
    opening,
    topPriority,
    recommendation,
    suppressedRecs,
    topGoal,
    facts,
    reasons,
    // Pass-through context for render functions
    _context: context,
    // Derived flags render functions use
    shiftToday, shiftTomorrow, shortMoney, tightMoney, hasUrgent,
    payArrived, daysToPayday, activeCaps, fin, priorities,
    shifts, userGoals,
  };
}

// ── EXPORT ─────────────────────────────────────────────────────────────
global.PerchBrief = { build: buildMorningBrief };

})(typeof window!=='undefined'?window:global);
