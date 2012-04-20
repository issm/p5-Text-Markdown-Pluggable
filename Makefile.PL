use inc::Module::Install;
name 'Text-Markdown-Pluggable';
all_from 'lib/Text/Markdown/Pluggable.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
