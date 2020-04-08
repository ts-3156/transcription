class TranscribeAudioWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 3, backtrace: false

  def perform(transcript_id, options = {})
    transcript = Transcript.find(transcript_id)
    python = "GOOGLE_APPLICATION_CREDENTIALS=#{ENV['GCS_CRED']} #{ENV['PYTHON']} #{Rails.root.join('bin/speech_transcribe_async_gcs.py')}"
    result = `#{python} --storage_uri gs://#{ENV['GCS_BUCKET']}/#{transcript.audio.key}`
    File.write('out.txt', result)
  end
end
