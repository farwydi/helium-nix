# helium-nix

Nix-пакет [Helium](https://github.com/imputnet/helium) — приватный Chromium-based браузер.

Собирается из официального AppImage ([helium-linux](https://github.com/imputnet/helium-linux)) через `appimageTools.wrapType2`. Версия и хэши — в `sources.json`, обновляются ежедневно GitHub Actions (`update.sh`).

## Сборка

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
./result/bin/helium
```

## home-manager

```nix
heliumSrc = builtins.fetchTarball {
  url = "https://github.com/farwydi/helium-nix/archive/refs/heads/master.tar.gz";
};
helium = pkgs.callPackage "${heliumSrc}/package.nix" { };
```
