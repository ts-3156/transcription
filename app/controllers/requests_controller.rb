class RequestsController < ApplicationController

  def index
    @requests = Request.includes(audio: :blob_blob, transcript: :blob_blob).order(created_at: :desc).limit(5)
    @requests = Request.where(id: [1, 2, 3]) if @requests.empty?
    @request = Request.new
  end

  def show
    @request = Request.find(params[:id])
  end

  def create
    @request = Request.new(name: params['request']['name'])
    @request.name = t('.created', at: l(Time.zone.now.in_time_zone('Tokyo'), format: :short)) if @request.name.blank?

    # TODO uploaded_file.valid? && @request.valid?
    uploaded_file = UploadedFile.new(params['request']['audio'])
    @request.build_audio(filename: uploaded_file.original_filename, codec: uploaded_file.codec, duration: uploaded_file.duration)

    if @request.save
      @request.create_transcript(status: 'started')
      uploaded_file_hash = "#{@request.id}_#{Digest::MD5.hexdigest(uploaded_file.tempfile.read)}"
      uploaded_file_path = Rails.root.join(ENV['TMP_AUDIO_DIR'], "#{uploaded_file_hash}_#{File.basename(uploaded_file.path)}")
      FileUtils.mv(uploaded_file.path, uploaded_file_path)

      TranscribeAudioWorker.perform_async(@request.id, uploaded_file_path)
      flash[:notice] = 'Request was successfully created.'
      redirect_to action: :index
    else
      # TODO display error message
    end
  end
end
