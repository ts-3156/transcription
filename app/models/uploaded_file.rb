class UploadedFile
  include ActiveModel::Model

  attr_reader :raw_file

  # TODO
  # validates :size, numericality: {less_than: 15000000, message: I18n.t('activemodel.errors.messages.file_size_too_big')}
  # validates :content_type, inclusion: {in: %w(image/jpeg image/png image/gif), message: I18n.t('activemodel.errors.messages.invalid_content_type')}

  # raw_file ActionDispatch::Http::UploadedFile
  def initialize(raw_file)
    @raw_file = raw_file
  end

  def size
    @raw_file.size
  end

  def content_type
    @raw_file.content_type
  end

  def tempfile
    @raw_file.tempfile
  end

  def path
    tempfile.path
  end

  def original_filename
    @raw_file.original_filename
  end

  def duration
    @duration ||= FfprobeUtil.detect_duration(tempfile.path)
  end

  def codec
    @codec ||= FfprobeUtil.detect_codec(tempfile.path)
  end
end
