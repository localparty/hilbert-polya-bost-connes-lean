/-
Hurwitz 1893 zero-convergence theorem — project-local proof.

This file replaces the monolithic axiom `hurwitz_zero_convergence` (previously
declared in `Integers/CCMComplement/Lemmas/HurwitzZeros.lean`) with a proved
theorem. The proof depends on
  * Mathlib: identity principle for analytic functions, locally-uniform-limit
    holomorphicity (Beffara 2022), Cauchy-integral-formula corollary
    `DifferentiableOn.analyticOnNhd`, compactness of closed disks/spheres
    (`isCompact_closedBall`, `isCompact_sphere`).
  * One *atomic* project-local axiom: the existence-form of Rouché's theorem
    `HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.rouche_zero_existence`
    (see `Helpers/Rouche.lean`).

## Mathematical content (Hurwitz 1893)

If `(f_n)` is a sequence of holomorphic functions on an open preconnected
set `U ⊆ ℂ`, converging locally uniformly to a holomorphic limit `f`, and
`z₀ ∈ U` is a zero of `f` with `f` not identically zero on `U`, then for
all sufficiently large `n` the function `f_n` has a zero `w_n` and one can
arrange `w_n → z₀`.

## Proof outline

1. Locally-uniform limit ⇒ `f` is holomorphic on `U`
   (`TendstoLocallyUniformlyOn.differentiableOn`).
2. Identity principle ⇒ since `f ≢ 0` on the preconnected `U` and
   `f z₀ = 0`, the zero at `z₀` is isolated:
   `∀ᶠ z in 𝓝[≠] z₀, f z ≠ 0`
   (via `AnalyticAt.eventually_eq_zero_or_eventually_ne_zero`).
3. Pick `r > 0` so that the closed disk `B̄(z₀, r) ⊆ U` and `f` is non-zero
   on `B̄(z₀, r) ∖ {z₀}`.
4. For each `k`, set `r_k := r/(k+1) > 0`. The sphere `∂B(z₀, r_k)` is
   compact and disjoint from `z₀`, so `|f|` attains a positive minimum
   `m_k > 0` there.
5. Locally-uniform convergence on `U` ⇒ uniform convergence on the compact
   `B̄(z₀, r)` ⊇ `∂B(z₀, r_k)`. For `n` large enough,
   `‖f_n − f‖ < m_k` on `∂B(z₀, r_k)`.
6. Rouché's existence form (the atomic sub-axiom) applied with
   `g := f`, `f := f_n n`, `c := z₀`, `r := r_k`:
   since `f_n` is `m_k`-close to `f` on the boundary and `f(z₀) = 0` with
   `z₀ ∈ B(z₀, r_k)`, `f_n` has a zero in `B(z₀, r_k)`.
7. Diagonal: pick a *monotone* threshold sequence `M : ℕ → ℕ` (Finset.sup
   over `N k`s) and define `kOf n := Nat.findGreatest (M · ≤ n) n`.
   Then `kOf n → ∞`, and a Classical.choice-picked witness in
   `ball z₀ (r/(kOf n + 1))` gives `w_n → z₀` with `f_n n (w_n) = 0`
   eventually.

## Provenance

Created in CCM-worker-hurwitz-prove sprint (2026-05-25). Architect
directive: discharge the monolithic `hurwitz_zero_convergence` axiom in
`HurwitzZeros.lean`. Single residual atomic wall:
`rouche_zero_existence` (existence form of Rouché 1862) — a genuine
Mathlib gap at the pinned SHA `5e932f97dd25535344f80f9dd8da3aab83df0fe6`.
-/

import HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers.Rouche
import Mathlib.Analysis.Complex.LocallyUniformLimit
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.Complex.CauchyIntegral
import Mathlib.Topology.UniformSpace.LocallyUniformConvergence
import Mathlib.Data.Nat.Find

namespace HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers

open Complex Filter Topology Metric Set

/-! ## Auxiliary lemma: positive minimum of `‖f‖` on a sphere -/

/-- On a sphere of positive radius `s > 0` around `c`, if `f` is continuous
and nowhere zero, then `‖f‖` has a positive lower bound. -/
private lemma exists_pos_min_norm_on_sphere
    {c : ℂ} {s : ℝ} (hs : 0 < s) {f : ℂ → ℂ}
    (hf_cont : ContinuousOn f (Metric.sphere c s))
    (hf_ne : ∀ z ∈ Metric.sphere c s, f z ≠ 0) :
    ∃ m > 0, ∀ z ∈ Metric.sphere c s, m ≤ ‖f z‖ := by
  have h_nonempty : (Metric.sphere c s).Nonempty :=
    NormedSpace.sphere_nonempty.mpr hs.le
  have h_norm_cont : ContinuousOn (fun z => ‖f z‖) (Metric.sphere c s) :=
    continuous_norm.comp_continuousOn hf_cont
  obtain ⟨z₀, hz₀_mem, hz₀_min⟩ :=
    (isCompact_sphere c s).exists_isMinOn h_nonempty h_norm_cont
  refine ⟨‖f z₀‖, ?_, fun z hz => hz₀_min hz⟩
  exact norm_pos_iff.mpr (hf_ne z₀ hz₀_mem)

/-! ## Main theorem -/

/-- **Hurwitz 1893 zero-convergence theorem**. A locally uniform limit of
holomorphic functions inherits zeros from the limit: if `f z₀ = 0` and `f`
is not identically zero on the open preconnected set `U`, then there is a
sequence `w_n → z₀` with `f_n (w_n) = 0` eventually.

Proof uses (1) Mathlib's identity principle and Weierstrass-Beffara
locally-uniform-limit holomorphicity, (2) the atomic Rouché-existence
sub-axiom `rouche_zero_existence`. -/
theorem hurwitz_zero_convergence
    {U : Set ℂ} (hU : IsOpen U) (hU_conn : IsPreconnected U)
    {z₀ : ℂ} (hz₀ : z₀ ∈ U)
    {f_n : ℕ → ℂ → ℂ} {f : ℂ → ℂ}
    (h_diff_n : ∀ n, DifferentiableOn ℂ (f_n n) U)
    (h_tendsto : TendstoLocallyUniformlyOn f_n f Filter.atTop U)
    (h_f_zero : f z₀ = 0)
    (h_f_ne : ¬ Set.EqOn f 0 U) :
    ∃ w_n : ℕ → ℂ, (∀ᶠ n in Filter.atTop, f_n n (w_n n) = 0) ∧
      Filter.Tendsto w_n Filter.atTop (nhds z₀) := by
  classical
  -- ===== Step 1: f is differentiable (hence analytic) on U. =====
  have h_diff_F : ∀ᶠ n in Filter.atTop, DifferentiableOn ℂ (f_n n) U :=
    Filter.Eventually.of_forall h_diff_n
  have h_f_diff : DifferentiableOn ℂ f U :=
    h_tendsto.differentiableOn h_diff_F hU
  have h_f_an : AnalyticOnNhd ℂ f U := h_f_diff.analyticOnNhd hU
  -- ===== Step 2: isolate the zero at z₀. =====
  have h_f_an_z₀ : AnalyticAt ℂ f z₀ := h_f_an z₀ hz₀
  have h_not_loc_zero : ¬ (∀ᶠ z in 𝓝 z₀, f z = 0) := by
    intro h_loc_zero
    apply h_f_ne
    have h_freq : ∃ᶠ z in 𝓝[≠] z₀, f z = 0 :=
      (h_loc_zero.filter_mono nhdsWithin_le_nhds).frequently
    exact h_f_an.eqOn_zero_of_preconnected_of_frequently_eq_zero hU_conn hz₀ h_freq
  have h_isol : ∀ᶠ z in 𝓝[≠] z₀, f z ≠ 0 :=
    h_f_an_z₀.eventually_eq_zero_or_eventually_ne_zero.resolve_left h_not_loc_zero
  -- ===== Step 3: pick small radius r > 0 with closedBall ⊆ U and f ≠ 0 away from z₀. =====
  have hU_nhds : U ∈ 𝓝 z₀ := hU.mem_nhds hz₀
  obtain ⟨r₁, hr₁_pos, hr₁_sub⟩ := Metric.nhds_basis_closedBall.mem_iff.mp hU_nhds
  rw [eventually_nhdsWithin_iff, Metric.eventually_nhds_iff] at h_isol
  obtain ⟨r₂, hr₂_pos, hr₂_nonzero⟩ := h_isol
  set r : ℝ := min r₁ r₂ / 2 with hr_def
  have hr_pos : 0 < r := by rw [hr_def]; positivity
  have hr_le_r₁ : r ≤ r₁ :=
    (half_le_self (le_min hr₁_pos.le hr₂_pos.le)).trans (min_le_left _ _)
  have hr_lt_r₂ : r < r₂ :=
    (half_lt_self (lt_min hr₁_pos hr₂_pos)).trans_le (min_le_right _ _)
  have h_closedBall_sub_U : Metric.closedBall z₀ r ⊆ U := by
    intro z hz
    apply hr₁_sub
    exact Metric.closedBall_subset_closedBall hr_le_r₁ hz
  -- For each k, set r_k := r/(k+1). Properties: 0 < r_k ≤ r, r_k < r₂, r_k → 0,
  -- and radK is non-increasing in k.
  set radK : ℕ → ℝ := fun k => r / (k + 1) with hradK_def
  have hradK_pos : ∀ k, 0 < radK k := fun k => div_pos hr_pos (by positivity)
  have hradK_le_r : ∀ k, radK k ≤ r := by
    intro k
    have : (1 : ℝ) ≤ (k : ℝ) + 1 := by
      have : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
      linarith
    calc radK k = r / ((k : ℝ) + 1) := rfl
      _ ≤ r / 1 := by
        apply div_le_div_of_nonneg_left hr_pos.le (by linarith) this
      _ = r := by ring
  have hradK_lt_r₂ : ∀ k, radK k < r₂ := fun k => (hradK_le_r k).trans_lt hr_lt_r₂
  have hradK_antitone : Antitone radK := by
    intro j k hjk
    rw [hradK_def]
    apply div_le_div_of_nonneg_left hr_pos.le (by positivity)
    exact_mod_cast Nat.succ_le_succ hjk
  have hradK_tendsto_zero : Filter.Tendsto radK Filter.atTop (nhds 0) := by
    have h_eq : radK = fun (k : ℕ) => r * (((k : ℝ) + 1)⁻¹) := by
      funext k; rw [hradK_def]; ring
    rw [h_eq]
    have h1 : Filter.Tendsto (fun k : ℕ => ((k : ℝ) + 1)) Filter.atTop Filter.atTop :=
      Filter.tendsto_atTop_add_const_right Filter.atTop 1 tendsto_natCast_atTop_atTop
    have h2 : Filter.Tendsto (fun k : ℕ => ((k : ℝ) + 1)⁻¹) Filter.atTop (nhds 0) :=
      h1.inv_tendsto_atTop
    simpa using h2.const_mul r
  -- f is nonzero on sphere z₀ (radK k) since this sphere is inside ball z₀ r₂ \ {z₀}.
  have h_f_ne_on_sphere : ∀ k, ∀ z ∈ Metric.sphere z₀ (radK k), f z ≠ 0 := by
    intro k z hz
    rw [Metric.mem_sphere] at hz
    have hz_ne_z₀ : z ≠ z₀ := by
      intro h_eq
      rw [h_eq, dist_self] at hz
      exact (hradK_pos k).ne' hz.symm
    have h_dist_z₀ : dist z z₀ < r₂ :=
      calc dist z z₀ = radK k := hz
        _ < r₂ := hradK_lt_r₂ k
    exact hr₂_nonzero h_dist_z₀ hz_ne_z₀
  -- f is continuous on closedBall z₀ r (subset of U).
  have h_f_cont_closedBall : ContinuousOn f (Metric.closedBall z₀ r) :=
    h_f_diff.continuousOn.mono h_closedBall_sub_U
  -- f and each f_n are differentiable on each closedBall z₀ (radK k).
  have h_closedBall_k_sub : ∀ k, Metric.closedBall z₀ (radK k) ⊆ Metric.closedBall z₀ r :=
    fun k => Metric.closedBall_subset_closedBall (hradK_le_r k)
  have h_f_diff_closedBall_k : ∀ k, DifferentiableOn ℂ f (Metric.closedBall z₀ (radK k)) :=
    fun k => h_f_diff.mono ((h_closedBall_k_sub k).trans h_closedBall_sub_U)
  have h_fn_diff_closedBall_k : ∀ k n,
      DifferentiableOn ℂ (f_n n) (Metric.closedBall z₀ (radK k)) :=
    fun k n => (h_diff_n n).mono ((h_closedBall_k_sub k).trans h_closedBall_sub_U)
  -- ===== Step 4: positive minimum m_k of |f| on sphere z₀ (radK k). =====
  have h_min_exists : ∀ k, ∃ m > 0, ∀ z ∈ Metric.sphere z₀ (radK k), m ≤ ‖f z‖ := by
    intro k
    have h_sphere_sub : Metric.sphere z₀ (radK k) ⊆ Metric.closedBall z₀ r :=
      (Metric.sphere_subset_closedBall).trans (h_closedBall_k_sub k)
    exact exists_pos_min_norm_on_sphere (hradK_pos k)
      (h_f_cont_closedBall.mono h_sphere_sub) (h_f_ne_on_sphere k)
  choose mK hmK_pos hmK_bound using h_min_exists
  -- ===== Step 5: uniform convergence on compact closedBall z₀ r. =====
  have h_isCompact_closedBall : IsCompact (Metric.closedBall z₀ r) :=
    isCompact_closedBall z₀ r
  have h_tendsto_on_closedBall : TendstoLocallyUniformlyOn f_n f Filter.atTop
      (Metric.closedBall z₀ r) := h_tendsto.mono h_closedBall_sub_U
  have h_uniform_on_closedBall : TendstoUniformlyOn f_n f Filter.atTop
      (Metric.closedBall z₀ r) :=
    (tendstoLocallyUniformlyOn_iff_tendstoUniformlyOn_of_compact h_isCompact_closedBall).mp
      h_tendsto_on_closedBall
  -- For each k, eventually ‖f_n n - f‖ < m_k on sphere z₀ (radK k).
  have h_eventually_close : ∀ k, ∀ᶠ n in Filter.atTop,
      ∀ z ∈ Metric.sphere z₀ (radK k), ‖f_n n z - f z‖ < mK k := by
    intro k
    have h_sphere_sub : Metric.sphere z₀ (radK k) ⊆ Metric.closedBall z₀ r :=
      (Metric.sphere_subset_closedBall).trans (h_closedBall_k_sub k)
    -- TUL ⇒ ∀ ε > 0, ∀ᶠ n, ∀ x ∈ s, dist (f x) (f_n n x) < ε.
    have h_dist : ∀ᶠ n in Filter.atTop, ∀ x ∈ Metric.closedBall z₀ r,
        dist (f x) (f_n n x) < mK k :=
      Metric.tendstoUniformlyOn_iff.mp h_uniform_on_closedBall (mK k) (hmK_pos k)
    filter_upwards [h_dist] with n hn z hz
    have := hn z (h_sphere_sub hz)
    rw [Complex.dist_eq] at this
    rw [show f_n n z - f z = -(f z - f_n n z) by ring, norm_neg]
    exact this
  -- ===== Step 6: combine — eventually ∃ w ∈ ball z₀ (radK k), f_n n w = 0. =====
  have h_witness : ∀ k, ∀ᶠ n in Filter.atTop,
      ∃ w ∈ Metric.ball z₀ (radK k), f_n n w = 0 := by
    intro k
    filter_upwards [h_eventually_close k] with n h_close
    refine rouche_zero_existence (c := z₀) (r := radK k) (hradK_pos k)
      (f := f_n n) (g := f)
      (h_fn_diff_closedBall_k k n) (h_f_diff_closedBall_k k) ?_ ?_
    · -- ‖f_n n z - f z‖ < ‖f z‖ on sphere
      intro z hz
      exact lt_of_lt_of_le (h_close z hz) (hmK_bound k z hz)
    · -- ∃ w ∈ ball z₀ (radK k), f w = 0 — take z₀.
      refine ⟨z₀, ?_, h_f_zero⟩
      rw [Metric.mem_ball, dist_self]
      exact hradK_pos k
  -- ===== Step 7: diagonal construction. =====
  -- Extract a per-k threshold Nk.
  have h_eventually_atTop : ∀ k, ∃ N : ℕ, ∀ n ≥ N,
      ∃ w ∈ Metric.ball z₀ (radK k), f_n n w = 0 :=
    fun k => Filter.eventually_atTop.mp (h_witness k)
  choose Nk hNk using h_eventually_atTop
  -- Monotone strengthening: M k := max k (max_{j ≤ k} Nk j).
  -- Properties: M monotone, M k ≥ Nk k, M k ≥ k.
  set M : ℕ → ℕ := fun k => max k ((Finset.range (k + 1)).sup Nk) with hM_def
  have hM_ge_k : ∀ k, k ≤ M k := fun k => le_max_left _ _
  have hM_ge_Nk : ∀ k, Nk k ≤ M k := by
    intro k
    refine le_max_of_le_right ?_
    apply Finset.le_sup (f := Nk)
    exact Finset.self_mem_range_succ k
  have hM_mono : Monotone M := by
    intro j k hjk
    refine max_le_max hjk ?_
    apply Finset.sup_mono
    exact Finset.range_subset_range.mpr (Nat.succ_le_succ hjk)
  have hM_witness : ∀ k, ∀ n ≥ M k, ∃ w ∈ Metric.ball z₀ (radK k), f_n n w = 0 :=
    fun k n hn => hNk k n ((hM_ge_Nk k).trans hn)
  -- Define kOf n := the largest k ≤ n with M k ≤ n; 0 if no such k.
  set kOf : ℕ → ℕ := fun n => Nat.findGreatest (fun k => M k ≤ n) n with hkOf_def
  -- Key: for K with n ≥ M K, K ≤ kOf n (since K ≤ M K ≤ n provides a witness).
  have hkOf_ge : ∀ K n, M K ≤ n → K ≤ kOf n := by
    intro K n hMKn
    have hK_le_n : K ≤ n := (hM_ge_k K).trans hMKn
    exact Nat.le_findGreatest hK_le_n hMKn
  -- For n ≥ M 0, M (kOf n) ≤ n (use findGreatest_spec with 0 as witness).
  have hM_kOf_le : ∀ n, M 0 ≤ n → M (kOf n) ≤ n := by
    intro n hn
    have h0_le_n : (0 : ℕ) ≤ n := Nat.zero_le _
    exact Nat.findGreatest_spec (P := fun k => M k ≤ n) h0_le_n hn
  -- Predicate "the witness ball at level kOf n contains a zero of f_n n".
  set predN : ℕ → Prop := fun n => ∃ w ∈ Metric.ball z₀ (radK (kOf n)), f_n n w = 0
    with hpredN_def
  have hpredN_eventually : ∀ n, M 0 ≤ n → predN n := by
    intro n hn
    exact hM_witness (kOf n) n (hM_kOf_le n hn)
  -- Pick a witness w_n by Classical.choice when predN holds; otherwise z₀.
  let w_n : ℕ → ℂ := fun n => if h : predN n then h.choose else z₀
  refine ⟨w_n, ?_, ?_⟩
  · -- Eventually f_n n (w_n n) = 0.
    rw [Filter.eventually_atTop]
    refine ⟨M 0, fun n hn => ?_⟩
    have h_pred : predN n := hpredN_eventually n hn
    show f_n n (if h : predN n then h.choose else z₀) = 0
    rw [dif_pos h_pred]
    exact h_pred.choose_spec.2
  · -- w_n → z₀ in the metric topology.
    rw [Metric.tendsto_atTop]
    intro ε hε
    -- Pick K with radK K < ε (possible since radK → 0).
    have h_radK_eps : ∃ K, radK K < ε := by
      have := Metric.tendsto_nhds.mp hradK_tendsto_zero ε hε
      rcases Filter.eventually_atTop.mp this with ⟨K, hK⟩
      refine ⟨K, ?_⟩
      have := hK K (le_refl K)
      rwa [Real.dist_eq, sub_zero, abs_of_nonneg (hradK_pos K).le] at this
    obtain ⟨K, hK_eps⟩ := h_radK_eps
    -- For n ≥ M K (which is ≥ M 0 by monotonicity), kOf n ≥ K and predN holds.
    refine ⟨M K, fun n hn => ?_⟩
    have h_pred : predN n := by
      apply hpredN_eventually
      exact (hM_mono (Nat.zero_le K)).trans hn
    have h_kOf_ge_K : K ≤ kOf n := hkOf_ge K n hn
    have h_radK_decr : radK (kOf n) ≤ radK K := hradK_antitone h_kOf_ge_K
    -- w_n n = h_pred.choose, and h_pred.choose ∈ ball z₀ (radK (kOf n)).
    show dist (w_n n) z₀ < ε
    have hw_eq : w_n n = h_pred.choose := dif_pos h_pred
    rw [hw_eq]
    have hmem := h_pred.choose_spec.1
    rw [Metric.mem_ball] at hmem
    calc dist h_pred.choose z₀ < radK (kOf n) := hmem
      _ ≤ radK K := h_radK_decr
      _ < ε := hK_eps

end HilbertPolyaBostConnes.Lemmas.HurwitzZeros.Helpers
