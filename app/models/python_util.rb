class PythonUtil
  class << self
    def transcribe(file_key)
      python = "GOOGLE_APPLICATION_CREDENTIALS=#{ENV['GCS_CRED']} #{ENV['PYTHON']} #{Rails.root.join('bin/speech_transcribe_async_gcs.py')}"
      result = `#{python} --storage_uri gs://#{ENV['GCS_BUCKET']}/#{file_key}`
      File.write('out.txt', result)
    end
  end
end
