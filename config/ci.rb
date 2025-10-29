# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: Ruby", "bin/rubocop"

  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: Specs", "bin/rspec spec"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  unless ENV["GITHUB_ACTIONS"] == "true"
    if success?
      step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
    else
      failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
    end
  end
end
