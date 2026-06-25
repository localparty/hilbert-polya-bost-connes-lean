/-
Rellich-Kondrachov H¹(BC) ↪ L²(BC) compact embedding — atomic axiom
for the BC-Galerkin truncation family `dInftyApproximantsFromTT`.

## Statement and scope

`dInftyApproximants_h1CompactEmbedding`:
  Given (i) a uniform operator-norm bound on `dInftyApproximantsFromTT`
  (provable from Banach-Steinhaus; see `UniformBound.lean`) and
  (ii) the Galerkin finite-rank-per-N axiom
  (`GalerkinFiniteRank.lean`), there exists a single compact set
  `K ⊂ H` containing every `D_N(B̄(0,1))`.

This is the *joint* compact bound on `⋃_N D_N(B̄(0,1))` that the
Bögli–Siegl–Tretter 2017 *discrete compactness* framework consumes.

## Why an axiom

The mathematical source is the compact embedding
  H¹(BC) ↪ L²(BC)
(Rellich 1930, Kondrachov 1945) applied to the joint H¹-image of the
unit-ball orbit. The Galerkin range of `D_N` is contained in the
finite-dimensional Hecke subspace `H_N`, which carries a controlled
H¹-norm (Paper 13 §L3c Fourier-cancellation argument). The uniform
operator-norm bound and finite-rank-per-N hypotheses together imply
that `⋃_N D_N(B̄(0,1))` is bounded *in the H¹-norm*, hence relatively
compact in L² by Rellich-Kondrachov.

Mathlib at the pinned SHA `5e932f97dd25535344f80f9dd8da3aab83df0fe6`
(v4.29.1) does **not** formalise:
  * Sobolev spaces for *general bilinear-form-induced* Hilbert spaces
    (the BC GNS Hilbert space is a `UniformSpace.Completion` of a
    star-algebra quotient; not a Euclidean Sobolev `H¹(ℝᵈ)` setting);
  * The Rellich-Kondrachov compact-embedding theorem in this
    generality.

The Euclidean Sobolev formalisation
(`Mathlib.Analysis.Distribution.Sobolev.*`) does exist for `H¹(ℝᵈ)`,
but it has no bridge to the BC GNS quotient. Building that bridge is a
substantial separate programme; the present axiom factors the
*conclusion* of that bridge cleanly away from the consumer.

## Honest caveat — D_N specificity is essential

The abstract (non-D_N-specific) statement
  "any uniformly-bounded family of finite-rank operators has joint
   compact image of the unit ball"
is **FALSE** in an infinite-dimensional Hilbert space. Counterexample:
fix an orthonormal basis `(e_N)` and set `T_N x := ⟨x, e_N⟩ e_N`. Each
`T_N` is rank-1, `‖T_N‖ = 1`, and `T_N(B̄(0,1)) ⊆ B̄(0,1)`, but the
collection `(e_N)` is not precompact in L². This is the well-known
failure of compactness for the closed unit ball in infinite
dimensions.

The D_N specificity in our axiom is essential: it encodes the H¹
regularity of `D_N(B̄(0,1))` that comes from the modular flow
structure (Paper 13 L3c) and that is not visible from "finite-rank" or
"uniform operator bound" alone.

## Conditional form

We state the axiom in **conditional form** (parametrised on a uniform
bound `C` and the finite-rank witnesses), even though both hypotheses
are derivable independently:
  * The uniform bound `hC` is proved in `UniformBound.lean` from
    Banach-Steinhaus + `dInftyApproximants_strongConv`.
  * The finite-rank witnesses `hFin` are asserted in
    `GalerkinFiniteRank.lean` as a structural Galerkin axiom.

The conditional form makes the *Rellich-Kondrachov content* explicit:
this axiom asserts only the H¹↪L² compact-embedding consequence, given
the operator-theoretic preconditions. Backfill replaces this axiom by
a proved consequence of a project-level H¹(BC) formalisation; the
two preconditions remain inputs.

## Provenance

Created in CCM-worker-rellich-prove sprint (2026-05-25). Architect
directive: factor the original `dInftyApproximantsFromTT_uniformlyCompact`
axiom into (i) a PROVED Banach-Steinhaus uniform bound, (ii) a
STRUCTURAL Galerkin finite-rank-per-N axiom, (iii) the residual
Rellich-Kondrachov H¹↪L² geometric content (this file).

## References

* Rellich, F., *Ein Satz über mittlere Konvergenz*, Nachr. Akad. Wiss.
  Göttingen Math.-Phys. Kl. (1930), 30–35.
* Kondrachov, V. I., *Sur certaines propriétés des fonctions dans
  l'espace L^p*, Doklady Akad. Nauk SSSR 48 (1945), 535–538.
* Bögli, S., Siegl, P., Tretter, C., *Approximations of spectra of
  Schrödinger operators with complex potentials on ℝᵈ*, Comm. Partial
  Differential Equations 42 (2017), 1001–1041 (arXiv:1604.07732), §2
  (discrete compactness framework).
* Stummel, F., *Diskrete Konvergenz linearer Operatoren II*,
  Math. Z. 120 (1971), 231–264.
* Anselone, P. M., *Collectively Compact Operator Approximation Theory
  and Applications to Integral Equations*, Prentice-Hall (1971).
* Paper 13 §L3c — H¹ Fourier-cancellation argument for the joint
  Galerkin image.
-/

import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.UniformBound
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers.GalerkinFiniteRank

namespace HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers

open HilbertPolyaBostConnes

/-- **Rellich-Kondrachov H¹↪L² compact embedding for the Galerkin
truncation family** (atomic axiom; Rellich 1930, Kondrachov 1945).

Conditional statement: given
  (i) a uniform operator-norm bound `hC` on `dInftyApproximantsFromTT`
      (provable from Banach-Steinhaus; see
      `dInftyApproximants_uniformBound`), and
  (ii) the Galerkin finite-rank-per-N witnesses `hFin`
      (axiomatic; see `dInftyApproximants_finiteRank`),
there exists a single compact set `K ⊂ TTBridge.gnsHilbertSpace`
containing every `D_N(B̄(0,1))`.

This axiom isolates the genuine *geometric* Rellich-Kondrachov content
(H¹ ↪ L² compact embedding) from the operator-theoretic preconditions
(uniform bound + finite rank), all in their cleanest atomic form. -/
axiom dInftyApproximants_h1CompactEmbedding
    {C : ℝ} (hC : ∀ N : ℕ, ‖dInftyApproximantsFromTT N‖ ≤ C)
    (hFin : ∀ N : ℕ,
      FiniteDimensional ℂ
        (LinearMap.range
          ((dInftyApproximantsFromTT N).toLinearMap :
            TTBridge.gnsHilbertSpace →ₗ[ℂ] TTBridge.gnsHilbertSpace))) :
    ∃ K : Set TTBridge.gnsHilbertSpace, IsCompact K ∧
      ∀ (N : ℕ) (x : TTBridge.gnsHilbertSpace), ‖x‖ ≤ 1 →
        dInftyApproximantsFromTT N x ∈ K

end HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers
