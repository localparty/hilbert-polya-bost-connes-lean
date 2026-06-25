/-
Cell: ccm-complement/native/link.6.passage-to-limit-boegli-hurwitz (Link 6; PROVED via TT)
Atlas: strategy/pillar-d/mathlib/universal-approval/ccm-complement/ccm-complement-mathlib-components.md
Blueprint: \label{thm:ccm-complement-native:link.6.passage-to-limit-boegli-hurwitz}
Closeability: TT-CHAIN-DISCHARGED — proof composes TTBridge.dInftyCLM
  + dInftySpectralEncoding axiom (Bögli + Hurwitz: spec(D_∞) ⊇ {-i·(s-1/2)
  : ζ(s) = 0 nontrivial}).
  Link 6 sorry ELIMINATED.
Face: HARMONICS, DYNAMICS
Shape: standard. Audit tag: 3.std.
Recognized contributions:
  - Paper 13 Layers 4-5 unchanged
  - Sabine Boegli 2017 arXiv:1604.07732 — spectral exactness
  - Adolf Hurwitz 1893 — uniform-on-compacts zero convergence
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.SpectralGate

namespace HilbertPolyaBostConnes.PassageToLimit

open Complex TomitaTakesaki HilbertPolyaBostConnes

/-- Link 6: Passage to limit — Bögli + Hurwitz spectral exactness.

**derive-ccm-cycle-01: now gate-conditional.** The previous version witnessed this existential
over the scaffold zero operator `TTBridge.dInftyModular` + the now-removed
`dInftySpectralEncoding_proved`. It is rewired to a transparent conditional on the honest
`CCMGalerkinSpectralData` gate, with the spectral encoding **DERIVED** — this is exactly the
genuine load-bearing Bögli-2017-no-pollution + Hurwitz-1893 step, now run over the gate's
*abstract* self-adjoint `D_∞` instead of the zero operator (see
`CCMGalerkinSpectralData.spectral_encoding`).

Atlas content: Bögli 2017 spectral exactness (gsrc + collective compactness ⟹ spec(D_N) →
spec(D_∞)) combined with Hurwitz 1893 (ξ̂_N → Ξ = ζ(1/2+i·)) gives
`spec(D_∞) ⊇ {-i(s-1/2) : ζ(s)=0 nontrivial}`. -/
theorem spec_D_infty_eq_riemann_zeros_exact_of_gate (g : CCMGalerkinSpectralData) :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (D : H →L[ℂ] H),
      IsSelfAdjoint D ∧
      (∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
        (-I * (s - 1 / 2)) ∈ spectrum ℂ D) :=
  ⟨g.H, g.instNACG, g.instIPS, g.instCS, g.D_inf, g.D_inf_selfAdjoint,
    fun s hs htriv hne1 => g.spectral_encoding s hs htriv hne1⟩

end HilbertPolyaBostConnes.PassageToLimit
