require "./*"

module Prefixer
  # config
  @@config_file : String
  @@config_file = ""

  def self.config_file
    @@config_file
  end

  def self.config_file=(value : String)
    if File.exists?(value) && !File.empty?(value)
      @@config_file = File.expand_path(value)
    else
      STDERR.puts "Given config file #{value} does not exist or is empty."
      Process.exit(1)
    end
  end

  def self.configure(opt_config, opt_config_set)
    if opt_config_set
      Prefixer.config_file = opt_config
    else
      Prefixer.config_file = default_config_file
    end
    Prefixer.prefixes = configured_prefixes
  end

  def self.default_config_file
    ENV["PREFIXER_USER_CONF"] ||= File.join(ENV["HOME"], ".prefixer.conf")
    ENV["PREFIXER_SYSTEM_CONF"] ||= "/etc/prefixer/prefixer.conf"
    return ENV["PREFIXER_USER_CONF"] if check_conf_file("PREFIXER_USER_CONF")
    return ENV["PREFIXER_SYSTEM_CONF"] if check_conf_file("PREFIXER_SYSTEM_CONF")

    STDERR.puts "Configuration file not found."
    STDERR.puts "Please configure some prefixes (one per line) in #{ENV["PREFIXER_USER_CONF"]} or #{ENV["PREFIXER_SYSTEM_CONF"]}"
    Process.exit(1)
  end

  def self.check_conf_file(env_var : String)
    valid? = File.exists?(ENV[env_var]) && !File.empty?(ENV[env_var])
    puts "#{ENV[env_var]} does not exist or is empty." if self.verbose && !valid?
    return valid?
  end

  def self.configured_prefixes
    prefixes = [] of Regex
    File.new(Prefixer.config_file).each_line do |line|
      next if line.strip == ""
      regex_match = line.strip.match(/\/(.*)\//)
      if regex_match && regex_match[1]?
        regex = regex_match[1]
      else
        regex = Regex.escape(line)
      end
      prefixes = self.add_prefix(regex, prefixes)
    end
    prefixes
  end

  def self.add_prefix(regex)
    self.prefixes = self.add_prefix(regex, self.prefixes)
  end

  def self.add_prefix(regex, prefixes)
    if Regex.error?(regex)
      STDERR.puts "Invalid regex: #{regex}"
      Process.exit(1)
    end
    if regex.includes?('/')
      STDERR.puts "Forward slashes are forbidden : #{regex}"
      Process.exit(1)
    end
    prefixes << /#{regex}/
    puts "Register prefix: #{regex} " if self.verbose
    prefixes
  end
end
