class PythonUtil
  class << self
    def transcribe(file_key)
      python = "GOOGLE_APPLICATION_CREDENTIALS=#{ENV['GCS_CRED']} #{ENV['PYTHON']} #{Rails.root.join('bin/speech_transcribe_async_gcs.py')}"
      `#{python} --storage_uri gs://#{ENV['GCS_BUCKET']}/#{file_key}`
    end
  end
end
