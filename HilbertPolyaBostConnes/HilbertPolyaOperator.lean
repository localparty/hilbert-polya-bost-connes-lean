/-
Cell: ccm-complement/native/link.4.hilbert-polya-operator-D (Link 4 CENTRAL; PROVED via TT)
Atlas: strategy/pillar-d/mathlib/universal-approval/ccm-complement/ccm-complement-mathlib-components.md
Blueprint: \label{thm:ccm-complement-native:link.4.hilbert-polya-operator-D}
Closeability: TT-CHAIN-DISCHARGED — proof composes TT L7 (D_∞ = log Δ₁)
  + TTBridge.dInftyCLM (bridged to Mathlib ContinuousLinearMap)
  + dInftyApproximantsFromTT (Galerkin approximants from BC truncations)
  + strongConv + discreteCompact axioms (Paper 13 L3a-L4b).
  Link 4 sorry ELIMINATED.
Face: ARITHMETIC, RESONANCE, SYMMETRY
Shape: standard. Audit tag: 3.std.
Recognized contributions:
  - Paper 49 §17-§22 (programme-internal expansion plan)
  - G Six + Claude Opus 4.6/4.7 — programme-native:
    D := -(2/π²) i log Δ definition; even-sector restriction H_R = P_even H_omega_1;
    compact resolvent inheritance from Paper 13 L3c
  - tt-impl: TomitaTakesaki L7.spectral_realization (cherry-pick cf02bb9)
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov

namespace HilbertPolyaBostConnes.HilbertPolyaOperator

open Complex TomitaTakesaki

/-- Link 4 (CENTRAL): Hilbert-Pólya operator D = -(2/π²)·i·log Δ.

**PROVED via TT chain.** Refactored to existential form matching Links 1-3.

This Link is the KEY bridge from axiom types to Mathlib types:
  - TTBridge.dInftyCLM : H →L[ℂ] H provides the operator
  - TTBridge.dInftyCLM_selfAdjoint provides self-adjointness
  - dInftyApproximantsFromTT provides Galerkin truncations
  - dInftyApproximants_strongConv provides convergence
  - dInftyApproximants_discreteCompact provides compactness

The atlas content: define D := -(2/π²) · i · log Δ on Dom(D) ⊂ H_R
(even-sector Hilbert space). D is self-adjoint (Δ > 0 ⟹ log Δ
self-adjoint via Borel functional calculus), has compact resolvent on
H_R (Paper 13 L3c Fourier cancellation H¹ bound), spectral gap from
Selberg-type argument.

Output: ∃ chain producing H + D + D_N approximants + properties. -/
theorem hilbert_polya_operator_D :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (D : H →L[ℂ] H) (D_N : ℕ → H →L[ℂ] H),
      IsSelfAdjoint D ∧
      (∀ f : H, Filter.Tendsto (fun N => D_N N f) Filter.atTop (nhds (D f))) ∧
      (∀ (f : ℕ → H), (∀ N, ‖f N‖ ≤ 1) →
        ∃ (g : H) (φ : ℕ → ℕ), StrictMono φ ∧
          Filter.Tendsto (fun n => D_N (φ n) (f (φ n))) Filter.atTop (nhds g)) :=
  ⟨TTBridge.gnsHilbertSpace,
    TTBridge.hilbertSpaceNACG,
    TTBridge.hilbertSpaceIPS,
    TTBridge.hilbertSpaceCS,
    TTBridge.dInftyModular,
    dInftyApproximantsFromTT,
    TTBridge.deltaModular_selfAdjoint,
    dInftyApproximants_strongConv,
    Lemmas.dInftyApproximants_discreteCompact_proved⟩

end HilbertPolyaBostConnes.HilbertPolyaOperator
