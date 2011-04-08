require 'rake/clean'

verbose true

task :default => :examples

namespace :swc do
  src_files = FileList['net/**/*.as'].each do |src_file|
    file src_file
  end
  
  desc "Build the debug FlashPunk SWC"
  task :debug => 'bin/flashpunk_debug.swc'
  file 'bin/flashpunk_debug.swc' => src_files do
    compc 'net', 'bin/flashpunk_debug.swc', compc_opts()
  end
  
  desc "Build the release FlashPunk SWC"
  task :release => 'bin/flashpunk.swc'
  file 'bin/flashpunk.swc' => src_files do
    compc 'net', 'bin/flashpunk.swc', compc_opts(:debug => false)
  end
  
  CLEAN << FileList['bin/*.swc', 'bin/*.cache']
end

desc "Build *all* the examples?!"
task :examples => :sounds
CLEAN << FileList['examples/**/bin/*.{swf,swf.cache}']
FileList['examples/**/src/Main.as'].each do |input_file|
  output_file = input_file.pathmap('%{src,bin}d/%{.*,*}n.swf') { |n| n.downcase }
  input_deps = FileList[input_file.pathmap '%X/**/*.as'].to_a
  input_deps << 'swc:debug'
  file output_file => input_deps do
    mxmlc input_file, output_file, mxmlc_opts({
      :library_paths => ['bin/flashpunk_debug.swc'],
      :source_paths => [input_file.pathmap '%d']
    })
  end
  task :examples => output_file
end

desc "Convert WAV files to MP3s using ffmpeg"
task :sounds
FileList['**/*.wav'].each do |wav_file|
  mp3_file = wav_file.pathmap('%X.mp3')
  file wav_file
  file mp3_file => wav_file do |t|
    ffmpeg wav_file, t.name
  end
  task :sounds => mp3_file
end

def compc(input_folders, output_file, opts={})
  mkdir_p File.dirname(output_file)
  args = compiler_args(opts[:command] || 'compc', opts)
  input_folders = [input_folders] if input_folders.kind_of? String
  input_folders.each do |input_folder|
    args << "-include-sources+=#{input_folder}"
  end
  args << "-output=#{output_file}"
  sh args.join ' '
end

def compc_opts(opts={})
  {
    :debug => true,
    :incremental => true,
    :source_paths => ['.'],
    :static => false
  }.merge(opts)
end

def mxmlc(input_file, output_file, opts={})
  mkdir_p File.dirname(output_file)
  args = compiler_args(opts[:command] || 'mxmlc', opts)
  args << "-output=#{output_file}"
  args << input_file
  sh args.join ' '
end

def mxmlc_opts(opts={})
  {
    :bgcolor => '#ffffff',
    :size => '800 600 ',
    :debug => true,
    :incremental => true,
    :library_paths => [],
    :source_paths => ['.'],
    :static => true
  }.merge(opts)
end

def compiler_args(command, opts)
  args = [
    command,
    "-as3",
    "-strict",
    "-verbose-stacktraces=true",
    "-warnings=true",
  ]
  if opts[:debug]
    args << "-debug" if opts[:debug]
    args << "-define+=ENV::debug,true"
    args << "-define+=ENV::release,false"
  else
    args << "-define+=ENV::debug,false"
    args << "-define+=ENV::release,true"
  end
  opts[:defines].each_pair do |key, value|
    args << "-define+=#{key},#{value}"
  end if opts[:defines]
  args << "-default-size #{opts[:size]}" if opts[:size]
  args << "-default-background-color=#{opts[:bgcolor]}" if opts[:bgcolor]
  args << "-incremental" if opts[:incremental]
  args << "-static-link-runtime-shared-libraries=true" if opts[:static]
  args << "-use-network=true" if opts[:network]
  opts[:library_paths].each do |path|
    args << "-library-path+=#{path}"
  end if opts[:library_paths]
  opts[:source_paths].each do |path|
    args << "-source-path+=#{path}"
  end if opts[:source_paths]
  args += opts[:args] if opts[:args]
  args
end

def ffmpeg(input, output)
  begin
    sh "ffmpeg -y -i #{input.inspect} #{output.inspect}" 
  rescue
    puts "WARNING: Couldn't encode #{output}, ffmpeg is required"
  end
end

