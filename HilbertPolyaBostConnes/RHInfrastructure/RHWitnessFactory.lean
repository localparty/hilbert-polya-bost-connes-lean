/-
RH terminal — HONEST Hilbert–Pólya conditional (derive-cycle-01 reconstruction).

## What this file is

The Riemann Hypothesis chain's terminal, stated **honestly as a transparent
conditional** on a single, clearly-named Hilbert–Pólya spectral-encoding
hypothesis. There is deliberately **no** `riemann_hypothesis_unconditional :
RiemannHypothesis` term here: producing one is equivalent to proving RH, which
is open. The honest deliverable is

  `riemann_hypothesis_of_hilbert_polya (e : HilbertPolyaSpectralEncoding) :
     RiemannHypothesis`

— "RH follows from [the named spectral-encoding hypothesis]" — together with the
underlying ~6-line discharge `riemann_hypothesis_of_spectral_encoding` (self-
adjoint operator ⟹ real spectrum ⟹ the Hilbert–Pólya rotation forces
`Re s = 1/2`).

`#print axioms riemann_hypothesis_of_hilbert_polya` is `[propext,
Classical.choice, Quot.sound]` — the kernel axioms only. The conditionality is
**type-level explicit** (one must supply `e : HilbertPolyaSpectralEncoding`),
not hidden behind an axiom or a `sorry`.

## Why this replaced the previous factory (derive-cycle-01, 2026-05-29)

The previous `RHWitnessFactory.lean` fabricated a `TTPhase5RHWitness` from the
TT/CCM substrate and produced `riemann_hypothesis_unconditional`. Audited under
the Option-1 DERIVE mandate (concrete-types), that construction was a
**zero-operator masquerade**:

  * `rh_witness_from_tt` built the witness over `D = dInftyModular = 0` and
    `D_N = dInftyGalerkin = 0` (the TT Phase-4 scaffold has `Δ = 0`), so the
    whole spectral encoding was asserted over the zero operator.
  * `compactRes_bridge` was a `sorry` on `HasCompactResolvent 0`, a statement
    that is **false** on an infinite-dimensional carrier (and equally false for
    the intended type-III₁ `log Δ`, whose spectrum is continuous on ℝ — no
    compact resolvent). It does not "vanish on refine."
  * the `xiTruncated*` family encoded zeros-of-ξ̂_N ⊆ spec(D_N = 0) = {0},
    which over an actual nontrivial zero is vacuous/inconsistent — the
    assume-the-spectral-encoding fake, not the classical Fredholm identity
    (that identity is a theorem only for the *genuine* finite-rank Galerkin
    `D_N`, which does not yet exist in Lean).

The mathematical reality (confirmed with rh-architect, memo 33): the conjunction
`IsSelfAdjoint D ∧ (∀ nontrivial zero s, -i(s-1/2) ∈ spec D)` is **equivalent to
RH**. So no honest *unconditional* witness is constructible without proving RH.
The fakes are therefore removed and the irreducible Hilbert–Pólya content is
surfaced as ONE named hypothesis (rh-architect "route (a)", the recommended
cycle-01 terminal).

## The mathematics behind the hypothesis (the programme's bet)

The integers-programme RH route is spectral (Hilbert–Pólya): the modular
Hamiltonian `D_∞ = log(Δ_{ω₁})` of the Bost–Connes type-III₁ factor, **restricted
to the even sector** `H_R = P_even · H_{ω₁}`, is conjectured to have *discrete*
spectrum equal to the (rotated) nontrivial zeta zeros `{-i(s-1/2)}` — even though
`D_∞` on the full GNS space has continuous spectrum on ℝ. The Hecke-prime
symmetry projects out the continuous part. `HilbertPolyaSpectralEncoding` below
is exactly that conjecture, stated as the weakest hypothesis sufficient for the
discharge. No term of this type is currently constructible in Lean.

## The genuine analytical layer survives (non-load-bearing alternative route)

`riemann_hypothesis (w : TTPhase5RHWitness)` (in `L6TerminalRhShowcasesMathlib`)
and its supporting L4 Bögli spectral-exactness + L5 Hurwitz machinery are genuine,
fully-proved functional analysis (`#print axioms riemann_hypothesis = [propext,
Classical.choice, Quot.sound]`). They remain in the namespace as a **documented
alternative discharge route**: they show how, given a genuine BC operator-algebraic
substrate, the spectral encoding could be *derived* from Galerkin approximation
(Bögli exactness → Hurwitz identification). They are not in the dependency chain
of this cycle's terminal because that substrate does not yet exist; a future cycle
that constructs it can route through them instead. See rh-architect memo 33 §Q3.
-/

import Mathlib.Analysis.CStarAlgebra.ContinuousLinearMap
import Mathlib.Analysis.CStarAlgebra.Spectrum
import Mathlib.NumberTheory.LSeries.RiemannZeta

namespace HilbertPolyaBostConnes.RHInfrastructure

open Complex

/-- **RH from the Hilbert–Pólya spectral encoding (explicit-binder form).**

    Given a self-adjoint bounded operator `D` on a complete complex inner-product
    space whose spectrum contains the rotated nontrivial zeta zeros `-i(s-1/2)`,
    the Riemann Hypothesis holds.

    Proof (the genuine "easy direction" of Hilbert–Pólya): `D` self-adjoint ⟹ its
    spectrum lies in `ℝ` (`IsSelfAdjoint.im_eq_zero_of_mem_spectrum`), so
    `(-i(s-1/2)).im = 0`; since `(-i(s-1/2)).im = 1/2 - Re s`, this forces
    `Re s = 1/2`. -/
theorem riemann_hypothesis_of_spectral_encoding
    {H : Type} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (D : H →L[ℂ] H) (hsa : IsSelfAdjoint D)
    (hspec : ∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
      (-I * (s - 1 / 2)) ∈ spectrum ℂ D) : RiemannHypothesis := by
  intro s hs_zero hs_triv hs_ne_one
  have hmem := hspec s hs_zero hs_triv hs_ne_one
  have hreal := hsa.im_eq_zero_of_mem_spectrum hmem
  have harith : (-I * (s - 1 / 2)).im = 1 / 2 - s.re := by
    simp [mul_im, I_re, I_im, neg_im, sub_re, sub_im]
  linarith

/-- **The Hilbert–Pólya spectral-encoding hypothesis** — the single, honestly-named
    open gate of the RH chain (rh-architect "route (a)", memo 33).

    A self-adjoint bounded operator on a complete complex inner-product Hilbert
    space whose spectrum contains the rotated nontrivial zeta zeros. Intended
    realisation: `H = H_R` the even sector of the Bost–Connes GNS space and
    `D = log(Δ_{ω₁})|_{H_R}`, conjectured to have discrete spectrum equal to the
    nontrivial zeros. **No value of this type is currently constructible** —
    inhabiting it is equivalent to proving RH. This is the canonical
    Hilbert–Pólya conjecture, stated as the weakest hypothesis that discharges
    Mathlib's `RiemannHypothesis`. -/
structure HilbertPolyaSpectralEncoding where
  /-- The Hilbert space carrier (intended: the even sector `H_R` of the BC GNS space). -/
  H : Type
  [instNACG : NormedAddCommGroup H]
  [instIPS : InnerProductSpace ℂ H]
  [instCS : CompleteSpace H]
  /-- The operator (intended: `D_∞ = log(Δ_{ω₁})|_{H_R}`). -/
  D : H →L[ℂ] H
  /-- `D` is self-adjoint — so its spectrum lies on the real axis. -/
  D_selfAdjoint : IsSelfAdjoint D
  /-- Spectral encoding: each rotated nontrivial zeta zero is in the spectrum of `D`. -/
  zeros_in_spectrum : ∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
    (-I * (s - 1 / 2)) ∈ spectrum ℂ D

/-- **The Riemann Hypothesis, conditional on the Hilbert–Pólya spectral
    encoding.** This is the honest terminal of the RH chain: a transparent
    conditional "RH follows from [`HilbertPolyaSpectralEncoding`]".

    `#print axioms riemann_hypothesis_of_hilbert_polya` is the kernel axioms
    `[propext, Classical.choice, Quot.sound]` only — the hypothesis is carried at
    the type level (one must supply `e`), not hidden behind any axiom or `sorry`. -/
theorem riemann_hypothesis_of_hilbert_polya
    (e : HilbertPolyaSpectralEncoding) : RiemannHypothesis :=
  letI := e.instNACG; letI := e.instIPS; letI := e.instCS
  riemann_hypothesis_of_spectral_encoding e.D e.D_selfAdjoint e.zeros_in_spectrum

end HilbertPolyaBostConnes.RHInfrastructure
