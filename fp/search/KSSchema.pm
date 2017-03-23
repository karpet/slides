package KSSchema::UnIndexedField;
use base 'KinoSearch::FieldSpec::text';
sub indexed {0}

package KSSchema;
use base 'KinoSearch::Schema';
use KinoSearch::Analysis::PolyAnalyzer;
our %fields = (
    content => 'text',
    uri     => 'KSSchema::UnIndexedField',
);

sub analyzer {
    return KinoSearch::Analysis::PolyAnalyzer->new( language => 'en' );
}
1;
