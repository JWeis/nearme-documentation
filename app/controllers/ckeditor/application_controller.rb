class Ckeditor::ApplicationController < ApplicationController
  respond_to :html, :json
  layout 'ckeditor/application'

  before_filter :find_asset, only: [:destroy]
  before_filter :ckeditor_authorize!
  before_filter :authorize_resource
  before_filter :check_authorized

  protected

  def ckeditor_scope
    if current_user.try(:is_instance_admin?) || current_user.try(:admin?)
      ['(assetable_id = ? AND assetable_type = ?) OR (assetable_id = ? AND assetable_type = ?)', current_user.id, 'User', PlatformContext.current.instance.id, 'Instance']
    else
      ['assetable_id = ? AND assetable_type = ?', current_user.try(:id), 'User']
    end
  end

  def check_authorized
    render text: 'No access' if current_user.blank?
  end

  def respond_with_asset(asset)
    file = params[:CKEditor].blank? ? params[:qqfile] : params[:upload]
    asset.data = Ckeditor::Http.normalize_param(file, request)

    callback = ckeditor_before_create_asset(asset)

    if callback && asset.save
      body = params[:CKEditor].blank? ? asset.to_json(only: [:id, :type]) : %"<script type='text/javascript'>
      window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{config.relative_url_root}#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
      </script>"

      render text: body
    else
      if params[:CKEditor]
        render text: %"<script type='text/javascript'>
        window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, null, '#{asset.errors.full_messages.first}');
        </script>"
      else
        render nothing: true
      end
    end
  end
end