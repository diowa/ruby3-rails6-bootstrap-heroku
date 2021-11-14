# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#home'
  get :hello_world, to: 'pages#hello_world'

  localized do
    get  'newsletter_subscription', to: 'newsletter_subscriptions#new', as: :newsletter_subscription
    post 'newsletter_subscription', to: 'newsletter_subscriptions#create', as: :create_newsletter_subscription
    get  'support_contact', to: 'support_contacts#new', as: :support_contact
    post 'support_contact', to: 'support_contacts#create', as: :create_support_contact
  end
end
