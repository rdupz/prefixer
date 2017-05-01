require "option_parser"
require "./prefixer/*"

arg_prefix = ""
arg_paths = [] of String
opt_blind = false
opt_no_update = false
opt_update_only = false
opt_dry_run = false
opt_verbose = false
opt_squash = false
opt_config = ""
opt_config_set = false
opt_regex = ""
opt_regex_set = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: prefixer -p prefix_arg [-bnosdv] files..."
  parser.on("-b", "--blind", "Blind mode set the prefix regardless the filename.") { opt_blind = true }

  parser.on("-n", "--no-update", "Do not replace existing prefix.") { opt_no_update = true }

  parser.on("-o", "--update-only", "Only replace existing prefix.") { opt_update_only = true }

  parser.on("-s", "--squash", "Replace all prefixes with the single new one.") { opt_squash = true }

  parser.on("-d", "--dry-run", "Perform a dry-run. Enable verbose mode.") { opt_dry_run = true
  opt_verbose = true }

  parser.on("-c config", "--config config", "Explicitely define the configuration file.") { |config|
    opt_config = config
    opt_config_set = true
  }

  parser.on("-r regex", "--regex regex", "Override allowed prefixes with regex.") { |regex|
    opt_regex = regex
    opt_regex_set = true
  }

  parser.on("-v", "--verbose", "Verbose mode.") { opt_verbose = true }

  parser.unknown_args { |args|
    if args.size < 2
      STDERR.puts parser
      exit 1
    end
    arg_prefix = args.shift
    arg_paths = args
  }

  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }
end

if (opt_update_only && opt_no_update)
  STDERR.puts "update-only and no-update are conflicting. Aborting."
  exit 1
end
if (opt_blind && opt_no_update)
  STDERR.puts "blind and no-update are conflicting. Aborting."
  exit 1
end
if (opt_blind && opt_update_only)
  STDERR.puts "blind and update-only are conflicting. Aborting."
  exit 1
end
if (opt_blind && opt_squash)
  STDERR.puts "blind and squash are conflicting. Aborting."
  exit 1
end
if (opt_no_update && opt_squash)
  STDERR.puts "no-update and squash are conflicting. Aborting."
  exit 1
end
if (opt_regex_set && opt_config_set)
  STDERR.puts "config and regex are conflicting. Aborting."
  exit 1
end

Prefixer.verbose = opt_verbose
if opt_regex_set
  Prefixer.add_prefix(opt_regex)
else
  Prefixer.configure(opt_config, opt_config_set)
end
Prefixer.prefix = arg_prefix
Prefixer.blind = opt_blind
Prefixer.squash = opt_squash
Prefixer.no_update = opt_no_update
Prefixer.update_only = opt_update_only
Prefixer.dry_run = opt_dry_run

arg_paths.each { |p| Prefixer.rename(p) }
