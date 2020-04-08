class TranscribeAudioWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 3, backtrace: false

  def perform(transcript_id, options = {})
    transcript = Transcript.find(transcript_id)
  end
end
