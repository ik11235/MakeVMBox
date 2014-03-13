# -*- coding: utf-8 -*-
class API < Grape::API
  # APIアクセスに接頭辞を付加
  # ex) http://localhost:3000/api
  prefix "api"
  
  # APIアクセスにバージョン情報を付加
  # ex) http://localhost:3000/api/v1
  version 'v1', :using => :path
  
  resource "vmimages" do
    # ex) http://localhost:3000/api/v1/users
    desc "returns all users"
    get do
      Vmimages.all
    end
    
    # ex) OK: http://localhost:3000/api/v1/users/1
    # ex) NG: http://localhost:3000/api/v1/users/a
    desc "return a user"
    params do
      requires :id, type: Integer
      optional :name, type: String
    end
    get ':id' do
      User.find(params[:id])
    end
  end
end
