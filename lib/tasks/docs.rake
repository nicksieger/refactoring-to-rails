desc "Generate an HTML document describing all commits"
task :commitdoc do
  header = <<-HDR
# Refactoring to Rails Commits

The commits in this project are meant to be read from beginning to
end. This document is an easy way to do that. It can be generated
directly from the commit logs. You can regenerate it by running
`rake commitdoc`.

HDR
  format = '### %s%n%n- [Commit: %h](https://github.com/nicksieger/refactoring-to-rails/commit/%H)%n%n%b%n'
  sh "(echo '#{header}' && git log --reverse --format=format:'#{format}' refactor-base..HEAD) | maruku -o- > commits.html"
end
