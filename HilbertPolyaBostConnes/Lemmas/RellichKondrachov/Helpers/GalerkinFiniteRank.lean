/-
Galerkin finite-rank property for the BC truncation family
`dInftyApproximantsFromTT` — atomic structural sub-axiom for
`HilbertPolyaBostConnes.Lemmas.RellichKondrachov`.

## Statement and scope

`dInftyApproximants_finiteRank N`: for every truncation index `N : ℕ`,
the *range* of the Galerkin operator `D_N = dInftyApproximantsFromTT N`
is a finite-dimensional ℂ-subspace of the GNS Hilbert space `H`.

Equivalently: `D_N` is a finite-rank operator, with rank bounded above
by the dimension of the truncated subspace `H_N ⊂ H` (the first `N`
prime-ideal sectors of the Bost-Connes Hecke basis).

## Why an axiom

`dInftyApproximantsFromTT` is itself an opaque axiom in
`Integers/CCMComplement/Infrastructure.lean` — only the *type*
(`ℕ → (H →L[ℂ] H)`) and the *strong-convergence behaviour*
(`dInftyApproximants_strongConv`) are exposed. The internal Galerkin
construction
  `D_N := P_N ∘ D_∞ ∘ P_N`
where `P_N : H ↠ H_N` is the orthogonal projection onto the first-N
sector and `D_∞ = log Δ₁` is the modular Hamiltonian, is not visible
to the Lean kernel.

Hence the finite-rank property — which is a *consequence* of this
hidden construction — must be asserted as a project-local atomic axiom.

## Backfill

Once the Galerkin construction is exposed (either by inlining the
definition of `D_N` from Paper 13 §L4a into Infrastructure, or via a
project-level Bost-Connes Hecke-basis decomposition), this axiom
becomes a *proved* statement: the range of `P_N ∘ D_∞ ∘ P_N` is
contained in the image of `P_N`, which is `H_N` of dimension ≤ `N`.

## Provenance

Created in CCM-worker-rellich-prove sprint (2026-05-25). Architect
directive: factor the original `dInftyApproximantsFromTT_uniformlyCompact`
axiom into:
  (1) A PROVED Banach-Steinhaus uniform bound (`UniformBound.lean`),
  (2) A STRUCTURAL finite-rank-per-N axiom (this file),
  (3) A genuine Rellich-Kondrachov H¹↪L² compact-embedding axiom
      (`CompactEmbedding.lean`), conditional on (1) and (2).

## References

* Paper 13 §L4a — Bost-Connes Galerkin truncation construction.
* Bögli–Siegl–Tretter 2017 arXiv:1604.07732 §2 — discrete compactness
  framework (the finite-rank-per-N hypothesis is one input).
* Stummel 1970, Anselone 1971 — collectively compact operator
  approximations.
-/

import HilbertPolyaBostConnes.Infrastructure
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

namespace HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers

open HilbertPolyaBostConnes

/-- **Galerkin finite-rank property** (atomic structural axiom).

For every truncation index `N : ℕ`, the range of
`dInftyApproximantsFromTT N` is a finite-dimensional ℂ-subspace of the
GNS Hilbert space.

This encodes the Galerkin truncation: `D_N` factors through a finite-
dimensional subspace `H_N ⊂ H` of dimension ≲ `N`. Since the
`dInftyApproximantsFromTT` construction is hidden behind an
Infrastructure-level axiom, the consequence (finite-rank) is asserted
here as an atomic axiom; backfill discharges it once the Galerkin
construction is exposed. -/
axiom dInftyApproximants_finiteRank :
    ∀ N : ℕ,
      FiniteDimensional ℂ
        (LinearMap.range
          ((dInftyApproximantsFromTT N).toLinearMap :
            TTBridge.gnsHilbertSpace →ₗ[ℂ] TTBridge.gnsHilbertSpace))

end HilbertPolyaBostConnes.Lemmas.RellichKondrachov.Helpers
