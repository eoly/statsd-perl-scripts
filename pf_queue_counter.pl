#!/usr/bin/perl

use strict;
use warnings;
use FindBin;

use lib "$FindBin::Bin/lib";
use Net::Statsd;

$Net::Statsd::HOST = '127.0.0.1';
$Net::Statsd::PORT = 8125;

my $pf_spool = "/var/spool/postfix";
my @pf_queues = ("maildrop","hold","incoming","active","deferred");

foreach (@pf_queues) {
    my $queue_name = $_;
    my $pf_queue_dir = $pf_spool . "/" . $queue_name;
    my $count = `find $pf_queue_dir -type f | wc -l`;
    print $queue_name . " : " . $count . "\n";
    my $stat = "postfix.queuesize.".$queue_name;
    $count =~ s/[\r\n]+$//;
    Net::Statsd::gauge($stat, $count);
}
