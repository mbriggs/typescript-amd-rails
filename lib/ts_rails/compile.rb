require 'tmpdir'
require 'tempfile'
require 'open3'

module TypeScript::Compile
  extend self

  def compile(raw_source, path)
    source = absolute_requires(raw_source, path)
    file = Tempfile.new(%w(typescript-node .ts))

    file.write(source)
    file.close

    beginning_time = Time.now
    result = compile_file(file.path)
    end_time = Time.now
    Rails.logger.warn "!!!!!!!!!!-> Compile time #{(end_time - beginning_time)*1000} milliseconds"


    unless result.success?
      Rails.logger.warn(result.stderr)
    end

    result.js
  ensure
    file.unlink
  end

  def absolute_requires(source, path)
    source.gsub(%r!^ *import +.+ += +require\(['"](.+)['"]\)!) do |import|
      import.sub($1, File.join(path, $1))
    end
  end

  def compile_file(source_file)
    Dir.mktmpdir do |output_dir|
      output_file = File.join(output_dir, 'out.js')

      execute_tsc(output_file, '-c', '--module', 'AMD', '--out', output_file, source_file)
    end
  end

  def execute_tsc(file, *args)
    cmd = args.unshift(tsc)
    Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
      exit_status = wait_thr.value
      output_js = File.exists?(file) ? File.read(file) : nil
      Result.new(output_js,
                 exit_status,
                 stdout.read,
                 stderr.read)
    end
  end

  Result = Struct.new(:js, :exit_status, :stdout, :stderr) do
    def success?
      exit_status == 0
    end
  end

  def tsc
    ENV["TSC_PATH"] || locate_executable("tsc")
  end

  def locate_executable(cmd)
    if RbConfig::CONFIG["host_os"] =~ /mswin|mingw/ && File.extname(cmd) == ""
      cmd << ".exe"
    end

    if File.executable? cmd
      cmd
    else
      path = ENV['PATH'].split(File::PATH_SEPARATOR).find { |p|
        full_path = File.join(p, cmd)
        File.executable?(full_path) && File.file?(full_path)
      }
      path && File.expand_path(cmd, path)
    end
  end
end

unless TypeScript::Compile.tsc
  raise 'could not find the typescript compiler (tsc) in your path'
end
