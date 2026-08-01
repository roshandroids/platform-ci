#!/usr/bin/env bash
# Parse ci/project.yaml → GITHUB_OUTPUT. Requires ruby (YAML stdlib on GH runners).
set -euo pipefail

CONFIG_PATH="${CONFIG_PATH:-ci/project.yaml}"

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "::error::Config not found: $CONFIG_PATH"
  exit 1
fi

# Emit key=value lines for GITHUB_OUTPUT (handles multiline via no newlines in values).
ruby -ryaml -e '
path = ENV.fetch("CONFIG_PATH")
cfg = YAML.load_file(path)
abort("config root must be a mapping") unless cfg.is_a?(Hash)

schema = cfg["schema"]
abort("schema must be 1 (got #{schema.inspect})") unless schema == 1

kind = cfg["kind"]
allowed = %w[flutter_app dart_package melos_workspace cli]
abort("kind must be one of #{allowed.join(", ")}") unless allowed.include?(kind)

flutter = cfg["flutter"]
flutter = nil if flutter.nil? || flutter.to_s.strip.empty?
dart = (cfg["dart"] || "3.6.0").to_s
melos = cfg.key?("melos") ? !!cfg["melos"] : (kind == "melos_workspace")

packages = cfg["packages"] || ["."]
abort("packages must be a non-empty array") unless packages.is_a?(Array) && !packages.empty?
primary = packages.first.to_s

q = cfg["quality"] || {}
q = {} unless q.is_a?(Hash)
format_on = q.key?("format") ? !!q["format"] : true
analyze_on = q.key?("analyze") ? !!q["analyze"] : true
test_on = q.key?("test") ? !!q["test"] : true
coverage_on = q.key?("coverage") ? !!q["coverage"] : false

format_paths = q["format_paths"] || ["lib", "test"]
format_paths = ["lib", "test"] unless format_paths.is_a?(Array)
analyze_paths = q["analyze_paths"] || format_paths
analyze_paths = format_paths unless analyze_paths.is_a?(Array)
test_path = (q["test_path"] || primary).to_s
pub_get_dirs = q["pub_get_dirs"] || packages
pub_get_dirs = packages unless pub_get_dirs.is_a?(Array)

b = cfg["build"] || {}
b = {} unless b.is_a?(Hash)
on_main = b["on_main"] || []
on_release = b["on_release"] || []
on_main = [] unless on_main.is_a?(Array)
on_release = [] unless on_release.is_a?(Array)

web = b["web"] || {}
web = {} unless web.is_a?(Hash)
web_on_pr = web.key?("on_pr") ? !!web["on_pr"] : false
web_base_href = (web["base_href"] || "/").to_s
web_path = (web["path"] || primary).to_s

cli = b["cli"] || {}
cli = {} unless cli.is_a?(Hash)
cli_entrypoint = (cli["entrypoint"] || "bin/app.dart").to_s
cli_name = (cli["name"] || "app").to_s

d = cfg["deploy"] || {}
d = {} unless d.is_a?(Hash)
deploy_target = (d["target"] || "none").to_s
deploy_on_main = d.key?("on_main") ? !!d["on_main"] : false

r = cfg["release"] || {}
r = {} unless r.is_a?(Hash)
release_mode = (r["mode"] || "manual").to_s
release_github = r.key?("github_release") ? !!r["github_release"] : true
release_pub_dev = r.key?("pub_dev") ? !!r["pub_dev"] : false

use_flutter = !flutter.nil? || %w[flutter_app melos_workspace].include?(kind)

require "json"
out = {
  "flutter_version" => flutter.to_s,
  "dart_version" => dart,
  "kind" => kind,
  "melos" => melos ? "true" : "false",
  "primary_package" => primary,
  "packages_json" => JSON.generate(packages),
  "use_flutter" => use_flutter ? "true" : "false",
  "quality_format" => format_on ? "true" : "false",
  "quality_analyze" => analyze_on ? "true" : "false",
  "quality_test" => test_on ? "true" : "false",
  "quality_coverage" => coverage_on ? "true" : "false",
  "format_paths" => format_paths.join(" "),
  "analyze_paths" => analyze_paths.join(" "),
  "test_path" => test_path,
  "pub_get_dirs" => pub_get_dirs.join(" "),
  "build_on_main_json" => JSON.generate(on_main),
  "build_on_release_json" => JSON.generate(on_release),
  "web_on_pr" => web_on_pr ? "true" : "false",
  "web_base_href" => web_base_href,
  "web_path" => web_path,
  "deploy_target" => deploy_target,
  "deploy_on_main" => deploy_on_main ? "true" : "false",
  "release_mode" => release_mode,
  "release_github" => release_github ? "true" : "false",
  "release_pub_dev" => release_pub_dev ? "true" : "false",
  "cli_entrypoint" => cli_entrypoint,
  "cli_name" => cli_name,
}

File.open(ENV.fetch("GITHUB_OUTPUT"), "a") do |f|
  out.each { |k, v| f.puts "#{k}=#{v}" }
end

puts "platform-ci config OK: kind=#{kind} flutter=#{flutter || "(none)"} packages=#{packages.size}"
'
