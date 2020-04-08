class UploadedFile
  include ActiveModel::Model

  attr_accessor :size, :content_type, :duration

  # TODO
  # validates :size, numericality: {less_than: 15000000, message: I18n.t('activemodel.errors.messages.file_size_too_big')}
  # validates :content_type, inclusion: {in: %w(image/jpeg image/png image/gif), message: I18n.t('activemodel.errors.messages.invalid_content_type')}

  def initialize(raw_file)
    @size = raw_file.size
    @content_type = raw_file.content_type
    @duration = detect_duration(raw_file.tempfile.path)
  end

  def detect_duration(file_path)
    `#{ENV['FFPROB']} -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 #{file_path}`.strip
  end
end
