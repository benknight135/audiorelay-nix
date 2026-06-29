self: super:

{
  audiorelay = super.stdenv.mkDerivation rec {
    pname = "audiorelay";
    version = "1.0.0-alpha09";

    src = super.fetchurl {
      url = "https://dl.audiorelay.net/setups/linux/audiorelay-1.0.0-alpha09-x64.tar.gz";
      sha256 = "0iw5qrg3bjzbiai3ch2widzshc754nkg5m3ngvqzwmpjw7n7i6x7";
    };

    nativeBuildInputs = [
      super.autoPatchelfHook
      super.makeWrapper
    ];

    buildInputs = [
      super.glibc
      super.stdenv.cc.cc.lib
      super.zlib

      super.libX11 super.libXext super.libXi super.libXrender super.libXtst
      super.cairo super.harfbuzz super.pango super.atk super.gdk-pixbuf
      super.gtk3 super.fontconfig super.glib super.libnotify super.mesa

      super.alsa-lib super.pulseaudio
      super.avahi

      super.libayatana-appindicator
      super.libayatana-indicator
      super.ayatana-ido
      super.libdbusmenu

      super.libsecret
    ];

    desktopItem = super.makeDesktopItem {
      name = "audiorelay";
      desktopName = "AudioRelay";
      exec = "audiorelay";
      icon = "audiorelay";
      comment = "Stream audio between devices";
      categories = [ "AudioVideo" "Audio" "Network" ];
    };

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      runHook preInstall
      
      install -Dm755 AudioRelay/bin/AudioRelay \
        $out/share/audiorelay/bin/AudioRelay

      cp -r AudioRelay/* $out/share/audiorelay/

      # Upstream ships a prebuilt ELF binary without an interpreter, so we must
      # manually set the dynamic linker. autoPatchelfHook does not catch it because
      # the binary is inside the unpacked tarball rather than the build directory.
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/share/audiorelay/bin/AudioRelay

      makeWrapper $out/share/audiorelay/bin/AudioRelay $out/bin/audiorelay \
        --set JAVA_HOME $out/share/audiorelay/lib/runtime \
        --set PATH "$out/share/audiorelay/lib/runtime/bin:$PATH"

      install -Dm644 AudioRelay/lib/AudioRelay.png \
        $out/share/icons/hicolor/512x512/apps/audiorelay.png

      install -Dm644 ${desktopItem}/share/applications/audiorelay.desktop \
        $out/share/applications/audiorelay.desktop

      runHook postInstall
    '';

    meta = with super.lib; {
      description = "Stream audio between your devices";
      longDescription = ''
        AudioRelay lets you stream audio between devices over your local network.
      '';
      homepage = "https://audiorelay.net/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "audiorelay";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    };
  };
}
