package PluginParser::Internet::Youtube;
use strict;
use warnings;
use LWP::Simple;
use LWP::UserAgent;
use POSIX;
use FindBin;
use lib "$FindBin::Bin/../../modules/";
use JSON::JSON;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(match);

sub match {
  my ($self,$core) = @_;

  if(!$core->{'pinged'}) { return ''; }
  if($core->{'event'} ne 'on_public_message' and $core->{'event'} ne 'on_private_message') { return ''; }

  if($core->{'message'} =~ /^youtube ([a-zA-Z0-9-_]+)$/) {
    return youtube($core,$core->{'chan'},$core->{'target'},$1);
  }
  elsif($core->{'message'} =~ /^youtube .*youtube\.com.+v=([a-zA-Z0-9-_]+).*$/) {
    return youtube($core,$core->{'chan'},$core->{'target'},$1);
  }
  elsif($core->{'message'} =~ /^youtube .*youtu\.be\/([a-zA-Z0-9-_]+).*$/) {
    return youtube($core,$core->{'chan'},$core->{'target'},$1);
  }

  return '';
}

sub youtube {
  my ($core,$chan,$target,$video) = @_;

  my $url = "http://gdata.youtube.com/feeds/api/videos/${video}?v=2&alt=jsonc";
  my $request = LWP::UserAgent->new;
  $request->timeout(60);
  $request->env_proxy;
  $request->agent('Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0)');
  $request->max_size('1024000');
  $request->parse_head(0);
  my $json = JSON::decode_json($request->get($url)->decoded_content);

  my $title = $json->{'data'}->{'title'};
  my $duration = POSIX::strftime('%H:%M:%S',gmtime($json->{'data'}->{'duration'}));
  my $author = $json->{'data'}->{'uploader'};
  my $views = $json->{'data'}->{'viewCount'};
  my $likes = $json->{'data'}->{'likeCount'};
  my $dislikes = ($json->{'data'}->{'ratingCount'} - $likes);

  my $restrictions = "(\x0314no region restrictions\x0F)";
  if($json->{'data'}->{'restrictions'}) { $restrictions = "(\x0307unavailable in some regions\x0F)"; }

  $core->{'output'}->parse("MESSAGE>${chan}>$target: \x02\"${title}\"\x02 \x0306${duration}\x0F (by \x0303${author}\x0F) \x0314${views}\x0F views, \x0303${likes}\x0F likes, \x0304${dislikes}\x0F dislikes http://youtu.be/${video} ${restrictions}");
}
