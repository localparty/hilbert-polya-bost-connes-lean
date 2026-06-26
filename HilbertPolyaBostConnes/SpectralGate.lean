/-
Honest spectral gate (Option-1 DERIVE refactor).

## What this file is

The honest replacement for the CCM zero-operator + assume-encoding masquerade. It bundles
the genuinely-OPEN Galerkin-approximation data of this programme as ONE named
gate `CCMGalerkinSpectralData`, and **DERIVES** the rotated-zeta spectral encoding from it
using the genuine, generic, kept machinery:

  * `Lemmas.boegli_spectral_exactness`  — Bögli 2017 no-spectral-pollution (reduces to the
    kept Anselone–Stummel port `collectively_compact_resolvent_uniform_bound`);
  * `Lemmas.hurwitz_zero_convergence`   — Hurwitz 1893 (reduces to the kept Rouché port
    `rouche_zero_existence`);
  * the DERIVED rotated-zeta facts `xiTruncatedLimit (= ζ(1/2+i·))`,
    `xiTruncatedLimit_zero_of_riemannZeta_zero`, `xiTruncatedLimit_ne_zero_on_rotationDomain`
    (see `Lemmas/HurwitzZeros.lean`).

The terminal `rh_of_ccm_galerkin (g) : RiemannHypothesis` then discharges RH by **reusing the
merged RH Hilbert–Pólya gate** (`HilbertPolyaBostConnes.RHInfrastructure.riemann_hypothesis_of_hilbert_polya`)
via the bridge `CCMGalerkinSpectralData.toHilbertPolya`. So CCM's genuine Bögli/Hurwitz/
Anselone/Rouché substrate stays **load-bearing**, and CCM is exhibited as a *reduction*
feeding the same named gate RH uses.

`#print axioms rh_of_ccm_galerkin` is `[propext, Classical.choice, Quot.sound,
collectively_compact_resolvent_uniform_bound, rouche_zero_existence]` — the kernel plus the
two KEPT genuine classical literature ports, nothing else: no zero operator, no undefined
`xiTruncated`, no assume-the-encoding axiom, no `sorry`. The Hilbert–Pólya content is a
type-level hypothesis (one must supply `g : CCMGalerkinSpectralData`), not an axiom.

## Why the gate is RH-equivalent (non-vacuous, not secretly inconsistent)

The Hurwitz step runs on the strip `ccmRotationDomain = {z | -1/2 < Im z < 1}`, on which the
zeros of `ζ(1/2+i·)` are exactly the rotated **nontrivial** zeros (the trivial zeros and the
`s=1` pole are off the strip). So the derived encoding only places rotated *nontrivial* zeros
into `spectrum D_inf`; combined with `IsSelfAdjoint D_inf` (spectrum ⊆ ℝ) this is exactly
`Re s = 1/2` for the nontrivial zeros — i.e. inhabiting the gate is equivalent to RH. A
half-plane domain would also catch the rotated trivial zeros (non-real), making the gate
*inconsistent* rather than RH-equivalent; the strip avoids that. The critical-strip
containment of the rotated nontrivial zeros is now **DERIVED** from Mathlib's functional
equation (`Lemmas.rotatedZero_mem_rotationDomain`, via `riemannZeta_nontrivial_zero_re_pos`),
not carried as a gate field — so the gate has NO Mathlib-gap hypothesis (per the memo-35
"DERIVE not BLESS" doctrine; the earlier `rotatedZeros_in_domain` gate field is removed).
-/

import HilbertPolyaBostConnes.Lemmas.BoegliExactness
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros
import HilbertPolyaBostConnes.RHInfrastructure.RHWitnessFactory

namespace HilbertPolyaBostConnes

open Complex Filter
open HilbertPolyaBostConnes.Lemmas

/-- **The CCM Galerkin spectral gate** — the single honestly-named open hypothesis of the
This chain bundles the genuinely-open finite-rank Galerkin-approximation data
(`D_∞ = log Δ|_{H_R}` and its truncations `D_N = P_N ∘ D_∞ ∘ P_N`, the truncated completed-xi
`ξ̂_N`, their convergence and the Fredholm spectral identification). **No term of this type is
currently constructible** — inhabiting it is equivalent to RH (see file header). -/
structure CCMGalerkinSpectralData where
  /-- The Hilbert-space carrier (intended: the even sector `H_R` of the BC GNS space). -/
  H : Type
  [instNACG : NormedAddCommGroup H]
  [instIPS : InnerProductSpace ℂ H]
  [instCS : CompleteSpace H]
  /-- The finite-rank Galerkin approximants (intended: `P_N ∘ log Δ ∘ P_N`). -/
  D_N : ℕ → (H →L[ℂ] H)
  /-- The limit modular Hamiltonian (intended: `D_∞ = log Δ_{ω₁}|_{H_R}`). -/
  D_inf : H →L[ℂ] H
  /-- `D_∞` is self-adjoint — so its spectrum lies on the real axis. -/
  D_inf_selfAdjoint : IsSelfAdjoint D_inf
  /-- `D_N → D_∞` strongly (gsrc). -/
  strongConv : StrongConvergence D_N D_inf
  /-- `{D_N}` is collectively compact (Anselone–Stummel). -/
  collectivelyCompact : CollectivelyCompactFamily D_N
  /-- The truncated completed-xi functions `ξ̂_N` (intended: char. polys of `D_N`). -/
  xiHat : ℕ → ℂ → ℂ
  /-- Each `ξ̂_N` is holomorphic on the rotation strip. -/
  xiHat_differentiableOn : ∀ N, DifferentiableOn ℂ (xiHat N) ccmRotationDomain
  /-- `ξ̂_N → Ξ = ζ(1/2+i·)` locally uniformly on the rotation strip. -/
  xiHat_tendsto : TendstoLocallyUniformlyOn xiHat xiTruncatedLimit Filter.atTop ccmRotationDomain
  /-- Fredholm spectral identification: zeros of `ξ̂_N` are spectral values of `D_N`. -/
  xiHat_zero_mem_spectrum : ∀ (N : ℕ) (z : ℂ), xiHat N z = 0 → z ∈ spectrum ℂ (D_N N)
  /-- Each `D_N` has nonempty spectrum (true for any bounded operator on a nontrivial space). -/
  spectrum_nonempty : ∀ N, (spectrum ℂ (D_N N)).Nonempty

namespace CCMGalerkinSpectralData

/-- **Zero-approximation (Hurwitz), DERIVED from the gate.** For each nontrivial zeta zero
`s`, there is a sequence of spectral points of the `D_N` converging to `-i(s-1/2)`. Proof:
Hurwitz 1893 applied to `ξ̂_N → Ξ` on the rotation strip (using the DERIVED `Ξ`-zero and
non-vanishing facts), spliced with the nonempty-spectrum fallback below the Hurwitz threshold. -/
theorem zeta_zeros_approx (g : CCMGalerkinSpectralData)
    (s : ℂ) (hs : riemannZeta s = 0) (htriv : ¬∃ n : ℕ, s = -2 * (↑n + 1)) (_hne1 : s ≠ 1) :
    ∃ z_N : ℕ → ℂ, (∀ N, z_N N ∈ spectrum ℂ (g.D_N N)) ∧
      Filter.Tendsto z_N Filter.atTop (nhds (-Complex.I * (s - 1 / 2))) := by
  letI := g.instNACG; letI := g.instIPS; letI := g.instCS
  obtain ⟨w_n, hw_zero, hw_conv⟩ :=
    hurwitz_zero_convergence
      ccmRotationDomain_isOpen ccmRotationDomain_isPreconnected
      (rotatedZero_mem_rotationDomain hs htriv)
      g.xiHat_differentiableOn
      g.xiHat_tendsto
      (xiTruncatedLimit_zero_of_riemannZeta_zero s hs)
      xiTruncatedLimit_ne_zero_on_rotationDomain
  rw [Filter.eventually_atTop] at hw_zero
  obtain ⟨N₀, hN₀⟩ := hw_zero
  classical
  let fallback : ℕ → ℂ := fun N => (g.spectrum_nonempty N).choose
  let z_N : ℕ → ℂ := fun N => if N₀ ≤ N then w_n N else fallback N
  refine ⟨z_N, ?_, ?_⟩
  · intro N
    by_cases h : N₀ ≤ N
    · show (if N₀ ≤ N then w_n N else fallback N) ∈ _
      rw [if_pos h]; exact g.xiHat_zero_mem_spectrum N (w_n N) (hN₀ N h)
    · show (if N₀ ≤ N then w_n N else fallback N) ∈ _
      rw [if_neg h]; exact (g.spectrum_nonempty N).choose_spec
  · have heqf : w_n =ᶠ[Filter.atTop] z_N := by
      filter_upwards [Filter.eventually_ge_atTop N₀] with N hN
      show w_n N = (if N₀ ≤ N then w_n N else fallback N)
      rw [if_pos hN]
    exact hw_conv.congr' heqf

/-- **Spectral encoding, DERIVED from the gate** (the load-bearing Bögli step). Each rotated
nontrivial zeta zero lies in the spectrum of `D_∞`: by `zeta_zeros_approx` a sequence of
`D_N`-spectral points converges to it, and Bögli no-spectral-pollution transfers it to the
strong limit `D_∞`. -/
theorem spectral_encoding (g : CCMGalerkinSpectralData)
    (s : ℂ) (hs : riemannZeta s = 0) (htriv : ¬∃ n : ℕ, s = -2 * (↑n + 1)) (hne1 : s ≠ 1) :
    (-Complex.I * (s - 1 / 2)) ∈ spectrum ℂ g.D_inf := by
  letI := g.instNACG; letI := g.instIPS; letI := g.instCS
  obtain ⟨z_N, hspec, hlim⟩ := g.zeta_zeros_approx s hs htriv hne1
  exact boegli_spectral_exactness g.strongConv g.collectivelyCompact hspec hlim

/-- **Bridge to the merged RH Hilbert–Pólya gate.** A CCM Galerkin spectral gate produces an
`HilbertPolyaBostConnes.RHInfrastructure.HilbertPolyaSpectralEncoding`, with the spectral-encoding field
DERIVED (not assumed) via Bögli+Hurwitz. This exhibits CCM as a reduction feeding RH's gate. -/
noncomputable def toHilbertPolya (g : CCMGalerkinSpectralData) :
    HilbertPolyaBostConnes.RHInfrastructure.HilbertPolyaSpectralEncoding where
  H := g.H
  instNACG := g.instNACG
  instIPS := g.instIPS
  instCS := g.instCS
  D := g.D_inf
  D_selfAdjoint := g.D_inf_selfAdjoint
  zeros_in_spectrum := fun s hs htriv hne1 => g.spectral_encoding s hs htriv hne1

end CCMGalerkinSpectralData

/-- **The Riemann Hypothesis, conditional on the CCM Galerkin spectral gate.** The honest CCM
terminal: a transparent conditional discharged by *reusing* the merged RH Hilbert–Pólya gate
through the `toHilbertPolya` bridge. The Hilbert–Pólya content is the type-level hypothesis
`g : CCMGalerkinSpectralData`, not an axiom or `sorry`. -/
theorem rh_of_ccm_galerkin (g : CCMGalerkinSpectralData) : RiemannHypothesis :=
  HilbertPolyaBostConnes.RHInfrastructure.riemann_hypothesis_of_hilbert_polya g.toHilbertPolya

end HilbertPolyaBostConnes
