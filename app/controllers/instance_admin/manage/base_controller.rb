class InstanceAdmin::Manage::BaseController < InstanceAdmin::ResourceController
  CONTROLLERS = {
    'approval_requests' => { controller: '/instance_admin/manage/approval_requests', default_action: 'index' },
    'inventories' => { controller: '/instance_admin/manage/inventories', default_action: 'index' },
    'transfers'   => { controller: '/instance_admin/manage/transfers', default_action: 'index' },
    'partners'    => { controller: '/instance_admin/manage/partners', default_action: 'index' },
    'users'       => { controller: '/instance_admin/manage/users', default_action: 'index' },
    'emails' => { controller: '/instance_admin/manage/email_templates', default_action: 'index' },
    'waiver_agreements' => { controller: '/instance_admin/manage/waiver_agreement_templates', default_action: 'index' },
    'transactable_types' => { controller: '/instance_admin/manage/transactable_types', default_action: 'index' },
    'support' => { controller: '/instance_admin/manage/support', default_action: 'index' },
    'faq' => { controller: '/instance_admin/manage/support/faqs', default_action: 'index' }
  }

  def index
    redirect_to instance_admin_manage_inventories_path
  end
end
