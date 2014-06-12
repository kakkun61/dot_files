def git_tracked? path
  system "git ls-files --error-unmatch #{path} >/dev/null 2>&1"
end

ARGV.each { |arg|
  if git_tracked? arg then
    `git rm #{arg}`
  else
    `rm #{arg}`
  end
}
