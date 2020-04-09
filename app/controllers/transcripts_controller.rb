class TranscriptsController < ApplicationController
  before_action :set_transcript, only: [:show, :edit, :update, :destroy]

  # GET /transcripts
  # GET /transcripts.json
  def index
    @transcripts = Transcript.all
    @transcript = Transcript.new
  end

  # GET /transcripts/1
  # GET /transcripts/1.json
  def show
  end

  # GET /transcripts/new
  def new
    @transcript = Transcript.new
  end

  # GET /transcripts/1/edit
  def edit
  end

  # POST /transcripts
  # POST /transcripts.json
  def create
    @transcript = Transcript.new(transcript_params)
    @transcript.name = I18n.l(Time.zone.now.in_time_zone('Tokyo'), format: :short) if @transcript.name.blank?

    # TODO uploaded_file.valid? && @transcript.valid?
    uploaded_file = UploadedFile.new(params['transcript']['audio'])
    @transcript.build_audio(filename: uploaded_file.original_filename, codec: uploaded_file.codec, duration: uploaded_file.duration)

    if @transcript.save
      uploaded_file_hash = "#{@transcript.id}_#{Digest::MD5.hexdigest(uploaded_file.tempfile.read)}"
      uploaded_file_path = Rails.root.join(ENV['TMP_AUDIO_DIR'], "#{uploaded_file_hash}_#{File.basename(uploaded_file.path)}")
      FileUtils.mv(uploaded_file.path, uploaded_file_path)

      TranscribeAudioWorker.perform_async(@transcript.id, uploaded_file_path, uploaded_file_hash)
      flash[:notice] = 'Transcript was successfully created.'
      redirect_to action: :index
    else
      # TODO display error message
    end
  end

  # PATCH/PUT /transcripts/1
  # PATCH/PUT /transcripts/1.json
  def update
    respond_to do |format|
      if @transcript.update(transcript_params)
        format.html { redirect_to @transcript, notice: 'Transcript was successfully updated.' }
        format.json { render :show, status: :ok, location: @transcript }
      else
        format.html { render :edit }
        format.json { render json: @transcript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transcripts/1
  # DELETE /transcripts/1.json
  def destroy
    @transcript.destroy
    respond_to do |format|
      format.html { redirect_to transcripts_url, notice: 'Transcript was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transcript
      @transcript = Transcript.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transcript_params
      params.require(:transcript).permit(:name)
    end
end
