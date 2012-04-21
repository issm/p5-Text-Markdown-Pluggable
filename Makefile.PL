use inc::Module::Install;
name 'Text-Markdown-Pluggable';
all_from 'lib/Text/Markdown/Pluggable.pm';

requires 'parent'         => '0.224';
requires 'Text::Markdown' => '1.000031';
requires 'Class::Load'    => '0.13';

tests 't/*.t t/*/*.t t/*/*/*.t';

test_requires 'Test::More';
test_requires 'Test::Differences' => '0.61';
test_requires 'Try::Tiny'         => '0.11';

auto_set_repository;
#auto_include;
WriteAll;
