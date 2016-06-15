#!/usr/bin/perl
use strict;
use warnings;

#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20/x86_64-linux-thread-multi";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20/x86_64-linux-thread-multi/auto";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20.2/x86_64-linux-gnu-thread-multi";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20.2/x86_64-linux-gnu-thread-multi/auto";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20/x86_64-linux-gnu-thread-multi";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20/x86_64-linux-gnu-thread-multi/auto";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/x86_64-linux-gnu-thread-multi";
#use lib "/usr/share/squeezeboxserver/CPAN/arch/5.20";
#use lib "/usr/share/squeezeboxserver/lib";
#use lib "/usr/share/squeezeboxserver/CPAN";
#use lib "/usr/share/squeezeboxserver";
#use lib "/usr/share/squeezeboxserver/CPAN";
#use lib "/usr/share/squeezeboxserver";



use feature qw/ say /;
use Data::Dumper;
use JSON::XS;

my $data =  qq# 
[  
   {  
      "ID":399097,
      "Name":"AirlessRadio - Piano",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Kathryn Kaye - There Was A Time",
      "Listeners":124,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":106746,
      "Name":"Chroma Piano",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Erik Satie - Je Te Veux",
      "Listeners":72,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":175152,
      "Name":"Abacus.fm Mozart Piano",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Abacus.fm - Abacus.fm Mozart Piano",
      "Listeners":35,
      "IsRadionomy":true,
      "IceUrl":"abacusfm-mozart-piano",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":219678,
      "Name":"Radio Caprice - Piano",
      "Format":"audio/aacp",
      "Bitrate":48,
      "Genre":"Piano",
      "CurrentTrack":"Debbie Fortnum - Visions",
      "Listeners":34,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":99188190,
      "Name":"Pianostation",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Gatchaman Crowds OST - Unbeatable Network",
      "Listeners":21,
      "IsRadionomy":true,
      "IceUrl":"Pianostation",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":482457,
      "Name":"PIANO \u0026amp; RELAXATION (radio.musicdays.pl)",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"sad cello Track11",
      "Listeners":21,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":708629,
      "Name":"Radio Caprice Classical Piano",
      "Format":"audio/aacp",
      "Bitrate":48,
      "Genre":"Piano",
      "CurrentTrack":"Beethoven (Jeno Jando) - Piano Sonata No.18 in Es-dur/ Op.31 No.3 - I. Allegro",
      "Listeners":12,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":1117082,
      "Name":"MOZART     WALLYradio",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"MOZART - ALBUM48",
      "Listeners":2,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":699652,
      "Name":"TWICKZ Piano Lounge",
      "Format":"audio/mpeg",
      "Bitrate":32,
      "Genre":"Piano",
      "CurrentTrack":"Daniel Barenboim - Piano Sonata No. 8 in C minor, Op. 13 `Pathtique`: I. Grave - Allegro di molto e con brio",
      "Listeners":2,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":1674681,
      "Name":"RadioFabio  ..::Online Piano Practicing::..",
      "Format":"audio/mpeg",
      "Bitrate":64,
      "Genre":"Piano",
      "CurrentTrack":"Practicing_Ravel_Sonatine_on_7_May_2014_1st_Part",
      "Listeners":1,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":537921,
      "Name":"TWICKZ Piano lounge",
      "Format":"audio/mpeg",
      "Bitrate":320,
      "Genre":"Piano",
      "CurrentTrack":"Vladimir Ashkenazy - III. Scherzo. Allegro vivace",
      "Listeners":1,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":1110834,
      "Name":"WALLYradio",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Michael Dulin - April Showers",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":878552,
      "Name":"BEETHOVEN                WALLYradio",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Ludwig van Beethoven - Verschiedene Volkslieder, WoO1",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":510448,
      "Name":"Lotus Therm - Piano - Guitar Classics",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Mr_Probz_ - _Waves_Modern_Machines_Remix_[www.MP3Fiber.com]",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":508159,
      "Name":"TWICKZ Piano Lounge",
      "Format":"audio/mpeg",
      "Bitrate":64,
      "Genre":"Piano",
      "CurrentTrack":"Vladimir Ashkenazy - III. Scherzo. Allegro vivace",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":507820,
      "Name":"AirlessRadio - Piano",
      "Format":"audio/aacp",
      "Bitrate":64,
      "Genre":"Piano",
      "CurrentTrack":"Kathryn Kaye - There Was A Time",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":442241,
      "Name":"RadioMED",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"AUSTREVERT - XEQUIJEL",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":414859,
      "Name":"TWICKZ Piano Lounge",
      "Format":"audio/mpeg",
      "Bitrate":128,
      "Genre":"Piano",
      "CurrentTrack":"Vladimir Ashkenazy - III. Scherzo. Allegro vivace",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   },
   {  
      "ID":158431,
      "Name":"RadioFabio  ..::Online Piano Practicing::..",
      "Format":"audio/mpeg",
      "Bitrate":64,
      "Genre":"Piano",
      "CurrentTrack":"Practicing_Scriabin_Sonata_N._10_on_2_Jan_2011",
      "Listeners":0,
      "IsRadionomy":false,
      "IceUrl":"",
      "AACEnabled":0,
      "IsPlaying":false,
      "IsAACEnabled":false
   }
]
#;

my @obj = @{ decode_json( $data ) };

print Dumper(@obj);
#print Dumper($obj->[1]{Name});

foreach my $station (@obj) {
print "$station->{Name}\n";
} 

#say ${ $obj->{'items'}->[1] }{'name'};
#   ^  ^             ^   ^   ^      ^
#   |  |             |   |   |      |
#   |  is an  arrayref   |    -----------
#   |                    |               |
#   |  first element of which is a hash  |
#   |                                    |
#   the variable is value of the 'name' key    

















# curl 'https://www.shoutcast.com/Home/BrowseByGenre' -H 'Cookie: ASP.NET_SessionId=epbuwwcwtlvudaw2zfdp22nz; _ga=GA1.2.843754441.1465483667' -H 'Origin: https://www.shoutcast.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.63 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: https://www.shoutcast.com/Search/AdvancedSearch' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 'genrename=Piano' --compressed

__END__



