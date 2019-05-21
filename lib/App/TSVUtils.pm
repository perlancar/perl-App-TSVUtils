package App::TSVUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

my %args_common = (
);

my %arg_filename_0 = (
    filename => {
        summary => 'Input TSV file',
        schema => 'filename*',
        req => 1,
        pos => 0,
        cmdline_aliases => {f=>{}},
    },
);

my %arg_filename_1 = (
    filename => {
        summary => 'Input TSV file',
        schema => 'filename*',
        req => 1,
        pos => 1,
        cmdline_aliases => {f=>{}},
    },
);

$SPEC{tsvutil} = {
    v => 1.1,
    summary => 'Perform action on a TSV file',
    'x.no_index' => 1,
    args => {
        %args_common,
        action => {
            schema => ['str*', in=>[
                'dump',
            ]],
            req => 1,
            pos => 0,
            cmdline_aliases => {a=>{}},
        },
        %arg_filename_1,
    },
    args_rels => {
    },
};
sub tsvutil {
    my %args = @_;
    my $action = $args{action};

    my $res = "";
    my $i = 0;

    open my($fh), "<:encoding(utf8)", $args{filename} or
        return [500, "Can't open input filename '$args{filename}': $!"];

    my $code_getline = sub {
        my $row0 = <$fh>;
        return undef unless defined $row0;
        chomp($row0);
        [split /\t/, $row0];
    };

    my $rows = [];

    while (my $row = $code_getline->()) {
        $i++;
        if ($action eq 'dump') {
            push @$rows, $row;
        } else {
            return [400, "Unknown action '$action'"];
        }
    } # while getline()

    if ($action eq 'dump') {
        return [200, "OK", $rows];
    }

    [200, "OK", $res, {"cmdline.skip_format"=>1}];
} # tsvutil

$SPEC{tsv_dump} = {
    v => 1.1,
    summary => 'Dump TSV as data structure (array of arrays)',
    args => {
        %args_common,
        %arg_filename_0,
    },
};
sub tsv_dump {
    my %args = @_;
    tsvutil(%args, action=>'dump');
}

1;
# ABSTRACT: CLI utilities related to TSV

=for Pod::Coverage ^(tsvutil)$

=head1 DESCRIPTION

This distribution contains the following CLI utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<App::SerializeUtils>

L<App::LTSVUtils> (which includes utilities like L<ltsv2tsv>, L<tsv2ltsv>, among
others).

L<App::CSVUtils> (which includes L<csv2tsv>, L<tsv2csv> among others).

=cut
