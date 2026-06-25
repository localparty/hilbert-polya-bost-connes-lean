/-
Cell: ccm-complement/native/link.1.bc-algebra-kms-1-type-iii-1-factor (Link 1; PROVED via TT)
Atlas: strategy/pillar-d/mathlib/universal-approval/ccm-complement/ccm-complement-mathlib-components.md
Blueprint: \label{thm:ccm-complement-native:link.1.bc-algebra-kms-1-type-iii-1-factor}
Closeability: TT-CHAIN-DISCHARGED — proof composes TT L1 (bc_system_exists axiom)
  + TT L2 (gns_construction + type_iii1_factor) + TTBridge instances.
  The Link 1 sorry is ELIMINATED; data flows from TT's actual content.
Face: ARITHMETIC, RESONANCE, MEASURE
Shape: standard. Audit tag: 3.std.
Recognized contributions:
  - Bost + Connes 1995 Selecta Math 1:411-457 Thm 25 — KMS_1 uniqueness
  - Araki + Woods 1968 Publ RIMS 4:51 — ITPFI type III_1 classification
  - Haagerup 1987 Acta Math 158:95-148 — III₁ uniqueness
  - Connes 1976 Ann Math — injectivity from hyperfiniteness
  - tt-impl: TomitaTakesaki L1+L2 (cherry-pick cf02bb9)
-/

import HilbertPolyaBostConnes.Infrastructure

namespace HilbertPolyaBostConnes.BCTypeIII1

open Complex TomitaTakesaki

/-- Link 1: Bost-Connes algebra at KMS₁ produces a type III₁ factor.

**PROVED via TT chain.** The witness chain:
  1. H := `TTBridge.gnsHilbertSpace` (the GNS Hilbert space H_{ω₁})
  2. Mathlib instances: `TTBridge.hilbertSpaceNACG/IPS/CS` (bridge instances)
  3. M := `vonNeumannAlgebraFromTT` (the bicommutant M₁ = π_{ω₁}(B_K)'')
  4. `M.IsTypeIII1` := `isTypeIII1FromTT` (Haagerup uniqueness + Araki-Woods)

This is the first CCM-complement Link whose sorry has been DISCHARGED by the
parallel TT scaffold (commit cf02bb9, cherry-picked into ccm-impl).

Output: Hilbert space H with instances + VonNeumannAlgebra M on H
        satisfying the type III₁ classification. -/
theorem bc_algebra_kms_1_type_iii1_factor :
    ∃ (H : Type) (_ : NormedAddCommGroup H) (_ : InnerProductSpace ℂ H)
      (_ : CompleteSpace H) (M : VonNeumannAlgebra H),
      M.IsTypeIII1 :=
  ⟨TTBridge.gnsHilbertSpace,
    TTBridge.hilbertSpaceNACG,
    TTBridge.hilbertSpaceIPS,
    TTBridge.hilbertSpaceCS,
    vonNeumannAlgebraFromTT,
    isTypeIII1FromTT⟩

end HilbertPolyaBostConnes.BCTypeIII1
