package Plugins::NewShoutcast::Plugin;

# Plugin to stream  Shoutcast radio stations
#
# Released under GPLv2
 
use strict;
use Switch;
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

$prefs->init({ 
	bitrate_filter 	=> 0, 
	sorting 		=> "L",
});


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

		{ name => cstring($client, 'PLUGIN_NEWSHOUTCAST_SETTINGS'), type => 'url', url => \&settingsHandler },

	]);


}

sub setBitrateHandler {

	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast setBitrateHandler");

	$prefs->set('bitrate_filter', $params->{filter});

	my $items = [];

	push @$items, {
		name => cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTERING_RESULT'),
		type => 'text',
	};
	$cb->( $items );


}
sub setSortingHandler {

	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast setSortingHandler");

	$prefs->set('sorting', $params->{filter});

	my $items = [];

	push @$items, {
		name => cstring($client, 'PLUGIN_NEWSHOUTCAST_SORTING_RESULT'),
		type => 'text',
	};
	$cb->( $items );


}
sub settingsHandler {

	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast settingsHandler");

	my $items = [];

	push @$items, {
		name => cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTERING'),
		type => 'url',
		url  => \&bitrateFilterHandler,
	};
	push @$items, {
		name => cstring($client, 'PLUGIN_NEWSHOUTCAST_SORTING'),
		type => 'url',
		url  => \&sortingHandler,
	};
	$cb->( $items );

}


sub sortingHandler {

	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast sortingHandler");

	my $items = [];

	push @$items, {
		name => ($prefs->get('sorting') eq 'L' ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_SORT_LISTENER'),
		type => 'url',
		url  => \&setSortingHandler,
		passthrough => [  { filter => 'L' } ],
	};
	push @$items, {
		name => ($prefs->get('sorting') eq 'B' ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_SORT_BITRATE'),
		type => 'url',
		url  => \&setSortingHandler,
		passthrough => [  { filter => 'B' } ],
	};
	push @$items, {
		name => ($prefs->get('sorting') eq 'A' ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_SORT_ALPHA'),
		type => 'url',
		url  => \&setSortingHandler,
		passthrough => [  { filter => 'A' } ],
	};
	$cb->( $items );

}

sub bitrateFilterHandler {

	my ($client, $cb, $args, $params) = @_;

	$log->debug("Shoutcast BitrateFilterHandler");

	my $items = [];

	push @$items, {
		name => ($prefs->get('bitrate_filter')==0 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_0'),
		type => 'url',
		url  => \&setBitrateHandler,
		passthrough => [  { filter => '0' } ],
	};
	push @$items, {
		name => ($prefs->get('bitrate_filter')==32 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_32'),
		type => 'url',
		url  => \&setBitrateHandler,
		passthrough => [  { filter => '32' } ],
	};
	push @$items, {
		name => ($prefs->get('bitrate_filter')==64 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_64'),
		type => 'url',

		url  => \&setBitrateHandler,
		passthrough => [  { filter => '64' } ],
	};
	push @$items, {
		name => ($prefs->get('bitrate_filter')==96 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_96'),
		type => 'url',

		url  => \&setBitrateHandler,
		passthrough => [  { filter => '96' } ],
	};
	push @$items, {
		name => ($prefs->get('bitrate_filter')==128 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_128'),
		type => 'url',

		url  => \&setBitrateHandler,
		passthrough => [  { filter => '128' } ],
	};
	push @$items, {
		name => ($prefs->get('bitrate_filter')==256 ? '-> ' : '') . cstring($client, 'PLUGIN_NEWSHOUTCAST_BITRATEFILTER_256'),
		type => 'url',

		url  => \&setBitrateHandler,
		passthrough => [  { filter => '256' } ],
	};
	$cb->( $items );

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

	$log->debug("Shoutcast getStations");

	my @stations = @{ $stations };
	my @sorted ;

	switch($prefs->get('sorting')){
		case 'L'	{ 
				@sorted =  sort { $b->{Listeners} <=> $a->{Listeners} } @stations ; 
				}
		case 'B'	{
				@sorted =  sort { $b->{Bitrate} <=> $a->{Bitrate} } @stations ; 
				}
		case 'A'	{ 
				@sorted =  sort { $b->{Name} <=> $a->{Name} } @stations ; 
				}
	}	


	my $station = [];

	
	my $items = [];
	for $station ( @sorted ) {

		if ($station->{Bitrate} >= $prefs->get('bitrate_filter')) {

			push @$items, {
				name 		=> $station->{Name}." (".string('PLUGIN_NEWSHOUTCAST_LISTENER').": ".$station->{Listeners}." / ".string('PLUGIN_NEWSHOUTCAST_BITRATE').": ".$station->{Bitrate}.")",
				type 		=> 'audio',
				url  		=> 'http://yp.shoutcast.com/sbin/tunein-station.m3u?id='.$station->{ID},
				bitrate 	=> $station->{Bitrate},
				listeners 	=> $station->{Listeners},
				genre	 	=> $station->{Genre},
				current_track	=> $station->{CurrentTrack},
			};
		}
	}
	$cb->( $items );
}


1;
