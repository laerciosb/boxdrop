# frozen_string_literal: true

class FolderReflex < ApplicationReflex
  def select
    folder = Folder.find(element.dataset[:id])

    if session[:selected_elements].include?(folder)
      session[:selected_elements] -= [folder]
    else
      session[:selected_elements] << folder
    end
  end

  def edit
    folder = Folder.find(element.dataset[:id])
    editing_folder = session[:editing_folder]

    editing_folder = if editing_folder == folder
                       nil
                     else
                       folder
                     end

    session[:editing_folder] = editing_folder
  end

  def finish
    folder = Folder.find(element.dataset[:id])
    editing_folder = session[:editing_folder]

    session[:editing_folder] = nil if editing_folder == folder
  end

  def move(attrs)
    parent = Folder.where(id: attrs['parent']).first
    folder = Folder.find(attrs['folder'])

    return unless parent != folder

    folder.parent = parent
    folder.save
  end

  def change_name
    folder = Folder.find(element.dataset[:id])
    folder.update(name: element[:value])
  end

  def delete
    Folder.find(element.dataset[:id]).destroy
  end

  def sample
    Folder.create(name: FFaker::Internet.domain_word.camelcase, parent_id: element.dataset['folder-id'])
  end
end
