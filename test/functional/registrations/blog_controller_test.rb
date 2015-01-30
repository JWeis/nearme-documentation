require 'test_helper'

class Registrations::BlogControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @blog_post = FactoryGirl.create(:published_user_blog_post, user: @user)
    @another_blog_post = FactoryGirl.create(:published_user_blog_post, user: @user)
    @unpublished_blog_post = FactoryGirl.create(:unpublished_user_blog_post, user: @user)
    @user.blog.instance.update_column(:user_blogs_enabled, true)
    FactoryGirl.create(:published_user_blog_post) #non-related blog post
  end

  context 'user blog is disabled' do
    setup do
      @user.blog.update_column(:enabled, false)
    end

    context '#index' do
      should 'not find only published user blog posts' do
        assert_raise(UserBlog::NotFound) do
          get :index, user_id: @user.id
        end
      end
    end

    context '#show' do
      should 'not find only published user blog posts' do
        assert_raise(UserBlog::NotFound) do
          get :show, user_id: @user.id, id: @blog_post
        end
      end
    end
  end

  context 'user blog is enabled' do
    setup do
      @user.blog.update_column(:enabled, true)
    end

    context '#index' do
      should 'find only published user blog posts' do
        get :index, user_id: @user.id
        assert_equal @user, assigns(:user)
        refute assigns(:blog_posts).include?(@unpublished_blog_post)
        assert_equal [@another_blog_post, @blog_post], assigns(:blog_posts)
        assert_response :success
      end
    end

    context '#show' do
      should 'find published user blog post' do
        get :show, user_id: @user.id, id: @blog_post
        assert_equal @user, assigns(:user)
        assert_equal @blog_post, assigns(:blog_post)
        assert_response :success
      end

      should 'not find unpublished user blog post' do
        assert_raise(ActiveRecord::RecordNotFound) do
          get :show, user_id: @user.id, id: @unpublished_blog_post
        end
      end
    end

  end
end
