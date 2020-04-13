class UploadedFile
  include ActiveModel::Model

  attr_reader :raw_file

  validate do
    if size > 120_000_000
      errors.add(:base, I18n.t('activerecord.errors.messages.file_size_too_large', value: 120))
    end
  end

  validate do
    unless content_type.match?(/audio/)
      errors.add(:base, I18n.t('activerecord.errors.messages.invalid_content_type'))
    end
  end

  validate do
    if duration > 3600
      errors.add(:base, I18n.t('activerecord.errors.messages.duration_too_long', value: FreeTrial.each_duration / 1.minute))
    end
  end

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
