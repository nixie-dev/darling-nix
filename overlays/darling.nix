self: super: {
  darling = self.callPackage ../packages/darling {};
  darling-wrapped = self.callPackage ../packages/darling/wrapped.nix {};

  darlingPackages = self.lib.makeScope self.newScope (selfScope: {
  ###### Local dev tools

    sdk = "${self.darling.sdk}/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";

    clang = self.pkgsBuildBuild.llvmPackages;

  } // super.lib.optionalAttrs (super.targetPlatform ? isDarwin) {
  ###### Cross-compilers exclusively

    binutils = self.wrapBintoolsWith {
      bintools = self.darlingPackages.clang.bintools-unwrapped;
      libc = null;
    };

    gcc = self.wrapCCWith {
      cc = self.darlingPackages.clang.clang-unwrapped;
      bintools = self.darlingPackages.binutils;
      libc = null;

      extraBuildCommands = ''
        tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
        mv cc-cflags.tmp $out/nix-support/cc-cflags
        echo "-target ${self.targetPlatform.config}" >> $out/nix-support/cc-cflags
        echo "-fuse-ld=lld" >> $out/nix-support/cc-cflags
        echo "-nostdinc -nostdlib" >> $out/nix-support/cc-cflags
        echo "-mmacosx-version-min=10.15" >> $out/nix-support/cc-cflags
        echo "--sysroot ${self.darlingPackages.sdk}" >> $out/nix-support/cc-cflags
        echo "-isystem ${self.darlingPackages.sdk}/usr/include" >> $out/nix-support/cc-cflags
        echo "-L ${self.darlingPackages.sdk}/usr/lib -lSystem" >> $out/nix-support/cc-cflags
      '';

      extraPackages = with self.darlingPackages.clang; [
        lld
      ];
    };

  } // super.lib.optionalAttrs (super.hostPlatform ? isDarwin) {
  ###### Native libraries

  });

  binutils = if (super.targetPlatform ? isDarwin)
             then self.darlingPackages.binutils
             else super.binutils;
  gcc = if (super.targetPlatform ? isDarwin)
        then self.darlingPackages.gcc
        else super.gcc;
}
