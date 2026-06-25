/-
Banach-Steinhaus uniform operator-norm bound for the BC-Galerkin
truncation family `dInftyApproximantsFromTT` — project-local PROVED
theorem (no new axioms).

## Statement and scope

`dInftyApproximants_uniformBound`:
  ∃ C : ℝ, ∀ N : ℕ, ‖dInftyApproximantsFromTT N‖ ≤ C

i.e. the operator-norm family `(‖D_N‖)_N` is uniformly bounded.

This is the standard **uniform boundedness consequence of pointwise
boundedness** for a family of continuous linear maps from a Banach
space, specialised to the Galerkin truncation `D_N` and the strong-
convergence input `dInftyApproximants_strongConv` (Infrastructure axiom).

## Proof (one-shot from Mathlib's Banach-Steinhaus)

For each `x : H`, the sequence `(D_N x)_N` converges to `D_∞ x` (the
strong-convergence Infrastructure axiom `dInftyApproximants_strongConv`),
so its range is bounded in `H`
(`Metric.isBounded_range_of_tendsto`). Mathlib's
`Bornology.IsBounded.exists_norm_le` extracts the per-`x` bound `C(x)`.
The Uniform Boundedness Principle
(`banach_steinhaus`, `Mathlib.Analysis.Normed.Operator.BanachSteinhaus`)
then converts pointwise boundedness into the desired uniform
operator-norm bound.

`gnsHilbertSpace` satisfies `CompleteSpace` (TT-Bridge instance
`hilbertSpaceCS`, ultimately from `UniformSpace.Completion` being a
complete metric space), which is the only nontrivial hypothesis of
`banach_steinhaus`.

## No axioms introduced

This file is a pure theorem; it does NOT introduce any new axiom. The
only Infrastructure-side axiom it consumes is
`dInftyApproximants_strongConv` (already pre-existing).

## Provenance

Created in CCM-worker-rellich-prove sprint (2026-05-25). Architect
directive: factor the original `dInftyApproximantsFromTT_uniformlyCompact`
axiom into its strictly-PROVABLE half (Banach-Steinhaus uniform bound)
+ its strictly-AXIOMATIC half (Rellich-Kondrachov H¹↪L² compact
embedding; see `CompactEmbedding.lean` for the residual axiom).
-/

import HilbertPolyaBostConnes.Infrastructure
import Mathlib.Analysis.Normed.Operator.BanachSteinhaus
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Analysis.Normed.Group.Bounded

namespace HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers

open HilbertPolyaBostConnes Filter Topology

/-- **Uniform operator-norm bound for the Galerkin truncation family.**

There exists a real constant `C` such that `‖dInftyApproximantsFromTT N‖ ≤ C`
for every truncation index `N : ℕ`.

Proof: pointwise convergence (`dInftyApproximants_strongConv`) ⇒ each
sequence `(D_N x)_N` is bounded (`isBounded_range_of_tendsto`). Mathlib's
`banach_steinhaus` (Uniform Boundedness Principle on a Banach space)
converts this pointwise boundedness into the uniform operator-norm bound. -/
theorem dInftyApproximants_uniformBound :
    ∃ C : ℝ, ∀ N : ℕ, ‖dInftyApproximantsFromTT N‖ ≤ C := by
  apply banach_steinhaus (g := fun N => dInftyApproximantsFromTT N)
  intro x
  -- (D_N x)_N converges to D_∞ x (the strong-convergence axiom).
  have h_conv :
      Tendsto (fun N => dInftyApproximantsFromTT N x) atTop
        (𝓝 (TTBridge.dInftyModular x)) :=
    dInftyApproximants_strongConv x
  -- A convergent sequence in a metric space has bounded range.
  have h_bdd :
      Bornology.IsBounded
        (Set.range (fun N => dInftyApproximantsFromTT N x)) :=
    Metric.isBounded_range_of_tendsto _ h_conv
  -- Extract the per-x bound.
  obtain ⟨C, hC⟩ := h_bdd.exists_norm_le
  refine ⟨C, fun N => ?_⟩
  exact hC _ ⟨N, rfl⟩

end HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers
