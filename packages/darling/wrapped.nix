{
  writeShellScriptBin,
  darling,
  util-linux,
  ...
}:

writeShellScriptBin "darling" ''
  exec ${util-linux}/bin/unshare -mUrc -S0 --map-auto ${darling}/bin/darling "$@"
''
