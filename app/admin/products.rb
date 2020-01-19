ActiveAdmin.register Product do
  actions :all

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.object.price_currency = 'RUB'

    inputs :name, :price, :description, :price_currency, :hidden

    actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :price do |v|
      v.price.format
    end
    column :description
    column :hidden
    column :created_at
    column :updated_at
    actions
  end

  permit_params :name, :price, :price_currency, :description, :hidden
end
