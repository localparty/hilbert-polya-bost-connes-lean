# hilbert-polya-bost-connes Lean 4 formalization

<!-- DOI badges are placeholders until Phase E Zenodo mint. -->
<!-- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20916336.svg)](https://doi.org/10.5281/zenodo.20916336) -->
<!-- [![Companion paper DOI](https://img.shields.io/badge/Paper-10.5281%2Fzenodo.20916427-blue)](https://doi.org/10.5281/zenodo.20916427) -->

Companion repository to the paper:

> **The Bost-Connes Modular Generator as a candidate Hilbert-Pólya Operator,
> formalized in Lean 4**
> *G Six*, 2026.

This repository contains the Lean 4 formalization of the construction. Zero
`sorry` count; 8 named programme-level axioms plus 6 TT-upstream-inherited
axioms via lake-dep on
[`tt-bost-connes-lean`](https://github.com/localparty/tt-bost-connes-lean) v0.2;
canonical terminal is a transparent conditional reduction over
`CCMGalerkinSpectralData`.

## Honest framing

The canonical terminal is

```
HilbertPolyaBostConnes.rh_of_ccm_galerkin
  (g : CCMGalerkinSpectralData) : RiemannHypothesis
```

— **"the Riemann Hypothesis follows from inhabiting `CCMGalerkinSpectralData`"**.
Inhabiting `CCMGalerkinSpectralData` is equivalent to the Riemann Hypothesis
(its Hurwitz step runs on the strip `{z | -1/2 < Im z < 1}` where the zeros of
`ξ̂(z) = ζ(1/2 + i·z)` are exactly the rotated nontrivial zeta zeros; combined
with the gate's `IsSelfAdjoint D_∞` field this forces `Re s = 1/2`). NO term of
`CCMGalerkinSpectralData` is constructed in this formalization; the
spectral encoding is DERIVED from the gate's fields via genuine Bögli (Bögli
2017 spectral exactness, reduced to Anselone 1971 / Stummel 1970 atomic) +
Hurwitz (Hurwitz 1893, reduced to Rouché 1862 atomic) machinery on abstract
`CCMGalerkinSpectralData`.

**This is NOT an unconditional closure of the Riemann Hypothesis.** It is a
structural reduction + operator-algebraic construction + transparent conditional
terminal.

## Build

```bash
elan default leanprover/lean4:v4.29.1
lake update
lake build HilbertPolyaBostConnes        # full chain through SpectralGate.rh_of_ccm_galerkin
```

Toolchain: Lean 4 v4.29.1. Mathlib pinned at
`5e932f97dd25535344f80f9dd8da3aab83df0fe6`. Lake-dep on
[`tt-bost-connes-lean`](https://github.com/localparty/tt-bost-connes-lean) v0.2 (commit
`d4bb8949e37f5e4b9769331294e8fb6e07b6de87`) for the Tomita-Takesaki / Bost-
Connes modular substrate.

## Module structure

| Module | Content |
|---|---|
| `Infrastructure.lean` | Opaque BC predicates (`IsTypeIII1`, `IsModularFlowErgodic`, `HasConnesSpectrumReal`), axiom-backed witnesses, Galerkin approximant scaffold |
| `TTBridge.lean` | Bridge defs from TT modular operator + flow into the spectral construction (`deltaModular`, `dInftyModular`, `dInftyCLM`) |
| `Lemmas/HurwitzZeros.lean` | Hurwitz 1893 zero-convergence theorem + DERIVED rotated-zeta data (`xiTruncatedLimit z := ζ(1/2 + i·z)`, `ccmRotationDomain`) |
| `Lemmas/HurwitzZeros/Helpers/Rouche.lean` | Rouché 1862 existence axiom (atomic literature port) |
| `Lemmas/HurwitzZeros/Helpers/Convergence.lean` | Convergence helpers |
| `Lemmas/BoegliExactness.lean` | Bögli 2017 spectral exactness theorem |
| `Lemmas/BoegliExactness/Helpers/Anselone.lean` | Anselone 1971 + Stummel 1970 collectively compact resolvent uniform-bound axiom (atomic literature port) |
| `Lemmas/BoegliExactness/Helpers/SpectralExactness.lean` | Spectral exactness assembly |
| `Lemmas/RellichKondrachov.lean` | Rellich-Kondrachov H¹↪L² discrete compactness scaffolding |
| `Lemmas/RellichKondrachov/Helpers/{CompactEmbedding, GalerkinFiniteRank, UniformBound}.lean` | RK helpers |
| `Lemmas/SubIssueWitnesses.lean` | Sub-issue witnesses |
| `Construction.lean` | `construction_of_gate (g)` — existential bundle of Galerkin spectral data + self-adjointness |
| `PassageToLimit.lean` | `spec_D_infty_eq_riemann_zeros_exact_of_gate (g)` |
| `SpectralGate.lean` | `CCMGalerkinSpectralData` named-gate type + canonical terminal `rh_of_ccm_galerkin (g) : RiemannHypothesis` |
| `RHFollows.lean` | `rh_via_self_adjointness_of_gate (g)` — Link-7 spectral argument (preserved alongside the merged-gate route in SpectralGate) |
| `Assembly.lean` | Chain composition + §7 verification-gates documentation |
| `BCTypeIII1.lean`, `ModularFlowErgodicity.lean`, `HilbertPolyaOperator.lean`, `SpectrumMatching.lean`, `TomitaTakesaki.lean` | Background substrate (off-terminal) |
| `RHInfrastructure/RHWitnessFactory.lean` | Project-local merged-gate RH bridge (`riemann_hypothesis_of_hilbert_polya`) consumed by `SpectralGate.rh_of_ccm_galerkin` |
| `TomitaTakesakiSupport/{Galerkin, RHWitness}.lean` | TT bridge scaffold modules included in this repo because they are not yet promoted to [`tt-bost-connes-lean`](https://github.com/localparty/tt-bost-connes-lean) v0.2 (Phase-7 substrate; SCAFFOLD-form per their source docstrings; zero named axioms / zero sorries) |

Cross-references to the companion paper's sections will be added at the
preprint's v0.1 alignment (Phase C).

## Verification

```bash
# zero code-level sorries:
grep -rE "by sorry|:= sorry|^sorry$|^\s+sorry$" HilbertPolyaBostConnes/ --include='*.lean'
# → no output

# named CCM-own axioms:
grep -hE "^axiom " HilbertPolyaBostConnes/**/*.lean | wc -l
# → 8 (plus 6 TT-upstream-inherited, declared in the lake-dep)

# canonical-terminal #print axioms:
cat > /tmp/print-axioms-hp.lean <<'LEAN'
import HilbertPolyaBostConnes.SpectralGate
#print axioms HilbertPolyaBostConnes.rh_of_ccm_galerkin
LEAN
lake env lean /tmp/print-axioms-hp.lean
# → 'HilbertPolyaBostConnes.rh_of_ccm_galerkin' depends on axioms: [propext,
#    Classical.choice, Quot.sound,
#    HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.collectively_compact_resolvent_uniform_bound,
#    HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.rouche_zero_existence]
```

= **kernel-three + 2 on-terminal CCM-own axioms** (Rouché 1862 +
Anselone-Stummel 1970-71). The other 6 CCM-own axioms (BC operator-
algebraic predicates + Galerkin discrete-compactness scaffolding) and the
6 TT-upstream-inherited axioms (Bost-Connes 1995 + KMS₁ + ITPFI) are
honestly OFF-terminal — they support the broader substrate but the
canonical terminal consumes `CCMGalerkinSpectralData` only via the gate's
type-level fields, decoupling per the project doctrine's conditional-
reduction framing.

The 8 CCM-own axioms and their literature citations:

| # | Axiom | Citation | On/off-terminal |
|---|---|---|---|
| 1 | `bc_factor_isTypeIII1` | Araki–Woods 1968 + Haagerup 1987 | off |
| 2 | `bc_modularFlow_ergodic` | Connes 1973 | off |
| 3 | `bc_connesSpectrum_real` | Connes 1973 | off |
| 4 | `dInftyApproximants_strongConv` | ITPFI + Chatelin (programme-internal Galerkin port) | off |
| 5 | `rouche_zero_existence` | Rouché 1862 (cf. Ahlfors §5.3 Thm 18) | **on** |
| 6 | `collectively_compact_resolvent_uniform_bound` | Anselone 1971 + Stummel 1970 | **on** |
| 7 | `dInftyApproximants_finiteRank` | Paper 13 §L4a Galerkin structural | off |
| 8 | `dInftyApproximants_h1CompactEmbedding` | Rellich 1930 + Kondrachov 1945 | off |

Axiom docstrings carry literature citations with a non-RH-equivalence note.
The on-terminal pair (`rouche_zero_existence`,
`collectively_compact_resolvent_uniform_bound`) carries verbatim statements
from the cited sources; off-terminal background-substrate axioms (#1–4, #7,
#8) carry author/year + topic + non-RH-equivalence framing inherited from
the source CCM substrate.

## License

CC-BY-4.0. See `LICENSE`.

## AI collaboration disclosure

During the preparation of this work, the author used Claude Opus 4.7.
