if ($message =~ /^$sl !quiet ([$valid_chan_characters]+) ([$valid_nick_characters]+)$/) {
  CheckAuth($1,$hostname) ? ACT('MESSAGE','chanserv',"quiet $1 $2") : AuthError($sender,$target,$1);
}

if ($message =~ /^$sl !unquiet ([$valid_chan_characters]+) ([$valid_nick_characters]+)$/) {
  CheckAuth($1,$hostname) ? ACT('MESSAGE','chanserv',"unquiet $1 $2") : AuthError($sender,$target,$1);
}

if ($message =~ /^$sl !quietme$/) {
  CheckAuth($target,$hostname) ? ACT('MESSAGE','chanserv',"quiet $target $receiver") : AuthError($sender,$target,$target);
}

if ($message =~ /^$sl !unquietme$/) {
  CheckAuth($target,$hostname) ? ACT('MESSAGE','chanserv',"unquiet $target $receiver") : AuthError($sender,$target,$target);
}

if ($message =~ /^$sl !quietyou$/) {
  CheckAuth($target,$hostname) ? ACT('MESSAGE','chanserv',"quiet $target $self") : AuthError($sender,$target,$target);
}

if ($message =~ /^$sl !unquietyou$/) {
  CheckAuth($target,$hostname) ? ACT('MESSAGE','chanserv',"unquiet $target $self") : AuthError($sender,$target,$target);
}

