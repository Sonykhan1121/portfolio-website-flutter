#!/usr/bin/env bash

set -euo pipefail

github_username="${GITHUB_USERNAME:-Sonykhan1121}"
output_path="${1:-assets/data/github_repositories.json}"
page_size=100
page=1
sync_tmp_dir="$(mktemp -d)"

trap 'rm -rf "${sync_tmp_dir}"' EXIT

printf '[]\n' > "${sync_tmp_dir}/all.json"

request_headers=(
  -H "Accept: application/vnd.github+json"
  -H "X-GitHub-Api-Version: 2022-11-28"
)

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  request_headers+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

while true; do
  page_path="${sync_tmp_dir}/page-${page}.json"
  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    "${request_headers[@]}" \
    "https://api.github.com/users/${github_username}/repos?type=owner&sort=updated&direction=desc&per_page=${page_size}&page=${page}" \
    --output "${page_path}"

  repository_count="$(jq 'length' "${page_path}")"
  jq -s '.[0] + .[1]' \
    "${sync_tmp_dir}/all.json" \
    "${page_path}" > "${sync_tmp_dir}/merged.json"
  mv "${sync_tmp_dir}/merged.json" "${sync_tmp_dir}/all.json"

  if (( repository_count < page_size )); then
    break
  fi
  ((page += 1))
done

mkdir -p "$(dirname "${output_path}")"
jq \
  '[.[] | {name, description, language, html_url, created_at, updated_at, stargazers_count, topics, fork, archived}]' \
  "${sync_tmp_dir}/all.json" > "${output_path}"

printf 'Wrote %s public repositories to %s\n' \
  "$(jq 'length' "${output_path}")" \
  "${output_path}"
