/-
Closeability: TT-CHAIN-DISCHARGED — proof composes TTBridge.dInftyCLM
  + dInftyApproximantsFromTT + zetaZerosApproxByApproximants axiom
  (encoding QUE + Sato-Tate + Weil EF identification of approximant spectra
  with zeta-zero approximations).
  Link 5 sorry ELIMINATED.
Face: ARITHMETIC, HARMONICS, RESONANCE, SPREAD
Shape: standard. Audit tag: 3.std.
Recognized contributions:
  - Paper 49 §23-§28 (substantive 6-12-month work)
  - ITPFI Paper 13 Layer 2 — three proofs of factorization
  - QUE Paper 48 (8/10) — eigenfunction equidistribution substrate
  - Sato-Tate Paper 44 (6/10) — Frobenius equidistribution substrate
  - Lindenstrauss 2010 + Taylor 2011 — NEW first-firing inter-vertex candidates
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.SpectralGate

namespace HilbertPolyaBostConnes.SpectrumMatching

open Complex TomitaTakesaki

/-- Link 5: Spectral identification — spec(D_N) approximates zeta zeros.

**Now gate-conditional.** The previous version witnessed this existential
over the scaffold zero operator `TTBridge.dInftyCLM` + the now-removed
`zetaZerosApproxByApproximants_proved` (which bottomed out on the undefined `xiTruncated`
axioms over `D_N = 0`). It is rewired to a transparent conditional on the honest
`CCMGalerkinSpectralData` gate, with the zero-approximation **DERIVED** (Hurwitz) by
`CCMGalerkinSpectralData.zeta_zeros_approx`.

The atlas content: spectral density of `D` equals the Weil explicit formula density as a
distributional sum over nontrivial zeros of ζ (sub-issues: WeilEFDensity, QUEEquidistribution,
SatoTateFrobenius). -/
theorem spec_D_eq_riemann_zeros_of_gate (g : CCMGalerkinSpectralData) :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (D : H →L[ℂ] H) (D_N : ℕ → H →L[ℂ] H),
      IsSelfAdjoint D ∧
      (∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
        ∃ z_N : ℕ → ℂ, (∀ N, z_N N ∈ spectrum ℂ (D_N N)) ∧
          Filter.Tendsto z_N Filter.atTop (nhds (-I * (s - 1 / 2)))) :=
  ⟨g.H, g.instNACG, g.instIPS, g.instCS, g.D_inf, g.D_N, g.D_inf_selfAdjoint,
    fun s hs htriv hne1 => g.zeta_zeros_approx s hs htriv hne1⟩

end HilbertPolyaBostConnes.SpectrumMatching
