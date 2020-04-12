class RequestsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :reject_crawler!, only: :create
  before_action only: :create do
    user = current_user_or_guest
    if user.files_count_limited?
      flash[:notice] = t('.create.files_count_limited')
      redirect_to action: :index
    elsif user.total_duration_limited?
      flash[:notice] = t('.create.duration_limited')
      redirect_to action: :index
    end
  end

  def index
    @user = current_user_or_guest
    records = @user.requests.includes(audio: :blob_blob, transcript: :blob_blob).order(created_at: :desc)
    @requests = records.reject(&:expired?).take(10)

    if @requests.blank?
      @requests = Request.where(id: [1, 2, 3]).order(created_at: :desc)
      @fake_requests = true
    end

    @request = Request.new
  end

  def show
    @request = Request.find(params[:id])
  end

  def create
    @request = Request.new

    # TODO uploaded_file.valid? && @request.valid?
    uploaded_file = UploadedFile.new(params['request']['audio'])
    audio = @request.build_audio(filename: uploaded_file.original_filename, codec: uploaded_file.codec, duration: uploaded_file.duration)

    if @request.save
      user = current_user_or_guest(true)
      user.requests << @request

      @request.create_transcript(status: 'started')
      uploaded_file_hash = "#{@request.id}_#{Digest::MD5.hexdigest(uploaded_file.tempfile.read)}"
      uploaded_file_path = Rails.root.join(ENV['TMP_AUDIO_DIR'], "#{uploaded_file_hash}_#{File.basename(uploaded_file.path)}")
      FileUtils.mv(uploaded_file.path, uploaded_file_path)

      TranscribeAudioWorker.perform_async(@request.id, uploaded_file_path)
      flash[:notice] = t('.successfully_created', name: audio.filename)
      redirect_to action: :index
    else
      # TODO display error message
    end
  end

  private

  def current_user_or_guest(create = false)
    if user_signed_in?
      current_user
    elsif guest_created?
      current_guest
    elsif create
      create_new_guest
    else
      Guest.new
    end
  end
end
