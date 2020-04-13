class TranscribeAudioWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 0, backtrace: false

  def perform(request_id, file_path, options = {})
    request = Request.find(request_id)
    audio = request.audio
    transcript = request.transcript
    transcript.update(status: 'in_progress')

    if FfprobeUtil.detect_codec(file_path) != 'flac'
      flac_path = Rails.root.join(ENV['TMP_AUDIO_DIR'], "#{file_path}.flac")
      SoxUtil.convert_to_flac(file_path, flac_path)
      file_path = flac_path
    end

    audio.blob.attach(io: File.open(file_path), filename: "#{audio.filename}", content_type: 'audio/flac')
    output = JSON.parse PythonUtil.transcribe(audio.blob.key)
    text = output['results'].map { |out| out['transcript'] }.join
    length = text.length

    transcript.blob.attach(io: StringIO.new(text), filename: I18n.t('activerecord.attributes.transcript.filename'), content_type: 'text/plain')
    transcript.update(status: 'succeeded', character_count: length, summary: text.truncate(1000))
  rescue => e
    transcript.update(status: 'failed')
    raise
  end
end
