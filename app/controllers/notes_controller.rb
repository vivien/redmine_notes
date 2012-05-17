require 'notes/git'

class NotesController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:id])
    @notes = Notes::Git.scan_bare(@project.repository.url)
  end
end
