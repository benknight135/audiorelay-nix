{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, libX11
, libXext
, libXi
, libXrender
, libXtst
, cairo
, harfbuzz
, pango
, atk
, gdk-pixbuf
, gtk3
, fontconfig
, glib
, libnotify
, mesa
, alsa-lib
, pulseaudio
, avahi
, libayatana-appindicator
, libayatana-indicator
, ayatana-ido
, libdbusmenu
, libsecret
, zlib
, ...
}:

stdenv.mkDerivation rec {
  pname = "audiorelay";
  version = "1.0.0-alpha09";

  src = fetchurl {
    url = "https://dl.audiorelay.net/setups/linux/audiorelay-1.0.0-alpha09-x64.tar.gz";
    sha256 = "0iw5qrg3bjzbiai3ch2widzshc754nkg5m3ngvqzwmpjw7n7i6x7";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    # X11 + GTK stack (auto-injected)
    libX11 libXext libXi libXrender libXtst
    cairo harfbuzz pango atk gdk-pixbuf gtk3
    fontconfig glib libnotify mesa

    # Audio + networking
    alsa-lib pulseaudio avahi

    # Ayatana indicators
    libayatana-appindicator
    libayatana-indicator
    ayatana-ido
    libdbusmenu

    # Misc
    libsecret
    zlib
  ];

  desktopItem = makeDesktopItem {
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

  meta = with lib; {
    description = "Stream audio between your devices";
    homepage = "https://audiorelay.net/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "audiorelay";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
