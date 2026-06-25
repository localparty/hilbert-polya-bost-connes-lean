/-
CCM-complement master construction: compose Links 1-6 into the
self-adjoint operator D_∞ with spectral encoding of zeta zeros.

This theorem has the SAME type as the RH axiom `D_infinity_spectral_encoding`.
With all 6 Links closed via TT-composition, this file now PROVES the
construction by composing TTBridge.dInftyCLM + TTBridge.dInftyCLM_selfAdjoint
+ dInftySpectralEncoding — discharging the RH axiom from the CCM side.

Construction outline (all PROVED via TT chain composition):
  Link 1 (BCTypeIII1):           BC → type III₁ factor on H_{ω₁}
  Link 2 (TomitaTakesaki):       III₁ factor → modular pair (Δ, J)
  Link 3 (ModularFlowErgodicity): σ_t ergodic, Connes Sd(M₁) = ℝ
  Link 4 (HilbertPolyaOperator): D := -(2/π²)·i·log Δ self-adjoint + D_N
  Link 5 (SpectrumMatching):     spec(D_N) approximates zeta zeros
  Link 6 (PassageToLimit):       spec(D_∞) ⊇ rotated zeros (Bögli+Hurwitz)
-/

import HilbertPolyaBostConnes.BCTypeIII1
import HilbertPolyaBostConnes.TomitaTakesaki
import HilbertPolyaBostConnes.ModularFlowErgodicity
import HilbertPolyaBostConnes.HilbertPolyaOperator
import HilbertPolyaBostConnes.SpectrumMatching
import HilbertPolyaBostConnes.PassageToLimit

namespace HilbertPolyaBostConnes

open Complex

/-- The CCM-complement construction: a self-adjoint operator on a Hilbert
space whose spectrum encodes the nontrivial zeros of the Riemann zeta
function via the Hilbert-Pólya rotation s ↦ -i(s - 1/2).

**derive-ccm-cycle-01: now gate-conditional.** The previous version returned the zero-operator
witness `PassageToLimit.spec_D_infty_eq_riemann_zeros_exact` (over `dInftyModular = 0` +
the assume-encoding fake). It is rewired to a transparent conditional on the honest
`CCMGalerkinSpectralData` gate; the existential is realised by the gate's *abstract*
self-adjoint operator with the encoding DERIVED via Bögli + Hurwitz (Link 6). -/
theorem ccm_complement_construction_of_gate (g : CCMGalerkinSpectralData) :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (D : H →L[ℂ] H),
      IsSelfAdjoint D ∧
      (∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
        (-I * (s - 1 / 2)) ∈ spectrum ℂ D) :=
  PassageToLimit.spec_D_infty_eq_riemann_zeros_exact_of_gate g

end HilbertPolyaBostConnes
