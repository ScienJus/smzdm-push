class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
  end
  
  def create_subscribe
    #得到关键词
    name = params[:name]
    if name == nil
      respond_to do |format|
        format.json {
          render json: { success: false, message: '关键词不能为空' }
        }
      end
    end
    #查询该关键词是否已经存在，不存在则创建
    keyword = Keyword.find_by_name(name);
    if keyword == nil
      keyword = Keyword.new
      keyword.name = name
      keyword.save
    end
    #查询该用户是否已经订阅了这个关键词
    if current_user.keywords.exists? keyword
      respond_to do |format|
        format.json { 
          render json: { success: false, message: '已订阅该关键词' }
        }
      end
    else
      current_user.keywords << keyword 
      respond_to do |format|
        format.json { 
          render json: { success: true, message: '订阅成功' }
        }
      end
    end
  end
  
  def delete_subscribe
    #得到关键词
    keyword = Keyword.find_by_id(params[:id])
    if keyword == nil
      respond_to do |format|
        format.json {
          render json: { success: false, message: '关键词不存在' }
        }
      end
    end
    if current_user.keywords.exists? keyword
      current_user.keywords.delete keyword
      #这里本来是要把没有订阅的关键词删除掉，但是可能会有并发问题，暂时延后
      respond_to do |format|
        format.json { 
          render json: { success: true, message: '解除订阅成功' }
        }
      end
    else
      respond_to do |format|
        format.json { 
          render json: { success: false, message: '并没有订阅该关键词' }
        }
      end
    end
  end
  
  def user_active
    unless current_user.active
      current_user.active = true
      current_user.save
      respond_to do |format|
        format.json { 
          render json: { success: true, message: '开启订阅成功' }
        }
      end
    else
      respond_to do |format|
        format.json { 
          render json: { success: false, message: '并没有关闭订阅' }
        }
      end
    end
  end
  
  def user_unactive
    if current_user.active
      current_user.active = false
      current_user.save
      respond_to do |format|
        format.json { 
          render json: { success: true, message: '关闭订阅成功' }
        }
      end
    else
      respond_to do |format|
        format.json { 
          render json: { success: false, message: '并没有开启订阅' }
        }
      end
    end
  end
  
  def delete_account
    current_user.destroy
    respond_to do |format|
      format.json { 
        render json: { success: true, message: '清除账号成功' }
      }
    end
  end
end
