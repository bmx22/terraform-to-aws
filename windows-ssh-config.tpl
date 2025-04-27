add-content -path c:/users/bryan/.ssh/config -value @'

Host ${hostname}
  Hostname ${hostname}
  User ${user}
  IdentityFile ${identityfile}
'@