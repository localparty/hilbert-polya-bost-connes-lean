import HilbertPolyaBostConnes.SpectralGate

/-! ## Terminal-type assertion

  Build-time type-check that the canonical terminal has the expected
  dependent function type:
    `CCMGalerkinSpectralData → RiemannHypothesis`
  If the type signature drifts the build fails here.
-/

example : HilbertPolyaBostConnes.CCMGalerkinSpectralData → RiemannHypothesis :=
  @HilbertPolyaBostConnes.rh_of_ccm_galerkin
