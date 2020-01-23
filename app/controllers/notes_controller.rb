class NotesController < AuthController
  before_action :set_note, only: [:edit, :update, :show, :destroy]

  def index
    @notes = Note
      .notes_for_user(current_user)
      .order(date_taken: :desc)
      .page(params[:page])
  end

  def new
    @note = Note.new
  end

  def edit; end

  def create
    @note = Note.new(note_params)

    if @note.save
      flash[:notice] = 'Note was successfully created'
      redirect_to note_path(@note)
    else
      render 'new'
    end
  end

  def update
    if @note.update(note_params)
      flash[:notice] = 'Note was successfully updated'
      redirect_to notes_path
    else
      render 'edit'
    end
  end

  def show; end

  def destroy
    @note.destroy
    flash[:notice] = 'Note was successfully deleted'
    redirect_to notes_path
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params['note']['date_taken'] = Time.strptime(params['note']['date_taken'], '%m/%d/%Y %I:%M %p').to_s

    params.require(:note).permit(:title, :content, :date_taken, :priority).merge(user: current_user)
  end
end
