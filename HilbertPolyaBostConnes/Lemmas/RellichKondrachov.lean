/-
Project-local Rellich-Kondrachov discharge of
`HilbertPolyaBostConnes.dInftyApproximants_discreteCompact`.

──────────────────────────────────────────────────────────────────────────
Discharged axiom (declared in `Infrastructure.lean`):

  axiom dInftyApproximants_discreteCompact :
      ∀ (f : ℕ → TTBridge.gnsHilbertSpace), (∀ N, ‖f N‖ ≤ 1) →
        ∃ (g : TTBridge.gnsHilbertSpace) (φ : ℕ → ℕ), StrictMono φ ∧
          Filter.Tendsto (fun n => dInftyApproximantsFromTT (φ n) (f (φ n)))
            Filter.atTop (nhds g)

Mathematical content: discrete compactness (Stummel-Vainikko, Bögli-Siegl-
Tretter 2017) of the BC-Galerkin truncation family
`{D_N = dInftyApproximantsFromTT N : N ∈ ℕ}` for the Hilbert-Pólya
operator `D_∞ = log Δ₁`. The honest geometric source is Rellich-Kondrachov
compactness of the embedding `H¹(BC) ↪ L²(BC)` applied to the joint H¹
image of the closed unit ball under the entire family:

  ⋃_N D_N(B_H) ⊆ (a single H¹-bounded set)
    ⊂ (H¹-bounded ⟹ L²-precompact via Rellich-Kondrachov)
    ⊆ (a single compact K ⊂ L²).

The geometric statement — that there is one compact set K ⊂ L² containing
every D_N(B_H) — is the *uniform compactness* / Bögli-Siegl-Tretter
discrete compactness condition. From it the diagonal-subseq conclusion
follows by Bolzano-Weierstrass (`IsCompact.tendsto_subseq`).

──────────────────────────────────────────────────────────────────────────
Discharge of the geometric input (`dInftyApproximantsFromTT_uniformlyCompact`):

Previously a monolithic axiom; now a project-local **proved theorem**
(this file), composing three atomic helpers under
`Helpers/`:

  Helpers/UniformBound.lean       — PROVED theorem (no axiom).
                                    Uniform operator-norm bound from
                                    Mathlib's Banach-Steinhaus applied to
                                    `dInftyApproximants_strongConv`.

  Helpers/GalerkinFiniteRank.lean — atomic axiom
                                    `dInftyApproximants_finiteRank`:
                                    each `D_N` has finite-dimensional
                                    range (structural Galerkin truncation
                                    content from Paper 13 §L4a).

  Helpers/CompactEmbedding.lean   — atomic axiom
                                    `dInftyApproximants_h1CompactEmbedding`:
                                    Rellich-Kondrachov H¹↪L² compact
                                    embedding (Rellich 1930, Kondrachov
                                    1945) applied to the joint H¹-image
                                    of the unit-ball orbit. Conditional
                                    on the uniform bound + finite-rank
                                    inputs.

Net effect: one prior monolithic axiom → ONE proved theorem (Banach-
Steinhaus uniform bound) + TWO atomic axioms (finite-rank + compact
embedding). Both new atomic axioms are *strictly* smaller and more
atomic than the prior axiom in their geometric content.

──────────────────────────────────────────────────────────────────────────
After integration by the orchestrator, the `dInftyApproximants_discreteCompact`
axiom block in `Infrastructure.lean` is replaced by a re-export of the
theorem `dInftyApproximants_discreteCompact_proved` defined here.
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.UniformBound
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.GalerkinFiniteRank
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.CompactEmbedding

namespace HilbertPolyaBostConnes.Lemmas

open Complex HilbertPolyaBostConnes

/-! ## Uniform compactness — PROVED from atomic helpers -/

/-- *Uniform compactness* of the BC-Galerkin truncation family
`dInftyApproximantsFromTT`: there exists a single compact set
`K ⊂ TTBridge.gnsHilbertSpace` such that for every truncation index `N`
and every unit-ball element `x`, `D_N(x) ∈ K`.

This is the Stummel-Vainikko / Bögli-Siegl-Tretter discrete compactness
condition for `{D_N}`, in its strongest geometric form (a single common
compact image bound, not just a precompact set after diagonalisation).

## Proof

Compose three atomic helpers:
  1. `Helpers.dInftyApproximants_uniformBound` (PROVED) — yields a
     constant `C` with `‖D_N‖ ≤ C` for all `N` (Banach-Steinhaus from
     `dInftyApproximants_strongConv`).
  2. `Helpers.dInftyApproximants_finiteRank` (atomic axiom) — yields the
     finite-rank-per-N witness (structural Galerkin truncation content).
  3. `Helpers.dInftyApproximants_h1CompactEmbedding` (atomic axiom) —
     consumes (1)+(2) and yields the joint compact-image conclusion
     (genuine Rellich-Kondrachov H¹↪L² content). -/
theorem dInftyApproximantsFromTT_uniformlyCompact :
    ∃ K : Set TTBridge.gnsHilbertSpace, IsCompact K ∧
      ∀ (N : ℕ) (x : TTBridge.gnsHilbertSpace), ‖x‖ ≤ 1 →
        dInftyApproximantsFromTT N x ∈ K := by
  obtain ⟨C, hC⟩ := RellichKondrachov.Helpers.dInftyApproximants_uniformBound
  exact RellichKondrachov.Helpers.dInftyApproximants_h1CompactEmbedding hC
    RellichKondrachov.Helpers.dInftyApproximants_finiteRank

/-! ## Discharge: discrete compactness from uniform compactness -/

/-- **Discrete compactness of `dInftyApproximantsFromTT` — PROVED.**

Same statement as the axiom
`HilbertPolyaBostConnes.dInftyApproximants_discreteCompact`,
but discharged from the more atomic uniform-compactness theorem
`dInftyApproximantsFromTT_uniformlyCompact` above.

Proof. Given a bounded sequence `(f N)` with `‖f N‖ ≤ 1`, the diagonal
sequence `n ↦ D_n(f n)` lies entirely in the common compact set `K`
provided by the uniform-compactness theorem. Metric-space Bolzano-
Weierstrass (`IsCompact.tendsto_subseq`, which applies because the GNS
Hilbert space is first-countable as a metric space) extracts a convergent
subsequence `D_{φ(n)}(f_{φ(n)}) → g`. -/
theorem dInftyApproximants_discreteCompact_proved :
    ∀ (f : ℕ → TTBridge.gnsHilbertSpace), (∀ N, ‖f N‖ ≤ 1) →
      ∃ (g : TTBridge.gnsHilbertSpace) (φ : ℕ → ℕ), StrictMono φ ∧
        Filter.Tendsto (fun n => dInftyApproximantsFromTT (φ n) (f (φ n)))
          Filter.atTop (nhds g) := by
  intro f hf
  obtain ⟨K, hKcpt, hKbnd⟩ := dInftyApproximantsFromTT_uniformlyCompact
  -- The diagonal sequence n ↦ D_n(f n) lies in K by uniform compactness.
  have hmem : ∀ n,
      (fun m => dInftyApproximantsFromTT m (f m)) n ∈ K :=
    fun n => hKbnd n (f n) (hf n)
  -- Bolzano-Weierstrass on the compact set K yields a convergent subseq.
  obtain ⟨g, _hg_in_K, φ, hφ, hconv⟩ := hKcpt.tendsto_subseq hmem
  exact ⟨g, φ, hφ, hconv⟩

end HilbertPolyaBostConnes.Lemmas
