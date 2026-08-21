#!/usr/bin/env bash
# Local contract checks for deploy.showcase (no GitHub Actions required).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

id_ok='^[a-z0-9]+(-[a-z0-9]+)*$'

assert_id() {
  local id="$1" want="$2"
  if [[ "$id" =~ $id_ok ]]; then
    [[ "$want" == ok ]] || { echo "accepted invalid id: $id"; exit 1; }
  else
    [[ "$want" == bad ]] || { echo "rejected valid id: $id"; exit 1; }
  fi
}

assert_id document-platform ok
assert_id hcm-requisitions ok
assert_id a ok
assert_id a1 ok
assert_id DocumentPlatform bad
assert_id document_platform bad
assert_id document/platform bad
assert_id ../document-platform bad
assert_id .git bad
assert_id .github bad
assert_id -leading bad
assert_id trailing- bad

ruby -ryaml -e '
cfg = YAML.load_file("examples/document-platform.ci.yaml")
s = cfg.fetch("deploy").fetch("showcase")
abort("enabled") unless s["enabled"] == true
abort("id") unless s["id"] == "document-platform"
%w[repository path base_href].each { |k| abort(k) if s.key?(k) }
puts "OK consumer example"
'

href="/rsprojects-showcase/generated/document-platform/"
path="generated/document-platform"
[[ "$href" == "/rsprojects-showcase/generated/document-platform/" ]]
[[ "$path" == generated/document-platform ]]

rm -rf /tmp/platform-ci-showcase-e2e
mkdir -p /tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/document-platform
mkdir -p /tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/hcm-requisitions
echo stale > /tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/document-platform/STALE
echo sibling > /tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/hcm-requisitions/SIBLING
mkdir -p /tmp/platform-ci-showcase-e2e/build/assets
cat > /tmp/platform-ci-showcase-e2e/build/index.html <<'HTML'
<!DOCTYPE html><html><head><base href="/rsprojects-showcase/generated/document-platform/"></head><body></body></html>
HTML
echo js > /tmp/platform-ci-showcase-e2e/build/flutter.js
cat > /tmp/platform-ci-showcase-e2e/build/showcase.json <<'JSON'
{"id":"document-platform","version":"1.2.0","commit":"abc123","deployedAt":"2026-08-21T00:00:00Z"}
JSON

# Replicate showcase-sync isolation (generated/<id>/ only).
target=/tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/document-platform
find "$target" -mindepth 1 -delete
cp -R /tmp/platform-ci-showcase-e2e/build/. "$target/"
test -f "$target/index.html"
grep -q '/rsprojects-showcase/generated/document-platform/' "$target/index.html"
test -f "$target/showcase.json"
test ! -f "$target/STALE"
test -f /tmp/platform-ci-showcase-e2e/rsprojects-showcase/generated/hcm-requisitions/SIBLING

if grep -n 'SHOWCASE_DEPLOY_TOKEN' \
  .github/workflows/deploy-showcase.yml \
  templates/consumer-deploy-showcase.yml \
  .github/actions/read-config/action.yml \
  .github/actions/showcase-validate/action.yml \
  examples/*.yaml \
  schema/ci.schema.json; then
  echo "SHOWCASE_DEPLOY_TOKEN still present in active config"
  exit 1
fi

echo "OK platform-ci showcase local contract"
