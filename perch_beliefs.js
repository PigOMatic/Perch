// ════════════════════════════════════════════════════════════════════════
// PERCH BELIEFS v1 — Inference Engine Foundation
// ════════════════════════════════════════════════════════════════════════
//
// The brain. Forms beliefs from evidence. Tracks confidence. Ages. Holds
// contradictions. Governed by perch_truth.md and perch_inference.md.
//
// THIS BUILD SURFACES NOTHING TO THE USER. The permission gate denies all
// emission. Beliefs are formed and stored internally only.
//
// No AI. No API. Reads: perch_action_log, perch_behavior_prefs,
// perch_context_v1, perch_memory_v1. Writes: perch_beliefs_v1.
// ════════════════════════════════════════════════════════════════════════

(function(global){
'use strict';

const BELIEFS_KEY = 'perch_beliefs_v1';
const ALK         = 'perch_action_log';

// ── Truth levels (from perch_truth.md) ────────────────────────────────
const TRUTH = { FACT:'fact', INFERENCE:'inference', PATTERN:'pattern',
                IDENTITY:'identity', REFLECTION:'reflection' };

// Confidence thresholds each level requires before it may be SPOKEN.
// This build never speaks — the gate always denies — but the thresholds
// are defined here so the gate enforces perch_truth.md faithfully.
const LEVEL_THRESHOLD = {
  fact:        1.0,   // provable
  inference:   0.5,
  pattern:     0.6,
  identity:    0.75,
  reflection:  0.8,
};

// Memory weight → aging behavior (from perch_truth.md)
const WEIGHT = { PERMANENT:'permanent', DURABLE:'durable', LOW:'low', TINY:'tiny' };
const DECAY_PER_DAY = { permanent:0, durable:0.002, low:0.008, tiny:0.02 };
const ARCHIVE_FLOOR = 0.12; // below this, a decaying belief is archived (not deleted)

// ── STORAGE ───────────────────────────────────────────────────────────
function _load(){
  try{ const raw=localStorage.getItem(BELIEFS_KEY); if(raw) return JSON.parse(raw); }catch(e){}
  return { beliefs:[], _meta:{ version:1, created:_today() } };
}
function _save(store){
  try{ localStorage.setItem(BELIEFS_KEY, JSON.stringify(store)); }catch(e){}
}
function _today(){ return new Date().toISOString().slice(0,10); }
function _daysBetween(aISO,bISO){
  const a=new Date(aISO+'T00:00:00').getTime(), b=new Date(bISO+'T00:00:00').getTime();
  return Math.floor((b-a)/86400000);
}
function _id(){ return 'blf_'+Date.now().toString(36)+'_'+Math.random().toString(36).slice(2,6); }

function _readActionLog(){
  try{ const raw=localStorage.getItem(ALK); const log=raw?JSON.parse(raw):[];
       return Array.isArray(log)?log:[]; }catch(e){ return []; }
}

// ── BELIEF RECORD ─────────────────────────────────────────────────────
function _newBelief(type, label, truthLevel, weight){
  return {
    id: _id(),
    type,                       // 'active_hour_pattern' | 'action_timing_pattern' | ...
    label,                      // human-readable claim
    truth_level: truthLevel,
    confidence: 0,
    evidence_count: 0,
    evidence: [],               // [{ note, ts }]
    contradicted_by: [],        // [{ note, ts }] — held, never auto-resolved
    weight: weight||WEIGHT.LOW,
    created_date: _today(),
    updated_date: _today(),
    last_reinforced_date: _today(),
    status: 'active',           // active | archived
  };
}

function _findBelief(store, type){
  return store.beliefs.find(b=>b.type===type && b.status==='active');
}

// ── CONFIDENCE MODEL ──────────────────────────────────────────────────
// Diminishing returns: each new piece of evidence adds less than the last.
// Never rounds up. Bounded 0–1. Consistency-weighted by the caller.
function _confidenceFromEvidence(evidenceCount, consistency){
  if(evidenceCount<=0) return 0;
  // Saturating curve: approaches but never reaches a ceiling below 1.0.
  // Patterns are never Fact-certain (perch_truth.md), so cap at 0.95.
  const CEIL = 0.95;
  const base = CEIL * (1 - Math.pow(0.75, evidenceCount));  // 1→.24, 4→.65, 8→.86, →.95
  const c = Math.max(0, Math.min(1, consistency==null?1:consistency));
  return parseFloat((base * c).toFixed(3));
}

// Reinforce a belief with a new observation.
function _reinforce(belief, note, consistency){
  belief.evidence.push({ note, ts:new Date().toISOString() });
  if(belief.evidence.length>50) belief.evidence.splice(0, belief.evidence.length-50);
  belief.evidence_count = belief.evidence.length;
  belief.confidence = _confidenceFromEvidence(belief.evidence_count, consistency);
  belief.last_reinforced_date = _today();
  belief.updated_date = _today();
}

// ── AGING ─────────────────────────────────────────────────────────────
// Decay confidence for beliefs not reinforced recently. Permanent never decays.
function _ageBeliefs(store){
  const today=_today();
  store.beliefs.forEach(b=>{
    if(b.status!=='active') return;
    if(b.weight===WEIGHT.PERMANENT) return;
    const idle=_daysBetween(b.last_reinforced_date||b.created_date, today);
    if(idle<=0) return;
    const rate=DECAY_PER_DAY[b.weight]!=null?DECAY_PER_DAY[b.weight]:DECAY_PER_DAY.low;
    const decayed=Math.max(0, b.confidence - rate*idle);
    if(decayed!==b.confidence){
      b.confidence=parseFloat(decayed.toFixed(3));
      b.updated_date=today;
    }
    if(b.confidence<ARCHIVE_FLOOR){
      b.status='archived';           // archived, not deleted — a later mention can revive
      b.updated_date=today;
    }
  });
}

// ── CONTRADICTION SUPPORT ─────────────────────────────────────────────
// Record contradicting evidence WITHOUT overwriting the belief or any
// stated preference. Lowers confidence but keeps both sides.
function _recordContradiction(belief, note){
  belief.contradicted_by.push({ note, ts:new Date().toISOString() });
  // Contradiction erodes confidence but never zeroes a belief outright.
  belief.confidence = parseFloat(Math.max(0, belief.confidence*0.7).toFixed(3));
  belief.updated_date = _today();
}

// ── EVIDENCE COLLECTOR ────────────────────────────────────────────────
// Reads perch_action_log and derives ONLY simple, safe, low-level beliefs.
// Never forms Identity or Reflection beliefs in this build.
function collect(){
  const store=_load();
  const log=_readActionLog();

  // Age existing beliefs first (time has passed since last run).
  _ageBeliefs(store);

  if(!log.length){ _save(store); return store; }

  // Only consider well-formed events (old/partial records are skipped, not fatal).
  const valid=log.filter(e=>e && typeof e.hour==='number' && typeof e.action==='string');

  if(valid.length){
    _deriveActiveHourPattern(store, valid);
    _deriveActionTimingPattern(store, valid);
    _deriveRecResponsePattern(store, valid);
    _deriveStyleResponsePattern(store, valid);
  }

  _save(store);
  return store;
}

// 1. active_hour_pattern — is there a consistent time-of-day the user acts?
function _deriveActiveHourPattern(store, events){
  const morning=events.filter(e=>e.hour>=5 && e.hour<12).length;
  const evening=events.filter(e=>e.hour>=17 && e.hour<24).length;
  const total=events.length;
  if(total<3) return; // Pattern level needs repetition (perch_truth.md)

  const dominant = morning>=evening?'morning':'evening';
  const count = Math.max(morning,evening);
  const consistency = count/total; // how concentrated in that window
  if(count<3) return;

  const label = dominant==='morning'
    ? 'Tends to act in the morning'
    : 'Tends to act in the evening';

  let b=_findBelief(store,'active_hour_pattern');
  if(!b){ b=_newBelief('active_hour_pattern', label, TRUTH.PATTERN, WEIGHT.DURABLE); store.beliefs.push(b); }

  // If the dominant window flipped, that's contradicting evidence — hold it.
  if(b.label!==label && b.evidence_count>0){
    _recordContradiction(b, 'Observed shift toward '+dominant);
    b.label=label; // update the current lean, but keep the contradiction on record
  }
  // Rebuild confidence from the full picture (idempotent per collect run).
  b.evidence=[{ note:count+' of '+total+' actions in the '+dominant, ts:new Date().toISOString() }];
  b.evidence_count=count;
  b.confidence=_confidenceFromEvidence(count, consistency);
  b.last_reinforced_date=_today();
  b.updated_date=_today();
}

// 2. action_timing_pattern — does the user tend to complete vs snooze?
function _deriveActionTimingPattern(store, events){
  const done=events.filter(e=>e.action==='done').length;
  const snoozed=events.filter(e=>e.action==='snoozed').length;
  const total=done+snoozed;
  if(total<3) return;

  const dominant = done>=snoozed?'completes':'defers';
  const count = Math.max(done,snoozed);
  const consistency = count/total;
  const label = dominant==='completes'
    ? 'Tends to complete things when surfaced'
    : 'Tends to defer things when surfaced';

  let b=_findBelief(store,'action_timing_pattern');
  if(!b){ b=_newBelief('action_timing_pattern', label, TRUTH.PATTERN, WEIGHT.DURABLE); store.beliefs.push(b); }
  if(b.label!==label && b.evidence_count>0){
    _recordContradiction(b, 'Observed shift toward '+dominant);
    b.label=label;
  }
  b.evidence=[{ note:count+' of '+total+' were '+dominant, ts:new Date().toISOString() }];
  b.evidence_count=count;
  b.confidence=_confidenceFromEvidence(count, consistency);
  b.last_reinforced_date=_today();
  b.updated_date=_today();
}

// 3. rec_response_pattern — which rec types does the user act on vs ignore?
function _deriveRecResponsePattern(store, events){
  const byRec={};
  events.forEach(e=>{
    if(!e.rec) return;
    // Normalize rec key to a family (rec_bill_due → bill, bp_* → goal, etc.)
    const fam = /bill/.test(e.rec)?'bill' : /bp_|goal/.test(e.rec)?'goal'
              : /shift/.test(e.rec)?'shift' : /brain/.test(e.rec)?'brain' : 'other';
    byRec[fam]=byRec[fam]||{done:0,snoozed:0,dismissed:0,total:0};
    byRec[fam][e.action]=(byRec[fam][e.action]||0)+1;
    byRec[fam].total++;
  });
  Object.keys(byRec).forEach(fam=>{
    const r=byRec[fam];
    if(r.total<3) return; // need repetition
    const actsOn = (r.done||0)/r.total;
    const type='rec_response_pattern:'+fam;
    const label = actsOn>=0.6 ? 'Acts on '+fam+' prompts'
                : actsOn<=0.3 ? 'Tends to skip '+fam+' prompts'
                : 'Mixed response to '+fam+' prompts';
    let b=_findBelief(store,type);
    if(!b){ b=_newBelief(type, label, TRUTH.PATTERN, WEIGHT.LOW); store.beliefs.push(b); }
    if(b.label!==label && b.evidence_count>0){
      _recordContradiction(b, 'Response mix changed for '+fam);
      b.label=label;
    }
    b.evidence=[{ note:(r.done||0)+' acted / '+r.total+' shown', ts:new Date().toISOString() }];
    b.evidence_count=r.total;
    b.confidence=_confidenceFromEvidence(r.total, Math.max(actsOn,1-actsOn));
    b.last_reinforced_date=_today();
    b.updated_date=_today();
  });
}

// 4. style_response_pattern — which wording style earns action?
function _deriveStyleResponsePattern(store, events){
  const byStyle={};
  events.forEach(e=>{
    if(!e.style) return;
    byStyle[e.style]=byStyle[e.style]||{done:0,total:0};
    if(e.action==='done') byStyle[e.style].done++;
    byStyle[e.style].total++;
  });
  const styles=Object.keys(byStyle).filter(s=>byStyle[s].total>=3);
  if(!styles.length) return;
  // Best-performing style with enough evidence.
  let best=null,bestRate=-1;
  styles.forEach(s=>{ const r=byStyle[s].done/byStyle[s].total; if(r>bestRate){bestRate=r;best=s;} });
  if(!best||bestRate<=0) return;

  const type='style_response_pattern';
  const label='Responds best to '+best+' wording';
  let b=_findBelief(store,type);
  if(!b){ b=_newBelief(type,label,TRUTH.PATTERN,WEIGHT.LOW); store.beliefs.push(b); }
  if(b.label!==label && b.evidence_count>0){
    _recordContradiction(b,'Best-performing style changed to '+best);
    b.label=label;
  }
  b.evidence=[{ note:best+': '+byStyle[best].done+'/'+byStyle[best].total+' acted', ts:new Date().toISOString() }];
  b.evidence_count=byStyle[best].total;
  b.confidence=_confidenceFromEvidence(byStyle[best].total, bestRate);
  b.last_reinforced_date=_today();
  b.updated_date=_today();
}

// ── PERMISSION GATE ───────────────────────────────────────────────────
// Decides whether a belief may be EMITTED to the user. In this build the
// gate ALWAYS denies UI emission — beliefs are internal only. It still
// computes the honest answer (permitted/downgraded/denied) so the logic
// is testable and correct for when emission is turned on later.
function evaluate(belief){
  if(!belief) return { decision:'denied', reason:'no belief' };
  const threshold = LEVEL_THRESHOLD[belief.truth_level] ?? 1.0;
  // Identity & Reflection are NEVER formed in this build; refuse them outright.
  if(belief.truth_level===TRUTH.IDENTITY || belief.truth_level===TRUTH.REFLECTION)
    return { decision:'denied', reason:'level not enabled in this build' };
  if(belief.status!=='active')
    return { decision:'denied', reason:'archived' };
  if(belief.confidence>=threshold)
    return { decision:'permitted-internal', reason:'meets threshold', level:belief.truth_level };
  // Could it be spoken at a lower level? (downgrade path, for later use)
  return { decision:'denied', reason:'below threshold' };
}

// HARD RULE: nothing is emitted to UI in this build, regardless of evaluate().
function mayEmitToUI(){ return false; }

// ── EXPORTS ────────────────────────────────────────────────────────────
global.PerchBeliefs = {
  collect,                         // read logs, form/update beliefs, age
  getBeliefs: ()=>_load().beliefs, // internal inspection
  getActive: ()=>_load().beliefs.filter(b=>b.status==='active'),
  evaluate,                        // permission logic (internal)
  mayEmitToUI,                     // always false in this build
  // internals exposed for tests
  _ageBeliefs, _confidenceFromEvidence, _recordContradiction, _newBelief,
  TRUTH, WEIGHT, LEVEL_THRESHOLD,
  reset: ()=>{ try{ localStorage.removeItem(BELIEFS_KEY); }catch(e){} },
};

})(typeof window!=='undefined'?window:global);
