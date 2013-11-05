use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'App::Monitor::Simple',
    AUTHOR        => 'toritori0318 <toritori0318@gmail.com>',
    VERSION_FROM  => 'lib/App/Monitor/Simple.pm',
    PREREQ_PM     => {
        'Getopt::Long'      => '0',
        'Pod::Usage'        => '0',
        'IO::CaptureOutput' => '0',
        'Test::MockTime'    => '0.12',
    },
    MIN_PERL_VERSION => '5.008001',
    LICENSE => 'perl',
    EXE_FILES => [ 'bin/monitor-simple' ],
);

