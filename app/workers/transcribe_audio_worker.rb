class TranscribeAudioWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 0, backtrace: false

  def perform(transcript_id, file_path, file_hash, options = {})
    transcript = Transcript.find(transcript_id)
    audio = transcript.audio

    if FfprobeUtil.detect_codec(file_path) != 'flac'
      flac_path = Rails.root.join(ENV['TMP_AUDIO_DIR'], "#{file_path}.flac")
      SoxUtil.convert_to_flac(file_path, flac_path)
      file_path = flac_path
    end

    audio.blob.attach(io: File.open(file_path), filename: "#{audio.filename}", content_type: 'audio/flac')
    PythonUtil.transcribe(audio.blob.key)
  end
end
