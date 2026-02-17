self: super: {
  darling = self.callPackage ../packages/darling {};
  darling-wrapped = self.callPackage ../packages/darling/wrapped.nix {};
}
