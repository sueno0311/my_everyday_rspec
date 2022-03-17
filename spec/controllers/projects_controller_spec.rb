require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      before do
        @request.host = "lvh.me"
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get :index
        expect(response).to be_successful
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_successful
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "as an authentecated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      let(:params) { attributes_for(:project, name: "New Project Name") }
      subject { patch :update, params: { id: @project.id, project: params} }

      it "update a project" do
        sign_in @user
        is_expected.to have_http_status "302"
        expect(@project.reload.name).to eq "New Project Name"
      end
    end

    context "as an unauthentecated user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user, name: "Old Project Name")
      end
      let(:params) { attributes_for(:project, name: "New Project Name") }
      subject { patch :update, params: { id: @project.id, project: params} }

      it "does not update a project" do
        sign_in @other_user
        is_expected.to have_http_status "302"
        expect(response).to redirect_to root_path
        expect(@project.reload.name).to eq "Old Project Name"
      end
    end
  end
end
