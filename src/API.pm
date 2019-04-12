package Plugins::NewShoutcast::API;

use strict;

use Digest::MD5 qw(md5_hex);
use File::Spec::Functions qw(catdir);
use JSON::XS::VersionOneAndTwo;
use List::Util qw(min max);
use URI::Escape qw(uri_escape uri_escape_utf8);

use Data::Dumper;

use constant API_URL => 'https://www.shoutcast.com/';
use constant DEFAULT_CACHE_TTL => 24 * 3600;

use Slim::Utils::Cache;
use Slim::Utils::Log;
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.newshoutcast');
my $log   = logger('plugin.newshoutcast');
my $cache = Slim::Utils::Cache->new();

sub flushCache { $cache->cleanup(); }

sub browseByGenre {

	my ( $class, $genre, $cb, $args ) = @_;
	$log->debug("Shoutcast browseByGenre");

	my $url = "https://directory.shoutcast.com/Home/BrowseByGenre";

	my $postdata = to_json({
		genrename     => $genre,
	});

	my $cacheKey = $args->{_noCache} ? '' : md5_hex($url.$genre);

	if ( $cacheKey && (my $cached = $cache->get($cacheKey)) ) {
		$log->debug("Returning cached data for: $url");

		$cb->($cached);
		return;
	}
	

	Slim::Networking::SimpleAsyncHTTP->new(
		sub {
			my $response = shift;
			
			my $result = eval { decode_json($response->content) };
			
			if ($@) {

				$log->error(Dumper($response)) unless $log->is_debug;
				$log->error($@);
			}

			$log->is_debug && warn Dumper($result);

			$result ||= {};
			
			$cache->set($cacheKey, $result, 5*60 || DEFAULT_CACHE_TTL);

			$cb->($result);
		},

		sub {
			warn Dumper(@_);
			$log->error($_[1]);
			$cb->( { error => $_[1] } );
		},
		
		{
			timeout => 15,
		}

	)->post($url,'Content-Type' => 'application/json', $postdata);


}
sub topStations {

	my ( $class, $cb, $args ) = @_;
	$log->debug("Shoutcast topStations");

	my $url = "https://directory.shoutcast.com/Home/Top";

	my $cacheKey = $args->{_noCache} ? '' : md5_hex($url);

	if ( $cacheKey && (my $cached = $cache->get($cacheKey)) ) {
		$log->debug("Returning cached data for: $url");

		$cb->($cached);
		return;
	}
	

	Slim::Networking::SimpleAsyncHTTP->new(
		sub {
			my $response = shift;
			
			my $result = eval { decode_json($response->content) };
			
			if ($@) {

				$log->error(Dumper($response)) unless $log->is_debug;
				$log->error($@);
			}

			$log->is_debug && warn Dumper($result);

			$result ||= {};
			
			$cache->set($cacheKey, $result, 5*60 || DEFAULT_CACHE_TTL);

			$cb->($result);
		},

		sub {
			warn Dumper(@_);
			$log->error($_[1]);
			$cb->( { error => $_[1] } );
		},
		
		{
			timeout => 15,

		}

	)->post($url,'Content-Type' => 'application/json','Content-Length' => 0);


}


sub searchStations {

	my ( $class, $key, $cb, $args ) = @_;

	$log->debug("Shoutcast searchStations");

//	my $url = "https://www.shoutcast.com/Search/UpdateAdvancedSearch";
	my $url = "https://directory.shoutcast.com/Search/UpdateSearch";

	my $postdata = to_json({
		query	=> $key,
	});

/*
	my $postdata = to_json({
		genre	=> "",
		artist	=> "",
		station	=> $key,
		song	=> "",
		genr	=> "",
	});
*/

	my $cacheKey = $args->{_noCache} ? '' : md5_hex($url.'stations'.$key);

	if ( $cacheKey && (my $cached = $cache->get($cacheKey)) ) {
		$log->debug("Returning cached data for: $url");

		$cb->($cached);
		return;
	}
	Slim::Networking::SimpleAsyncHTTP->new(
		sub {
			my $response = shift;
			
			my $result = eval { decode_json($response->content) };

			
			if ($@) {

				$log->error(Dumper($response)) unless $log->is_debug;
				$log->error($@);
			}

			$log->is_debug && warn Dumper($result);

			$result ||= {};
			
			$cache->set($cacheKey, $result, 5*60 || DEFAULT_CACHE_TTL);

			$cb->($result);
		},

		sub {
			warn Dumper(@_);
			$log->error($_[1]);
			$cb->( { error => $_[1] } );
		},
		
		{
			timeout => 15,

		}
	)->post($url,'Content-Type' => 'application/json', $postdata);

}

sub searchArtists {

	my ( $class, $key, $cb, $args ) = @_;

	$log->debug("Shoutcast searchArtists");

//	my $url = "https://www.shoutcast.com/Search/UpdateAdvancedSearch";
	my $url = "https://directory.shoutcast.com/Search/UpdateSearch";


	my $postdata = to_json({
		query	=> $key,
	});

/*
	my $postdata = to_json({
		genre	=> "",
		artist	=> $key,
		station	=> "",
		song	=> "",
		genr	=> "",
	});
*/

	my $cacheKey = $args->{_noCache} ? '' : md5_hex($url.'artists'.$key);

	if ( $cacheKey && (my $cached = $cache->get($cacheKey)) ) {
		$log->debug("Returning cached data for: $url");

		$cb->($cached);
		return;
	}
	Slim::Networking::SimpleAsyncHTTP->new(
		sub {
			my $response = shift;
			
			my $result = eval { decode_json($response->content) };
			
			if ($@) {

				$log->error(Dumper($response)) unless $log->is_debug;
				$log->error($@);
			}

			$log->is_debug && warn Dumper($result);

			$result ||= {};
			
			$cache->set($cacheKey, $result, 1*60 || DEFAULT_CACHE_TTL);

			$cb->($result);
		},

		sub {
			warn Dumper(@_);
			$log->error($_[1]);
			$cb->( { error => $_[1] } );
		},
		
		{
			timeout => 15,

		}
	)->post($url,'Content-Type' => 'application/json', $postdata);

}

1;
