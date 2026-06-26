/-
Project-local Hurwitz 1893 zero-convergence lemma + DERIVED rotated-zeta analytic data.

## Option-1 DERIVE reconstruction (2026-05-29)

The previous version of this file declared the `xiTruncated*` FAMILY as **undefined
opaque axioms** — `xiTruncated : ℕ → ℂ → ℂ` and `xiTruncatedLimit : ℂ → ℂ` had **no
definition** (pure symbols) — plus the assume-the-spectral-encoding axiom
`xiTruncated_zero_mem_spectrum` (zeros of the undefined `ξ̂_N` are eigenvalues of the
Galerkin operator `D_N`, which over the scaffold `D_N = 0` forces those zeros into
`spectrum 0 = {0}`, i.e. vacuous/inconsistent the moment a nontrivial zero is
exhibited). Together with `zetaZerosApproxByApproximants_proved` over that zero `D_N`
this was the CCM half of the zero-operator + assume-encoding masquerade. **All of that
is removed.**

What survives / is DERIVED here:
  * `hurwitz_zero_convergence` — the genuine project-local Hurwitz theorem (reduces to
    the kept classical Rouché port `rouche_zero_existence`). KEPT verbatim, generic.
  * `xiTruncatedLimit z := riemannZeta (1/2 + I·z)` — now a real DEFINITION (per the RH
    deriver's handoff: Mathlib-derivable; `runs/derive-rh-cycle-01/closure.md`).
  * `xiTruncatedLimit_zero_of_riemannZeta_zero` — DERIVED via `Complex.I_mul_I`.
  * `xiTruncatedLimit_ne_zero_on_rotationDomain` — DERIVED via `riemannZeta_zero`
    (`Ξ(i/2) = ζ(0) = -1/2 ≠ 0`, and `i/2` lies in the rotation domain).
  * `ccmRotationDomain := {z | -1/2 < Im z}` — the open, convex (hence preconnected),
    ζ-pole-avoiding half-plane. Every rotated nontrivial zero `-i(s-1/2)` lies here and
    `Ξ = ζ(1/2+i·)` is holomorphic here (the ζ pole at `s=1` sits at `z = -i/2`, on the
    excluded boundary `Im = -1/2`).
  * `rotatedZero_mem_rotationDomain` — DERIVED via `riemannZeta_ne_zero_of_one_le_re`
    (`ζ(s)=0 ⟹ Re s < 1 ⟹ Im(-i(s-1/2)) = 1/2 - Re s > -1/2`).

The genuinely-open Galerkin data (the finite-rank `D_N`, the truncated `ξ̂_N`, their
strong/locally-uniform convergence, and the Fredholm spectral identification
`ξ̂_N(z)=0 ⟹ z ∈ spec D_N`) is NO LONGER a pile of file-level axioms. It is bundled as
the honest named gate `CCMGalerkinSpectralData` in
`HilbertPolyaBostConnes/SpectralGate.lean`, where the spectral encoding is DERIVED from
the gate via the generic Bögli + Hurwitz machinery together with these DERIVED sub-facts.

Recognized contributions:
  - Adolf Hurwitz 1893 (uniform-on-compacts zero convergence)
  - Eugène Rouché 1862 (existence form, via the kept atomic `rouche_zero_existence`)
  - Riemann ζ values (`riemannZeta_zero`) + non-vanishing on Re ≥ 1
    (`riemannZeta_ne_zero_of_one_le_re`, the PNT input)
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.Convergence
import Mathlib.NumberTheory.LSeries.Nonvanishing

namespace HilbertPolyaBostConnes.Lemmas

open Complex Filter Topology

/-! ## Pure Hurwitz zero-convergence lemma (KEPT — genuine, reduces to Rouché) -/

/-- **Hurwitz 1893**: If `f_n` is a sequence of holomorphic functions on an open
preconnected set `U ⊆ ℂ` converging locally uniformly to `f`, and `f` is not identically
zero on `U` but has a zero at `z₀ ∈ U`, then there exists a sequence `z_n → z₀` with
`f_n (z_n) = 0` eventually.

Proved theorem (re-exports
`HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.hurwitz_zero_convergence`); the proof
reduces the classical content to the single atomic Mathlib-gap sub-axiom
`rouche_zero_existence` (existence form of Rouché's theorem). -/
theorem hurwitz_zero_convergence
    {U : Set ℂ} (hU : IsOpen U) (hU_conn : IsPreconnected U)
    {z₀ : ℂ} (hz₀ : z₀ ∈ U)
    {f_n : ℕ → ℂ → ℂ} {f : ℂ → ℂ}
    (h_diff_n : ∀ n, DifferentiableOn ℂ (f_n n) U)
    (h_tendsto : TendstoLocallyUniformlyOn f_n f Filter.atTop U)
    (h_f_zero : f z₀ = 0)
    (h_f_ne : ¬ Set.EqOn f 0 U) :
    ∃ z_n : ℕ → ℂ, (∀ᶠ n in Filter.atTop, f_n n (z_n n) = 0) ∧
      Filter.Tendsto z_n Filter.atTop (nhds z₀) :=
  HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.hurwitz_zero_convergence
    hU hU_conn hz₀ h_diff_n h_tendsto h_f_zero h_f_ne

/-! ## DERIVED rotated completed-zeta data

The Hurwitz application uses the limit function `Ξ(z) := ζ(1/2 + i·z)` (the nontrivial
zeta zeros, rotated by `s ↦ -i(s-1/2)`, become the zeros of `Ξ`). The previous undefined
`xiTruncatedLimit` axiom is replaced by this definition, and its two analytic properties
become theorems off Mathlib. -/

/-- The rotated zeta limit function `Ξ(z) = ζ(1/2 + i·z)`. DERIVED definition (was an
undefined `noncomputable axiom xiTruncatedLimit : ℂ → ℂ`). -/
noncomputable def xiTruncatedLimit (z : ℂ) : ℂ := riemannZeta (1 / 2 + Complex.I * z)

/-- DERIVED (was an axiom): each nontrivial zeta zero `s` produces a `Ξ`-zero at the
rotated point `-i(s-1/2)`, since `1/2 + i·(-i(s-1/2)) = s` (via `Complex.I_mul_I`). -/
theorem xiTruncatedLimit_zero_of_riemannZeta_zero
    (s : ℂ) (hs : riemannZeta s = 0) :
    xiTruncatedLimit (-Complex.I * (s - 1 / 2)) = 0 := by
  unfold xiTruncatedLimit
  have h : (1 : ℂ) / 2 + Complex.I * (-Complex.I * (s - 1 / 2)) = s := by
    have hI : Complex.I * Complex.I = -1 := Complex.I_mul_I
    linear_combination (1 / 2 - s) * hI
  rw [h]; exact hs

/-! ### The rotation domain `{z | -1/2 < Im z}` -/

/-- The open, preconnected, ζ-pole-and-trivial-zero-avoiding **strip**
`{z | -1/2 < Im z < 1}` in which the Hurwitz argument runs.

Why a strip and not a half-plane: for `z` in the strip, `w := 1/2 + i·z` has
`Re w = 1/2 - Im z ∈ (-1/2, 1)`, so the only ζ-zeros encountered are the **nontrivial**
ones (`0 < Re w < 1`); the trivial zeros (`Re w ≤ -2`) and the ζ pole at `w = 1`
(`z = -i/2`, `Im = -1/2`) are excluded. This is exactly what keeps the
`CCMGalerkinSpectralData` gate **RH-equivalent** rather than secretly inconsistent: a
half-plane would also catch the rotated *trivial* zeros (non-real after rotation),
which no self-adjoint operator could host. `Ξ = ζ(1/2+i·)` is holomorphic on the strip. -/
def ccmRotationDomain : Set ℂ := {z : ℂ | -1/2 < z.im ∧ z.im < 1}

theorem ccmRotationDomain_isOpen : IsOpen ccmRotationDomain :=
  (isOpen_lt continuous_const Complex.continuous_im).inter
    (isOpen_lt Complex.continuous_im continuous_const)

theorem ccmRotationDomain_isPreconnected : IsPreconnected ccmRotationDomain := by
  -- Transport preconnectedness of `univ ×ˢ Ioo(-1/2, 1)` through the ℝ-linear
  -- homeomorphism `ℂ ≃L[ℝ] ℝ × ℝ` (avoids the `ContinuousSMul ℝ ℂ` instance diamond).
  have heq : ccmRotationDomain =
      Complex.equivRealProdCLM.symm '' ((Set.univ : Set ℝ) ×ˢ Set.Ioo (-1/2 : ℝ) 1) := by
    ext z
    simp only [ccmRotationDomain, Set.mem_setOf_eq, Set.mem_image, Set.mem_prod,
      Set.mem_univ, Set.mem_Ioo, true_and]
    constructor
    · intro hz
      exact ⟨(z.re, z.im), hz, by rw [Complex.equivRealProdCLM_symm_apply]; exact Complex.re_add_im z⟩
    · rintro ⟨⟨a, b⟩, hb, rfl⟩
      rw [Complex.equivRealProdCLM_symm_apply]
      simpa using hb
  rw [heq]
  exact (isPreconnected_univ.prod isPreconnected_Ioo).image _
    Complex.equivRealProdCLM.symm.continuous.continuousOn

/-- DERIVED (was the assume-encoding fake `xiTruncatedLimit_not_identically_zero`):
`Ξ` is not identically zero on the rotation strip — witnessed at `z = i/2 ∈
ccmRotationDomain`, where `Ξ(i/2) = ζ(1/2 + i·(i/2)) = ζ(0) = -1/2 ≠ 0`. -/
theorem xiTruncatedLimit_ne_zero_on_rotationDomain :
    ¬ Set.EqOn xiTruncatedLimit 0 ccmRotationDomain := by
  intro h
  have him : (Complex.I / 2).im = 1 / 2 := by
    rw [Complex.div_im]; norm_num [Complex.I_im, Complex.I_re]
  have hmem : (Complex.I / 2) ∈ ccmRotationDomain := by
    show -1/2 < (Complex.I / 2).im ∧ (Complex.I / 2).im < 1
    rw [him]; norm_num
  have h0 : xiTruncatedLimit (Complex.I / 2) = 0 := h hmem
  have hval : xiTruncatedLimit (Complex.I / 2) = riemannZeta 0 := by
    unfold xiTruncatedLimit
    congr 1
    have hI : Complex.I * Complex.I = -1 := Complex.I_mul_I
    linear_combination (1 / 2 : ℂ) * hI
  rw [hval, riemannZeta_zero] at h0
  norm_num at h0

/-! ## DERIVED critical-strip location of nontrivial zeros (the BUILD)

Option-1 DERIVE follow-up: the rotated-zero
domain-membership that was carried as the gate field `rotatedZeros_in_domain` is now
fully DERIVED from Mathlib. The classical fact — nontrivial zeta zeros lie in the open
critical strip `0 < Re s < 1` — comes from the functional equation `riemannZeta_one_sub`
together with the Re ≥ 1 non-vanishing `riemannZeta_ne_zero_of_one_le_re` and `riemannZeta_zero`. -/

/-- **A nontrivial zeta zero lies in the open critical strip `0 < Re s < 1`.** DERIVED.

Upper bound: `riemannZeta_ne_zero_of_one_le_re` (contrapositive). Lower bound: apply the
functional equation `riemannZeta_one_sub` at `1 - s`. If `Re s ≤ 0` then, since the factors
`2`, `(2π)^(-(1-s))`, `Γ(1-s)` and `ζ(1-s)` are all nonzero (the last by the Re ≥ 1
non-vanishing), the FE forces `cos(π(1-s)/2) = 0`, hence `s = -2k` for some `k : ℤ`; combined
with `Re s ≤ 0`, `s ≠ 0` (as `ζ(0) = -1/2 ≠ 0`) and `s` nontrivial, that is a contradiction. -/
theorem riemannZeta_nontrivial_zero_re_pos {s : ℂ}
    (hζ : riemannZeta s = 0) (htriv : ¬∃ n : ℕ, s = -2 * (↑n + 1)) :
    0 < s.re ∧ s.re < 1 := by
  have hub : s.re < 1 := by
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hζ
  refine ⟨?_, hub⟩
  by_contra hle
  rw [not_lt] at hle
  -- s ≠ 0 (else ζ s = ζ 0 = -1/2 ≠ 0)
  have hs0 : s ≠ 0 := by
    rintro rfl; rw [riemannZeta_zero] at hζ; norm_num at hζ
  -- ∀ m:ℕ, (1 - s) ≠ -↑m   (serves the FE hyp at 1-s AND Gamma_ne_zero)
  have hne : ∀ m : ℕ, (1 - s) ≠ -(m : ℂ) := by
    intro m hm
    have hsm : s = 1 + (m : ℂ) := by linear_combination -hm
    have hre : (1 : ℝ) ≤ s.re := by
      rw [hsm, Complex.add_re, Complex.one_re, Complex.natCast_re]
      linarith [Nat.cast_nonneg (α := ℝ) m]
    linarith
  have hne1 : (1 - s) ≠ 1 := fun h => hs0 (by linear_combination -h)
  -- functional equation at (1-s): ζ s = 2 (2π)^(-(1-s)) Γ(1-s) cos(π(1-s)/2) ζ(1-s)
  have hFE := riemannZeta_one_sub hne hne1
  rw [sub_sub_cancel, hζ] at hFE
  -- nonzero factors
  have h2pi : (2 * (Real.pi : ℂ)) ≠ 0 :=
    mul_ne_zero two_ne_zero (Complex.ofReal_ne_zero.mpr Real.pi_ne_zero)
  have hcpow : (2 * (Real.pi : ℂ)) ^ (-(1 - s)) ≠ 0 := by
    intro h; exact h2pi ((Complex.cpow_eq_zero_iff _ _).mp h).1
  have hGamma : Complex.Gamma (1 - s) ≠ 0 := Complex.Gamma_ne_zero hne
  have hzeta1s : riemannZeta (1 - s) ≠ 0 := by
    apply riemannZeta_ne_zero_of_one_le_re
    rw [Complex.sub_re, Complex.one_re]; linarith
  have hprod : (2 : ℂ) * (2 * (Real.pi : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) ≠ 0 :=
    mul_ne_zero (mul_ne_zero two_ne_zero hcpow) hGamma
  -- isolate cos(π(1-s)/2) = 0
  have hcos : Complex.cos ((Real.pi : ℂ) * (1 - s) / 2) = 0 := by
    rcases mul_eq_zero.mp hFE.symm with h | h
    · rcases mul_eq_zero.mp h with h' | h'
      · exact absurd h' hprod
      · exact h'
    · exact absurd h hzeta1s
  -- cos = 0 ⟹ s = -2k
  rw [Complex.cos_eq_zero_iff] at hcos
  obtain ⟨k, hk⟩ := hcos
  have hπ : (Real.pi : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have hk2 : (Real.pi : ℂ) * (1 - s) = (Real.pi : ℂ) * (2 * ↑k + 1) := by linear_combination 2 * hk
  have h1s : (1 - s) = 2 * (↑k : ℂ) + 1 := mul_left_cancel₀ hπ hk2
  have hsk : s = -2 * (↑k : ℂ) := by linear_combination -h1s
  -- contradiction: Re s = -2k ≤ 0 ⟹ k ≥ 0; k = 0 ⟹ s = 0; k ≥ 1 ⟹ s nontrivial-excluded
  have hkre : s.re = -2 * (k : ℝ) := by rw [hsk]; simp
  have hk0 : 0 ≤ k := by
    have : (0 : ℝ) ≤ (k : ℝ) := by rw [hkre] at hle; linarith
    exact_mod_cast this
  rcases eq_or_lt_of_le hk0 with hkeq | hkgt
  · rw [← hkeq] at hsk; simp at hsk; exact hs0 hsk
  · apply htriv
    refine ⟨(k - 1).toNat, ?_⟩
    have hcast : ((k - 1).toNat : ℂ) + 1 = (↑k : ℂ) := by
      have hz : ((k - 1).toNat : ℤ) = k - 1 := Int.toNat_of_nonneg (by omega)
      have : ((k - 1).toNat : ℂ) = (↑k : ℂ) - 1 := by exact_mod_cast hz
      rw [this]; ring
    rw [hsk, hcast]

/-- DERIVED (was the rescinded gate field `rotatedZeros_in_domain`): the rotated point
`-i(s-1/2)` of a nontrivial zeta zero lies in the rotation strip, since
`riemannZeta_nontrivial_zero_re_pos` gives `0 < Re s < 1`, hence
`-1/2 < Im(-i(s-1/2)) = 1/2 - Re s < 1`. -/
theorem rotatedZero_mem_rotationDomain {s : ℂ}
    (hζ : riemannZeta s = 0) (htriv : ¬∃ n : ℕ, s = -2 * (↑n + 1)) :
    (-Complex.I * (s - 1 / 2)) ∈ ccmRotationDomain := by
  obtain ⟨hlb, hub⟩ := riemannZeta_nontrivial_zero_re_pos hζ htriv
  show -1/2 < (-Complex.I * (s - 1 / 2)).im ∧ (-Complex.I * (s - 1 / 2)).im < 1
  have harith : (-Complex.I * (s - 1 / 2)).im = 1 / 2 - s.re := by
    simp [mul_im, I_re, I_im, neg_im, sub_re, sub_im]
  rw [harith]; constructor <;> linarith

end HilbertPolyaBostConnes.Lemmas
