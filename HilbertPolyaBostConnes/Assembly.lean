/-
HilbertPolyaBostConnes.Assembly — chain aggregator.

Imports every module of the formalization, so that
`import HilbertPolyaBostConnes.Assembly` (driven by the root
`HilbertPolyaBostConnes.lean`) transitively brings the entire chain into
scope for downstream consumers, audit scripts, and `#print axioms`
verification.

## Canonical terminal

```
HilbertPolyaBostConnes.rh_of_ccm_galerkin
  (g : CCMGalerkinSpectralData) : RiemannHypothesis
```

Declared in `HilbertPolyaBostConnes.SpectralGate`. The terminal is a
TRANSPARENT CONDITIONAL REDUCTION on the named Galerkin spectral-data
gate `CCMGalerkinSpectralData`; inhabiting the gate is RH-equivalent
(see the gate-rationale docstring in `SpectralGate.lean`). The terminal
is NOT an unconditional closure of the Riemann Hypothesis.

## Master plan §7 verification gates

This formalization is published under the gates documented in
`hilbert-polya-bost-connes-master-plan.md` §7 and the doctrine document
`concrete-types-strategy.md` §3 (universal protocols). The publishable
attestations are:

1. `lake build HilbertPolyaBostConnes` returns 0; zero `sorry` count
   in `HilbertPolyaBostConnes/*.lean`.
2. The named-axiom inventory matches the master plan §6 budget and the
   `axioms-disclosure.md` companion document, both synced 2026-06-24
   against the construction's HEAD state:
   - 8 CCM-substrate-own atomic axioms (4 Infrastructure BC operator-
     algebraic substrate + 4 Lemmas/Helpers classical literature ports);
   - 6 TT-upstream axioms inherited via the lake-dep on
     `tt-bost-connes-lean` v0.2 (Bost-Connes 1995 substrate).
3. `#print axioms HilbertPolyaBostConnes.rh_of_ccm_galerkin` reports
   the on-terminal closure (kernel-three + two atomic classical-
   literature ports), nothing else:
   ```
   [propext, Classical.choice, Quot.sound,
    HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.collectively_compact_resolvent_uniform_bound,
    HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.rouche_zero_existence]
   ```
4. Each named axiom in the budget passes the per-axiom carrier-type
   audit per `concrete-types-strategy.md` §2.2 (no `Set Unit` collapses,
   no `True` placeholders at the carrier level, no contractible-singleton
   carriers); each carries a docstring with the bibliographic citation,
   theorem number, verbatim statement, and one-line non-RH-equivalence
   note per master plan §6 + doctrine §3.3.
5. Disclosure-alignment crosscheck against the companion paper's
   `references.tex` (Phase C scope; not enforced at this aggregator).
6. Open-content audit: no axiom cites the project's own paper, an
   internal cell, an unpublished preprint, or a placeholder
   (Failure Mode #7 boundary per `concrete-types-strategy.md` §2).
7. Honest framing: paper + README state explicitly that the terminal
   `rh_of_ccm_galerkin` is a CONDITIONAL REDUCTION over the Galerkin
   spectral data type, not an unconditional closure of the Riemann
   Hypothesis. Per `concrete-types-strategy.md` §0 conditional-reduction
   framing.

## Module groups

Chain composition follows the dependency order:

- TT-substrate bridge:
  `TomitaTakesakiSupport/{Galerkin, RHWitness}` (Phase-7 scaffold absorbed
  locally because not yet promoted to `tt-bost-connes-lean` v0.2;
  both scaffold-form, zero named axioms, zero sorries),
  `TTBridge`, `TomitaTakesaki`.
- CCM infrastructure: `Infrastructure`, `BCTypeIII1`,
  `ModularFlowErgodicity`, `HilbertPolyaOperator`, `SpectrumMatching`.
- Atomic literature lemmas (with `Helpers/` sub-axiom files):
  `Lemmas/HurwitzZeros{,/Helpers/Convergence,/Helpers/Rouche}`,
  `Lemmas/BoegliExactness{,/Helpers/Anselone,/Helpers/SpectralExactness}`,
  `Lemmas/RellichKondrachov{,/Helpers/CompactEmbedding,
    /Helpers/GalerkinFiniteRank,/Helpers/UniformBound}`,
  `Lemmas/SubIssueWitnesses`.
- Existential + spectral construction:
  `Construction`, `PassageToLimit`, `RHFollows`.
- RH-bridge gate and terminal:
  `RHInfrastructure/RHWitnessFactory`, `SpectralGate`.
-/

-- TT-substrate bridge (TT v0.2 lake-dep + locally absorbed Phase-7 scaffolds)
import HilbertPolyaBostConnes.TomitaTakesakiSupport.Galerkin
import HilbertPolyaBostConnes.TomitaTakesakiSupport.RHWitness
import HilbertPolyaBostConnes.TTBridge
import HilbertPolyaBostConnes.TomitaTakesaki

-- CCM infrastructure
import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.BCTypeIII1
import HilbertPolyaBostConnes.ModularFlowErgodicity
import HilbertPolyaBostConnes.HilbertPolyaOperator
import HilbertPolyaBostConnes.SpectrumMatching

-- Atomic literature lemmas + Helpers sub-axiom files
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.Convergence
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.Rouche
import HilbertPolyaBostConnes.Lemmas.BoegliExactness
import HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.Anselone
import HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.SpectralExactness
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.CompactEmbedding
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.GalerkinFiniteRank
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.UniformBound
import HilbertPolyaBostConnes.Lemmas.SubIssueWitnesses

-- Existential + spectral construction
import HilbertPolyaBostConnes.Construction
import HilbertPolyaBostConnes.PassageToLimit
import HilbertPolyaBostConnes.RHFollows

-- RH-bridge gate and terminal
import HilbertPolyaBostConnes.RHInfrastructure.RHWitnessFactory
import HilbertPolyaBostConnes.SpectralGate
