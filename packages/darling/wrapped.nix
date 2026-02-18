{
  writeShellScriptBin,
  darling,
  util-linux,
  ...
}:

writeShellScriptBin "darling" ''
  exec ${util-linux}/bin/unshare -mUcr -S0 ${darling}/bin/darling "$@"
''
