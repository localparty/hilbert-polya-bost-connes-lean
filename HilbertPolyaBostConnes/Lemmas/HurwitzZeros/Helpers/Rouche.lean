/-
Rouché's theorem (existence form) — atomic Mathlib-gap sub-axiom for
`HilbertPolyaBostConnes.Lemmas.HurwitzZeros`.

## Statement and scope

`rouche_zero_existence` packages the **existence form** of Rouché's
theorem (Rouché 1862): if `f, g : ℂ → ℂ` are holomorphic on a closed
disk `B̄(c, r)`, `|f − g| < |g|` on the boundary `∂B(c, r)`, and `g`
has at least one zero strictly inside the disk, then `f` also has at
least one zero strictly inside.

This is the *atomic* form needed by Hurwitz: it asserts only the
**existence** of a perturbed zero, not the equality of zero-counts
(the full Rouché theorem) or the equality of winding numbers (the
argument-principle form).

## Why an axiom

Mathlib at the pinned SHA (`5e932f97dd25535344f80f9dd8da3aab83df0fe6`,
v4.29.1) lacks Rouché's theorem in any zero-counting form. The
`circleIntegral` API, Cauchy's integral formula, and the locally-uniform-
limit Weierstrass package are all present, but the argument-principle
identity

  `(2πi)⁻¹ · ∮_{|z−c|=r} f'/f = (# zeros of f in B(c,r))`

is not. Without that identity, the standard "f − g small ⇒ ∮ (f'/f) and
∮ (g'/g) agree" deformation argument cannot be carried out in-Mathlib.

This file isolates the wall as a single, citable axiom rather than
inlining its absence inside the Hurwitz proof. A future Mathlib-side
PR adding Rouché's theorem would replace this axiom with an import,
without touching the Hurwitz consumer.

## Honest caveat — existence form is strictly weaker than full Rouché

The literature statement of Rouché's theorem is the *equality* of zero
counts (with multiplicity) for `f` and `g` inside `B(c, r)`. The
existence form below is a one-line consequence (`g` has a zero ⇒ same
count for `f` ⇒ `f` has a zero), but the converse implication does not
hold. We ship only the existence form because the Hurwitz consumer
needs only this much — the full count-preservation statement is
overkill for the application.

The existence form is itself standard textbook material; see e.g.
Ahlfors, *Complex Analysis* (3rd ed.), §5.3 Theorem 18, where Rouché is
stated in the equality-of-counts form and the existence corollary is
taken as immediate.

## References

* Rouché, E., *Mémoire sur la série de Lagrange*, Journal de l'École
  Polytechnique 22 (1862), 217–218.
* Ahlfors, L., *Complex Analysis*, 3rd ed., McGraw-Hill (1979),
  Chapter 5 §3 Theorem 18 (the argument principle and Rouché).
* Conway, J. B., *Functions of One Complex Variable I*, 2nd ed.,
  Springer GTM 11 (1978), Chapter V §3.8 (Rouché's theorem).

## Provenance

Created in CCM-worker-hurwitz-prove sprint (2026-05-25). Architect
directive: replace `hurwitz_zero_convergence` (the monolithic axiom in
`HurwitzZeros.lean`) with a project-local proved theorem, factoring out
any genuinely Mathlib-gap content into named atomic sub-axioms. The
existence-form Rouché surfaced as the single atomic wall.
-/

import Mathlib.Analysis.Complex.LocallyUniformLimit
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.Complex.CauchyIntegral

namespace HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers

open Complex Filter Topology Metric

/-- **Rouché's theorem, existence form** (Rouché 1862; atomic
Mathlib-gap sub-axiom).

Let `f, g : ℂ → ℂ` be holomorphic on the closed disk `B̄(c, r)`. If
`|f z − g z| < |g z|` for every `z` on the boundary circle
`∂B(c, r) = {z : |z − c| = r}`, and `g` has a zero strictly inside
`B(c, r)`, then `f` also has a zero strictly inside `B(c, r)`.

## Honest scope statement

This is the **existence-form** corollary of the full Rouché theorem; we
ship only the existence statement because it is exactly what the
Hurwitz zero-convergence consumer (see
`HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.Convergence`)
needs. The full count-preservation form would also be provable from the
same circle-integral identity but is not required here.

## Status as an axiom

Mathlib at the pinned SHA lacks any zero-counting form of Rouché's
theorem (the argument-principle identity is absent). Once that surface
is filled in upstream, this axiom can be replaced by an `import` swap.

See the file docstring for the literature citation and the standard
Cauchy-integral derivation. -/
axiom rouche_zero_existence
    {c : ℂ} {r : ℝ} (hr : 0 < r)
    {f g : ℂ → ℂ}
    (hf : DifferentiableOn ℂ f (Metric.closedBall c r))
    (hg : DifferentiableOn ℂ g (Metric.closedBall c r))
    (h_close : ∀ z ∈ Metric.sphere c r, ‖f z - g z‖ < ‖g z‖)
    (h_g_has_zero : ∃ w ∈ Metric.ball c r, g w = 0) :
    ∃ w ∈ Metric.ball c r, f w = 0

end HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers
