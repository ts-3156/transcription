class FfprobeUtil
  class << self
    def detect_duration(file_path)
      `#{ENV['FFPROBE']} -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 #{file_path}`.strip.to_i
    end

    def detect_codec(file_path)
      `#{ENV['FFPROBE']} -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 #{file_path}`.strip
    end
  end
end
