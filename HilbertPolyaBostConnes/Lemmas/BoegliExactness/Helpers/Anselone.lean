/-
Anselone-Stummel collectively-compact framework — atomic Mathlib-gap
sub-axiom for `HilbertPolyaBostConnes.Lemmas.BoegliExactness`.

## Statement and scope

`collectively_compact_resolvent_uniform_bound` packages the
*Anselone 1971 / Stummel 1970* uniform-invertibility-of-the-resolvent
theorem for collectively compact operator families converging strongly
to a limit operator. Precisely:

  If `D_N : ℕ → (H →L[ℂ] H)` is collectively compact and converges
  strongly to `D_∞`, then for any `z ∉ σ(D_∞)`, there exists `N₀, R > 0`
  such that for every `N ≥ N₀`, `z·1 - D_N` is a unit (i.e., `z ∉ σ(D_N)`)
  and the inverse `(z·1 - D_N)⁻¹` has norm uniformly bounded by `R`.

This is the **operator-theoretic core** of Bögli 2017 Theorem 2.6
(no-spectral-pollution direction). The Neumann-series perturbation
step that finishes the no-pollution proof, given this uniform bound, is
project-locally provable from Mathlib's `Units.add` and is supplied in
`Helpers/SpectralExactness.lean`.

## Why an axiom

Mathlib at the pinned SHA (`5e932f97dd25535344f80f9dd8da3aab83df0fe6`,
v4.29.1) lacks:

  * Any formalisation of *collective compactness* (Stummel 1970 /
    Anselone 1971) for operator families. The Mathlib `IsCompactOperator`
    predicate is for single operators, not for families.
  * Any spectral-approximation framework for non-self-adjoint operators
    (Bögli–Siegl–Tretter 2019 — see the programme target file
    `rh/pillar-a/specialty-boegli-siegl-tretter-2019`).
  * The Banach–Steinhaus uniform-boundedness transfer from strong
    convergence + collective compactness to resolvent boundedness, which
    proceeds via the closed-graph theorem applied to the family of
    approximate resolvents.

A standard textbook proof of `collectively_compact_resolvent_uniform_bound`
runs roughly:

  (i)   Strong convergence + collective compactness ⟹ `D_N − D_∞` is
        eventually small in operator norm on compact sets (Anselone's
        approximation Lemma; *Anselone 1971* §1.6, Theorem 1.6).
  (ii)  For `z ∉ σ(D_∞)`, `R_∞ := (D_∞ − z·I)⁻¹` exists and is bounded.
  (iii) Write `D_N − z·I = (D_∞ − z·I) + (D_N − D_∞)`. By (i) and the
        collective-compactness perturbation lemma, for large `N` the
        operator `(D_N − D_∞) R_∞` has norm `< 1` on the unit ball, so
        `I + (D_N − D_∞) R_∞` is invertible, and hence
        `(D_N − z·I) = (D_∞ − z·I)(I + (D_N − D_∞) R_∞)` is invertible.
  (iv)  Bounding the Neumann sum and `R_∞` gives the uniform `R`.

This argument is genuine 100+ line classical operator theory; once
Mathlib lands a `CollectivelyCompactFamily` API and the Anselone
perturbation lemma, this axiom becomes a direct import.

## Honest caveat — operator-norm vs. strong topology

Anselone 1971's original statement uses a slightly different convergence
notion (collectively-compact-norm convergence, equivalent to gsrc for
the bounded D_N case). Our `StrongConvergence` is the pointwise
strong-operator-topology variant. The two coincide under our
[CompleteSpace H] + bounded-operator setting (Teschl 2014 Lemma 2.7);
this equivalence is part of the deferred Mathlib content.

## References

* Anselone, P. M., *Collectively Compact Operator Approximation Theory*,
  Prentice-Hall (1971), Theorem 1.6 and §3.
* Stummel, F., *Diskrete Konvergenz linearer Operatoren I*, Math. Ann.
  190 (1970), 45–92, §3.
* Bögli, S., *Convergence of sequences of linear operators and their
  spectra*, Integral Equations and Operator Theory 88 (2017) 559–599
  (arXiv:1604.07732), Theorem 2.6.
* Bögli, S., Siegl, P., Tretter, C., *Approximations of spectra of
  Schrödinger operators with complex potentials on ℝ^d*,
  Comm. Partial Differential Equations 42 (2017) 1001–1041 — programme
  target Mathlib file
  `Mathlib/Analysis/Spectrum/BoegliSieglTretter.lean`.
* Teschl, G., *Mathematical Methods in Quantum Mechanics* (2nd ed.),
  AMS Graduate Studies in Mathematics 157 (2014), Lemma 2.7
  (gsrc ⇔ strong convergence for bounded operators).

## Provenance

Created in CCM-worker-boegli-prove sprint (2026-05-25). Architect
directive: replace the monolithic axiom `boegli_spectral_exactness` in
`Lemmas/BoegliExactness.lean` with a project-local theorem, factoring
out the remaining classical-content wall into one atomic, citable
sub-axiom. The Anselone resolvent bound surfaced as the single wall.
-/

import Mathlib.Analysis.Normed.Algebra.Spectrum
import Mathlib.Analysis.Normed.Ring.Units
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Topology.Algebra.Module.LinearMap
import Mathlib.Analysis.Normed.Operator.ContinuousLinearMap

namespace HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers

open Complex Filter Topology

/-! ## Abstract Bögli hypotheses

Mathlib-typed forms of the two hypotheses of Bögli 2017 Theorem 2.6,
specialised to bounded operators on a complex Hilbert space. These
definitions duplicate the ones at the same name in the parent file
`Lemmas/BoegliExactness.lean`; the duplicated bodies are intentional
since the parent and Helpers must define them independently to avoid a
circular dependency. The two share an identical body and unfold to the
same proposition, so the parent's re-export uses the helper proof
verbatim. -/

/-- Pointwise strong-operator convergence `D_N → D_∞` for a sequence of
bounded operators on a complex Hilbert space. For bounded operators,
Teschl 2014 Lemma 2.7 gsrc convergence reduces to this pointwise form. -/
def StrongConvergence
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (D_N : ℕ → (H →L[ℂ] H)) (D_inf : H →L[ℂ] H) : Prop :=
  ∀ f : H,
    Filter.Tendsto (fun N => D_N N f) Filter.atTop (nhds (D_inf f))

/-- Collectively / discretely compact family of bounded operators
(Stummel 1970 / Anselone 1971). Every unit-bounded sequence `f : ℕ → H`
admits a subsequence `f (φ n)` such that `D_{φ n} (f (φ n))` converges.

This is *strictly weaker* than "every D_N is compact" (which would force
each D_N to be infinite-rank-finitely-degenerate); it is *strictly
stronger* than "D_∞ is compact". The intermediate notion is exactly what
Bögli 2017 identifies as the right hypothesis for spectral exactness of
non-self-adjoint approximants. -/
def CollectivelyCompactFamily
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (D_N : ℕ → (H →L[ℂ] H)) : Prop :=
  ∀ (f : ℕ → H), (∀ N, ‖f N‖ ≤ 1) →
    ∃ (g : H) (φ : ℕ → ℕ), StrictMono φ ∧
      Filter.Tendsto (fun n => D_N (φ n) (f (φ n))) Filter.atTop (nhds g)

/-! ## Anselone 1971 / Stummel 1970 atomic sub-axiom -/

/-- **Anselone 1971 / Stummel 1970 — collectively-compact resolvent
uniform bound** (atomic Mathlib-gap sub-axiom).

Suppose `D_N : ℕ → (H →L[ℂ] H)` is a sequence of bounded operators on a
complex Hilbert space `H` such that

  * `D_N → D_∞` strongly (pointwise on `H`);
  * `{D_N}` is collectively compact (Stummel/Anselone).

If `z ∉ σ(D_∞)`, then there exist `N₀ ∈ ℕ` and `R > 0` such that for
every `N ≥ N₀`, the operator `z·1 - D_N` is a unit (so `z ∉ σ(D_N)`)
and `‖(z·1 - D_N)⁻¹‖ ≤ R`.

The unit is supplied as an explicit `(H →L[ℂ] H)ˣ` whose underlying
operator equals `algebraMap ℂ (H →L[ℂ] H) z - D_N N`, so the Neumann
perturbation step in `Helpers.SpectralExactness` can feed it directly
to `Units.add`.

## Honest scope statement

This is the **uniform-resolvent-bound** core of the Anselone–Stummel
framework. The full Bögli 2017 Theorem 2.6 (both no-pollution and
no-missing-eigenvalues directions) follows from this bound together
with — in the no-pollution direction — a Neumann-series perturbation
argument that is proved in `Helpers/SpectralExactness.lean` from
Mathlib's `Units.add`.

## Status as an axiom

Mathlib at the pinned SHA lacks collective compactness for operator
families and the associated Anselone approximation lemma. Once that
surface is filled in (target file
`Mathlib/Analysis/Spectrum/BoegliSieglTretter.lean`), this axiom can be
replaced by an `import` swap. -/
axiom collectively_compact_resolvent_uniform_bound
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H]
    {D_N : ℕ → (H →L[ℂ] H)} {D_inf : H →L[ℂ] H}
    (h_gsrc : StrongConvergence D_N D_inf)
    (h_cc : CollectivelyCompactFamily D_N)
    {z : ℂ} (hz_not_spec : z ∉ spectrum ℂ D_inf) :
    ∃ (N₀ : ℕ) (R : ℝ), 0 < R ∧
      ∀ N ≥ N₀, ∃ (u : (H →L[ℂ] H)ˣ),
        ((u : H →L[ℂ] H) = algebraMap ℂ (H →L[ℂ] H) z - D_N N) ∧
        ‖((↑u⁻¹) : H →L[ℂ] H)‖ ≤ R

end HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers
