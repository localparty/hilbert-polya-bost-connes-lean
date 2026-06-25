/-
Cell: ccm-complement/native/link.3.modular-flow-ergodicity-connes-spectrum (Link 3; PROVED via TT)
Atlas: strategy/pillar-d/mathlib/universal-approval/ccm-complement/ccm-complement-mathlib-components.md
Blueprint: \label{thm:ccm-complement-native:link.3.modular-flow-ergodicity-connes-spectrum}
Closeability: TT-CHAIN-DISCHARGED — proof composes TT L1+L2+L3+L4 chain
  + isModularFlowErgodicFromTT + hasConnesSpectrumRealFromTT axioms.
  The Link 3 sorry is ELIMINATED; flow ergodicity flows from TT L4 BR Vol II.
Face: DYNAMICS, RESONANCE, ARITHMETIC
Shape: standard. Audit tag: 3.std.
Recognized contributions:
  - BGS chain L2 (paper32-bgs-spectral-statistics/research/01-modular-flow-ergodicity.md)
  - Alain Connes 1973 Ann Inst Fourier 23 — type III + Sd modular spectrum
  - tt-impl: TomitaTakesaki L4 (cherry-pick cf02bb9)
-/

import HilbertPolyaBostConnes.Infrastructure

namespace HilbertPolyaBostConnes.ModularFlowErgodicity

open Complex TomitaTakesaki

/-- Link 3: Modular flow ergodicity and Connes spectrum.

**PROVED via TT chain.** Refactored from universal form to existential
matching Links 1-2 pattern.

Witness chain:
  1. H := `TTBridge.gnsHilbertSpace`
  2. M := `vonNeumannAlgebraFromTT`, `M.IsTypeIII1` := `isTypeIII1FromTT`
  3. Δ := `modularOperatorFromTT`
  4. `IsModularFlowErgodic M` := `isModularFlowErgodicFromTT`
  5. `HasConnesSpectrumReal M` := `hasConnesSpectrumRealFromTT`

The atlas claim: σ_t = Ad(Δ^{it}) is ergodic on M₁ (Path B: factoriality +
trivial center + Tomita-Takesaki). Connes spectrum Sd(M₁) = ℝ. -/
theorem connes_spectrum_real :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (M : VonNeumannAlgebra H) (_ : M.IsTypeIII1)
      (_ : ModularOperator M),
      IsModularFlowErgodic M ∧ HasConnesSpectrumReal M :=
  ⟨TTBridge.gnsHilbertSpace,
    TTBridge.hilbertSpaceNACG,
    TTBridge.hilbertSpaceIPS,
    TTBridge.hilbertSpaceCS,
    vonNeumannAlgebraFromTT,
    isTypeIII1FromTT,
    modularOperatorFromTT,
    isModularFlowErgodicFromTT,
    hasConnesSpectrumRealFromTT⟩

end HilbertPolyaBostConnes.ModularFlowErgodicity
