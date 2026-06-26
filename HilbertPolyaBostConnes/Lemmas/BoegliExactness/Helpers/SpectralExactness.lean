/-
Bögli 2017 Theorem 2.6 no-spectral-pollution — project-local proof.

This file replaces the monolithic axiom `boegli_spectral_exactness`
(previously declared in `HilbertPolyaBostConnes/Lemmas/BoegliExactness.lean`)
with a proved theorem. The proof depends on
  * Mathlib: `Units.add` (Neumann-series perturbation of a unit; *Heather
    Macbeth* 2020, `Mathlib/Analysis/Normed/Ring/Units.lean`),
    `spectrum.notMem_iff` (resolvent set ↔ unit), `spectrum.of_subsingleton`
    (trivial-algebra spectrum is empty), `norm_algebraMap`,
    `ContinuousLinearMap.norm_id_le` (operator-norm of identity ≤ 1).
  * One *atomic* project-local axiom: the Anselone–Stummel uniform
    resolvent bound
    `HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.collectively_compact_resolvent_uniform_bound`
    (see `Helpers/Anselone.lean`).

## Mathematical content (Bögli 2017 Theorem 2.6, no-pollution direction)

Suppose `D_N → D_∞` strongly (gsrc) and `{D_N}` is collectively compact.
If `z_N ∈ σ(D_N)` for every `N` and `z_N → z`, then `z ∈ σ(D_∞)`.

## Proof outline

By contradiction. Suppose `z ∉ σ(D_∞)`. By the Anselone–Stummel uniform
resolvent bound, there exist `N₀, R > 0` such that for all `N ≥ N₀`,
the operator `z·1 − D_N` is a unit and its inverse has norm `≤ R`.
Since `z_N → z`, pick `N₁` so that `|z_N − z| < R⁻¹` for `N ≥ N₁`. For
`N := max N₀ N₁`, we have:

  * `u_N := (z·1 − D_N)` is a unit with `‖u_N⁻¹‖ ≤ R`;
  * The perturbation `t := (z_N − z)·1 = algebraMap ℂ A (z_N − z)`
    satisfies `‖t‖ = |z_N − z| · ‖1‖ ≤ |z_N − z| < R⁻¹ ≤ ‖u_N⁻¹‖⁻¹`
    (using `‖1‖ ≤ 1` for `1 = id` in `H →L[ℂ] H`, and inverting the
    `‖u_N⁻¹‖ ≤ R` bound — `‖u_N⁻¹‖ > 0` since `u_N⁻¹` is a unit in the
    nontrivial ring `H →L[ℂ] H`).

Mathlib's `Units.add` then yields a unit `u_N + t`, whose underlying
element is `(z·1 − D_N) + (z_N − z)·1 = z_N·1 − D_N`. Hence
`z_N ∉ σ(D_N)`, contradicting `h_spec N`.

The "nontrivial ring" hypothesis is established at the start of the
proof by ruling out the `Subsingleton (H →L[ℂ] H)` case: if the algebra
were trivial, `σ(D_N) = ∅` (by `spectrum.of_subsingleton`), contradicting
`z_N 0 ∈ σ(D_N 0)`.

## Provenance

Created in CCM-worker-boegli-prove sprint (2026-05-25). Architect
directive: discharge the monolithic `boegli_spectral_exactness` axiom in
`Lemmas/BoegliExactness.lean`. Single residual atomic wall:
`collectively_compact_resolvent_uniform_bound` (Anselone–Stummel uniform
resolvent bound) — a genuine Mathlib gap at the pinned SHA
`5e932f97dd25535344f80f9dd8da3aab83df0fe6`.
-/

import HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.Anselone
import Mathlib.Analysis.Normed.Algebra.Spectrum
import Mathlib.Analysis.Normed.Ring.Units
import Mathlib.Analysis.Normed.Operator.ContinuousLinearMap

namespace HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers

open Complex Filter Topology

/-- **Bögli 2017 Theorem 2.6** (no-spectral-pollution direction).
For a sequence `D_N : ℕ → (H →L[ℂ] H)` of bounded operators on a complex
Hilbert space `H` that

  * converges strongly (gsrc) to a bounded operator `D_∞`, and
  * is collectively compact,

every limit `z` of a convergent sequence `(z_N)` with `z_N ∈ σ(D_N)`
lies in the spectrum of the limit `D_∞`:

      z_N ∈ σ(D_N),  z_N → z   ⟹   z ∈ σ(D_∞).

Proof reduces the classical Bögli theorem to the atomic Anselone–Stummel
sub-axiom `collectively_compact_resolvent_uniform_bound` plus Mathlib's
Neumann-series perturbation lemma `Units.add`. -/
theorem boegli_spectral_exactness
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H]
    {D_N : ℕ → (H →L[ℂ] H)} {D_inf : H →L[ℂ] H}
    (h_gsrc : StrongConvergence D_N D_inf)
    (h_cc : CollectivelyCompactFamily D_N)
    {z_N : ℕ → ℂ} {z : ℂ}
    (h_spec : ∀ N, z_N N ∈ spectrum ℂ (D_N N))
    (h_lim : Filter.Tendsto z_N Filter.atTop (nhds z)) :
    z ∈ spectrum ℂ D_inf := by
  by_contra hz_not_spec
  -- ===== Step 1: rule out the Subsingleton (H →L[ℂ] H) case. =====
  haveI hNontriv : Nontrivial (H →L[ℂ] H) := by
    rcases subsingleton_or_nontrivial (H →L[ℂ] H) with hSub | hNon
    · exfalso
      haveI := hSub
      have h := h_spec 0
      rw [spectrum.of_subsingleton (D_N 0)] at h
      exact h
    · exact hNon
  -- ===== Step 2: apply the Anselone sub-axiom. =====
  obtain ⟨N₀, R, hR_pos, hAnselone⟩ :=
    collectively_compact_resolvent_uniform_bound h_gsrc h_cc hz_not_spec
  -- ===== Step 3: convert z_N → z to a metric ε = R⁻¹ statement. =====
  have hRinv_pos : (0 : ℝ) < R⁻¹ := inv_pos.mpr hR_pos
  obtain ⟨N₁, hN₁⟩ := (Metric.tendsto_atTop.mp h_lim) R⁻¹ hRinv_pos
  -- ===== Step 4: pick N = max N₀ N₁ and unpack the resolvent unit. =====
  set N := max N₀ N₁ with hN_def
  have hN0 : N₀ ≤ N := le_max_left _ _
  have hN1 : N₁ ≤ N := le_max_right _ _
  obtain ⟨u_N, hu_eq, hu_bound⟩ := hAnselone N hN0
  -- ===== Step 5: norm bound on the perturbation t = (z_N N − z)·1. =====
  set t : H →L[ℂ] H := algebraMap ℂ (H →L[ℂ] H) (z_N N - z) with ht_def
  have h_one_norm : ‖(1 : H →L[ℂ] H)‖ ≤ 1 := by
    rw [show (1 : H →L[ℂ] H) = ContinuousLinearMap.id ℂ H from
      ContinuousLinearMap.one_def]
    exact ContinuousLinearMap.norm_id_le
  have h_close_norm : ‖z_N N - z‖ < R⁻¹ := by
    have := hN₁ N hN1
    rwa [Complex.dist_eq] at this
  have h_t_norm_le : ‖t‖ ≤ ‖z_N N - z‖ := by
    show ‖algebraMap ℂ (H →L[ℂ] H) (z_N N - z)‖ ≤ ‖z_N N - z‖
    rw [norm_algebraMap]
    nlinarith [norm_nonneg (z_N N - z), h_one_norm, norm_nonneg (1 : H →L[ℂ] H)]
  have h_t_norm_lt : ‖t‖ < R⁻¹ := lt_of_le_of_lt h_t_norm_le h_close_norm
  -- ===== Step 6: from ‖u_N⁻¹‖ ≤ R derive R⁻¹ ≤ ‖u_N⁻¹‖⁻¹. =====
  have h_u_inv_pos : 0 < ‖((↑u_N⁻¹) : H →L[ℂ] H)‖ := Units.norm_pos _
  have h_R_le_inv : R⁻¹ ≤ ‖((↑u_N⁻¹) : H →L[ℂ] H)‖⁻¹ := by
    rw [inv_le_inv₀ hR_pos h_u_inv_pos]
    exact hu_bound
  have h_t_lt_inv : ‖t‖ < ‖((↑u_N⁻¹) : H →L[ℂ] H)‖⁻¹ :=
    lt_of_lt_of_le h_t_norm_lt h_R_le_inv
  -- ===== Step 7: apply Units.add — z_N·1 - D_N is a unit. =====
  have h_uzN_val : (u_N.add t h_t_lt_inv : H →L[ℂ] H) = (u_N : H →L[ℂ] H) + t := rfl
  have h_uzN_eq : (u_N.add t h_t_lt_inv : H →L[ℂ] H) =
      algebraMap ℂ (H →L[ℂ] H) (z_N N) - D_N N := by
    rw [h_uzN_val, hu_eq, ht_def, map_sub (algebraMap ℂ (H →L[ℂ] H)) (z_N N) z]
    abel
  -- ===== Step 8: conclude — z_N N ∉ σ(D_N N), contradicting h_spec N. =====
  have h_unit_zN : IsUnit (algebraMap ℂ (H →L[ℂ] H) (z_N N) - D_N N) :=
    h_uzN_eq ▸ (u_N.add t h_t_lt_inv).isUnit
  exact (spectrum.notMem_iff.mpr h_unit_zN) (h_spec N)

end HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers
