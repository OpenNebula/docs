#!/usr/bin/ruby

require 'date'
require 'fileutils'
require 'open3'
require 'yaml'

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
# Run a command
#
# @param cmd [String] Command to run
def run(cmd)
    puts cmd

    rtn = nil

    Open3.popen3(cmd) do |_, o, e, t|
        out_reader = Thread.new { streamer(o) }
        err_reader = Thread.new { streamer(e) }

        rtn = [out_reader.value, err_reader.value, t.value]
    end

    rtn
end

# Print error and exit
#
# @param rc [Array] rc[0] STDOUT rc[1] STDERR
def error(rc)
    return rc[0].strip if rc[2].success?

    puts "ERROR: #{rc[1]}"

    exit(-1)
end

# Print lines until empty
#
# @param str [String]  Line to print
def streamer(str)
    full = ''

    str.each do |l|
        next if l.empty? || l == "\n"

        full << l

        print l

        $stdout.flush
    end

    full
end

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

config = YAML.load_file('publish/config.yaml')

unless config['mapping'].include?(ARGV[0])
    puts "Aborting, branch '#{ARGV[0]}' is not published"
    exit(0)
end

# ------------------------------------------------------------------------------
# Read secrets from ENV
# ------------------------------------------------------------------------------
host      = ENV['HOST']
host_path = ENV['HOST_PATH']

# ------------------------------------------------------------------------------
# Compile documentation
# ------------------------------------------------------------------------------
error(run('make html'))

# ------------------------------------------------------------------------------
# Publish documentation
# ------------------------------------------------------------------------------
date_time           = DateTime.now.strftime('%Y%m%d%H%M%S')
branch_dir          = config['mapping'][ARGV[0]]
branch_symlink_path = "#{host_path}/#{branch_dir}"
branch_build_path   = "#{branch_symlink_path}.#{date_time}"
ssh_op              = '-o StrictHostKeyChecking=no -i /tmp/id_rsa'

error(run("ssh #{ssh_op} #{host} 'test -d #{host_path} && touch #{host_path}'"))
error(run("ssh #{ssh_op} #{host} 'mkdir #{branch_build_path}'"))

error(run("tar -C 'build/html' --mode='a+r' -cf - . | " \
          "ssh #{ssh_op} #{host} 'tar -C '#{branch_build_path}' -xvf -'"))
error(
    run(
        "ssh #{ssh_op} #{host} " \
        "'ln -nsf #{branch_dir}.#{date_time} #{branch_symlink_path}'"
    )
)
