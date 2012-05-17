require 'redmine'

Redmine::Plugin.register :redmine_notes do
  name 'Redmine Notes plugin'
  author 'Vivien Didelot <vivien@didelot.org>'
  description 'List annotations found in the project repository'
  version '0.0.1'
  url 'http://github.com/v0n/redmine_notes'
  author_url 'http://vivien.didelot.org'
  requires_redmine :version_or_higher => '1.3.1'

  project_module :notes do
    permission :notes, { :notes => [:index] }, :public => true
  end

  # TODO do not add it if the repo type isn't git (for the moment)
  menu :project_menu, :notes, { :controller => :notes, :action => :index }, :caption => 'Notes', :if => proc { |project| not project.repository.nil? }, :after => :repository
end
