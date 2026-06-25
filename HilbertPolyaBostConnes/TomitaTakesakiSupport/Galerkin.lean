/-
Phase 7 (subagent 2 scope): Galerkin truncations D_N of the modular Hamiltonian.

Defines `dInftyGalerkin : BostConnesSystem → ℕ → H →L[ℂ] H`, the family of
finite-dimensional Galerkin projections of D_∞ that the RH chain's
TTPhase5RHWitness consumes via `D_N : ℕ → H →L[ℂ] H`.

SCAFFOLD FORM: `dInftyGalerkin BC N := 0` (zero CLM for all N). The genuine
Galerkin truncation `P_N · D_∞ · P_N` (where P_N is the orthogonal projection
to the first N Hecke basis vectors) requires an explicit orthonormal basis on
the GNS Hilbert space — substrate that refines once the BC algebra structure
(StarRing + StarModule + Hecke basis) is asserted on BostConnesSystem.

UPGRADE PATH:
  1. Assert an orthonormal basis {e_n} on L2.GNSHilbert BC (from the bilateral
     Hecke basis Ω_{n,m,α} of the BC algebra at KMS₁)
  2. Define P_N := ∑_{i<N} |e_i⟩⟨e_i| (finite-rank projection)
  3. `dInftyGalerkin BC N := P_N ∘ modularHamiltonian BC ∘ P_N`
  4. Each D_N is self-adjoint + finite-rank (hence compact)

Source: Teschl, Mathematical Methods in Quantum Mechanics, 2014, §2.4;
  Reed-Simon, Methods of Modern Mathematical Physics I, 1972, Ch. VIII.
-/

import TomitaTakesaki.TomitaS

namespace HilbertPolyaBostConnes.TomitaTakesakiSupport.Galerkin

open TomitaTakesaki

/-- Galerkin truncation of D_∞ to the first N basis vectors of the GNS
Hilbert space.

Scaffold: zero CLM for all N. Substantive: `P_N ∘ D_∞ ∘ P_N` where
P_N is the orthogonal projection onto the first N Hecke basis vectors. -/
noncomputable def dInftyGalerkin (BC : BostConnesSystem) (_ : ℕ) :
    L2.GNSHilbert BC →L[ℂ] L2.GNSHilbert BC :=
  0

/-- Each Galerkin truncation is self-adjoint (scaffold: zero is self-adjoint;
substantive: P_N D P_N is self-adjoint when D is). -/
theorem dInftyGalerkin_selfAdjoint (BC : BostConnesSystem) (N : ℕ) :
    IsSelfAdjoint (dInftyGalerkin BC N) :=
  IsSelfAdjoint.zero _

end HilbertPolyaBostConnes.TomitaTakesakiSupport.Galerkin
