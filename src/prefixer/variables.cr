require "./*"

module Prefixer
  # prefixes
  @@prefixes : Array(Regex)
  @@prefixes = [] of Regex

  def self.prefixes
    @@prefixes
  end

  def self.prefixes=(value)
    @@prefixes = value
  end

  # prefix
  @@prefix : String
  @@prefix = ""

  def self.prefix
    @@prefix
  end

  def self.prefix=(value : String)
    if value == ""
      STDERR.puts "prefix cannot be empty"
      Process.exit(1)
    end

    if !Regex.union(@@prefixes.map { |p| /\A#{p.source}\Z/ }).match(value)
      STDERR.puts "#{value} is not an allowed prefix."
      Process.exit(1)
    end

    @@prefix = value
  end

  # blind
  @@blind : Bool
  @@blind = false

  def self.blind
    @@blind
  end

  def self.blind=(value)
    @@blind = value
  end

  # update_only
  @@update_only : Bool
  @@update_only = false

  def self.update_only
    @@update_only
  end

  def self.update_only=(value)
    @@update_only = value
  end

  # no_update
  @@no_update : Bool
  @@no_update = false

  def self.no_update
    @@no_update
  end

  def self.no_update=(value)
    @@no_update = value
  end

  # dry_run
  @@dry_run : Bool
  @@dry_run = false

  def self.dry_run
    @@dry_run
  end

  def self.dry_run=(value)
    @@dry_run = value
  end

  # squash
  @@squash : Bool
  @@squash = false

  def self.squash
    @@squash
  end

  def self.squash=(value)
    @@squash = value
  end

  # verbose
  @@verbose : Bool
  @@verbose = false

  def self.verbose
    @@verbose
  end

  def self.verbose=(value)
    @@verbose = value
  end
end
