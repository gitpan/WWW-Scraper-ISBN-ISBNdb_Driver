#!perl -T

use Test::More tests => 5;

use WWW::Scraper::ISBN;
use ExtUtils::MakeMaker;

my $scraper = new WWW::Scraper::ISBN();
$scraper->drivers( qw/ ISBNdb / );

my $access_key = $ENV{ISBNDB_ACCESS_KEY};

{
  no warnings;
  $WWW::Scraper::ISBN::ISBNdb_Driver::ACCESS_KEY = $access_key;
}

SKIP: {
  skip "no access key provided in the ISBNDB_ACCESS_KEY environment variable" => 5 unless $access_key;

  my $isbn = '0596101058';
  my $result = eval { $scraper->search( $isbn ) };
  skip "failed search (perhaps you provided an invalid access key?): $@" => 5 if $@;

  if( $result->found ) {
    my $book = $result->book;
    is( $book->{isbn}, $isbn );
    is( $book->{title}, "Learning Perl", 'title' );
    is( $book->{author}, "Randal L. Schwartz, Tom Phoenix, brian d foy, ", 'author' );
    is( $book->{publisher}, "O'Reilly", 'publisher' );
    is( $book->{year}, '', 'year' );
  }
};