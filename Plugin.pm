package Plugins::NewShoutcast::Plugin;

# Plugin to stream  Shoutcast radio stations
#
# Released under GPLv2

use strict;
use base qw(Slim::Plugin::OPMLBased);

use Data::Dumper;
use Encode qw(encode decode);

use Slim::Utils::Strings qw(string cstring);
use Slim::Utils::Prefs;
use Slim::Utils::Log;

use Plugins::NewShoutcast::Genres;
use Plugins::NewShoutcast::API;

my	$log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.newshoutcast',
	'defaultLevel' => 'DEBUG',
	'description'  => 'PLUGIN_NEWSHOUTCAST',
});

my $prefs = preferences('plugin.newshoutcast');

sub initPlugin {
	my $class = shift;

	$log->debug("Shoutcast initPlugin");

	$class->SUPER::initPlugin(
		feed   => \&toplevel,
		tag    => 'newshoutcast',
		menu   => 'radios',
		is_app => 1,
		weight => 10,
	);

}

sub getDisplayName { 'PLUGIN_NEWSHOUTCAST' }


sub toplevel {
	my ($client, $callback, $args) = @_;

	$log->debug("Shoutcast toplevel ");
	
	if (!Slim::Networking::Async::HTTP::hasSSL() || !eval { require IO::Socket::SSL } ) {
		$callback->([
			{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_MISSINGSSL'), type => 'text' },
		]);
		return;
	}
	
	$callback->([
		{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_TOPSTATIONS'), type => 'url', url => \&topStationsHandler },

		{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_GENRES'), type => 'url', url => \&GenreHandler },

		{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_SEARCHSTATION'), type => 'search', url => \&searchStationsHandler },

		{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_SEARCHARTIST'), type => 'search', url => \&searchArtistsHandler },

	]);


}

sub GenreHandler {

	my ($client, $cb, $args) = @_;

	$log->debug("Shoutcast GenresHandler");
	
	my $g = Plugins::NewShoutcast::Genres::getGenres();

	my $items = [];

	for my $genre ( sort keys %$g ) {

		push @$items, {
			name => $genre,
			type => 'url',
			url  => \&subGenreHandler,
			passthrough => [  { genre => $genre } ],
		};

	}
	$cb->( $items );

	return;
				
}
sub subGenreHandler {
	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast subGenresHandler");

	$params ||= {};
	
	my $genres = Plugins::NewShoutcast::Genres::getGenres();
	my $genre = $params->{genre};

	my $items = [];

	push @$items, {
		name => $genre,
		type => 'url',
		url  => \&searchGenreHandler,
		passthrough => [  { genre => $genre } ],
	};

	for my $subgenre ( @{ %$genres{ $params->{genre} } } ) {

		push @$items, {
			name => $subgenre,
			type => 'url',
			url  => \&searchGenreHandler,
			passthrough => [  { genre => $subgenre } ],
		};

	}
	$cb->( $items );

	return;

}


sub searchStationsHandler {
	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast searchStationsHandler");
#	$log->debug(Dumper( $args->{search} ));

	my $key = $args->{search};

	Plugins::NewShoutcast::API->searchStations( $key, sub {

		my $stations = shift;
		getStations($stations, $cb);

	});

}

sub searchArtistsHandler {
	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast searchArtistsHandler".Dumper( $args->{search} ));

	my $key = $args->{search};
	Plugins::NewShoutcast::API->searchArtists( $key, sub {

		my $stations = shift;
		getStations($stations, $cb);

	});

}

sub topStationsHandler {
	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast topStationsHandler");

	Plugins::NewShoutcast::API->topStations( sub {

		my $stations = shift;
		getStations($stations, $cb);

	});

}

sub searchGenreHandler {
	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast searchGenreHandler");

	my $genre = $params->{genre};

	Plugins::NewShoutcast::API->browseByGenre( $genre, sub {
		my $stations = shift;
		getStations($stations, $cb);
	});

}

sub getStations {
	my ($stations, $cb) = @_;

	$log->debug("Shoutcast getStations".Dumper($stations));

	my @stations = @{ $stations };
	my $station = [];

	
	my $items = [];
	for $station ( @stations ) {
		push @$items, {
			name 		=> $station->{Name}." (".string('PLUGIN_NEWSHOUTCAST_LISTENER').": ".$station->{Listeners}."/ ".string('PLUGIN_NEWSHOUTCAST_BITRATE').": ".$station->{Bitrate}.")",
			type 		=> 'audio',
			url  		=> 'http://yp.shoutcast.com/sbin/tunein-station.m3u?id='.$station->{ID},
			bitrate 	=> $station->{Bitrate},
			listeners 	=> $station->{Listeners},
			genre	 	=> $station->{Genre},
		};
	}
	$cb->( $items );
}


1;
