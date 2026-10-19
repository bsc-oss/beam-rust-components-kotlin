#!/usr/bin/env bash
set -e

helpFunction() {
  echo ""
  echo "Usage: $0 -r -p /Documents/dev/matrix-rust-sdk -m sdk"
  echo -e "\t-p Local path to the rust-sdk repository"
  echo -e "\t-o Optional output path with the expected name of the aar file"
  echo -e "\t-r Flag to build in release mode"
  echo -e "\t-m Option to select the gradle module to build. Default is sdk"
  echo -e "\t-t Select a target architecture to build for. Default will build for all known Android targets."
  echo -e "\t-l Build for the local architecture. Incompatible with '-t'."
  exit 1
}

echo_and_exec() {
    echo "$ $@"
    "$@"
}

scripts_dir=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit
  pwd -P
)

is_release='false'
gradle_module='sdk'
only_target=''
local_target=''
output=''

while getopts ':rp:m:t:lo:' 'opt'; do
  case ${opt} in
  'r') is_release='true' ;;
  'p') sdk_path="$OPTARG" ;;
  'm') gradle_module="$OPTARG" ;;
  't') only_target="$OPTARG" ;;
  'l') local_target='true' ;;
  'o') output="$OPTARG" ;;
  ?) helpFunction ;;
  esac
done

if [ -z "$sdk_path" ]; then
  echo "sdk_path is empty, please provide one"
  helpFunction
fi

if [ -n "$local_target" ]; then
    if [ -n "$only_target" ]; then
        echo "Cannot specifiy both '-l' and '-t'." >&2
        exit 1
    fi

    only_target="$(uname -m)-linux-android"
    # On ARM MacOS, `uname -m` returns arm64, but the toolchain is called aarch64
    only_target="${only_target/arm64/aarch64}"
fi

if [ -z "$only_target" ]; then
  echo "no target provided, build for all targets"
  target_command=()
else
  target_command=("--only-target" "$only_target")
fi

if ${is_release}; then
  profile="small-release-stripped"
else
  profile="reldev"
fi

if [ "$gradle_module" = "crypto" ]; then
  ## NDK is needed for https://crates.io/crates/olm-sys
  if [ -z "$ANDROID_NDK" && -z "$ANDROID_HOME" ]; then
    echo "please set the ANDROID_NDK environment variable to your Android NDK installation"
    exit 1
  fi
  src_dir="$scripts_dir/../crypto/crypto-android/src/main"
  package="crypto-sdk"
else
  src_dir="$scripts_dir/../sdk/sdk-android/src/main"
  package="full-sdk"
fi

echo "Launching build script with following params:"
echo "sdk_path = $sdk_path"
echo "profile = $profile"
echo "gradle_module = $gradle_module"
echo "src-dir = $src_dir"

echo_and_exec cd "$sdk_path"
echo_and_exec cargo xtask kotlin build-android-library --profile "$profile" "${target_command[@]}" --src-dir "$src_dir" --package "$package"

cd "$scripts_dir/.."

shift $((OPTIND - 1))

moveFunction() {
  if [ -z "$output" ]; then
    echo -e "\nSUCCESS: Output AAR file is '$1'"
  else
    mv "$1" "$output"
    echo -e "\nSUCCESS: Output AAR file is '$output'"
  fi
}

## For now, cargo ndk includes all generated so files from the target directory, so makes sure it just includes the one we need.
echo "Clean .so files"
if [ "$gradle_module" = "crypto" ]; then
  find crypto/crypto-android/src/main/jniLibs -type f ! -name 'libmatrix_sdk_crypto_ffi.so' -delete
else
  find sdk/sdk-android/src/main/jniLibs -type f ! -name 'libmatrix_sdk_ffi.so' -delete
fi

# Strip symbol tables from .so files. The Rust build keeps a ~30MB .symtab/.strtab
# per ABI that `strip = "debuginfo"` does not remove, so an explicit strip is
# required. Skipping it silently was how we once shipped a 166MB aar vs ~93MB.
find_llvm_strip() {
  # 1. Explicit ANDROID_NDK, 2. ANDROID_HOME/ndk/*, 3. default macOS SDK location.
  local candidates=()
  [ -n "$ANDROID_NDK" ] && candidates+=("$ANDROID_NDK")
  [ -n "$ANDROID_HOME" ] && candidates+=("$ANDROID_HOME"/ndk/*)
  candidates+=("$HOME"/Library/Android/sdk/ndk/*)

  local ndk
  for ndk in "${candidates[@]}"; do
    [ -d "$ndk" ] || continue
    # prebuilt dir is host-specific (e.g. darwin-x86_64, runs under Rosetta on arm64).
    local strip_bin
    for strip_bin in "$ndk"/toolchains/llvm/prebuilt/*/bin/llvm-strip; do
      if [ -f "$strip_bin" ]; then
        echo "$strip_bin"
        return 0
      fi
    done
  done
  return 1
}

echo "Stripping symbol tables from .so files"
NDK_STRIP="$(find_llvm_strip)" || {
  echo "ERROR: could not locate llvm-strip. Set ANDROID_NDK or ANDROID_HOME," >&2
  echo "       or install an NDK under \$HOME/Library/Android/sdk/ndk." >&2
  echo "       Refusing to ship unstripped .so files." >&2
  exit 1
}
echo "Using llvm-strip at $NDK_STRIP"

if [ "$gradle_module" = "crypto" ]; then
  find crypto/crypto-android/src/main/jniLibs -name 'libmatrix_sdk_crypto_ffi.so' -exec "$NDK_STRIP" {} \;
else
  find sdk/sdk-android/src/main/jniLibs -name 'libmatrix_sdk_ffi.so' -exec "$NDK_STRIP" {} \;
fi
echo "Symbols stripped successfully"

if ${is_release}; then
  if [ "$gradle_module" = "sdk" ]; then
    ./gradlew :sdk:sdk-android:assembleRelease
    moveFunction "sdk/sdk-android/build/outputs/aar/sdk-android-release.aar"
  else
    ./gradlew :crypto:crypto-android:assembleRelease
    moveFunction "crypto/crypto-android/build/outputs/aar/crypto-android-release.aar"
  fi
else
  if [ "$gradle_module" = "sdk" ]; then
    ./gradlew :sdk:sdk-android:assembleDebug
    moveFunction "sdk/sdk-android/build/outputs/aar/sdk-android-debug.aar"
  else
    ./gradlew :crypto:crypto-android:assembleDebug
    moveFunction "crypto/crypto-android/build/outputs/aar/crypto-android-debug.aar"
  fi
fi
