{ pkgs, lib }:
let
  claudeCodeVersion = "2.1.114"; # Set to a version string like "1.2.3" to pin, or null for latest
  claudeCodeBinaryPkg = {
    "aarch64-darwin" = { name = "claude-code-darwin-arm64"; hash = "sha256-W33zTuyDOZaEGI7EZCrmD0//lsaCLbL/WY5JNbnSnfk="; };
    "x86_64-darwin"  = { name = "claude-code-darwin-x64";   hash = lib.fakeHash; };
    "aarch64-linux"  = { name = "claude-code-linux-arm64";  hash = lib.fakeHash; };
    "x86_64-linux"   = { name = "claude-code-linux-x64";    hash = lib.fakeHash; };
  }.${pkgs.stdenv.hostPlatform.system};
in
  if claudeCodeVersion == null
    then pkgs.claude-code
    else pkgs.stdenv.mkDerivation {
      pname = "claude-code";
      version = claudeCodeVersion;
      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/@anthropic-ai/${claudeCodeBinaryPkg.name}/-/${claudeCodeBinaryPkg.name}-${claudeCodeVersion}.tgz";
        hash = claudeCodeBinaryPkg.hash;
      };
      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;
      dontFixup = true;
      installPhase = ''
        mkdir -p $out/bin
        cp claude $out/bin/claude
        chmod +x $out/bin/claude
      '';
      meta = {
        description = "Claude Code CLI";
        license = lib.licenses.unfree;
        mainProgram = "claude";
      };
    }
