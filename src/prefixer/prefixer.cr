require "file"

module Prefixer
  def self.rename(path : String)
    if !File.exists?(path)
      STDERR.puts "#{path} does not exist. Aborting..."
      Process.exit(1)
    end
    filename = File.basename(path)
    dirname = File.dirname(path)
    new_filename = prefix(filename).to_s
    new_path = File.join(dirname, new_filename)
    puts "#{path}  =>  #{new_path}" if self.verbose
    File.rename(path, new_path) unless self.dry_run
  end

  def self.prefix(filename : String)
    splitted = self.split(filename)
    return filename if self.no_update && splitted.size > 1
    return filename if self.update_only && splitted.size == 1
    new_filename = filename
    new_filename = unprefix(filename) unless self.blind
    "#{prefix}#{new_filename}"
  end

  def self.unprefix(filename : String)
    return self.split(filename)[-1] if self.squash
    splitted = self.split(filename)
    splitted.shift if splitted.size > 1
    unprefixed = splitted.join
  end

  def self.split(filename : String)
    m = Regex.union(prefixes.map { |p| /\A#{p.source}/ }).match(filename)
    return [m[0]] + self.split(filename.lchop(m[0])) if m && m[0]?
    [filename]
  end
end
