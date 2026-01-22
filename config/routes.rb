Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboards#show"

  # SHARED ROUTES STARTS HERE
  get "/verify/:emp_id", to: "employees#verify", as: :verify_employee
  get "/holidays", to: "holidays#index", as: :holidays
  # SHARED ROUTES ENDS HERE

  # EMPLOYEE ROUTES STARTS HERE
  resource :dashboard, only: [ :show ] do
    get :birthdays
  end

  resources :leave_requests, only: [ :index, :new, :create ]

  resources :attendances, only: [ :index ] do
    collection do
      post :check_in
      post :check_out
    end
  end

  resource :profile, only: [ :edit, :update ] do
    collection do
      get :my_id_card
    end
  end
  resources :payslip_requests, only: [ :index, :new, :create ]
  resources :attendance_regularizations, only: [ :index, :new, :create ]
  # EMPLOYEE ROUTES ENDS HERE


  # ADMIN ROUTES STARTS HERE
  namespace :admin do
    resource :dashboard, only: [ :show ]

    resources :employees, only: [ :index, :new, :create, :edit, :update ]

    resources :attendances, only: [ :index, :edit, :update ] do
      collection do
        get :export
      end
    end

    resources :leave_requests, only: [ :index ] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :holidays, only: [:index, :create, :destroy]

    resources :attendance_summaries, only: [ :index ]

    resources :payrolls, only: [ :index, :create ]
    resources :payslip_requests, only: [ :index, :update ]
    resources :attendance_regularizations, only: [ :index, :update ]
  end
  # ADMIN ROUTES ENDS HERE
end
