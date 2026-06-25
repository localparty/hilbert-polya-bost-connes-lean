/-
Cell: ccm-complement/native/link.7.RH-follows-from-self-adjointness (Link 7; FOLLOWS)
Atlas: strategy/pillar-d/mathlib/universal-approval/ccm-complement/ccm-complement-mathlib-components.md
Blueprint: \label{thm:ccm-complement-native:link.7.RH-follows-from-self-adjointness}
Closeability: composite — MATHLIB-EXISTS (RHS RiemannHypothesis : Prop at
  Mathlib/NumberTheory/LSeries/RiemannZeta.lean:160 Loeffler) + CCM construction
  (LHS D_infinity self-adjoint via Links 1-6)
Face: ARITHMETIC, RESONANCE
Shape: standard + composite. Audit tag: 3.std + 4 (RHS outcome-4 citation).
Recognized contributions:
  - Bombieri §I — RH formal statement
  - Hilbert-Polya conjecture (folkloric)
  - Loeffler (Mathlib) — root def RiemannHypothesis : Prop
  - CCM-complement Links 1-6 (construction of D_infinity)
-/

import HilbertPolyaBostConnes.Construction

namespace HilbertPolyaBostConnes.RHFollows

open Complex

/-- Link 7: The Riemann Hypothesis follows from self-adjointness of D_∞ — **honest
conditional form (derive-ccm-cycle-01).**

The previous `rh_via_self_adjointness : RiemannHypothesis` concluded RH **unconditionally** by
obtaining the zero-operator construction witness (`dInftyModular = 0` + the assume-encoding
fake). That is replaced by a transparent conditional on the honest `CCMGalerkinSpectralData`
gate. The Link-7 spectral argument is preserved verbatim:

  `D_∞` self-adjoint ⟹ spectrum(D_∞) ⊆ ℝ (`IsSelfAdjoint.im_eq_zero_of_mem_spectrum`);
  the gate-derived encoding puts `-i(s-1/2)` in spectrum(D_∞) for each nontrivial zero `s`;
  so `(-i(s-1/2)).im = 1/2 - Re s = 0`, i.e. `Re s = 1/2`.

The construction is now `ccm_complement_construction_of_gate g` (Bögli + Hurwitz over the
gate's abstract self-adjoint operator). The fully-packaged conditional is also available as
`HilbertPolyaBostConnes.rh_of_ccm_galerkin` (which reuses the merged RH Hilbert–Pólya gate). -/
theorem rh_via_self_adjointness_of_gate (g : CCMGalerkinSpectralData) : RiemannHypothesis := by
  obtain ⟨H, inst₁, inst₂, inst₃, D, hsa, hspec⟩ := ccm_complement_construction_of_gate g
  letI : NormedAddCommGroup H := inst₁
  letI : InnerProductSpace ℂ H := inst₂
  letI : CompleteSpace H := inst₃
  intro s hs_zero hs_triv hs_ne_one
  have hmem := hspec s hs_zero hs_triv hs_ne_one
  have hreal := hsa.im_eq_zero_of_mem_spectrum hmem
  have harith : (-I * (s - 1 / 2)).im = 1 / 2 - s.re := by
    simp [mul_im, I_re, I_im, neg_im, sub_re, sub_im]
  linarith

end HilbertPolyaBostConnes.RHFollows
