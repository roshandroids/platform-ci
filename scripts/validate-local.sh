#!/usr/bin/env bash
# Run the same quality gates as platform-ci quality.yml (locally).
# Usage: ./validate-local.sh [ci.yaml]
set -euo pipefail

CONFIG_PATH="${1:-ci.yaml}"

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "error: missing $CONFIG_PATH" >&2
  exit 1
fi

if ! command -v ruby >/dev/null; then
  echo "error: ruby required to parse ci.yaml" >&2
  exit 1
fi

if ! command -v flutter >/dev/null; then
  echo "error: flutter not on PATH" >&2
  exit 1
fi

eval "$(
  CONFIG_PATH="$CONFIG_PATH" ruby -ryaml -e '
    cfg = YAML.load_file(ENV.fetch("CONFIG_PATH"))
    abort("invalid ci.yaml") unless cfg.is_a?(Hash)
    quality = cfg["quality"].is_a?(Hash) ? cfg["quality"] : {}
    paths = cfg["paths"] || ["."]
    kind = cfg["kind"] || "app"
    puts "KIND=#{kind}"
    puts "DO_FORMAT=#{quality.key?("format") ? !!quality["format"] : true}"
    puts "DO_ANALYZE=#{quality.key?("analyze") ? !!quality["analyze"] : true}"
    puts "DO_TEST=#{quality.key?("test") ? !!quality["test"] : true}"
    puts "COVERAGE=#{quality.key?("coverage") ? !!quality["coverage"] : false}"
    puts "MELOS_FILTER=#{quality["melos_filter"].to_s}"
    paths.each_with_index { |p, i| puts "PATH_#{i}=#{p}" }
    puts "PATH_COUNT=#{paths.length}"
  '
)"

echo "==> platform-ci local validate ($CONFIG_PATH) kind=$KIND"

run_in_paths() {
  local cmd="$1"
  local i
  for ((i = 0; i < PATH_COUNT; i++)); do
    local var="PATH_$i"
    local p="${!var}"
    echo "--> ($p) $cmd"
    (cd "$p" && eval "$cmd")
  done
}

if [[ "$KIND" == "melos" ]]; then
  if ! command -v melos >/dev/null; then
    dart pub global activate melos
    export PATH="$PATH:$HOME/.pub-cache/bin"
  fi
  melos bootstrap ${MELOS_FILTER:+--scope="$MELOS_FILTER"}
  if [[ "$DO_FORMAT" == "true" ]]; then
    melos exec ${MELOS_FILTER:+--scope="$MELOS_FILTER"} -- dart format --set-exit-if-changed .
  fi
  if [[ "$DO_ANALYZE" == "true" ]]; then
    melos exec ${MELOS_FILTER:+--scope="$MELOS_FILTER"} -- flutter analyze --fatal-infos
  fi
  if [[ "$DO_TEST" == "true" ]]; then
    if [[ "$COVERAGE" == "true" ]]; then
      melos exec ${MELOS_FILTER:+--scope="$MELOS_FILTER"} -- flutter test --coverage
    else
      melos exec ${MELOS_FILTER:+--scope="$MELOS_FILTER"} -- flutter test
    fi
  fi
else
  run_in_paths "flutter pub get"
  if [[ "$DO_FORMAT" == "true" ]]; then
    run_in_paths "dart format --set-exit-if-changed ."
  fi
  if [[ "$DO_ANALYZE" == "true" ]]; then
    run_in_paths "flutter analyze --fatal-infos"
  fi
  if [[ "$DO_TEST" == "true" ]]; then
    if [[ "$COVERAGE" == "true" ]]; then
      run_in_paths "flutter test --coverage"
    else
      run_in_paths "flutter test"
    fi
  fi
fi

echo "==> OK"
