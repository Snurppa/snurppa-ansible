---
name: hickey-review
description: Review code, diffs, or implementation plans through Rich Hickey's "Simple Made Easy" lens — complecting, fragmentation, coupling, and incidental complexity (complexity nobody asked for). Use whenever reviewing a PR, diff, design doc, RFC, or an agent-generated plan, and whenever the user asks "is this simple", "is this over-engineered", "is this coupled", "do we actually need all this", or mentions complecting or Hickey. Use it even for requests phrased as ordinary code review — structural complexity is invisible to correctness review and to tests.
---

# Hickey: Simplicity Review

One question, asked of everything: **what's braided here that could hang
straight?**

Tests tell you the code works. They say nothing about whether it's simple.
Complected code can be correct today; the bill arrives when someone has to
change it.

Analytical only — read, reason, report. Don't run builds or edit code unless
asked separately. Judge against the ask you're given. Context beyond it, and
what to act on and when, belong to the invoker.

## Review steps

Top-down, and cheap where nothing is wrong. Most units get one sentence and no
further attention.

1. **Frame.** Explain the whole artifact in two sentences — what it's for,
   told to its caller. Every other module, system, or concept that sentence
   has to name is a headline candidate.
2. **Zoom.** Take the coarsest level that has more than one unit — packages,
   then types; a plan's components. Give each unit one sentence. Descend only
   into units whose sentence drags strands; a unit that explains alone is done.
3. **Notice.** While reading code at the current level, the shapes in the
   tables below are what catch your eye. They aren't a checklist to run
   against every symbol.
4. **Measure** each candidate (next section), draft its simpler version, and
   re-count.
5. **Widen** when a candidate's shape recurs: check adjacent siblings. The
   symptom the invoker pointed at is often one instance of something larger, and
   the larger thing is the headline.
6. **Report** what survived.

## Vocabulary

- **Simple** — one fold: one role, one concept. About lack of *interleaving*,
  not cardinality. Ten unentangled things beat two knotted ones.
  **Objective** — you can go look for the braids.
- **Easy** — near at hand: installed, familiar, within current skill.
  **Relative** — easy *for whom*. Most defenses of a design are arguments from
  easiness in simplicity's clothes.
- **Complect** — braid together, so neither strand can be reasoned about alone.
- **Compose** — place side by side, preserving independence.
- **Co-explained** — two things are coupled to the degree they must be
  explained together: understanding A needs B, changing A means changing B.
  **Cohesive** when they share meaning. **Accidental** when they ride together
  only because someone put them in the same place.
- **Construct vs. artifact** — the construct is what you type; the artifact is
  what runs and what you live with. Judge constructs by their artifacts.

## The measure

Hickey says where to look; co-explanation says what it costs.

Applied to candidates, not to every symbol. Strands come from two probes:

- **Explain it.** Take the candidate's sentence from the zoom; count what else
  it forces you to name. Finds complecting.
- **Change it.** Change one strand; count what else must change with it.
  Finds fragmentation, which no unit's own sentence shows.

For each strand ask: **do they share meaning — do they change for the same
reasons?**

| Share meaning? | Placed | Verdict |
|---|---|---|
| No | Together | Complecting — split |
| Yes | Apart | Fragmentation — gather |
| Yes | Together | Cohesion — no finding |
| No | Apart | Independence — no finding |

The test runs both ways. A proposed split says what makes the parts two
concepts; a proposed merge says what makes them one. Resemblance isn't shared
meaning. Two helpers that look alike but change on unrelated clocks are two
concepts, and merging them buys a parameterized helper both sides fight over.

A recommendation must lower the count. If the reworked explanation names as
many strands, it's a reshuffle. A simplification shrinks the code too; if the
alternative is bigger than what it replaces, it probably isn't one.

## Inherent and incidental

| Kind | Origin | Verdict |
|---|---|---|
| **Inherent** | The domain is this messy | Keep; make it explicit |
| **Incidental** | Your choice of tool, construct, abstraction, process — *"incidental is Latin for your fault"* | Remove, or state the trade |

Cohesive co-explanation is inherent; accidental co-explanation is incidental.

**The incidental test.** If the requirement stayed identical but you chose a
different shape, would this still exist? No → it's the fault of the choice, not
the problem. Anything that traces to nothing in the ask is incidental.

Incidental complexity isn't forbidden — a framework or an ORM can be worth its
cost. The cost must be **stated**. The Perlis trap: every proposal lists
benefits, none list byproducts.

## Complecting — two things in one

Each row is where to look, not a verdict. A construct is a finding only when
the measure says its strands don't share meaning; most instances of an idiom
are just the idiom.

| Construct | What it can complect | Direction |
|---|---|---|
| Mutable state | Value + time + identity | Immutable values; state behind a functional interface |
| Objects | State + identity + value + namespace | Data + functions + namespaces |
| Inheritance | Type with type | Composition, interfaces |
| Switch / match on type | Who + what, in one closed place | Open polymorphism, dispatch |
| Imperative loops | What + how + order | `map` / `filter` / `reduce`, set functions |
| Direct call A → B | What + when + where | A queue, when timing or placement matters |
| ORM | Identity + relational model + query | Data + declarative query |
| Scattered conditionals | One decision braided into structure | Each policy's rules in one place; rules, lookup tables |
| Hardwired subcomponents | A unit + the parts it assembles | Small interface; parts arrive as arguments |
| One decision moving another | Two decisions into one, such as location + performance | Make each where it's decided |
| Callbacks over mutable state | Control flow + state + time | Streams, queues, values |
| String protocols, ad-hoc formats | Meaning + order | Data |
| Interface implying its implementation | What + how | Declarative spec |
| Hand-rolled utility where a library fits | Scope decision + implementation choice | The library — code you don't own doesn't bitrot. "Zero deps" is an easiness judgment |

## Fragmentation — one thing in many

One domain concept split across fields, modules, or state locations and held
by an unenforced rule. The fingerprint is at the *readers*, each consumer
reconstituting the same value. Reconciliation machinery is the other
fingerprint, such as state copied between entities or a "keep X in sync with Y"
comment. The machinery is the symptom, not the fix.

| Shape | What it fragments | Direction |
|---|---|---|
| Parallel optionals with coupled presence | Existence + shape, admitting illegal states | Discriminated union |
| Booleans encoding a state machine | One state into independent flags | Enum / union naming each state |
| Per-entity copies of a value that must agree | One value into N copies plus an "all agree" rule | Single source of truth at the containing scope |
| Pipeline projecting one value out of a per-entity structure | Sharedness reconstituted at read time | Share the state; delete the pipeline |
| Callback-down + value-up across modules | One state location into a cycle | Lift the state to the shared layer |
| "Update X when Y changes" by convention | A rule into memory | Structure making the coupling mechanical |
| Duplicated derivations | One computation into N copies | Compute once, read N times |
| Config split across files by history | A concept into cross-referenced shards | Collapse into the module that defines the concept |
| Helper placed in whichever module imported it first | Its natural home into an authoring-order accident | The module that *generates* the concept, not the one that first read it |

**Concept multiplication** is the whole-construct case: two constructs for one
concept, delete one. A new abstraction that reinvents the repo's canonical
instance of that kind of thing is the finding; its internals come second.
"Mirrors the existing pattern" is an easiness judgment; extending keeps the
concept count flat, mirroring doubles it.

## Plans

A plan's units are its components. Trace each to the ask; one that traces to
nothing is incidental. An interface with one implementation and no second one
in the plan is the usual case.

## Reasoning that stopped early

The lens leans toward collapsing things; the two-way test is the counterweight.

These phrases mean the reasoning stopped a step early. Reopen what they
dismiss:

- *"separate concerns"*: at the domain level, or just today's file layout?
- *"different consumers read different fields"*
- *"could diverge, but won't in practice"*
- *"each X could eventually have its own Y"*
- *"it's a convention"*, *"we remember to update both"*
- *"X is the natural home for Y"*: circular if Y is already in X.
- *"shaped for a different domain"*: a different domain with the same *kind*
  of operation is concept multiplication.
- *"out of scope"*, *"pre-existing"*, *"follow-up"*: process judgments, not
  simplicity judgments. Report it.

## Reporting

Per finding:

- **Finding** — what's braided or fragmented, and where.
- **Strands** — what a reader must drag along to explain it.
- **Class** — inherent or incidental.
- **Simpler version** and the strands it removes — pseudocode counts. Never
  call something inherent without having designed the simple version and
  saying what makes it non-viable.

Order by strands removed; the first is the headline. No "what's good here"
section — praise biases the framing, and an absent finding is its own praise.
