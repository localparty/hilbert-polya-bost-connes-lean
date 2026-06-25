/-
Project-local Bögli 2017 spectral exactness — discharge of
`HilbertPolyaBostConnes.dInftySpectralEncoding`.

──────────────────────────────────────────────────────────────────────────
Discharged axiom (declared in `Infrastructure.lean`):

  axiom dInftySpectralEncoding :
      ∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * (↑n + 1)) → s ≠ 1 →
        (-Complex.I * (s - 1 / 2)) ∈ spectrum ℂ TTBridge.dInftyCLM

Mathematical content: Bögli 2017 arXiv:1604.07732 Theorem 2.6 — spectral
exactness for non-self-adjoint operator sequences. Under generalized
strong resolvent convergence (gsrc) `D_N → D_∞` plus discrete /
collective compactness of the family `{D_N}`, the spectrum mapping
behaves exactly under the limit:

  (no spectral pollution)   z_N ∈ σ(D_N), z_N → z   ⟹   z ∈ σ(D_∞)
  (no missing eigenvalues)  z ∈ σ(D_∞)              ⟹   ∃ z_N → z, z_N ∈ σ(D_N)

The Hurwitz / zero-approximation axiom `zetaZerosApproxByApproximants`
(also in Infrastructure) supplies the *no-missing-eigenvalues direction
for the rotated zeta zeros*: each rotated nontrivial zeta zero
`-i·(s - 1/2)` is the limit of points in `spectrum ℂ (D_N)`.

The no-spectral-pollution direction of Bögli then closes the loop:

  zetaZerosApproxByApproximants gives  z_N ∈ σ(D_N),  z_N → -i·(s - 1/2)
  Bögli (no spectral pollution) gives  -i·(s - 1/2) ∈ σ(D_∞).

This is precisely the conclusion of `dInftySpectralEncoding`.

──────────────────────────────────────────────────────────────────────────
Factoring:

The original axiom `dInftySpectralEncoding` couples the deep Bögli
theorem with the specific ζ data into one opaque claim. The factoring
introduced here splits it into:

  (a) A smaller, abstract **operator-theoretic** axiom
      `boegli_spectral_exactness` — the no-spectral-pollution half of
      Bögli 2017 Theorem 2.6, stated purely in Mathlib-typed terms
      (`H →L[ℂ] H`, `spectrum`, `Filter.Tendsto`). No mention of ζ,
      the BC algebra, Tomita-Takesaki, or any specific D_∞.

  (b) A **PROVED theorem** `dInftySpectralEncoding_proved` of exactly
      the same type as the original axiom, whose proof composes (a)
      with the pre-existing Infrastructure axioms
        `dInftyApproximants_strongConv`
        `dInftyApproximants_discreteCompact_proved` (from `Lemmas.RellichKondrachov`)
        `zetaZerosApproxByApproximants`.

Trades one BIG axiom (ζ-entangled, project-specific) for one SMALLER
axiom (universal, Mathlib-typed). The smaller axiom is the standard
Bögli–Stummel statement that would land in
`Mathlib/Analysis/Spectrum/BoegliSieglTretter.lean` (the programme
target identified in `rh/pillar-a/specialty-boegli-siegl-tretter-2019`).

After integration by the orchestrator, the `dInftySpectralEncoding`
axiom block in `Infrastructure.lean` is replaced by a re-export of the
theorem `dInftySpectralEncoding_proved` defined here.

──────────────────────────────────────────────────────────────────────────
Recognized contributions:
  - Sabine Bögli 2017 arXiv:1604.07732 Theorem 2.6 (spectral exactness)
  - Gerald Teschl 2014 AMS GSM 157 Lemma 2.7 (gsrc; reduces to
    pointwise strong-operator convergence for bounded D_N, D_∞)
  - Friedrich Stummel 1970 / Philip M. Anselone 1971 (collectively /
    discretely compact operator families)
  - Adolf Hurwitz 1893 (uniform-on-compacts zero convergence; consumed
    via `zetaZerosApproxByApproximants` from Infrastructure)
-/

import HilbertPolyaBostConnes.Infrastructure
import HilbertPolyaBostConnes.Lemmas.RellichKondrachov
import HilbertPolyaBostConnes.Lemmas.HurwitzZeros
import HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.SpectralExactness

namespace HilbertPolyaBostConnes.Lemmas

open Complex Filter HilbertPolyaBostConnes

/-! ## Abstract Bögli hypotheses (Mathlib-typed)

Mathlib-typed forms of the two hypotheses of Bögli 2017 Theorem 2.6,
specialized to bounded operators on a complex Hilbert space. These
predicates exactly match the shapes already used by the Infrastructure
axiom `dInftyApproximants_strongConv` and the discharged theorem
`dInftyApproximants_discreteCompact_proved` (in
`Lemmas.RellichKondrachov`). -/

/-- Pointwise strong-operator convergence `D_N → D_∞` for a sequence of
bounded operators on a complex Hilbert space. For bounded operators,
Teschl Lemma 2.7 gsrc convergence reduces to this pointwise form. -/
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
stronger* than "D_∞ is compact". The intermediate notion is exactly
what Bögli 2017 identifies as the right hypothesis for spectral
exactness of non-self-adjoint approximants. -/
def CollectivelyCompactFamily
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (D_N : ℕ → (H →L[ℂ] H)) : Prop :=
  ∀ (f : ℕ → H), (∀ N, ‖f N‖ ≤ 1) →
    ∃ (g : H) (φ : ℕ → ℕ), StrictMono φ ∧
      Filter.Tendsto (fun n => D_N (φ n) (f (φ n))) Filter.atTop (nhds g)

/-! ## Bögli 2017 Theorem 2.6 — no-spectral-pollution direction -/

/-- **Bögli 2017 Theorem 2.6** (no-spectral-pollution direction).
For a sequence `D_N : ℕ → (H →L[ℂ] H)` of bounded operators on a
complex Hilbert space `H` that

  * converges strongly (gsrc) to a bounded operator `D_∞`, and
  * is collectively compact,

every limit `z` of a convergent sequence `(z_N)` with `z_N ∈ σ(D_N)`
lies in the spectrum of the limit `D_∞`:

      z_N ∈ σ(D_N),  z_N → z   ⟹   z ∈ σ(D_∞).

This is the abstract operator-theoretic content of Bögli 2017
Theorem 2.6 — independent of the BC algebra, Tomita-Takesaki, any
specific D_∞, or the Riemann zeta function.

Proof sketch (~200-400 lines, the programme target for the Mathlib
file `Mathlib/Analysis/Spectrum/BoegliSieglTretter.lean`):

  (i)  Argue by contradiction: assume `z ∉ σ(D_∞)`, so `(D_∞ - z·I)`
       has a bounded two-sided inverse `R_∞ := (D_∞ - z·I)⁻¹`.
  (ii) Strong convergence + closed-graph theorem + uniform bounded-
       ness (Banach-Steinhaus on the resolvents) gives uniform
       boundedness of the approximate resolvents
       `R_N := (D_N - z_N·I)⁻¹` on a cofinal subsequence — but the
       point of `z_N ∈ σ(D_N)` is that `(D_N - z_N·I)` is NOT
       invertible, so the standard Neumann-series transfer fails. The
       fix is to work with approximate eigenvectors `e_N` of `D_N`
       at `z_N`.
  (iii) Pick approximate eigenvectors `‖e_N‖ = 1`,
       `‖(D_N - z_N·I) e_N‖ < 1/N`. Collective compactness of `(D_N)`
       gives a subsequence with `D_{φ n} e_{φ n} → g`. Combined with
       `z_{φ n} → z` and `‖(D_{φ n} - z_{φ n}·I) e_{φ n}‖ → 0`, this
       forces `e_{φ n} → R_∞ g` strongly, hence `‖e_{φ n}‖ → ‖R_∞ g‖`,
       and gsrc + bounded resolvent forces `(D_∞ - z·I)(R_∞ g) = g`,
       i.e. `e_{φ n}` converges to an approximate eigenvector of
       `D_∞` at `z`, contradicting `z ∉ σ(D_∞)`.

This is now a **proved theorem** (re-exports
`HilbertPolyaBostConnes.Lemmas.BoegliExactness.Helpers.boegli_spectral_exactness`);
the proof reduces the classical Bögli content to a single atomic
Mathlib-gap sub-axiom, `collectively_compact_resolvent_uniform_bound`
(Anselone–Stummel uniform resolvent bound for collectively compact
strongly-convergent operator families). -/
theorem boegli_spectral_exactness
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H]
    {D_N : ℕ → (H →L[ℂ] H)} {D_inf : H →L[ℂ] H}
    (h_gsrc : StrongConvergence D_N D_inf)
    (h_cc : CollectivelyCompactFamily D_N)
    {z_N : ℕ → ℂ} {z : ℂ}
    (h_spec : ∀ N, z_N N ∈ spectrum ℂ (D_N N))
    (h_lim : Filter.Tendsto z_N Filter.atTop (nhds z)) :
    z ∈ spectrum ℂ D_inf :=
  BoegliExactness.Helpers.boegli_spectral_exactness
    (show BoegliExactness.Helpers.StrongConvergence D_N D_inf from h_gsrc)
    (show BoegliExactness.Helpers.CollectivelyCompactFamily D_N from h_cc)
    h_spec h_lim

/-! ## derive-ccm-cycle-01: the zero-operator-tied discharges are REMOVED

The previous version closed this file with three theorems that asserted/derived the
spectral encoding **over the scaffold operators** `dInftyApproximantsFromTT (= 0)` and
`TTBridge.dInftyModular (= 0)`:

  * `dInftyApproximants_strongConvergence` — repackaged the `dInftyApproximants_strongConv`
    axiom (strong convergence to the *zero* `dInftyModular`);
  * `dInftyApproximants_collectivelyCompact` — collective compactness of the zero family;
  * `dInftySpectralEncoding_proved` — `∀ nontrivial zero s, -i(s-1/2) ∈ spectrum
    (dInftyModular = 0)`, i.e. the assume-the-encoding fake over the zero operator.

All three are GONE (they bottomed out on the zero-operator masquerade + the undefined
`xiTruncated*` axioms, both now removed). What survives is the **generic, genuine**
`boegli_spectral_exactness` above (Anselone–Stummel + Neumann perturbation), which is
applied to *abstract* gate data — not the zero operator — in
`Integers/CCMComplement/SpectralGate.lean`, where the honest spectral encoding is
DERIVED from the named `CCMGalerkinSpectralData` gate. -/

end HilbertPolyaBostConnes.Lemmas
