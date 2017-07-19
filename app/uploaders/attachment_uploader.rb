class AttachmentUploader < PrivateFileUploader
  def extension_white_list
    %w(jpg jpeg png pdf doc docx xls xlsx psd txt zip rar)
  end

  def file_name
    File.basename(model.file.url) if file
  end
end