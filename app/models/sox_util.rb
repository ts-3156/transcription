class SoxUtil
  class << self
    def convert_to_flac(src_path, dst_path)
      `#{ENV['SOX']} #{src_path} --rate 16k --bits 16 --channels 1 #{dst_path}`
    end
  end
end
