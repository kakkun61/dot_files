#!/usr/bin/env ruby

def git_tracked? path
  system "git ls-files --error-unmatch #{path} >/dev/null 2>&1"
end

opts = []
args = []
endopt = false
ARGV.each { |arg|
  if endopt or arg[0] != '-' then
    args.push arg
  else
    opts.push arg
    if arg == '--' then
      endopt = true
    end
  end
}

optstr = opts.join ' '

args.each { |arg|
  if git_tracked? arg then
    `git rm #{optstr} #{arg}`
  else
    `/bin/rm #{optstr} #{arg}`
  end
}
