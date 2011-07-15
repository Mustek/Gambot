if ($message =~ /^$sl !join ([$valid_chan_characters]+)$/) {
  CheckAuth($1,$hostname) ? ACT('JOIN',$1) : AuthError($sender,$target,$1);
}

if ($message =~ /^$sl !part ([$valid_chan_characters]+) ?(.+)?$/) {
  CheckAuth($1,$hostname) ? ACT('PART',$1,$2) : AuthError($sender,$target,$1);
}
