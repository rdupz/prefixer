# PREFIXER

The following README is a manual export. 


* * *

<a name="NAME"></a>

## NAME

**prefixer** −− Renames a file by changing the beginning of its name.

<a name="SYNOPSIS"></a>

## SYNOPSIS

**prefixer** [**−vdh**] [**−b** | [**−so** | **−n**]] [**−c** _config_] [**−r** _regex_] _prefix file ..._

<a name="DESCRIPTION"></a>

## DESCRIPTION

**prefixer** provides a convenient way to deal with prefixes in filenames. By defining a set of prefixes, **prefixer** is able to identify the current prefix(es) in the filename and to change it to _prefix_. The optional arguments allow to filter the input _files_ and/or to choose how the prefix(es) are processed.

The first mandatory argument _prefix_ is the one to applied on the filenames. The other mandatory argument _file_ is the file to be renamed. Several files can be specified. Directories and links are processed like any other files.

<a name="CONFIGURATION"></a>

## CONFIGURATION

In order to define the set of prefixes to be used, you **can** fill at least one configuration file. The default configuration files are located (or may be created) at _/etc/prefixer/prefixer.conf_ (system-wide) and _$HOME/.prefixer.conf_ (per-user). The per-user configuration file overrides the system-wide configuration file. A random file can be used as the configuration file with the **--config** option: the specified file then overrides all the other configuration files.

In a configuration file, **the content of one line is interpreted as one prefix**. To define a set of prefixes on a single line, you can use a Perl regex: the syntax is /regex/. For example a line matching a word ending with - would contains : "/\w+-/". Lines containing only whitespaces are ignored. Prefixes containing forward slashes will raise an error. There are no other limitations.

To define a one-shot set of prefixes the **--regex** option should be used. It overrides all other configurations.

<a name="OPTIONS"></a>

## OPTIONS

The following options are available:  
**−b**, **−−blind**

Blind mode set the prefix regardless the filename. Keep all existing prefixes and add _prefix_ before them.

**−n**, **−−no−update**

Do not set _prefix_ if other prefixes already exist.

**−o**, **−−update−only**

Rename file only if at least one prefix already exists.

**−s**, **−−squash**

Replace all prefixes with the single new one.

**−c**, **−−config**=_config_

Explicitly defines the configuration file.

**−r**, **−−regex**=_regex_

Override allowed prefixes with regex.

**−d**, **−−dry−run**

Perform a dry-run. Enable verbose mode.

**−v**, **−−verbose**

Verbose mode.

**−h**, **−−help**

Show this help.

<a name="EXIT_STATUS"></a>

## EXIT STATUS

The **prefixer** utility exits 0 on success, and >0 if an error occurs.

<a name="EXAMPLES"></a>

## EXAMPLES

Here is the best part.  
In these examples the configuration defines 3 prefixes: **A-**, **B-**, **C-**.  
$ prefixer A- foo-bar

Renames foo in A-foo-bar.

$ prefixer A- B-C-foo-bar

Renames B-C-foo in A-C-foo-bar.

$ prefixer --dry-run --squash --update-only A- B-C-foo-bar foobar

Shows that prefixer would rename B-C-foo in A-foo-bar and ignore foobar.

$ prefixer --blind A- B-C-foo-bar

Renames B-C-foo in A-B-C-foo-bar.

$ prefixer --regex ’X-Y-Z-’ --no-update Z- X-foo-bar

Does not update X-foo-bar because "X-" is a prefix matching the regex. A-, B- and C- are no longer prefixes.

<a name="SEE_ALSO"></a>

## SEE_ALSO

rename(1), mv(1)

<a name="BUGS"></a>

## BUGS

No known bugs.

Note however that **prefixer is still in development, and may not work as expected.** If you have any problems with it, please feel free to email me and let me know.

<a name="AUTHOR"></a>

## AUTHOR

Romain Duperré (romainduperre@gmail.com)

* * *