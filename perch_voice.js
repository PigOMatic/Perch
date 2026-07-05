// ════════════════════════════════════════════════════════════════════════
// PERCH VOICE v1 — Relationship-Aware Voice
// ════════════════════════════════════════════════════════════════════════
//
// Makes Perch sound like it knows the household, not like a form.
// PerchVoice.say(intent, context) returns a short, natural line.
//
// No AI. No API. Pure variation banks + relationship model.
// Reads people from perch_memory_v1, context from perch_context_v1.
// ════════════════════════════════════════════════════════════════════════

(function(global){
'use strict';

// ── Avoid repeating the same phrase twice in a row (per intent) ────────
const _lastSaid = {};
function _pick(intent, variations, fillFn){
  if(!variations || !variations.length) return '';
  let pool = variations;
  // Filter out the exact last-said line for this intent, if pool allows
  if(pool.length>1 && _lastSaid[intent]!=null){
    const filtered = pool.filter((_,i)=>i!==_lastSaid[intent]);
    if(filtered.length){ 
      const idx=Math.floor(Math.random()*filtered.length);
      const realIdx=variations.indexOf(filtered[idx]);
      _lastSaid[intent]=realIdx;
      return fillFn?fillFn(filtered[idx]):filtered[idx];
    }
  }
  const idx=Math.floor(Math.random()*pool.length);
  _lastSaid[intent]=idx;
  return fillFn?fillFn(pool[idx]):pool[idx];
}

// ── PEOPLE MODEL ────────────────────────────────────────────────────────
function _people(){
  try{ return (PerchMemory.get('people')||[]).filter(p=>p.name); }
  catch(e){ return []; }
}
function _findPerson(nameOrId){
  if(!nameOrId) return null;
  const people=_people();
  const lower=String(nameOrId).toLowerCase();
  return people.find(p=>p.id===nameOrId) ||
         people.find(p=>(p.name||'').toLowerCase()===lower) || null;
}

// Relationship word from a person object ("son" → "your son")
function _relationshipRef(p){
  if(!p||!p.relationship) return null;
  const r=p.relationship.toLowerCase();
  const map={
    son:'your son', daughter:'your daughter',
    spouse:'your wife', wife:'your wife', husband:'your husband',
    partner:'your partner', mother:'your mom', father:'your dad',
    brother:'your brother', sister:'your sister', friend:'your friend'
  };
  return map[r]||('your '+r);
}

// Family-position ref derived from birth_year among same-relationship siblings
function _positionRef(p){
  if(!p||!p.birth_year) return null;
  const rel=(p.relationship||'').toLowerCase();
  const kids=_people().filter(x=>['son','daughter'].includes((x.relationship||'').toLowerCase())&&x.birth_year);
  if(['son','daughter'].includes(rel)&&kids.length>=2){
    const sorted=[...kids].sort((a,b)=>a.birth_year-b.birth_year); // oldest first
    if(sorted[0].id===p.id||sorted[0].name===p.name) return 'your oldest';
    if(sorted[sorted.length-1].id===p.id||sorted[sorted.length-1].name===p.name) return 'your youngest';
  }
  // Age-based descriptors
  const age=new Date().getFullYear()-p.birth_year;
  if(rel==='son'){
    if(age<=4) return 'your little guy';
    if(age>=13) return 'your teenager';
  }
  if(rel==='daughter'){
    if(age<=4) return 'your little one';
    if(age>=13) return 'your teenager';
  }
  return null;
}

// Choose a reference for a person — mostly name, occasionally relationship.
// bias: 'name' (default), 'relationship', 'mix'
function personRef(nameOrId, bias){
  const p=_findPerson(nameOrId);
  if(!p) return typeof nameOrId==='string'?nameOrId:'them';
  const name=p.name;
  const rel=_relationshipRef(p);
  const pos=_positionRef(p);
  if(bias==='relationship'&&rel) return rel;
  if(bias==='position'&&pos) return pos;
  // 'mix' or default: name most of the time, relationship ~30%, position ~15%
  const roll=Math.random();
  if(bias==='mix'){
    if(pos&&roll>0.85) return pos;
    if(rel&&roll>0.6) return rel;
    return name;
  }
  return name; // default: use the name
}

// ── ROLE / CONTEXT for Jeff ─────────────────────────────────────────────
// Derived from what Perch knows exists in the household.
function _roleContexts(){
  const ctx=[];
  const people=_people();
  const kids=people.filter(p=>['son','daughter'].includes((p.relationship||'').toLowerCase()));
  if(kids.length) ctx.push('family');       // dad life
  // Work — always present for Jeff (ICU nurse)
  ctx.push('work');
  // Property/homestead
  try{ if((PerchMemory.get('properties')||[]).length) ctx.push('homestead'); }catch(e){}
  // Interests
  try{
    const c=(window.PerchLearn&&PerchLearn.getContext)?PerchLearn.getContext():null;
    if(c&&c.interests&&c.interests.length) ctx.push('interest');
  }catch(e){}
  // Goals
  try{ if((PerchMemory.get('future_horizon')||[]).some(g=>g.is_life_goal)) ctx.push('goals'); }catch(e){}
  return ctx;
}

// ── VARIATION BANKS ─────────────────────────────────────────────────────

// 30+ ask_about_person — {name} filled with personRef
const ASK_ABOUT_PERSON = [
  "What\u2019s {name} into lately?",
  "Anything {name} has been excited about?",
  "What would make {name} light up right now?",
  "What\u2019s {name} been enjoying these days?",
  "Anything new with {name}?",
  "What\u2019s {name} been up to?",
  "What does {name} get excited about lately?",
  "Anything {name} has been wanting to learn?",
  "What\u2019s been keeping {name} busy?",
  "What\u2019s {name}\u2019s thing right now?",
  "Anything {name} can\u2019t stop talking about?",
  "What would {name} pick if it were up to them?",
  "What\u2019s {name} been asking for lately?",
  "Anything {name} has really taken to?",
  "What\u2019s got {name}\u2019s attention these days?",
  "What does {name} love doing right now?",
  "Anything {name} has been curious about?",
  "What\u2019s the latest with {name}?",
  "What\u2019s {name} hooked on lately?",
  "Anything {name} has been into that surprised you?",
  "What would {name} want to do this weekend?",
  "What\u2019s {name} been building or making?",
  "Anything {name} has been practicing?",
  "What lights {name} up these days?",
  "What\u2019s {name} been watching or reading?",
  "Anything {name} has been talking about a lot?",
  "What\u2019s {name}\u2019s current favorite?",
  "What would {name} choose for a treat?",
  "Anything {name} has been proud of lately?",
  "What\u2019s new in {name}\u2019s world?",
  "What has {name} been drawn to recently?",
];

// 20+ ask_about_family
const ASK_ABOUT_FAMILY = [
  "Anything the kids are into lately?",
  "What\u2019s new in dad life?",
  "How\u2019s the family doing this week?",
  "Anything the kids have been asking for?",
  "What\u2019s the household been up to?",
  "Anything fun happening with the kids?",
  "What would the family enjoy this weekend?",
  "Anything the kids have taken to lately?",
  "How are things at home?",
  "What\u2019s been going on with the family?",
  "Anything the kids can\u2019t get enough of?",
  "What\u2019s keeping the house busy these days?",
  "Anything new with the little ones?",
  "What would make for a good family night?",
  "How\u2019s everyone at home doing?",
  "Anything the kids have been excited about?",
  "What\u2019s the family looking forward to?",
  "Anything worth planning for the kids?",
  "What\u2019s been happening around the house?",
  "Anything the kids have been learning?",
  "What would the family want to do together?",
  "Anything new on the home front?",
];

// 20+ ask_about_interest — {interest} optional
const ASK_ABOUT_INTEREST = [
  "Still thinking about {interest}?",
  "How\u2019s the {interest} idea coming along?",
  "Anything new with {interest}?",
  "Still curious about {interest}?",
  "Where are you landing on {interest}?",
  "Been able to look more into {interest}?",
  "Is {interest} still on your mind?",
  "How serious is the {interest} idea getting?",
  "Any progress on the {interest} front?",
  "Still drawn to {interest}?",
  "What\u2019s been taking up your attention outside work?",
  "Anything you\u2019ve been tinkering with lately?",
  "What\u2019s been on your mind outside work?",
  "Any projects pulling at you these days?",
  "Anything new you\u2019ve been wanting to try?",
  "What\u2019s been catching your interest lately?",
  "Anything you\u2019ve been meaning to get into?",
  "What would you spend a free afternoon on?",
  "Anything you\u2019ve been reading up on?",
  "What\u2019s the latest thing you\u2019re into?",
  "Any new rabbit holes lately?",
  "What\u2019s been sparking ideas for you?",
];

// 20+ ask_about_role — keyed by context
const ASK_ABOUT_ROLE = {
  family: [
    "What\u2019s new in dad life?",
    "How\u2019s dad life treating you?",
    "Looks like dad life has been busy \u2014 anything new?",
    "How are things on the dad front?",
    "Anything new with the kids in the mix?",
  ],
  work: [
    "Ready for another ICU night?",
    "How\u2019s the work rhythm lately?",
    "Another shift coming up \u2014 how are you feeling about it?",
    "How\u2019s the schedule treating you?",
    "How\u2019s work been sitting with you lately?",
  ],
  homestead: [
    "Anything happening around the homestead?",
    "How are the property projects coming?",
    "Anything new on the homestead?",
    "What\u2019s next on the property list?",
    "Anything going on around the barn or garden?",
  ],
  interest: [
    "Still thinking about that project?",
    "What\u2019s been taking up your attention outside work?",
    "Any projects pulling at you lately?",
    "Anything outside work that\u2019s been on your mind?",
    "What have you been tinkering with?",
  ],
  goals: [
    "How are you feeling about the big goals lately?",
    "Anything shifting with what you\u2019re building toward?",
    "How\u2019s the plan feeling these days?",
    "Still aiming where you were?",
    "Anything changed about what you\u2019re working toward?",
  ],
};

// 20+ confirm_memory_saved
const CONFIRM_MEMORY = [
  "Got it.",
  "Noted.",
  "I\u2019ll remember that.",
  "Got it \u2014 that\u2019s in.",
  "Filed away.",
  "Good to know.",
  "I\u2019ve got that now.",
  "Locked in.",
  "That\u2019s noted.",
  "Consider it remembered.",
  "Got that down.",
  "I\u2019ll hang onto that.",
  "Noted \u2014 thanks.",
  "That\u2019s saved.",
  "I\u2019ll keep that in mind.",
  "Down for later.",
  "Got it, that helps.",
  "Makes sense \u2014 noted.",
  "I\u2019ll remember.",
  "That\u2019s in the book.",
];

// 15+ recall_answer templates — {summary}, {people}, {context} filled
const RECALL_ANSWER = [
  "{summary}{peopleClause}.",
  "That was {summary}{peopleClause}.",
  "{summary} \u2014 {peopleClause2}.",
  "You\u2019re thinking of {summary}{peopleClause}.",
  "{summary}. {peopleClause3}",
  "That\u2019d be {summary}{peopleClause}.",
  "{summary}{peopleClause} \u2014 does that sound right?",
];

// 15+ confidence_summary (broad)
const CONFIDENCE_SUMMARY = [
  "Perch is starting to understand your life.",
  "Perch is getting to know you.",
  "Perch is picking up the rhythm of your days.",
  "Perch is learning what matters to you.",
  "Perch is starting to see the shape of your week.",
  "Perch knows a bit more about you each day.",
  "Perch is filling in the picture slowly.",
  "Perch is starting to know the household.",
  "Perch is learning your patterns.",
  "Perch is getting a feel for your life.",
  "Perch knows you a little better now.",
  "Perch is building an understanding of your days.",
  "Perch is learning who and what matters to you.",
  "Perch is starting to understand your world.",
  "Perch knows the outlines now, filling in details.",
];

// ── MAIN: say(intent, context) ──────────────────────────────────────────
function say(intent, context){
  context=context||{};
  switch(intent){

    case 'ask_about_person': {
      const ref=personRef(context.person, context.bias||'mix');
      return _pick(intent, ASK_ABOUT_PERSON, (t)=>t.replace(/\{name\}/g, ref));
    }

    case 'ask_about_family':
      return _pick(intent, ASK_ABOUT_FAMILY);

    case 'ask_about_interest': {
      const interest=context.interest||null;
      // If no interest given, prefer the generic (no-{interest}) lines
      const pool = interest
        ? ASK_ABOUT_INTEREST
        : ASK_ABOUT_INTEREST.filter(t=>!t.includes('{interest}'));
      return _pick(intent, pool, (t)=>t.replace(/\{interest\}/g, interest||'that'));
    }

    case 'ask_about_role': {
      const contexts=_roleContexts();
      let roleKey=context.role;
      if(!roleKey||!ASK_ABOUT_ROLE[roleKey]){
        // Pick a context that actually applies to Jeff
        const applicable=contexts.filter(c=>ASK_ABOUT_ROLE[c]);
        roleKey=applicable.length?applicable[Math.floor(Math.random()*applicable.length)]:'work';
      }
      return _pick('ask_about_role_'+roleKey, ASK_ABOUT_ROLE[roleKey]||ASK_ABOUT_ROLE.work);
    }

    case 'confirm_memory_saved':
      return _pick(intent, CONFIRM_MEMORY);

    case 'recall_answer': {
      const summary=context.summary||context.label||'that one';
      const people=context.people||[];
      const interestCtx=context.interestContext||null;
      let peopleClause='', peopleClause2='', peopleClause3='';
      if(people.length){
        const list=people.join(' and ');
        peopleClause=' \u2014 you mentioned it with '+list;
        peopleClause2='you saw it with '+list;
        peopleClause3='You were with '+list+'.';
        if(interestCtx){
          peopleClause=' \u2014 you mentioned seeing it with '+list+' when '+interestCtx+' caught your interest';
          peopleClause3='You saw it with '+list+' around when '+interestCtx+' caught your interest.';
        }
      } else {
        peopleClause2='you mentioned it';
        peopleClause3='';
      }
      return _pick(intent, RECALL_ANSWER, (t)=>t
        .replace(/\{summary\}/g, summary)
        .replace(/\{peopleClause2\}/g, peopleClause2)
        .replace(/\{peopleClause3\}/g, peopleClause3)
        .replace(/\{peopleClause\}/g, peopleClause)
        .replace(/\s+\u2014\s+\./g,'.')  // clean empty clauses
        .replace(/\s+\./g,'.')
        .trim());
    }

    case 'confidence_summary':
      return _pick(intent, CONFIDENCE_SUMMARY);

    case 'followup_interest': {
      const interest=context.interest||'that';
      return _pick(intent, ASK_ABOUT_INTEREST, (t)=>t.replace(/\{interest\}/g, interest));
    }

    case 'ask_missing_area': {
      // Ask about the area with lowest confidence that still applies
      const contexts=_roleContexts().filter(c=>ASK_ABOUT_ROLE[c]);
      const roleKey=contexts.length?contexts[Math.floor(Math.random()*contexts.length)]:'work';
      return _pick('ask_missing_'+roleKey, ASK_ABOUT_ROLE[roleKey]);
    }

    default:
      return '';
  }
}

// ── PLAIN-ENGLISH CONFIDENCE (person/area specific) ─────────────────────
function confidencePhrase(kind, target){
  // kind: 'person' → target is a name; else broad dimension
  if(kind==='person'){
    const p=_findPerson(target);
    if(!p) return null;
    const details=(p.known_details||[]).length;
    const name=p.name;
    if(details===0) return 'Perch is still getting to know '+name+'.';
    if(details===1) return 'Perch knows '+name+' a little.';
    if(details<=3)  return 'Perch knows enough about '+name+' to help with small ideas.';
    return 'Perch knows '+name+' pretty well now.';
  }
  // Broad areas
  const c=(window.PerchLearn&&PerchLearn.getContext)?PerchLearn.getContext().confidence:{};
  const val=c[kind]||0;
  const areas={
    family:'your family', interests:'your hobbies', person:'you',
    work:'your work rhythm', goals:'your goals', money:'your finances'
  };
  const who=areas[kind]||kind;
  if(val<0.1) return 'Perch is still learning '+who+'.';
  if(val<0.35) return 'Perch is starting to understand '+who+'.';
  if(val<0.6) return 'Perch knows a bit about '+who+'.';
  return 'Perch knows '+who+' fairly well.';
}

// Compare two areas — "knows your work rhythm better than your outside-work interests"
function compareAreas(){
  const c=(window.PerchLearn&&PerchLearn.getContext)?PerchLearn.getContext().confidence:{};
  if((c.work||0)>0.2 && (c.interests||0)<(c.work||0)-0.15)
    return 'Perch knows your work rhythm better than your outside-work interests.';
  if((c.family||0)>0.2 && (c.interests||0)<(c.family||0)-0.15)
    return 'Perch knows your family better than your hobbies right now.';
  return null;
}

// ── EXPORTS ──────────────────────────────────────────────────────────────
global.PerchVoice = {
  say,
  personRef,
  relationshipRef:(n)=>{ const p=_findPerson(n); return _relationshipRef(p); },
  positionRef:(n)=>{ const p=_findPerson(n); return _positionRef(p); },
  confidencePhrase,
  compareAreas,
  roleContexts:_roleContexts,
  // testing
  _resetHistory:()=>{ for(const k in _lastSaid) delete _lastSaid[k]; }
};

})(typeof window!=='undefined'?window:global);
