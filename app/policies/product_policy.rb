class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end
  def retire_product?
    admin_authorization
  end

  def resume_product?
    admin_authorization
  end

  def create?
    admin_authorization
  end

  def new?
    admin_authorization
  end

  def update?
    admin_authorization
  end

  def edit?
    admin_authorization
  end

  def destroy?
    admin_authorization
  end

  def category_products?
    true
  end

  private
  def admin_authorization
    @user.nil? ? false : @user.admin?
  end
end
